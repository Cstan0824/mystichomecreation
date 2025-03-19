package mvc.Helpers;

import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import mvc.DataAccess;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class SignalHub {
    private Jedis jedis = null;
    private static final EntityManager db = DataAccess.getEntityManager();

    public SignalHub(Jedis jedis) {
        this.jedis = jedis;
    }

    public void buildSubscriber(String channel, String key, QueryMetadata metadata)
            throws JsonProcessingException {
        new Thread(() -> subscribe(channel, key)).start();
        //Build json to store query and its type
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonResponse = objectMapper.createObjectNode();
        ((ObjectNode) jsonResponse).put("type", metadata.getType().get());
        ((ObjectNode) jsonResponse).put("query", metadata.getSql());
        jedis.set(key + ":sync_query", objectMapper.writeValueAsString(jsonResponse));
    }

    private void subscribe(String channel, String key) {
        jedis.subscribe(new JedisPubSub() {
            @Override
            public void onMessage(String channel, String message) {
                System.out.println("Received message: " + message + " on channel: " + channel);
                SyncCache(key);
            }
        }, channel);
    }

    @SuppressWarnings("unchecked")
    private void SyncCache(String key) {
        String json = jedis.get(key + ":sync_query");
        QueryMetadata metadata = JsonConverter.deserialize(json, QueryMetadata.class).get(0);
        // Execute query
        Query query = db.createNativeQuery(metadata.getSql());
        switch (metadata.getType()) {
            case SINGLE -> {
                Object result = query.getSingleResult();
                Redis.storeResult(key, metadata.getLevel(), result);
            }
            case LIST -> {
                List<Object> results = query.getResultList();
                Redis.storeResult(key, metadata.getLevel(), results);
            }
        }
    }

    public void publish(String channel, String message) {
        jedis.publish(channel, message);
    }

    

}


