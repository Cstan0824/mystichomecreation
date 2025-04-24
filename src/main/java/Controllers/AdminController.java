package Controllers;

import mvc.ControllerBase;
import mvc.Result;

public class AdminController extends ControllerBase {
    // @Authorization(permissions = "Admin/index")
    public Result index() throws Exception {
        return page();
    }

    // @Authorization

}
