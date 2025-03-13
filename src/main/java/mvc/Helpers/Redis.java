package mvc.Helpers;

import redis.clients.jedis.Jedis;

public class Redis {
    private static final  String HOST = "redis";
    private static final int PORT = 6379;
    public Redis() {
        Jedis jedis = new Jedis("redis", 6379);
        jedis.set("message", "Hello Message From Redis/Java");
        String value = jedis.get("message");
        jedis.close();
    }
    
    public String getOrCreate(String key) {
        return "";
    }
}
