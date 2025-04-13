import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import mvc.Annotations.AuthorizationHandler;
import mvc.Annotations.SyncCacheHandler;
import mvc.Annotations.WatcherHandler;
import mvc.Cache.Redis;
import mvc.Http.HttpBase;
import java.util.Map;

@WebListener
public class Configuration implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // ✅ This runs when the web app starts
        System.out.println("[Startup] MysticHome is initializing...");

        // Register middlewares
        HttpBase.addMiddleware(new AuthorizationHandler());
        HttpBase.addMiddleware(new SyncCacheHandler());
        HttpBase.addMiddleware(new WatcherHandler());
        System.out.println("[Startup] Middleware handlers registered");

        // Restore Redis SignalHub
        Redis.getSignalHub().restore(Redis.getSyncCachePrefix());
        System.out.println("[Startup] Redis SignalHub restored");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[Shutdown] MysticHome is being undeployed...");

        try {
            System.out.println("[Shutdown] Shutting down Redis threads...");
            Redis.getSignalHub().shutdown();

            // Find and interrupt any remaining Redis threads
            Map<Thread, StackTraceElement[]> threadMap = Thread.getAllStackTraces();
            for (Thread thread : threadMap.keySet()) {
                String threadName = thread.getName();
                if (threadName.contains("Redis") || threadName.contains("Jedis") || threadName.contains("PubSub")) {
                    try {
                        System.out.println("[Shutdown] Interrupting thread: " + threadName);
                        thread.interrupt();
                    } catch (Exception e) {
                        System.err
                                .println("[Shutdown] Error interrupting thread " + threadName + ": " + e.getMessage());
                    }
                }
            }

            System.out.println("[Shutdown] All Redis threads terminated");
        } catch (Exception e) {
            System.err.println("[Shutdown] Error during Redis cleanup: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("[Shutdown] MysticHome shutdown completed");
    }
}
