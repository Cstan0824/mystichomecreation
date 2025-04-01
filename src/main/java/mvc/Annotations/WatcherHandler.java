package mvc.Annotations;

import mvc.Helpers.AuditTrail;
import mvc.Helpers.AuditTrail.AuditType;
import mvc.Helpers.AuditTrail.LogTarget;
import mvc.Http.HttpContext;

public class WatcherHandler implements Middleware {
    private String description;
    private String source;

    @Override
    public void onError(HttpContext context) {
    }

    @Override
    public void executeBeforeAction(HttpContext context) {
    }

    @Override
    public void executeAfterAction(HttpContext context) {
        AuditTrail trail = new AuditTrail(description, source, AuditType.INFO, LogTarget.DATABASE);
        trail.log();

    }

}
