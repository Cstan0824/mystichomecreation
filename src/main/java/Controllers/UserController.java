package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.HttpRequest;
import mvc.Http.HttpMethod;
import mvc.Http.HttpStatusCode;

public class UserController extends ControllerBase {
    public Result index() throws Exception {
        return page();
    }

    public Result list() throws Exception {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result addUser() throws Exception {
        boolean isValidated = true;

        if (isValidated) {
            return page("index", "Landing");
        } else {
            return json("Data is not valid", HttpStatusCode.INTERNAL_SERVER_ERROR, "error");
        }
        // return page("index");
    }
}
