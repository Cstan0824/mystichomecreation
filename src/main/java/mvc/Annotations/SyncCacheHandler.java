package mvc.Annotations;

import mvc.Helpers.Redis;

public class SyncCacheHandler implements Middleware {
    private String channel;
    private String message;
    @Override
    public void onError() {
        System.out.println("Error occurred while executing the action");
    }

    @Override
    public void executeBeforeAction() {
    }

    @Override
    public void executeAfterAction() {
        //Publish Message to JedisPubHub
        Redis.getSignalHub().publish("","");
    }
}
