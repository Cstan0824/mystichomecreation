package mvc;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import mvc.Annotations.AuthorizationHandler;
import mvc.Annotations.SyncCacheHandler;
import mvc.Annotations.WatcherHandler;
import mvc.App.Application;
import mvc.Cache.Redis;
import mvc.Helpers.AuditTrail;
import mvc.Helpers.AuditTrail.AuditType;
import mvc.Helpers.AuditTrail.LogTarget;
import mvc.Http.HttpBase;
import java.util.Map;

public class ApplicationContext implements Application {

    private static Application application = new ApplicationContext();

    private static AuditTrail logger = new AuditTrail();

    public static Application getInstance() {
        return application;
    }

    @Override
    public void initialize(ServletContextEvent sce) {
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
    public void onError(ServletRequest request, ServletResponse response, FilterChain chain, Throwable t) {
        // log error to file
        HttpServletRequest httpRequest = (HttpServletRequest) request;

        logger.setSource(httpRequest.getPathInfo());
        logger.setMessage(t.getMessage());
        logger.setType(AuditType.ERROR);
        logger.setTarget(LogTarget.FILE);

        logger.log();
    }

    @Override
    public void onHttpRequest(ServletRequest request, ServletResponse response, FilterChain chain) {
        // Log to Database to replace Watcher
        HttpServletRequest httpRequest = (HttpServletRequest) request;

        logger.setSource(httpRequest.getPathInfo());
        logger.setMessage("API Request");
        logger.setType(AuditType.INFO);
        logger.setTarget(LogTarget.DATABASE);

        logger.log();
    }

    @Override
    public void onDestroy(ServletContextEvent sce) {
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
