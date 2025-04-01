package mvc.Annotations;

import mvc.Result;
import mvc.Helpers.SessionHelper;
import mvc.Http.HttpContext;
import mvc.Http.HttpStatusCode;

public class AuthorizationHandler implements Middleware {
    private final String UNAUTHORIZED_PAGE = System.getenv("UNAUTHORIZED_PAGE");
    private String permissions;

    @Override
    public void onError(HttpContext context) {
    }

    @Override
    public void executeBeforeAction(HttpContext context) {
        if ("*".equals(permissions)) {
            return;
        }
        SessionHelper session = new SessionHelper(context.getRequest().getSession());

        if (session.isAuthenticated() && session.getPermissions() != null
                && permissions.contains(session.getPermissions())) {
            return; // User is authenticated and has the required permissions
        }
        context.setRequestCancelled(true);
        context.setResult(new Result());
        context.getResult().setStatusCode(HttpStatusCode.UNAUTHORIZED);
        context.getResult().setContentType("text/html");
        context.getResult().setCharset("UTF-8");
        context.getResult().setRedirect(true);
        context.getResult().setPath(UNAUTHORIZED_PAGE);

    }

    @Override
    public void executeAfterAction(HttpContext context) {

    }
}
