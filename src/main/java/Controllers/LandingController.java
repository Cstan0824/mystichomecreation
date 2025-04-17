package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.HttpRequest;
import mvc.ControllerBase;
import mvc.Http.HttpMethod;
import mvc.Result;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {

    // @Authorization(permissions = "Landing/index")
    public Result index() throws Exception {
        return page();
    }

    public Result login() throws Exception {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result login(String username, String password) throws Exception {
        return page("index");
    }
}
