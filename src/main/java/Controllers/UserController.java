package Controllers;

import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Cache.Redis;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.Helpers.otps.OTPHelper;
import mvc.Http.HttpMethod;
import java.time.LocalDate;
import java.util.List;

import DAO.AccountDAO;
import DAO.OrderDAO;
import DAO.UserDAO;
import DTO.VoucherInfoDTO;
import Models.Accounts.BankType;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderStatus;
import Models.Users.Role;
import Models.Users.RoleType;
import Models.Users.User;

import mvc.ControllerBase;
import mvc.Helpers.Notify.Notification;
import mvc.Helpers.Notify.NotificationService;

import mvc.Result;

public class UserController extends ControllerBase {
    private AccountDAO accountDA = new AccountDAO();
    private UserDAO userDA = new UserDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private Redis redis = new Redis();

    // #region User Account
    @Authorization(accessUrls = "User/account")
    public Result account() throws Exception {
        SessionHelper session = getSessionHelper();

        request.setAttribute("username", session.getUsername());
        List<BankType> bankTypes = accountDA.getBankTypes();
        request.setAttribute("bankTypes", bankTypes);
        return page();
    }

    @Authorization(accessUrls = "User/account/profile")
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

    @Authorization(accessUrls = "User/account/profile/edit")
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

        // Username validation
        if (user.getUsername() != null) {
            if (user.getUsername().isEmpty()) {
                return error("Username cannot be empty");
            }
            if (user.getUsername().length() < 4 || user.getUsername().length() > 50) {
                return error("Username must be between 4 and 50 characters");
            }
            if (!user.getUsername().matches("^[a-zA-Z0-9@_]+$")) {
                return error("Username can only contain letters, numbers, @ and _ characters");
            }

            // Check if username is taken by another user
            if (!user.getUsername().equals(existingUser.getUsername())) {
                User existingUserWithSameUsername = userDA.getUserByUsername(user.getUsername());
                if (existingUserWithSameUsername != null) {
                    return error("Username already exists");
                }
            }

            existingUser.setUsername(user.getUsername());
        }

        // Email validation
        if (user.getEmail() != null) {
            if (user.getEmail().isEmpty()) {
                return error("Email cannot be empty");
            }
            String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
            if (!user.getEmail().matches(emailRegex)) {
                return error("Please enter a valid email address");
            }

            // Check if email is taken by another user
            if (!user.getEmail().equals(existingUser.getEmail())) {
                User existingUserWithSameEmail = userDA.getUserByEmail(user.getEmail());
                if (existingUserWithSameEmail != null) {
                    return error("Email already in use by another account");
                }
            }

            existingUser.setEmail(user.getEmail());
        }

        // Birthdate validation
        if (user.getBirthdate() != null) {
            if (!user.getBirthdate().isEmpty()) {
                try {
                    // Parse the birthdate
                    java.time.LocalDate date = java.time.LocalDate.parse(user.getBirthdate());
                    java.time.LocalDate minDate = java.time.LocalDate.of(1900, 1, 1);

                    if (date.isBefore(minDate)) {
                        return error("Birthdate cannot be earlier than year 1900");
                    }
                } catch (Exception e) {
                    return error("Invalid birthdate format");
                }
            }

            existingUser.setBirthdate(user.getBirthdate());
        }

        // password is intentionally NOT updated here

        boolean response = userDA.updateUser(existingUser);

        if (response) {
            // Update session with the new data
            session.setEmail(existingUser.getEmail());
            session.setUsername(existingUser.getUsername());
            return success("Profile updated successfully");
        }

