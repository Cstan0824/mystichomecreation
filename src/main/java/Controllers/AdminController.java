package Controllers;

import java.util.List;

import DAO.AccountDA;
import Models.Accounts.Voucher;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;

public class AdminController extends ControllerBase {
    private AccountDA accountDA = new AccountDA();

    // @Authorization(permissions = "Admin/index")
    public Result index() throws Exception {
        return page();
    }

    @Authorization(accessUrls = "User/account/vouchers")
    @ActionAttribute(urlPattern = "account/vouchers")
    public Result vouchers() throws Exception {
        List<Voucher> vouchers = accountDA.getVouchers();
        request.setAttribute("vouchers", vouchers);
        return page();
    }

    // @Authorization
    // #region Customer/Staff List
    

    // #endregion

}
