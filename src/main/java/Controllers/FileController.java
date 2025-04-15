package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

@WebServlet("/File/*")
public class FileController extends ControllerBase {

    @ActionAttribute(urlPattern = "upload/product")
    public Result upload() throws Exception {
        // get file from request and save it to the server
        return success();
    }

    @ActionAttribute(urlPattern = "download/product")
    public Result download(String id) throws Exception {
        // get the file data from the server and return it to the client
        return success();
    }

    @ActionAttribute(urlPattern = "retrieve/product")
    public Result retrieve(String id) throws Exception {
        return success();
    }

    // do the similiar things for user

}
