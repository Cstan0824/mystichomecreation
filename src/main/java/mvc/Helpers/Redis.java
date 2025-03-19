package mvc.Helpers;

import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;

import jakarta.persistence.TypedQuery;
import redis.clients.jedis.Jedis;

public class Redis {
    private static final String HOST = "redis";
    private static final int PORT = 6379;
    private static final Jedis jedis = new Jedis(HOST, PORT);
    private static final SignalHub signalHub = new SignalHub(jedis);
    private static boolean isConnected = false;

    public Redis() {
        if (isConnected) {
            return;
        }
        try {
            jedis.connect();
            isConnected = true;
        } catch (Exception e) {
            isConnected = false;
        }
    }

    public static SignalHub getSignalHub() {
        return signalHub;
    }

    public <T> T getOrCreate(String key, Class<T> type, Callback<T> callback) {
        return getOrCreate(key, type, callback, CacheLevel.HIGH);
    }

    public <T> T getOrCreate(String key, Class<T> type, Callback<T> callback, CacheLevel priority) {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type).get(0); 
            }

            //Cache miss
            T value = callback.get();

            if (value == null)
                return null;

            if (priority.get() == CacheLevel.CRITICAL.get()) {
                jedis.set(key, JsonConverter.serialize(value));
            } else {
                jedis.setex(key, priority.get(), JsonConverter.serialize(value));
            }
            return value; 
        } catch (Exception e) {
            return null;
        }
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, Callback<List<T>> callback) {
        return getOrCreateList(key, type, callback, CacheLevel.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, Callback<List<T>> callback, CacheLevel priority) {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type); //return as object, use JSON parser
            }

            //Cache miss
            List<T> value = callback.get();
            jedis.set("callback", callback.toString());
            System.out.println(callback.toString());
            if (value == null)
                return null;
            if (value.isEmpty())
                return null;

            if (priority.get() == CacheLevel.CRITICAL.get()) {
                jedis.set(key, JsonConverter.serialize(value));
            } else {
                jedis.setex(key, priority.get(), JsonConverter.serialize(value));
            }
            return value; 
        } catch (Exception e) {
            return null;
        }
    }

    private boolean cacheHit(String result) {
        return !(result == null || result.equals("") || result.equals("nil"));
    }

    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) throws JsonProcessingException {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type).get(0);
            }

            //Cache miss
            T value = query.getSingleResult();
            String sql = QueryConverter.getQuery(query);
            //Pass in the query to SignalHub
            QueryMetadata metadata = new QueryMetadata("list", level, sql);

            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);

            if (sql.equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }

            storeResult(key, level, value);
            return value;
        } catch (IllegalArgumentException | NullPointerException e) {
            return null;
        }
    }
    
    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException  {
        return getOrCreate(key, type, query, CacheLevel.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) throws JsonProcessingException {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type);
            }

            //Cache miss
            List<T> value = query.getResultList();
            String sql = QueryConverter.getQuery(query);
            //Pass in the query to SignalHub
            QueryMetadata metadata = new QueryMetadata("list", level, sql);

            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);

            if (sql.equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }
            storeResult(key, level, value);
            return value;
        } catch (IllegalArgumentException | NullPointerException e) {
            return null;
        }
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreateList(key, type, query, CacheLevel.HIGH);
    }

    public static <T> void storeResult(String key, CacheLevel level, T value) {
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }
    
    public static <T> void storeResult(String key, CacheLevel level, List<T> value) {
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }

    public enum CacheLevel {
        LOW(3600), //1 hour
        MEDIUM(15000),
        HIGH(36000), //10 hour
        CRITICAL(-1); //no expiry

        private final int value;

        private CacheLevel(int value) {
            this.value = value;
        }

        public int get() {
            return value;
        }
    }
}
