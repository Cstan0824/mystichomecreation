package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.Watcher;
import mvc.Http.HttpMethod;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {

    //@Authorization(permissions = "Landing/index")
    @Watcher(source = "index", description = "from Landing/index")
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
