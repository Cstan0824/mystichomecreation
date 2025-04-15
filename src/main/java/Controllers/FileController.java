package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

public class FileController extends ControllerBase {

    @ActionAttribute(urlPattern = "/file/upload")
    public Result upload() throws Exception {
        return success();
    }

    public Result download() throws Exception {
        return success();

    }

    public Result delete() throws Exception {
        return success();

    }

    public Result retrieve() throws Exception {
        return success();

    }

}
