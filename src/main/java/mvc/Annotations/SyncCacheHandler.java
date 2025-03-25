package mvc.Annotations;

import mvc.Cache.Redis;

public class SyncCacheHandler implements Middleware {
    private String channel;
    private String message;


    @Override
    public void onError() {
    }

    @Override
    public void executeBeforeAction() {
    }

    @Override
    public void executeAfterAction() {
        Redis.getSignalHub().publish(channel, message);
    }
}
