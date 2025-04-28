package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.HttpRequest;
import mvc.Http.HttpMethod;

public class ChatController extends ControllerBase {

    @HttpRequest(HttpMethod.POST)
    public Result prompt() throws Exception {
        return success();
    }
}
