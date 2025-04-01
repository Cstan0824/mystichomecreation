package mvc.Cache;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
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
    private Set<String> subscribers = new HashSet<>();
    private JedisPool pool = new JedisPool(Redis.getHost(), Redis.getPort());
    private Jedis jedis;
    private static final EntityManager db = DataAccess.getEntityManager();
    private static Logger logger =  AuditTrail.getLogger();


    public SignalHub(Jedis jedis) {
        if (!jedis.isConnected()) {
            jedis.connect();
        }
        this.jedis = jedis;
    }
    
    

    public void buildSubscriber(String channel, String key, QueryMetadata metadata)
            throws JsonProcessingException {
            //subscribe(channel, key);
            new Thread(() -> subscribe(channel, key)).start();
            //Build json to store query and its type
            ObjectMapper objectMapper = new ObjectMapper();

            jedis.set(key + ":" + Redis.getSyncCachePrefix(), objectMapper.writeValueAsString(metadata));
    }

    public void buildSubcriber(String key, QueryMetadata metadata) 
            throws JsonProcessingException 
    {
        buildSubscriber(metadata.getControllerName(), key, metadata);
    }

    private void subscribe(String channel, String key) {
        try (Jedis jedisPubSub = pool.getResource()) {
            jedisPubSub.subscribe(new JedisPubSub() {

                @Override
            public void onSubscribe(String channel, int subscribedChannels) {
                System.out.println("Subscribed to channel: " + channel);
                subscribers.add(channel);
            }

            @Override
                public void onUnsubscribe(String channel, int subscribedChannels) {
                    System.out.println("Unsubscribed from channel: " + channel);
                    subscribers.remove(channel);
                }
            
                @Override
                public void onMessage(String channel, String message) {
                    System.out.println("Received message: " + message + " on channel: " + channel);
                    syncCache(key);
                    //System.out.println("Success Sync Cache");
                }
            }, channel);
        } catch (Exception e) {
            logger.info("ERROR thows at [subscribe(String channel, String key)]" + e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private void syncCache(String key) {
        try (Jedis threadJedis = Redis.getJedis()) {
            String json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix());
            if (json == null || json.equals("")) {
                return;
            }
            //try to get again if the result is OK or PONG [Jedis is not thread safe] sometime return unexpected result[OK,PONG]
            if (json.equals("OK") || json.equals("PONG")) {
                json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix()); 
            }
            QueryMetadata metadata = JsonConverter.deserialize(json, QueryMetadata.class).get(0);
            // Execute query
            Query query = db.createQuery(metadata.getSql());
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
        } catch (Exception e) {
            logger.info("ERROR thows at [syncCache(String key)]" + e.getMessage());
        }
    }

    public void publish(String channel, String message) {
        try (Jedis jedisPubSub = pool.getResource()) {
            jedis.publish(channel, message);

        }
        //jedis.publish(channel, message);
    }

    //TODO: NEED TO TEST
    public void restore(String prefix) {
        try (Jedis jedis = pool.getResource()) {
            String pattern = "*:" + prefix;
            Set<String> keys = jedis.keys(pattern);
            //Create a new thread to build the subscriber
            keys.forEach(key -> {
                try {
                    String sync_query = jedis.get(key);
                    String actualKey = key.split(":")[0];
                    QueryMetadata metadata = JsonConverter.deserialize(sync_query, QueryMetadata.class).get(0);
                    buildSubcriber(actualKey, metadata);
                } catch (JsonProcessingException e) {
                    logger.info("ERROR thows at [restore(String prefix)]" + e.getMessage());
                }
                //Convert to QueryMetadata object
                //signalHub.buildSubscriber(key);
            });
        }
    }
    

}


