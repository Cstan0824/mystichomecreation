package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Http.HttpStatusCode;
import jakarta.servlet.annotation.WebServlet;

//Just redirect to the error page inside web.xml
@WebServlet("/Error/*")
public class ErrorController extends ControllerBase {

    public Result serverError() throws Exception {
        response.setStatus(HttpStatusCode.INTERNAL_SERVER_ERROR.get());
        return page();
    }

    public Result notFound() throws Exception {
        response.setStatus(HttpStatusCode.NOT_FOUND.get());
        return page();
    }

}
