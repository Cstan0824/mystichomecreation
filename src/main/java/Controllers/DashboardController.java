package Controllers;

import mvc.ControllerBase;
import mvc.Result;

public class DashboardController extends ControllerBase {

    public Result index() throws Exception {
        return page();
    }

}
