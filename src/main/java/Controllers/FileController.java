package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.FileType;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Http.HttpMethod;

@WebServlet("/File/*")
public class FileController extends ControllerBase {

    // #region Product
    @ActionAttribute(urlPattern = "upload/product")
    @HttpRequest(HttpMethod.POST)
    public Result uploadProduct(byte[][] files) throws Exception {
        // get file from request and save it to the server
        // byte[] files1 = file[0];
        // byte[] files2 = file[1];
        
        

        
        return success();
    }

    @ActionAttribute(urlPattern = "download/product")
    public Result downloadProduct(int id) throws Exception {
        // get the file data from the server and return it to the client
        byte[] file = null;
        return file(file, "product-image-" + id, FileType.PNG);
    }

    @ActionAttribute(urlPattern = "retrieve/product")
    public Result retrieveProduct(int id) throws Exception {
        byte[] file = null;
        return source(file, "product-image-" + id, FileType.PNG);
    }
    // #endregion

    // #region User
    @ActionAttribute(urlPattern = "upload/user")
    @HttpRequest(HttpMethod.POST)
    public Result uploadUser(byte[][] files) throws Exception {
        // get file from request and save it to the server
        // byte[] files1 = file[0];
        // byte[] files2 = file[1];
        return success();
    }

    @ActionAttribute(urlPattern = "download/user")
    public Result downloadUser(int id) throws Exception {
        // get the file data from the server and return it to the client
        byte[] file = null;
        return file(file, "user-image-" + id, FileType.PNG);
    }

    @ActionAttribute(urlPattern = "retrieve/user")
    public Result retrieveUser(int id) throws Exception {
        byte[] file = null;
        return source(file, "user-image-" + id, FileType.PNG);
    }
    // #endregion
}
