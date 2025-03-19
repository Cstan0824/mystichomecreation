package mvc.Annotations;

public class AuthorizationHandler implements Middleware {
    @Override
    public void onError() {
        System.out.println("Error occurred while executing the action");
    }

    @Override
    public void executeBeforeAction() {
        System.out.println("Executing before action");
    }

    @Override
    public void executeAfterAction() {
        System.out.println("Executing after action");
    }
}
