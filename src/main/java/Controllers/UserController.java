package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.Http.HttpMethod;

import java.util.List;

import DAO.AccountDA;
import DAO.UserDA;
import Models.Accounts.BankType;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Users.User;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/User/*")
public class UserController extends ControllerBase {
    private AccountDA accountDA = new AccountDA();
    private UserDA userDA = new UserDA();

    // #region User Account
    // @Authorization(permissions = "User/account")
    public Result account() throws Exception {
        List<BankType> bankTypes = accountDA.getBankTypes();
        request.setAttribute("bankTypes", bankTypes);
        return page();
    }

    // @Authorization(permissions = "User/account/profile")
    @ActionAttribute(urlPattern = "account/profile")
    public Result profile() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        request.setAttribute("profile", session.getUser());
        return page();
    }

    // @Authorization(permissions = "User/account/profile/edit")
    @ActionAttribute(urlPattern = "account/profile/edit")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result editProfile(User user) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase

        // Fetch the current user from DB to preserve unchanged fields (like password)
        User existingUser = userDA.getUserById(session.getId());
        if (existingUser == null) {
            return error("User not found.");
        }

        // Only update selected fields
        if (user.getUsername() != null) {
            existingUser.setUsername(user.getUsername());
        }

        if (user.getEmail() != null) {
            existingUser.setEmail(user.getEmail());
        }

        if (user.getBirthdate() != null) {
            existingUser.setBirthdate(user.getBirthdate());
        }

        // password is intentionally NOT updated here

        boolean response = userDA.updateUser(existingUser);

        if (response) {
            session.setUser(existingUser); // Update session with the new data
            return success("Profile updated successfully");
        }

        System.out.println("Failed to update user: " + existingUser.getId());
        return error("Failed to update profile");
    }

    // @Authorization(permissions = "User/account/transactions")
    @ActionAttribute(urlPattern = "account/transactions")
    public Result transactions() throws Exception {
        // wait for product/order part to be done
        return page();
    }

    // @Authorization(permissions = "User/account/transactions/details")
    @ActionAttribute(urlPattern = "account/transactions/details")
    public Result orderDetails(String id) throws Exception {
        // return page("details", "Order", id);
        return page("index", "dev");
    }

    // @Authorization(permissions = "User/account/password")
    @ActionAttribute(urlPattern = "account/password")
    public Result password() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        String passwordChangeState = session.get("passwordChangeState");
        request.setAttribute("passwordChageState", passwordChangeState);
        return page();
    }

    // @Authorization(permissions = "User/account/password/verify")
    @ActionAttribute(urlPattern = "account/password/verify")
    @HttpRequest(HttpMethod.POST)
    public Result verifyPassword(String password) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();

        boolean response = accountDA.verifyPassword(userId, password);
        if (response) {
            session.set("passwordChangeState", "step#1");
            return success();
        }

        return error("Incorrect password");
    }

    // @Authorization(permissions = "User/account/password/otp")
    @ActionAttribute(urlPattern = "account/password/otp")
    @HttpRequest(HttpMethod.POST)
    public Result verifyOTP(String otp) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        String passwordChangeState = session.get("passwordChangeState");

        if (!"step#1".equals(passwordChangeState)) {
            return error("Invalid state for OTP verification");
        }

        boolean response = Helpers.verifyOTP(otp);
        if (response) {
            session.set("passwordChangeState", "step#2");
            return success();
        }
        return error("Invalid OTP");
    }

    // @Authorization(permissions = "User/account/password/new")
    @ActionAttribute(urlPattern = "account/password/new")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result changePassword(String newPassword) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        String passwordChangeState = session.get("passwordChangeState");

        if (!"step#2".equals(passwordChangeState)) {
            return error("Invalid state for password change");
        }

        boolean response = accountDA.changePassword(userId, newPassword);
        if (response) {
            session.remove("passwordChangeState");
            return success("Password changed successfully");
        }
        return error("Failed to change password");
    }

    // @Authorization(permissions = "User/account/ShippingAddresses")
    @ActionAttribute(urlPattern = "account/addresses")
    public Result addresses() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<ShippingInformation> ShippingAddresses = accountDA.getShippingInformation(userId);
        request.setAttribute("ShippingAddresses", ShippingAddresses);
        return page();
    }

    // @Authorization(permissions = "User/account/ShippingAddresses/default")
    @ActionAttribute(urlPattern = "account/addresses/default")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result setDefaultShippingAddress(int ShippingAddressId) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        boolean response = accountDA.setDefaultShippingInformation(userId, ShippingAddressId);
        if (!response) {
            return error("Failed to set default addresses");
        }
        return success();
    }

    // @Authorization(permissions = "User/account/ShippingAddresses/add")
    @ActionAttribute(urlPattern = "account/addresses/add")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result addShippingAddress(ShippingInformation shippingInformation) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        boolean response = accountDA.addShippingInformation(userId, shippingInformation);
        if (response) {
            return success();
        }
        return error("Failed to add addresses");
    }

    // @Authorization(permissions = "User/account/ShippingAddresses/edit")
    @ActionAttribute(urlPattern = "account/addresses/edit")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result editShippingAddress(ShippingInformation shippingInformation) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        boolean response = accountDA.updateShippingInformation(userId, shippingInformation);
        if (response) {
            return success();
        }
        return error("Failed to update addresses");
    }

    // @Authorization(permissions = "User/account/ShippingAddresses/delete")
    @ActionAttribute(urlPattern = "account/addresses/delete")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result deleteShippingAddress(int shippingAddressId) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        boolean response = accountDA.deleteShippingInformation(userId, shippingAddressId);
        if (response) {
            return success();
        }
        return error("Failed to delete addresses");
    }

    // @Authorization(permissions = "User/account/payments")
    @ActionAttribute(urlPattern = "account/payments")
    public Result payments() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();

        // Get User payment cards
        List<PaymentCard> paymentCards = accountDA.getPaymentCards(userId);
        request.setAttribute("paymentCards", paymentCards);
        return page();
    }

    // @Authorization(permissions = "User/account/payment/default")
    @ActionAttribute(urlPattern = "account/payment/default")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result setDefaultPaymentCard(int cardId) throws Exception {
        SessionHelper session = getSessionHelper();
        boolean response = accountDA.setDefaultPaymentCard(session.getId(), cardId);
        if (!response) {
            return error("Failed to set default payment card");
        }
        return success();
    }

    // @Authorization(permissions = "User/account/payment/edit")
    @ActionAttribute(urlPattern = "account/payment/add")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result addPaymentCard(PaymentCard paymentCard) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();
        boolean response = accountDA.addPaymentCard(paymentCard, userId);
        if (response) {
            return success();
        }
        return error("Failed to update payment card details");
    }

    // @Authorization(permissions = "User/account/payment/edit")
    @ActionAttribute(urlPattern = "account/payment/edit")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result editPaymentCard(PaymentCard paymentCard) throws Exception {
        boolean response = accountDA.updatePaymentCard(paymentCard);
        System.out.println(response);
        System.out.println("Payment card ID: " + paymentCard.getId());
        System.out.println("Payment card name: " + paymentCard.getName());
        if (response) {
            return success();
        }
        return error("Failed to update payment card details");
    }

    // @Authorization(permissions = "User/account/payment/delete")
    @ActionAttribute(urlPattern = "account/payment/delete")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result deletePaymentCard(int cardId) throws Exception {
        boolean response = accountDA.deletePaymentCard(cardId);
        System.out.println(response);
        if (response) {
            return success();
        }
        return error("Failed to delete payment card");
    }

    // @Authorization(permissions = "User/account/vouchers")
    @ActionAttribute(urlPattern = "account/vouchers")
    public Result vouchers() throws Exception {
        List<Voucher> vouchers = accountDA.getVouchers();
        request.setAttribute("vouchers", vouchers);
        return page();
    }

    // @Authorization(permissions = "User/account/vouchers/add")
    @ActionAttribute(urlPattern = "account/voucher/add")
    @SyncCache(channel = "Voucher", message = "addVoucher")
    @HttpRequest(HttpMethod.POST)
    public Result addVoucher(Voucher voucher) throws Exception {
        boolean response = accountDA.addVoucher(voucher);
        if (response) {
            return success();
        }
        return error("Failed to add voucher");
    }

    // @Authorization(permissions = "User/account/vouchers/status")
    @ActionAttribute(urlPattern = "account/voucher/status")
    @SyncCache(channel = "Voucher", message = "updateVoucherStatus")
    @HttpRequest(HttpMethod.POST)
    public Result updateVoucherStatus(int voucherId, boolean status) throws Exception {
        boolean response = accountDA.updateVoucherStatus(voucherId, status);
        if (!response) {
            return error("Failed to update voucher to " + (status ? "active" : "inactive"));
        }
        return success();
    }

    public Result demoSession() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase

        User user = userDA.getUserById(1);
        // Store user object in session
        session.setUser(user);

        // Add indication of successful login to request attributes
        request.setAttribute("currentUser", user);

        return success();
    }
    // #endregion
}
