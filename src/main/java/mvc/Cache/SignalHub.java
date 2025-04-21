package mvc.Cache;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import mvc.DataAccess;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.Audits.AuditService;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPubSub;

public class SignalHub {
    private Set<String> subscribers = ConcurrentHashMap.newKeySet(); // Thread-safe set
    private final Map<String, Thread> activeSubscriptions = new ConcurrentHashMap<>();
    // Map channel name to a set of keys subscribed to that channel
    private final Map<String, Set<String>> channelKeys = new ConcurrentHashMap<>();

    private final JedisPool pool;
    private static Logger logger = AuditService.getLogger();
    private final ExecutorService executor = Executors.newFixedThreadPool(32);

    public SignalHub(JedisPool pool) {
        this.pool = pool;
    }

    /**
     * Registers a subscriber for a channel to handle cache updates
     */
    public void buildSubscriber(String channel, String key, QueryMetadata metadata)
            throws JsonProcessingException {
        if (channel == null || channel.isEmpty() || key == null || key.isEmpty()) {
            logger.warning("Cannot build subscriber with null or empty channel/key.");
            return;
        }

        // Store the metadata using a dedicated connection
        try (Jedis jedis = pool.getResource()) {
            ObjectMapper objectMapper = new ObjectMapper();
            String metadataJson = objectMapper.writeValueAsString(metadata);
            // Use a specific key for metadata storage, including the channel context if
            // needed
            // Example: key + ":" + channel + ":" + Redis.getSyncCachePrefix();
            // For simplicity, keeping original metadata key structure for now:
            String metadataKey = key + ":" + Redis.getSyncCachePrefix();

            jedis.set(metadataKey, metadataJson);
            logger.fine("Stored metadata for key [" + key + "] under metadata key [" + metadataKey + "]");

            // Verify metadata was stored correctly (optional)
            String storedMetadata = jedis.get(metadataKey);
            if (storedMetadata == null || storedMetadata.isEmpty()) {
                logger.warning("Verification failed: Failed to store metadata for key: " + metadataKey);
            }
        } catch (Exception e) {
            logger.severe("Error storing metadata for key [" + key + "]: " + e.getMessage());
            throw new RuntimeException("Failed to store metadata", e); // Re-throw critical error
        }

        // Add the key to the set for this channel
        channelKeys.computeIfAbsent(channel, k -> ConcurrentHashMap.newKeySet()).add(key);
        logger.info("Associated key [" + key + "] with channel [" + channel + "]");

        // Only create subscription thread if it doesn't exist for the channel
        activeSubscriptions.computeIfAbsent(channel, c -> {
            Thread thread = new Thread(() -> {
                logger.info("Subscription thread starting for channel: " + c);
                // Pass only the channel name to the subscribe method
                subscribe(c);
            });
            thread.setName("Redis-PubSub-" + c); // Named threads are easier to debug
            thread.setDaemon(true);
            thread.start();
            logger.info("Started new subscription thread for channel: " + c);
            return thread;
        });
    }

    /**
     * Fixes the typo in the original method name for backward compatibility
     */
    public void buildSubcriber(String key, QueryMetadata metadata)
            throws JsonProcessingException {
        if (metadata.getControllerName() == null || metadata.getControllerName().isEmpty()) {
            buildSubscriber("*", key, metadata);
        } else {
            buildSubscriber(metadata.getControllerName(), key, metadata);
        }
    }

