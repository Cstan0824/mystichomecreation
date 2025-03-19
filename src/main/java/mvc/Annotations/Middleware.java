package mvc.Annotations;

public interface Middleware {
    public void onError();

    public void executeBeforeAction();

    public void executeAfterAction();
}
