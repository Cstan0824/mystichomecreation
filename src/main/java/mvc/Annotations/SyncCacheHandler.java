package mvc.Annotations;

import mvc.Cache.Redis;

public class SyncCacheHandler implements Middleware {
    private String channel;
    private String message;


    @Override
    public void onError() {
        System.out.println("Error occurred while executing the action");
    }

    @Override
    public void executeBeforeAction() {
        System.out.println("SyncCacheHandler execute before action");
    }

    @Override
    public void executeAfterAction() {
        System.out.println("SyncCacheHandler execute after action");
        //Publish Message to JedisPubHub
        Redis.getSignalHub().publish(channel, message);
        System.out.println("Message published to channel: " + channel);
    }
}
