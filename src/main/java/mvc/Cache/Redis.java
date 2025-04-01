package mvc.Cache;

import java.util.List;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;

import jakarta.persistence.TypedQuery;
import mvc.Cache.QueryMetadata.QueryResultType;
import mvc.Helpers.AuditTrail;
import mvc.Helpers.JsonConverter;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class Redis {
    private static final String REDIS_SYNC_CACHE_PREFIX = "SYNC_QUERY";
    private static final String HOST = "redis";
    private static final int PORT = 6379;
    private static final JedisPool pool = new JedisPool(HOST, PORT);
    private static final Jedis jedis = pool.getResource();
    private static final SignalHub signalHub = new SignalHub(jedis);
    private static boolean isConnected = false;
    private static boolean isInitialized = true;
    private static Logger logger =  AuditTrail.getLogger();

    public Redis() {
        if (isConnected) {
            return;
        }
        if (!jedis.isConnected()) {
            isConnected = true;
            return;
        }
        try {
            jedis.connect();
            isConnected = true;
            if (isConnected && !isInitialized) {
                signalHub.restore(REDIS_SYNC_CACHE_PREFIX);
                isInitialized = false;
            }
        } catch (Exception e) {
            isConnected = false;
            logger.info("Failed to connect to Redis");
        }
    }

    public static String getSyncCachePrefix() {
        return REDIS_SYNC_CACHE_PREFIX;
    }

    public static String getHost() {
        return HOST;
    }

    public static int getPort() {
        return PORT;
    }

    public static SignalHub getSignalHub() {
        return signalHub;
    }

    public static Jedis getJedis() {
        if (!jedis.isConnected()) {
            jedis.connect();
        }
        return jedis;
    }

    //#region RETRIEVE FROM CACHE
    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        String result;
        try {
            if (!jedis.isConnected()) {
                jedis.connect();
            }

            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type).get(0);
            }

            //Cache miss
            T value = query.getSingleResult();
            String sql = QueryConverter.getQuery(query);
            //Pass in the query to SignalHub
            QueryMetadata metadata = new QueryMetadata(QueryResultType.SINGLE, level, sql,type.getSimpleName());

            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);

            if (sql.equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }

            cacheResult(key, level, value);
            return value;
        } catch (IllegalArgumentException | NullPointerException | JsonProcessingException e) {
            logger.info("ERROR throws at [getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level)]: " + e.getMessage());
            return null;
        }
    }
    
    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreate(key, type, query, CacheLevel.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        String result;
        try {
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type);
            }

            //Cache miss
            List<T> value = query.getResultList();
            String sql = QueryConverter.getQuery(query);
            //Pass in the query to SignalHub
            QueryMetadata metadata = new QueryMetadata(QueryResultType.LIST, level, sql, type.getSimpleName());

            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);
            if (sql.equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }
            cacheResult(key, level, value);
            return value;
        } catch (IllegalArgumentException | NullPointerException | JsonProcessingException e) {
            logger.info("ERROR throws at [getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level)]: " + e.getMessage());
            return null;
        }
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreateList(key, type, query, CacheLevel.HIGH);
    }
    //#endregion


    //#region CACHE RESULT
    //Ensure Thread safety by using JedisPool at SignalHub
    public static <T> void cacheResult(Jedis jedis, String key, CacheLevel level, T value) throws JsonProcessingException {
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }

    public static <T> void cacheResult(String key, CacheLevel level, T value) throws JsonProcessingException {
        cacheResult(jedis, key, level, value);
    }

    public static <T> void cacheResult(Jedis jedis, String key, CacheLevel level, List<T> value) throws JsonProcessingException {
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }
    
    public static <T> void cacheResult(String key, CacheLevel level, List<T> value) throws JsonProcessingException {
        cacheResult(jedis, key, level, value);
    }
    //#endregion

    private boolean cacheHit(String result) {
        return !(result == null || result.equals("") || result.equals("nil"));
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
