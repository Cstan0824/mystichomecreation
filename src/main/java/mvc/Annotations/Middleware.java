package mvc.Annotations;

import mvc.Http.HttpContext;

public interface Middleware {
    public void onError(HttpContext context);

    public void executeBeforeAction(HttpContext context);

    public void executeAfterAction(HttpContext context);
}
