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
    private static final SignalHub signalHub = new SignalHub(pool);

    private static Logger logger = AuditTrail.getLogger();

    public Redis() {
        // Empty constructor - initialization moved to static block
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
        return pool.getResource();
    }

    // #region RETRIEVE FROM CACHE
    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        try (Jedis jedis = pool.getResource()) {
            String result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type).get(0);
            }

            // Cache miss
            T value = query.getResultList().get(0);

            // Create metadata with query parameters by passing the entire query
            QueryMetadata metadata = new QueryMetadata(query, QueryResultType.SINGLE, level, type.getSimpleName());

            // Use metadata with SignalHub
            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);

            if (metadata.getSql().equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }

            cacheResult(jedis, key, level, value);
            return value;
        } catch (Exception e) {
            logger.warning("ERROR in getOrCreate: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreate(key, type, query, CacheLevel.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        try (Jedis jedis = pool.getResource()) {
            String result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type);
            }

            // Cache miss
            List<T> value = query.getResultList();

            // Create metadata with query parameters by passing the entire query
            QueryMetadata metadata = new QueryMetadata(query, QueryResultType.LIST, level, type.getSimpleName());

            // Use metadata with SignalHub
            signalHub.buildSubscriber(type.getSimpleName(), key, metadata);

            if (metadata.getSql().equals("")) {
                throw new IllegalArgumentException("Query is empty");
            }
            cacheResult(jedis, key, level, value);
            return value;
        } catch (Exception e) {
            logger.warning("ERROR in getOrCreateList: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreateList(key, type, query, CacheLevel.HIGH);
    }
    // #endregion

    // #region CACHE RESULT
    public static <T> void cacheResult(Jedis jedis, String key, CacheLevel level, T value)
            throws JsonProcessingException {
        if (value == null) {
            // assume that value already removed
            jedis.del(key);
            jedis.del(key + ":" + Redis.getSyncCachePrefix());
            return;
        }
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }

    public static <T> void cacheResult(String key, CacheLevel level, T value) throws JsonProcessingException {
        try (Jedis jedis = pool.getResource()) {
            cacheResult(jedis, key, level, value);
        }
    }

    public static <T> void cacheResult(Jedis jedis, String key, CacheLevel level, List<T> value)
            throws JsonProcessingException {
        if (value == null) {
            // assume that value already removed
            jedis.del(key);
            jedis.del(key + ":" + Redis.getSyncCachePrefix());
            return;
        }
        if (level.get() == CacheLevel.CRITICAL.get()) {
            jedis.set(key, JsonConverter.serialize(value));
        } else {
            jedis.setex(key, level.get(), JsonConverter.serialize(value));
        }
    }

    public static <T> void cacheResult(String key, CacheLevel level, List<T> value) throws JsonProcessingException {
        try (Jedis jedis = pool.getResource()) {
            cacheResult(jedis, key, level, value);
        }
    }
    // #endregion

    private boolean cacheHit(String result) {
        return !(result == null || result.equals("") || result.equals("nil"));
    }

    public enum CacheLevel {
        LOW(3600), // 1 hour
        MEDIUM(15000),
        HIGH(36000), // 10 hour
        CRITICAL(-1); // no expiry

        private final int value;

        private CacheLevel(int value) {
            this.value = value;
        }

        public int get() {
            return value;
        }
    }

}