    /**
     * Handle subscription to a Redis channel. This method now only needs the
     * channel.
     */
    private void subscribe(String channel) { // Removed 'key' parameter
        Jedis subscribeJedis = null;

        try {
            // Get a dedicated connection for subscription
            subscribeJedis = pool.getResource();

            if (subscribeJedis == null) {
                logger.warning("Failed to get Jedis resource for subscription on channel: " + channel);
                return;
            }

            // Test connection before subscribing
            try {
                subscribeJedis.ping();
            } catch (Exception e) {
                logger.severe("Connection test failed for channel [" + channel + "]: " + e.getMessage());
                throw e; // Re-throw to trigger reconnection logic
            }

            // Create fresh subscriber for each attempt
            JedisPubSub subscriber = new JedisPubSub() {
                @Override
                public void onSubscribe(String subscribedChannel, int subscribedChannels) {
                    logger.info("Successfully subscribed to channel: " + subscribedChannel);
                    subscribers.add(subscribedChannel);
                }

                @Override
                public void onUnsubscribe(String unsubscribedChannel, int subscribedChannels) {
                    logger.info("Unsubscribed from channel: " + unsubscribedChannel);
                    subscribers.remove(unsubscribedChannel);
                }

                @Override
                public void onMessage(String receivedChannel, String message) {
                    logger.info("Received message: [" + message + "] on channel: [" + receivedChannel + "]");

                    // Get all keys associated with this channel
                    Set<String> keysToSync = channelKeys.get(receivedChannel);

                    if (keysToSync != null && !keysToSync.isEmpty()) {
                        logger.info(
                                "Found " + keysToSync.size() + " keys to sync for channel [" + receivedChannel + "]");
                        for (String keyToSync : keysToSync) {
                            // Use Thread Pool to prevent resource exhaustion
                            executor.submit(() -> syncCache(keyToSync));
                            logger.fine("Dispatched sync task for key [" + keyToSync + "] on channel ["
                                    + receivedChannel + "]");
                        }
                    } else {
                        logger.warning(
                                "Received message on channel [" + receivedChannel + "] but no keys found to sync.");
                    }
                }

                @Override
                public void onPMessage(String pattern, String msgChannel, String message) {
                    logger.info("Received pattern message on " + pattern + " (" + msgChannel + "): " + message);
                }

                @Override
                public void onPSubscribe(String pattern, int subscribedChannels) {
                    logger.info("Subscribed to pattern: " + pattern);
                }

                @Override
                public void onPUnsubscribe(String pattern, int subscribedChannels) {
                    logger.info("Unsubscribed from pattern: " + pattern);
                }
            };

            // This is a blocking call that won't return until unsubscribed
            logger.info("Jedis subscribing to channel: " + channel);
            subscribeJedis.subscribe(subscriber, channel);
            logger.info("Jedis subscribe call returned for channel: " + channel);

        } catch (Exception e) {
            logger.severe("ERROR during subscription process for channel [" + channel + "]: " + e.getMessage());
            e.printStackTrace();

            // Clean up the subscription record if it fails
            activeSubscriptions.remove(channel);

            // Try to reconnect after a delay
            try {
                if (subscribeJedis != null) {
                    try {
                        subscribeJedis.close();
                    } catch (Exception ce) {
                        // Ignore close errors
                    }
                }
                logger.info("Attempting reconnection for channel [" + channel + "] in 5 seconds...");
                Thread.sleep(5000);

                // Check if the channel should still be actively subscribed
                if (channelKeys.containsKey(channel) && !channelKeys.get(channel).isEmpty()) {
                    activeSubscriptions.computeIfAbsent(channel, c -> {
                        Thread thread = new Thread(() -> subscribe(c));
                        thread.setDaemon(true);
                        thread.setName("Redis-PubSub-" + c + "-Reconnect");
                        thread.start();
                        logger.info("Restarted subscription thread via reconnection logic for channel: " + c);
                        return thread;
                    });
                } else {
                    logger.info(
                            "Skipping reconnection for channel [" + channel + "] as no keys are associated anymore.");
                }
            } catch (InterruptedException ie) {
                logger.warning("Reconnection attempt interrupted for channel [" + channel + "]");
                Thread.currentThread().interrupt();
            } catch (Exception reconEx) {
                logger.severe(
                        "Exception during reconnection attempt for channel [" + channel + "]: " + reconEx.getMessage());
            }
        }
    }

    @SuppressWarnings("unchecked")
    private void syncCache(String key) {
        try (Jedis threadJedis = pool.getResource()) {
            String json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix());
            if (json == null || json.isEmpty()) {
                return;
            }

            // Handle special responses
            if (json.equals("OK") || json.equals("PONG")) {
                json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix());
                if (json == null || json.isEmpty() || json.equals("OK") || json.equals("PONG")) {
                    return;
                }
            }

