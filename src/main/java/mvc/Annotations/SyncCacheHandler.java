package mvc.Annotations;

import mvc.Cache.Redis;
import mvc.Http.HttpContext;

public class SyncCacheHandler implements Middleware {
    private String channel;
    private String message;

    @Override
    public void onError(HttpContext context) {
        System.out.println("SyncCacheHandler: onError() called");
    }

    @Override
    public void executeBeforeAction(HttpContext context) {
    }

    @Override
    public void executeAfterAction(HttpContext context) {
        if (channel.toUpperCase().equals("NULL"))
            return;
        Redis.getSignalHub().publish(channel, message);
    }
}
