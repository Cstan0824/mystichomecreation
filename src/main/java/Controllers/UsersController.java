package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;



@WebServlet("/User/*")
public class UsersController extends ControllerBase {
    
    public Result cart() throws Exception {

        return page();

    }

}
