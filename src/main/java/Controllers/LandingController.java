package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.Watcher;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {

    @Watcher(source = "index", description = "from Landing/index")
    public Result index() throws Exception {
        System.out.println("LandingController index() called");
        return page();
    }
}
