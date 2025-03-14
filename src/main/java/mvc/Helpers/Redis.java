package mvc.Helpers;

import java.util.List;

import redis.clients.jedis.Jedis;

public class Redis {
    private static final  String HOST = "redis";
    private static final int PORT = 6379;
    private static final Jedis jedis = new Jedis(HOST, PORT);
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
    
    public <T> T getOrCreate(String key, Class<T> type, Callback<T> callback) {
        return getOrCreate(key, type, callback, CachePriority.HIGH); //use high by default
    }
    
    public <T> T getOrCreate(String key, Class<T> type, Callback<T> callback, CachePriority priority) {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type).get(0); //return as object, use JSON parser
            }

            //Cache miss
            T value = callback.get();
            if (value == null) return null;
            
            if (priority.get() == CachePriority.CRITICAL.get()) {
                jedis.set(key, JsonConverter.serialize(value));
            } else {
                jedis.setex(key, priority.get(), JsonConverter.serialize(value));
            }
            return value; //execute callback function and return the result to caller

        } catch (Exception e) {
            return null;
        }
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, Callback<List<T>> callback) {
        return getOrCreateList(key, type, callback, CachePriority.HIGH);
    }

    public <T> List<T> getOrCreateList(String key, Class<T> type, Callback<List<T>> callback, CachePriority priority) {
        String result;
        try {
            result = jedis.get(key);
            if (cacheHit(result)) {
                return JsonConverter.deserialize(result, type); //return as object, use JSON parser
            }

            //Cache miss
            List<T> value = callback.get();
            if (value == null)
                return null;
            if (value.isEmpty())
                return null;

            if (priority.get() == CachePriority.CRITICAL.get()) {
                jedis.set(key, JsonConverter.serialize(value));
            } else {
                jedis.setex(key, priority.get(), JsonConverter.serialize(value));
            }
            return value; //execute callback function and return the result to caller

        } catch (Exception e) {
            return null;
        }
    }


    //Jedis Pub/Sub implementation (Synchronize Cache data from database)
    
    // private void registerSubscribers(String channel) {
    //     new Thread(new Runnable() {
    //         @Override
    //         public void run() {
    //             jedis.subscribe(new BinaryJedisPubSub() {
    //                 @Override
    //                 public void onMessage(String channel, String message) {
    //                     System.out.println("Received message: " + message + " on channel: " + channel);
    //                 }
    //             }, channel);
    //         }
    //     }).start();
    // }

    // public void publihMessage(String channel, String message) {
    //     jedis.publish(channel, message);
    // }
    private boolean cacheHit(String result) {
        return !(result == null || result.equals("") || result.equals("nil"));
    }

    @FunctionalInterface
    public interface Callback<T> {
        T get();
    }

    public enum CachePriority {
        LOW(3600), //1 hour
        MEDIUM(15000),
        HIGH(36000), //10 hour
        CRITICAL(-1); //no expiry

        private final int value;

        private CachePriority(int value) {
            this.value = value;
        }

        public int get() {
            return value;
        }
    }
}