            EntityManager db = DataAccess.getEntityManager();
            try {
                QueryMetadata metadata = JsonConverter.deserialize(json, QueryMetadata.class).get(0);

                // Create the query
                Query query = db.createQuery(metadata.getSql());

                // Apply named parameters if they exist
                if (metadata.getNamedParameters() != null && !metadata.getNamedParameters().isEmpty()) {
                    for (Map.Entry<String, Object> param : metadata.getNamedParameters().entrySet()) {
                        if (param.getValue() != null) {
                            query.setParameter(param.getKey(), param.getValue());
                        }
                    }
                }

                // Apply positional parameters if they exist
                if (metadata.getPositionalParameters() != null && !metadata.getPositionalParameters().isEmpty()) {
                    for (Map.Entry<Integer, Object> param : metadata.getPositionalParameters().entrySet()) {
                        if (param.getValue() != null) {
                            query.setParameter(param.getKey(), param.getValue());
                        }
                    }
                }

                // Execute query with parameters
                switch (metadata.getType()) {
                    case SINGLE -> {
                        if (query.getResultList().isEmpty()) {
                            return;
                        }
                        Object result = query.getResultList().get(0);
                        Redis.cacheResult(threadJedis, key, metadata.getLevel(), result);
                    }
                    case LIST -> {
                        List<Object> results = query.getResultList();
                        Redis.cacheResult(threadJedis, key, metadata.getLevel(), results);
                    }
                }
            } finally {
                db.close();
            }
        } catch (Exception e) {
            logger.warning("ERROR in syncCache: " + e.getMessage());
            e.printStackTrace(System.err);
        }
    }

    public void publish(String channel, String message) {
        try (Jedis jedis = pool.getResource()) {
            jedis.publish(channel, message);
            logger.info("Published message to " + channel + ": " + message);
        } catch (Exception e) {
            logger.warning("ERROR in publish: " + e.getMessage());
        }
    }

    public void restore(String prefix) {
        try (Jedis jedis = new Jedis(Redis.getHost(), Redis.getPort())) {
            // First test connection
            try {
                String pingResult = jedis.ping();
                logger.info("Redis connection test before restore: " + pingResult);
            } catch (Exception e) {
                logger.severe("Cannot restore - Redis connection test failed: " + e.getMessage());
                return;
            }

            // Find all matching keys
            String pattern = "*:" + prefix;
            Set<String> keys;
            try {
                keys = jedis.keys(pattern);
                logger.info("Found " + keys.size() + " keys for restoration with pattern: " + pattern);
            } catch (Exception e) {
                logger.severe("Failed to get keys for restore: " + e.getMessage());
                e.printStackTrace();
                return;
            }

            // Try to restore each key
            int success = 0;
            int failed = 0;

            for (String key : keys) {
                try {
                    // Get the stored metadata
                    String metadataJson = jedis.get(key);

                    if (metadataJson == null || metadataJson.isEmpty()) {
                        failed++;
                        continue;
                    }

                    // Extract actual key (everything before last colon)
                    String actualKey = key.substring(0, key.lastIndexOf(':'));

                    if (actualKey.isEmpty()) {
                        failed++;
                        continue;
                    }

                    ObjectMapper mapper = new ObjectMapper();
                    QueryMetadata metadata;

                    try {
                        // This is more robust than the list deserialization approach
                        metadata = mapper.readValue(metadataJson, QueryMetadata.class);
                    } catch (Exception e) {
                        logger.severe("Failed to deserialize metadata for key " + key + ": " + e.getMessage());
                        e.printStackTrace();
                        failed++;
                        continue;
                    }

                    // Create subscription
                    String channel = metadata.getControllerName() != null && !metadata.getControllerName().isEmpty()
                            ? metadata.getControllerName()
                            : "*";

                    // Build the subscriber
                    buildSubscriber(channel, actualKey, metadata);
                    logger.info("Successfully restored subscription for key [" + actualKey + "] on channel " + channel);
                    success++;

                } catch (Exception e) {
                    logger.severe("Error restoring key " + key + ": " + e.getMessage());
                    e.printStackTrace();
                    failed++;
                }
            }

            logger.info("Restore complete: " + success + " subscriptions restored, " + failed + " failed");
        } catch (Exception e) {
            logger.severe("Critical error in restore process: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void shutdown() {
        // Track which threads we're shutting down
        int count = 0;

        logger.info("Shutting down SignalHub and all PubSub subscriptions");
        // Interrupt and stop each subscription thread
        for (Map.Entry<String, Thread> entry : activeSubscriptions.entrySet()) {
            try {
                String channel = entry.getKey();
                Thread thread = entry.getValue();

                if (thread != null && thread.isAlive()) {
                    logger.info("Shutting down subscription for channel: " + channel);
                    thread.interrupt(); // Interrupt the thread
                    count++;
                }
            } catch (Exception e) {
                logger.warning("Error shutting down subscription thread: " + e.getMessage());
            }
        }

        // Clear the collections
        activeSubscriptions.clear();
        subscribers.clear(); // Clear the old set if still used
        channelKeys.clear(); // Clear the channel-to-keys mapping

        logger.info("SignalHub shutdown complete. Interrupted " + count + " subscription threads.");
    }
}
