package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {
    public Result index() {
        return page();
    }

}
