package mvc.Cache;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import mvc.DataAccess;
import mvc.Helpers.JsonConverter;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPubSub;

public class SignalHub {
    private Set<String> subscribers = new HashSet<>();
    private JedisPool pool = new JedisPool(Redis.getHost(), Redis.getPort());
    private Jedis jedis;
    private static final EntityManager db = DataAccess.getEntityManager();

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
                    System.out.println("Success Sync Cache");
                }
            }, channel);
        } catch (Exception e) {
            System.out.println("Error in subscribe: " + e.getMessage());
        }

    }

    @SuppressWarnings("unchecked")
    private void syncCache(String key) {
        try (Jedis threadJedis = Redis.getJedis()) {
            String json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix());
        if (json == null || json.equals("")) {
            System.out.println("Result havent been cached");
            return;
        }
        if (json.equals("OK") || json.equals("PONG")) {
            System.out.println(json);
            json = threadJedis.get(key + ":" + Redis.getSyncCachePrefix()); //try to get again if the result is OK or PONG [Jedis is not thread safe]
        }
        System.out.println("Syncing cache for key | " + key + ":" + Redis.getSyncCachePrefix());
        System.out.println("Json: " + json);
        QueryMetadata metadata = JsonConverter.deserialize(json, QueryMetadata.class).get(0);
        System.out.println("Metadata: " + metadata.getSql());
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
        }catch(Exception e){

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
                    System.out.println("Sync Query: " + sync_query);
                    String actualKey = key.split(":")[0];
                    QueryMetadata metadata = JsonConverter.deserialize(sync_query, QueryMetadata.class).get(0);
                    buildSubcriber(actualKey, metadata);
                } catch (JsonProcessingException e) {

                }
                //Convert to QueryMetadata object
                //signalHub.buildSubscriber(key);
            });
        }
    }
    

}


