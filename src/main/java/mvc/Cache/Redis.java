package mvc.Cache;

import java.util.List;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;

import jakarta.persistence.TypedQuery;
import mvc.Cache.QueryMetadata.QueryResultType;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.Audits.AuditService;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class Redis {
    private static final String REDIS_SYNC_CACHE_PREFIX = "SYNC_QUERY";
    private static final String HOST = "redis";
    private static final int PORT = 6379;
    private static final JedisPool pool;
    private static final SignalHub signalHub;
    static {
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(64);
        config.setMaxIdle(32);
        config.setMinIdle(8);
        config.setBlockWhenExhausted(true);
        config.setMaxWaitMillis(10000);

        pool = new JedisPool(config, HOST, PORT);
        signalHub = new SignalHub(pool);
    }

    private static Logger logger = AuditService.getLogger();

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
    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level, String controllerName) {
        try (Jedis jedis = pool.getResource()) {
            String result = jedis.get(key);
            if (cacheHit(result)) {
                List<T> cachedList = JsonConverter.deserialize(result, type);
                if (cachedList == null) {
                    return null;
                }
                if (cachedList.size() == 0) {
                    return null;
                }
                return JsonConverter.deserialize(result, type).get(0);
            }

            // Cache miss
            List<T> resultList = query.getResultList();
            if (resultList.isEmpty()) {
                return null;
            }
            T value = resultList.get(0);

            // Create metadata with query parameters by passing the entire query
            if (controllerName == null) {
                controllerName = type.getSimpleName();
            }
            QueryMetadata metadata = new QueryMetadata(query, QueryResultType.SINGLE, level, controllerName);

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

    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        return getOrCreate(key, type, query, level, null);
    }

    public <T> T getOrCreate(String key, Class<T> type, TypedQuery<T> query) throws JsonProcessingException {
        return getOrCreate(key, type, query, CacheLevel.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level,
            String controllerName) {
        try (Jedis jedis = pool.getResource()) {
            String result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type);
            }

            // Cache miss
            List<T> value = query.getResultList();

            if (value.isEmpty()) {
                return null;
            }

            // Create metadata with query parameters by passing the entire query
            if (controllerName == null) {
                controllerName = type.getSimpleName();
            }
            QueryMetadata metadata = new QueryMetadata(query, QueryResultType.LIST, level, controllerName);

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

    public <T> List<T> getOrCreateList(String key, Class<T> type, TypedQuery<T> query, CacheLevel level) {
        return getOrCreateList(key, type, query, level, null);
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

    // #region SET VALUE TO CACHE - Value set from here will not trigger SyncCache
    public void setValue(String key, String value) {
        setValue(key, value, CacheLevel.LOW);
    }

    public void setValue(String key, String value, CacheLevel level) {
        try (Jedis jedis = pool.getResource()) {
            if (level.get() == CacheLevel.CRITICAL.get()) {
                jedis.set(key, value);
            } else {
                jedis.setex(key, level.get(), value);
            }
        } catch (Exception e) {
            logger.warning("ERROR in setValue: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void setValue(String key, String value, int expiry) {
        try (Jedis jedis = pool.getResource()) {
            if (expiry == CacheLevel.CRITICAL.get()) {
                jedis.set(key, value);
            } else {
                jedis.setex(key, expiry, value);
            }
        } catch (Exception e) {
            logger.warning("ERROR in setValue: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public String getValue(String key) {
        try (Jedis jedis = pool.getResource()) {
            return jedis.get(key);
        } catch (Exception e) {
            logger.warning("ERROR in getValue: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public String getAndExpireValue(String key) {
        try (Jedis jedis = pool.getResource()) {
            String value = jedis.get(key);
            if (value != null) {
                jedis.expire(key, 0); // Set the key to expire immediately
            }
            return value;
        } catch (Exception e) {
            logger.warning("ERROR in getValueAndExpire: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean removeValue(String key) {
        try (Jedis jedis = pool.getResource()) {
            jedis.del(key);
            return true;
        } catch (Exception e) {
            logger.warning("ERROR in removeValue: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    // #endregion

    public Long getTTL(String key) {
        try (Jedis jedis = pool.getResource()) {
            return jedis.ttl(key);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            return null;
        }
    }

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