        return error("Failed to update profile");
    }

    @Authorization(accessUrls = "User/account/transactions")
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

    @Authorization(accessUrls = "User/account/transactions/details")
    @ActionAttribute(urlPattern = "account/transactions/details")
    public Result orderDetails(String id) throws Exception {
        // return page("details", "Order", id);
        return page("index", "dev");
    }

    @Authorization(accessUrls = "User/account/password")
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

    @Authorization(accessUrls = "User/account/password/verify")
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

    @Authorization(accessUrls = "User/account/password/otp/send")
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

    @Authorization(accessUrls = "User/account/password/otp")
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

    // @Authorization(accessUrls = "User/account/password/new")
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

        // Add password validation
        if (newPassword == null || newPassword.isEmpty()) {
            return error("Password cannot be empty");
        }
        if (newPassword.length() < 8 || newPassword.length() > 16) {
            return error("Password must be between 8 and 16 characters");
        }
        // Optional: Add more complex password requirements
        // if
        // (!newPassword.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,16}$"))
        // {
        // return error("Password must contain at least one digit, lowercase letter,
        // uppercase letter, and special character");
        // }

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

        // Add password validation
        if (newPassword == null || newPassword.isEmpty()) {
            return error("Password cannot be empty");
        }
        if (newPassword.length() < 8 || newPassword.length() > 16) {
            return error("Password must be between 8 and 16 characters");
        }
        // Optional: Add more complex password requirements
        // if
        // (!newPassword.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,16}$"))
        // {
        // return error("Password must contain at least one digit, lowercase letter,
        // uppercase letter, and special character");
        // }

        String email = session.get("forgotPasswordState-user-email");

        boolean response = accountDA.changePassword(email, newPassword);
        if (response) {
            session.remove("forgotPasswordState");
            session.remove("forgotPasswordState-user-email");
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

    @Authorization(accessUrls = "User/account/ShippingAddresses")
    @ActionAttribute(urlPattern = "account/addresses")
    public Result addresses() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<ShippingInformation> ShippingAddresses = accountDA.getShippingInformation(userId);
        request.setAttribute("ShippingAddresses", ShippingAddresses);
        return page();
    }

    @Authorization(accessUrls = "User/account/ShippingAddresses/default")
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

    @Authorization(accessUrls = "User/account/addresses/add")
    @ActionAttribute(urlPattern = "account/addresses/add")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result addShippingAddress(ShippingInformation shippingInformation) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();
        System.out.println("addShippingAddress");

        // Validate shipping information
        Result validationResult = validateShippingInformation(shippingInformation);
        if (validationResult != null) {
            return validationResult;
        }

        boolean response = accountDA.addShippingInformation(userId, shippingInformation);
        if (response) {
            return success("Shipping address added successfully");
        }
        return error("Failed to add address");
    }

    @Authorization(accessUrls = "User/account/ShippingAddresses/edit")
    @ActionAttribute(urlPattern = "account/addresses/edit")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result editShippingAddress(ShippingInformation shippingInformation) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();

        // Validate shipping information
        Result validationResult = validateShippingInformation(shippingInformation);
        if (validationResult != null) {
            return validationResult;
        }

        // Verify the address belongs to the user
        List<ShippingInformation> userAddresses = accountDA.getShippingInformation(userId);
        boolean addressBelongsToUser = userAddresses.stream()
                .anyMatch(addr -> addr.getId() == shippingInformation.getId());

        if (!addressBelongsToUser) {
            return error("You don't have permission to edit this address");
        }

        boolean response = accountDA.updateShippingInformation(userId, shippingInformation);
        if (response) {
            return success("Address updated successfully");
        }
        return error("Failed to update address");
    }

    @Authorization(accessUrls = "User/account/ShippingAddresses/delete")
    @ActionAttribute(urlPattern = "account/addresses/delete")
    @SyncCache(channel = "User")
    @HttpRequest(HttpMethod.POST)
    public Result deleteShippingAddress(int shippingAddressId) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();

        // Verify the address exists and belongs to the user
        if (shippingAddressId < 0) {
            return error("Invalid address ID");
        }

        List<ShippingInformation> userAddresses = accountDA.getShippingInformation(userId);
        boolean addressBelongsToUser = userAddresses.stream()
                .anyMatch(addr -> addr.getId() == shippingAddressId);

        if (!addressBelongsToUser) {
            return error("You don't have permission to delete this address");
        }

        boolean response = accountDA.deleteShippingInformation(userId, shippingAddressId);
        if (response) {
            return success("Address deleted successfully");
        }
        return error("Failed to delete address");
    }

    // Add this helper method to handle validation
    private Result validateShippingInformation(ShippingInformation shippingInformation) throws Exception {
        // Label validation
        if (shippingInformation.getLabel() == null || shippingInformation.getLabel().trim().isEmpty()) {
            return error("Address label is required");
        }
        if (shippingInformation.getLabel().length() > 50) {
            return error("Address label cannot exceed 50 characters");
        }

        // Receiver name validation
        if (shippingInformation.getReceiverName() == null || shippingInformation.getReceiverName().trim().isEmpty()) {
            return error("Receiver name is required");
        }
        if (shippingInformation.getReceiverName().length() > 100) {
            return error("Receiver name cannot exceed 100 characters");
        }

        // Phone number validation
        if (shippingInformation.getPhoneNumber() == null || shippingInformation.getPhoneNumber().trim().isEmpty()) {
            return error("Phone number is required");
        }
        // Malaysian phone number format
        String phoneRegex = "^(\\+?6?01)[0-46-9]-*[0-9]{7,8}$";
        if (!shippingInformation.getPhoneNumber().matches(phoneRegex)) {
            return error("Please enter a valid Malaysian phone number");
        }

        // State validation
        if (shippingInformation.getState() == null || shippingInformation.getState().trim().isEmpty()) {
            return error("State is required");
        }

        // Postcode validation
        if (shippingInformation.getPostCode() == null || shippingInformation.getPostCode().trim().isEmpty()) {
            return error("Postcode is required");
        }
        String postcodeRegex = "^\\d{5}$";
        if (!shippingInformation.getPostCode().matches(postcodeRegex)) {
            return error("Please enter a valid 5-digit postcode");
        }

        // Address line 1 validation
        if (shippingInformation.getAddressLine1() == null || shippingInformation.getAddressLine1().trim().isEmpty()) {
            return error("Address line 1 is required");
        }
        if (shippingInformation.getAddressLine1().length() > 255) {
            return error("Address line 1 cannot exceed 255 characters");
        }

        // Address line 2 validation (optional)
        if (shippingInformation.getAddressLine2() != null && shippingInformation.getAddressLine2().length() > 255) {
            return error("Address line 2 cannot exceed 255 characters");
        }

        return null; // Validation passed
    }

    @Authorization(accessUrls = "User/account/payments")
    @ActionAttribute(urlPattern = "account/payments")
    public Result payments() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();

        // Get User payment cards
        List<PaymentCard> paymentCards = accountDA.getPaymentCards(userId);
        request.setAttribute("paymentCards", paymentCards);
        return page();
    }

    @Authorization(accessUrls = "User/account/payment/default")
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

    @Authorization(accessUrls = "User/account/payment/add")
    @ActionAttribute(urlPattern = "account/payment/add")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result addPaymentCard(PaymentCard paymentCard) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();

        // Validate payment card information
        Result validationResult = validatePaymentCard(paymentCard);
        if (validationResult != null) {
            return validationResult;
        }

        boolean response = accountDA.addPaymentCard(paymentCard, userId);
        if (response) {
            return success("Payment card added successfully");
        }
        return error("Failed to add payment card");
    }

    @Authorization(accessUrls = "User/account/payment/edit")
    @ActionAttribute(urlPattern = "account/payment/edit")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result editPaymentCard(PaymentCard paymentCard) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();

        // Validate payment card information
        Result validationResult = validatePaymentCard(paymentCard);
        if (validationResult != null) {
            return validationResult;
        }

        // Verify the payment card belongs to the user
        List<PaymentCard> userCards = accountDA.getPaymentCards(userId);
        boolean cardBelongsToUser = userCards.stream()
                .anyMatch(card -> card.getId() == paymentCard.getId());

        if (!cardBelongsToUser) {
            return error("You don't have permission to edit this payment card");
        }

        boolean response = accountDA.updatePaymentCard(paymentCard);
        if (response) {
            return success("Payment card updated successfully");
        }
        return error("Failed to update payment card");
    }

    @Authorization(accessUrls = "User/account/payment/delete")
    @ActionAttribute(urlPattern = "account/payment/delete")
    @SyncCache(channel = "PaymentCard")
    @HttpRequest(HttpMethod.POST)
    public Result deletePaymentCard(int cardId) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();

        // Verify the card exists and belongs to the user
        if (cardId <= 0) {
            return error("Invalid card ID");
        }

        List<PaymentCard> userCards = accountDA.getPaymentCards(userId);
        boolean cardBelongsToUser = userCards.stream()
                .anyMatch(card -> card.getId() == cardId);

        if (!cardBelongsToUser) {
            return error("You don't have permission to delete this payment card");
        }

        boolean response = accountDA.deletePaymentCard(cardId);
        if (response) {
            return success("Payment card deleted successfully");
        }
        return error("Failed to delete payment card");
    }

    // Add this helper method to validate payment cards
    private Result validatePaymentCard(PaymentCard paymentCard) throws Exception {
        // Card holder name validation
        if (paymentCard.getName() == null || paymentCard.getName().trim().isEmpty()) {
            return error("Card holder name is required");
        }
        if (paymentCard.getName().length() > 100) {
            return error("Card holder name cannot exceed 100 characters");
        }

        // Card number validation
        if (paymentCard.getCardNumber() == null || paymentCard.getCardNumber().trim().isEmpty()) {
            return error("Card number is required");
        }

        // Remove spaces and dashes for validation
        String cardNumber = paymentCard.getCardNumber().replaceAll("[ -]", "");

        // Basic card number format validation - should be numeric and within typical
        // length
        if (!cardNumber.matches("^\\d{13,19}$")) {
            return error("Please enter a valid card number");
        }

        // Optional: Implement Luhn algorithm for more thorough card validation
        // if (!isValidCardNumber(cardNumber)) {
        // return error("Invalid card number. Please check and try again.");
        // }

        // Expiry date validation
        if (paymentCard.getExpiryDate() == null || paymentCard.getExpiryDate().trim().isEmpty()) {
            return error("Expiry date is required");
        }

        // Validate expiry date format (MM/YYYY)
        if (!paymentCard.getExpiryDate().matches("^(0[1-9]|1[0-2])/20\\d{2}$")) {
            return error("Expiry date must be in format MM/YYYY");
        }

        // Check if card is not expired
        try {
            String[] expiryParts = paymentCard.getExpiryDate().split("/");
            int expiryMonth = Integer.parseInt(expiryParts[0]);
            int expiryYear = Integer.parseInt(expiryParts[1]);

            LocalDate today = LocalDate.now();
            LocalDate expiryDate = LocalDate.of(expiryYear, expiryMonth, 1)
                    .plusMonths(1).minusDays(1); // Last day of expiry month

            if (expiryDate.isBefore(today)) {
                return error("Card has expired. Please use a valid card");
            }
        } catch (Exception e) {
            return error("Invalid expiry date format");
        }

        // Bank type validation
        if (paymentCard.getBankTypeId() <= 0) {
            return error("Bank type is required");
        }

        return null; // Validation passed
    }

    @Authorization(accessUrls = "User/account/vouchers")
    @ActionAttribute(urlPattern = "account/vouchers")
    public Result vouchers() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<VoucherInfoDTO> vouchers = accountDA.getAllVoucherInfo(userId);
        request.setAttribute("vouchers", vouchers);
        return page();
    }

    @Authorization(accessUrls = "User/account/voucher/add")
    @ActionAttribute(urlPattern = "account/voucher/add")
    @SyncCache(channel = "Voucher", message = "addVoucher")
    @HttpRequest(HttpMethod.POST)
    public Result addVoucher(Voucher voucher) throws Exception {
        // Validate voucher before adding
        Result validationResult = validateVoucher(voucher);
        if (validationResult != null) {
            return validationResult;
        }

        boolean response = accountDA.addVoucher(voucher);
        if (response) {
            return success("Voucher added successfully");
        }
        return error("Failed to add voucher");
    }

    // Add this helper method to validate voucher data
    private Result validateVoucher(Voucher voucher) throws Exception {
        // Define allowed voucher types
        final String TYPE_PERCENTAGE = "percentage";
        final String TYPE_FIXED = "flat";

        // Validate name
        if (voucher.getName() == null || voucher.getName().trim().isEmpty()) {
            return error("Voucher name is required");
        }
        if (voucher.getName().length() > 100) {
            return error("Voucher name cannot exceed 100 characters");
        }

        // Validate description
        if (voucher.getDescription() == null || voucher.getDescription().trim().isEmpty()) {
            return error("Voucher description is required");
        }
        if (voucher.getDescription().length() > 255) {
            return error("Voucher description cannot exceed 255 characters");
        }

        // Validate type - must be either "Percentage" or "Fixed"
        if (voucher.getType() == null || voucher.getType().trim().isEmpty()) {
            return error("Voucher type is required");
        } else if (!TYPE_PERCENTAGE.equalsIgnoreCase(voucher.getType())
                && !TYPE_FIXED.equalsIgnoreCase(voucher.getType())) {
            return error("Voucher type must be either 'Percentage' or 'Fixed'");
        }

        // Validate minimum spent
        if (voucher.getMinSpent() < 0) {
            return error("Minimum spend cannot be negative");
        }

        // Validate amount
        if (voucher.getAmount() <= 0) {
            return error("Voucher amount must be greater than zero");
        }

        // If percentage type, validate percentage range (1-100%)
        if (TYPE_PERCENTAGE.equals(voucher.getType()) && voucher.getAmount() > 100) {
            return error("Percentage discount cannot exceed 100%");
        }

        // Validate max coverage
        if (voucher.getMaxCoverage() < 0) {
            return error("Maximum coverage cannot be negative");
        }

        // Validate usage per month - must be more than 0
        if (voucher.getUsagePerMonth() <= 0) {
            return error("Usage per month must be greater than zero");
        }

        return null; // Validation passed
    }

    @Authorization(accessUrls = "User/account/voucher/status")
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

    @Authorization(accessUrls = "User/account/notifications")
    @ActionAttribute(urlPattern = "account/notifications")
    public Result notifications() throws Exception {
        SessionHelper session = getSessionHelper(); // function from ControllerBase
        int userId = session.getId();
        List<Notification> notifications = accountDA.getNotifications(userId);
        request.setAttribute("notifications", notifications);
        return page();
    }

    @Authorization(accessUrls = "User/account/notification/redirect")
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

        // Username validation
        if (username == null || username.isEmpty()) {
            return error("Username cannot be empty");
        }
        if (username.length() < 4 || username.length() > 50) {
            return error("Username must be between 4 and 50 characters");
        }
        if (!username.matches("^[a-zA-Z0-9@_]+$")) {
            return error("Username can only contain letters, numbers, @ and _ characters");
        }

        // Email validation
        if (email == null || email.isEmpty()) {
            return error("Email cannot be empty");
        }
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        if (!email.matches(emailRegex)) {
            return error("Please enter a valid email address");
        }

        // Check if user or email already exists
        User user = userDA.getUserByEmailUsername(email, username);
        if (user != null) {
            if (user.getUsername().equals(username)) {
                return error("Username already exists");
            }
            if (user.getEmail().equals(email)) {
                return error("Email already in use by another account");
            }
        }

        // Send OTP
        if (OTPHelper.sendOTP(email)) {
            session.set("signUpState", "step#2");
            session.set("signup-user-email", email);
            return success();
        }

        return error("Failed to send verification code. Please try again.");
    }

    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "User")
    @ActionAttribute(urlPattern = "signUp/otp")
    public Result verifyOTPAndCreateUser(User user, String entryOtp) throws Exception {
        SessionHelper session = getSessionHelper();
        if (!"step#2".equals(session.get("signUpState"))) {
            return error("Invalid state for account registration");
        }

        if (user.getEmail() == null || "".equals(user.getEmail())) {
            return error("Email cannot be empty");
        }

        if (!user.getEmail().equals(session.get("signup-user-email"))) {
            return error("Email does not match the one used for verification");
        }

        // Password validation
        String password = user.getPassword();
        if (password == null || password.isEmpty()) {
            return error("Password cannot be empty");
        }
        if (password.length() < 8 || password.length() > 16) {
            return error("Password must be between 8 and 16 characters");
        }

        // You could add more password complexity requirements here
        // For example: if
        // (!password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,16}$"))
        // {
        // return error("Password must contain at least one digit, one lowercase, one
        // uppercase, and one special character");
        // }

        // Birthdate validation
        String birthdate = user.getBirthdate();
        if (birthdate != null && !birthdate.isEmpty()) {
            try {
                // Parse the birthdate
                java.time.LocalDate date = java.time.LocalDate.parse(birthdate);
                java.time.LocalDate minDate = java.time.LocalDate.of(1900, 1, 1);
                java.time.LocalDate today = java.time.LocalDate.now();

                if (date.isBefore(minDate)) {
                    return error("Birthdate cannot be earlier than year 1900");
                }

                if (date.isAfter(today)) {
                    return error("Birthdate cannot be in the future");
                }
            } catch (Exception e) {
                return error("Invalid birthdate format");
            }
        }

        // Verify OTP
        boolean response = OTPHelper.verifyOTP(session.get("signup-user-email"), entryOtp);
        if (!response) {
            return error("Invalid verification code");
        }

        // Retrieve role
        Role role = userDA.getRoleByName(RoleType.CUSTOMER.get());
        if (role == null) {
            return error("Error while creating user account. Please contact support.");
        }

        // Create user
        user.setPassword(Helpers.hashPassword(user.getPassword()));
        user.setRole(role);
        boolean result = userDA.createUser(user);
        if (!result) {
            return error("Unable to create user account. Please try again later.");
        }

        session.remove("signUpState");
        return success("Account created successfully!");
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
