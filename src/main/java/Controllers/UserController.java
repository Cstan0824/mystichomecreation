package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/User/*")
public class UserController extends ControllerBase {

    // #region User Account
    // @Authorization(permissions = "User/account")
    public Result account() throws Exception {
        return page();
    }

    // @Authorization(permissions = "User/account/profile")
    @ActionAttribute(urlPattern = "account/profile")
    public Result profile() throws Exception {
        return page();
    }

    // @Authorization(permissions = "User/account/transactions")
    @ActionAttribute(urlPattern = "account/transactions")
    public Result transactions() throws Exception {
        return page();
    }

    // @Authorization(permissions = "User/account/transactions/details")
    @ActionAttribute(urlPattern = "account/transactions/details")
    public Result orderDetails(String id) throws Exception {
        // return page("details", "Order", id);
        return page("index", "dev");
    }

    @ActionAttribute(urlPattern = "account/password")
    public Result password() throws Exception {
        return page();
    }

    @ActionAttribute(urlPattern = "account/addresses")
    public Result addresses() throws Exception {
        return page();
    }

    @ActionAttribute(urlPattern = "account/payments")
    public Result payments() throws Exception {
        return page();
    }

    @ActionAttribute(urlPattern = "account/vouchers")
    public Result vouchers() throws Exception {
        return page();
    }
    // #endregion
}
