package mvc.Cache;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import mvc.DataAccess;
import mvc.Helpers.AuditTrail;
import mvc.Helpers.JsonConverter;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPubSub;

public class SignalHub {
    private Set<String> subscribers = ConcurrentHashMap.newKeySet(); // Thread-safe set
    private final Map<String, Thread> activeSubscriptions = new ConcurrentHashMap<>();

    private final JedisPool pool;
    private static Logger logger = AuditTrail.getLogger();

    public SignalHub(JedisPool pool) {
        this.pool = pool;
    }

    /**
     * Registers a subscriber for a channel to handle cache updates
     */
    public void buildSubscriber(String channel, String key, QueryMetadata metadata)
            throws JsonProcessingException {
        if (channel == null || channel.isEmpty()) {
            return;
        }

        // Store the metadata using a dedicated connection
        try (Jedis jedis = pool.getResource()) {
            ObjectMapper objectMapper = new ObjectMapper();
            String metadataJson = objectMapper.writeValueAsString(metadata);
            String metadataKey = key + ":" + Redis.getSyncCachePrefix();

            // Store metadata for sync operations
            String result = jedis.set(metadataKey, metadataJson);

            // Verify metadata was stored correctly
            String storedMetadata = jedis.get(metadataKey);
            if (storedMetadata == null || storedMetadata.isEmpty()) {
                logger.warning("Failed to store metadata for key: " + metadataKey);
            }
        }

        // Only create subscription thread if it doesn't exist
        if (!activeSubscriptions.containsKey(channel)) {
            Thread thread = new Thread(() -> {
                logger.info("Subscription thread started for channel: " + channel);
                subscribe(channel, key);
            });
            thread.setName("Redis-PubSub-" + channel); // Named threads are easier to debug
            thread.setDaemon(true);
            thread.start();
            activeSubscriptions.put(channel, thread);
        } else {
            logger.info("Subscription already exists for channel: " + channel);
        }
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
     * Handle subscription to a Redis channel
     */
    private void subscribe(String channel, String key) {
        Jedis subscribeJedis = null;

        try {
            // Get a dedicated connection for subscription
            subscribeJedis = pool.getResource();

            if (subscribeJedis == null) {
                return;
            }

            // Test connection before subscribing
            try {
                String pingResult = subscribeJedis.ping();
            } catch (Exception e) {
                logger.severe("Connection test failed: " + e.getMessage());
                throw e; // Re-throw to trigger reconnection logic
            }

            // Create fresh subscriber for each attempt
            JedisPubSub subscriber = new JedisPubSub() {
                @Override
                public void onSubscribe(String channel, int subscribedChannels) {
                    logger.info("Successfully subscribed to channel: " + channel);
                    subscribers.add(channel);
                }

                @Override
                public void onUnsubscribe(String channel, int subscribedChannels) {
                    logger.info("Unsubscribed from channel: " + channel);
                    subscribers.remove(channel);
                }

                @Override
                public void onMessage(String channel, String message) {
                    logger.info("Received message: " + message + " on channel: " + channel);
                    // Use a separate thread to avoid blocking pubsub
                    new Thread(() -> syncCache(key)).start();
                }

                @Override
                public void onPMessage(String pattern, String channel, String message) {
                    logger.info("Received pattern message on " + pattern + ": " + message);
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
            subscribeJedis.subscribe(subscriber, channel);

        } catch (Exception e) {
            logger.severe("ERROR in subscribe: " + e.getMessage());
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
                Thread.sleep(5000);

                // If there's still an active subscription request, try again
                if (!activeSubscriptions.containsKey(channel)) {
                    Thread thread = new Thread(() -> subscribe(channel, key));
                    thread.setDaemon(true);
                    thread.start();
                    activeSubscriptions.put(channel, thread);
                }
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
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
                        Object result = query.getSingleResult();
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
            e.printStackTrace();
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

    /**
     * Restore subscriptions from Redis
     * 
     * @param prefix The prefix to search for (typically SYNC_QUERY)
     */
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
                            : "global";

                    // Build the subscriber
                    buildSubscriber(channel, actualKey, metadata);
                    logger.info("Successfully restored subscription for key " + actualKey + " on channel " + channel);
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
                    thread.interrupt();
                    count++;
                }
            } catch (Exception e) {
                logger.warning("Error shutting down subscription: " + e.getMessage());
            }
        }

        // Clear the collections
        activeSubscriptions.clear();
        subscribers.clear();

        logger.info("SignalHub shutdown complete. Terminated " + count + " subscription threads.");
    }
}
