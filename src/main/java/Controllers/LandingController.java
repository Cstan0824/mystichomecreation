package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.Watcher;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {

    @Watcher(source = "index", description = "from Landing/index")
    public Result index() throws Exception {
        // response.setAttribute("user","USER123");
        context.getRequest().setAttribute("title", "MysticHome Creations");
        return page();
    }
}
