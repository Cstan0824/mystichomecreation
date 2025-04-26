package Controllers;

import java.util.List;

import DAO.AccountDA;
import DAO.OrderDAO;
import DAO.UserDA;
import DTO.VoucherInfoDTO;
import Models.Accounts.BankType;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderStatus;
import Models.Users.Role;
import Models.Users.User;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Cache.Redis;
import mvc.ControllerBase;
import mvc.Helpers.Helpers;
import mvc.Helpers.Notify.Notification;
import mvc.Helpers.Notify.NotificationService;
import mvc.Helpers.SessionHelper;
import mvc.Helpers.otps.OTPHelper;
import mvc.Http.HttpMethod;
import mvc.Result;

public class UserController extends ControllerBase {
    private AccountDA accountDA = new AccountDA();
    private UserDA userDA = new UserDA();
    private OrderDAO orderDAO = new OrderDAO();
    private Redis redis = new Redis();

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
        if (session.getId() == 0) {
            return page();
        }
        User user = userDA.getUserById(session.getId());
        if (user == null) {
            return page();
        }
        request.setAttribute("profile", session.getUserSession());
        if (session.getUserSession().getImageId() != null) {
            request.setAttribute("imageUrl", "File/Content/user/retrieve?id=" + session.getUserSession().getImageId());
        }
        request.setAttribute("birthDate", user.getBirthdate());
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
            // session.setUser(existingUser); // Update session with the new data
            session.setEmail(user.getEmail());
            session.setUsername(user.getUsername());
            return success("Profile updated successfully");
        }

        System.out.println("Failed to update user: " + existingUser.getId());
        return error("Failed to update profile");
    }

    // @Authorization(permissions = "User/account/transactions")
    @ActionAttribute(urlPattern = "account/transactions")
    public Result transactions() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<OrderStatus> orderStatuses = orderDAO.getAllOrderStatuses();
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.setAttribute("orderStatuses", orderStatuses);

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
        if (null == passwordChangeState || "".equals(passwordChangeState)) {
            passwordChangeState = "step#1";
        }
        passwordChangeState = passwordChangeState.split("#")[1];
        request.setAttribute("passwordChangeState", passwordChangeState);
        request.setAttribute("email", session.getEmail());
        return page();
    }

    // @Authorization(permissions = "User/account/password/verify")
    @ActionAttribute(urlPattern = "account/password/verify")
    @HttpRequest(HttpMethod.POST)
    public Result verifyPassword(String password) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();

        boolean response = accountDA.verifyPassword(userId, password);
        if (!response) {
            return error("Incorrect password");
        }
        session.set("passwordChangeState", "step#2");
        // generate otp and send to user
        sendOTP();

        return success();
    }

    @ActionAttribute(urlPattern = "account/password/otp/send")
    @HttpRequest(HttpMethod.POST)
    public Result sendOTP() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        String passwordChangeState = session.get("passwordChangeState");
        String forgotPasswordState = session.get("forgotPasswordState");

        if (!"step#2".equals(passwordChangeState) && !"step#2".equals(forgotPasswordState)) {
            return error("Invalid state for OTP generation");
        }
        boolean response = false;
        if ("step#2".equals(passwordChangeState)) {
            response = OTPHelper.sendOTP(userId);
        } else {
            String email = session.get("forgotPasswordState-user-email");
            if (email == null || "".equals(email)) {
                return error("Invalid State for  OTP generation");
            }
            response = OTPHelper.sendOTP(email);
        }
        if (response) {
            return success("OTP sent successfully");
        }
        return error("Failed to send OTP");
    }

    // @Authorization(permissions = "User/account/password/otp")
    @ActionAttribute(urlPattern = "account/password/otp")
    @HttpRequest(HttpMethod.POST)
    public Result verifyOTP(String otp) throws Exception {
        SessionHelper session = getSessionHelper();
        String passwordChangeState = session.get("passwordChangeState");
        String forgotPasswordState = session.get("forgotPasswordState");

        if (!"step#2".equals(passwordChangeState) && !"step#2".equals(forgotPasswordState)) {
            return error("Invalid state for OTP validation");
        }
        boolean response = false;
        if ("step#2".equals(passwordChangeState)) {
            response = OTPHelper.verifyOTP(session.getId(), otp);
        } else {
            String email = session.get("forgotPasswordState-user-email");
            if (email == null || "".equals(email)) {
                return error("Invalid State for OTP generation");
            }
            response = OTPHelper.verifyOTP(email, otp);
        }

        if (response) {
            session.set("passwordChangeState", "step#3");
            session.set("forgotPasswordState", "step#3");
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

        if (!"step#3".equals(passwordChangeState)) {
            return error("Invalid state for password change");
        }

        boolean response = accountDA.changePassword(userId, newPassword);
        if (response) {
            session.remove("passwordChangeState");
            // TODO: Notify User
            NotificationService notificationService = new NotificationService();
            Notification notification = new Notification();
            // Get Current DateTime in String format
            String currentDateTime = Helpers.getCurrentDateTime();

            notification.setCreatedAt(currentDateTime);
            notification.setTitle("Password Changed");
            notification
                    .setContent("Your password has been changed successfully, Not you? Click me for customer support.");
            notification.setUserId(userId);
            notification.setUrl("");

            notificationService.setNotification(notification);
            notificationService.inform();
            return success("Password changed successfully");
        }
        return error("Failed to change password");
    }

    @ActionAttribute(urlPattern = "account/forgetPassword/new")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result resetPassword(String newPassword) throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        String forgotPasswordState = session.get("forgotPasswordState");

        if (!"step#3".equals(forgotPasswordState)) {
            return error("Invalid state for password change");
        }

        String email = session.get("forgotPasswordState-user-email");

        boolean response = accountDA.changePassword(email, newPassword);
        if (response) {
            session.remove("passwordChangeState");
            // TODO: Notify User
            User user = userDA.getUserByEmail(email);
            String currentDateTime = Helpers.getCurrentDateTime();
            NotificationService notificationService = new NotificationService();
            Notification notification = new Notification();

            notification.setCreatedAt(currentDateTime);
            notification.setTitle("Password Changed");
            notification
                    .setContent("Your password has been changed successfully, Not you? Click me for customer support.");
            notification.setUser(user);
            notification.setUrl("");

            notificationService.setNotification(notification);
            notificationService.inform();
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

    //@Authorization(accessUrls = "User/account/vouchers")
    @ActionAttribute(urlPattern = "account/vouchers")
    public Result vouchers() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<VoucherInfoDTO> vouchers = accountDA.getAllVoucherInfo(userId);
        request.setAttribute("vouchers", vouchers);
        return page();
    }

    @Authorization(accessUrls = "User/account/vouchers/add")
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

    @Authorization(accessUrls = "User/account/vouchers/status")
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

    // @Authorization (permissions = "User/account/notifications")
    @ActionAttribute(urlPattern = "account/notifications")
    public Result notifications() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<Notification> notifications = accountDA.getNotifications(userId);
        request.setAttribute("notifications", notifications);
        return page();
    }

    // @Authorization (permissions = "User/account/notification/redirect")
    @ActionAttribute(urlPattern = "account/notification/redirect")
    @SyncCache(channel = "Notification")
    @HttpRequest(HttpMethod.POST)
    public Result notificationRedirectUrl(int id) throws Exception {
        String url = accountDA.triggerReadNotification(id);
        // extract action and controller from url
        if ("".equals(url)) {
            return error("Failed to redirect to the notification URL");
        }
        return json(url);
    }

    public Result signUp() throws Exception {
        SessionHelper session = getSessionHelper();
        String signUpState = session.get("signUpState");
        if (null == signUpState || "".equals(signUpState)) {
            signUpState = "step#1";
        }
        request.setAttribute("signUpState", signUpState.split("#")[1]);
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result signUp(String email, String username) throws Exception {
        SessionHelper session = getSessionHelper();
        User user = userDA.getUserByEmailUsername(email, username);

        if (user != null) {
            if (user.getUsername().equals(username)) {
                return error("User already Exists");
            }
            if (user.getEmail().equals(email)) {
                return error("Email already been used at another account");
            }
        }

        if (true == OTPHelper.sendOTP(email)) {
            session.set("signUpState", "step#2");
            session.set("signup-user-email", email);
        }
        return success();
    }

    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "User")
    @ActionAttribute(urlPattern = "signUp/otp")
    public Result verifyOTPAndCreateUser(User user, String entryOtp) throws Exception {
        SessionHelper session = getSessionHelper();
        if (!"step#2".equals(session.get("signUpState"))) {
            return error("Invalid State for Account Registration");
        }

        if (user.getEmail() == null || "".equals(user.getEmail())) {
            return error("Invalid State for Account Registration");
        }

        if (!user.getEmail().equals(session.get("signup-user-email"))) {
            return error("Invalid State for Account Registration");
        }

        boolean response = OTPHelper.verifyOTP(session.get("signup-user-email"), entryOtp);
        if (!response) {
            return error("Invalid OTP");
        }

        // Retrieve existing managed Role (with id=2) from the database
        Role role = userDA.getRoleById(2); // Ensure getRoleById is implemented in UserDA or equivalent DAO
        if (role == null) {
            return error("Error while trying to create user account. Role not found.");
        }
        user.setPassword(Helpers.hashPassword(user.getPassword()));
        user.setRole(role);
        boolean result = userDA.createUser(user);
        if (!result) {
            return error("Unable to create user account");
        }
        session.remove("signUpState");
        return success();
    }

    @HttpRequest(HttpMethod.POST)
    @ActionAttribute(urlPattern = "signUp/otp/send")
    public Result resendOTP() throws Exception {
        SessionHelper session = getSessionHelper();
        if (!"step#2".equals(session.get("signUpState"))) {
            return error("Invalid State for Account Registration");
        }

        String email = session.get("signup-user-email");

        if (email == null || "".equals(email)) {
            return error("Invalid State for Account Registration");
        }

        boolean response = OTPHelper.sendOTP(email);
        if (!response) {
            return error("Failed to send OTP");
        }

        return success();
    }

    @ActionAttribute(urlPattern = "account/forgetPassword")
    public Result forgetPassword() throws Exception {
        SessionHelper session = getSessionHelper();
        String forgotPasswordState = session.get("forgotPasswordState");
        if (null == forgotPasswordState || "".equals(forgotPasswordState)) {
            forgotPasswordState = "step#1";
        }
        request.setAttribute("forgotPasswordState", forgotPasswordState.split("#")[1]);
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "User")
    @ActionAttribute(urlPattern = "account/forgetPassword/verify")
    public Result verifyEmail(String email, String username) throws Exception {
        SessionHelper session = getSessionHelper();
        User user = userDA.getUserByEmailUsername(email, username);

        if (user == null) {
            return error("User or Email Not Found.");
        }

        if (!username.equals(user.getUsername())) {
            return error("User not Found");
        }

        if (!email.equals(user.getEmail())) {
            return error("Email Doesn't Match with your account.");
        }

        if (true == OTPHelper.sendOTP(email)) {
            session.set("forgotPasswordState", "step#2");
            session.set("forgotPasswordState-user-email", email);
        }

        return success();
    }
    // #endregion
}
