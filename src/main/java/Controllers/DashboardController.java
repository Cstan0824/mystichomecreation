package Controllers;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import DAO.AccountDAO;
import DAO.ReportDAO;
import DAO.UserDAO;
import DAO.productDAO;
import Models.Accounts.Voucher;
import Models.Products.product;
import Models.Products.productDTO;
import Models.Products.productType;
import Models.Users.Role;
import Models.Users.RoleType;
import Models.Users.User;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Http.HttpMethod;

public class DashboardController extends ControllerBase {
    private AccountDAO accountDA = new AccountDAO();
    private UserDAO userDA = new UserDAO();
    private ReportDAO reportDAO = new ReportDAO();
    private productDAO productDAO = new productDAO();

    public Result index() throws Exception {

        // #region total customer and staff
        int totalCustomers = reportDAO.getTotalCustomers();
        int totalStuff = reportDAO.getTotalStaff();

        System.out.println("✅ Total Customers: " + totalCustomers);
        System.out.println("✅ Total Staff: " + totalStuff);

        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalStaff", totalStuff);

        // #region payment preferences
        List<Object[]> paymentPreferences = reportDAO.getPaymentPreferences();

        request.setAttribute("paymentPreferences", paymentPreferences);

        // #region total revenue of all time
        double totalRevenue = reportDAO.getTotalRevenue();
        request.setAttribute("totalRevenue", totalRevenue);

        // #region Order comparison
        int thisMonthCount = reportDAO.getOrdersThisMonth();
        int lastMonthCount = reportDAO.getOrdersLastMonth();

        // if lastMonthCount == 0, then pctChange = 100 if thisMonthCount > 0, else 0
        double pctChange = lastMonthCount == 0 ? (thisMonthCount == 0 ? 0 : 100)
                : ((thisMonthCount - lastMonthCount) * 100.0 / lastMonthCount);
        String changeLabel = String.format("%+,.0f%%", pctChange);

        request.setAttribute("orderChangeLabel", changeLabel);
        request.setAttribute("orderChangeUp", pctChange >= 0);
        request.setAttribute("ordersThisMonth", thisMonthCount);

        // #region product list
        List<productType> productTypes = productDAO.getAllProductTypes();
        List<product> products = reportDAO.getAllProducts();

        List<Integer> ids = products.stream()
                .map(product::getId)
                .toList();

        Map<Integer, Double> avgMap = reportDAO.getAverageRatingsForProducts(ids);
        Map<Integer, Integer> soldMap = reportDAO.getTotalSoldForProducts(ids);

        List<productDTO> dtos = products.stream()
                .map(p -> new productDTO(
                        p,
                        avgMap.getOrDefault(p.getId(), 0.0),
                        soldMap.getOrDefault(p.getId(), 0)))
                .toList();

        // display purpose only
        request.setAttribute("productList", products);
        request.setAttribute("productTypes", productTypes);
        request.setAttribute("productDTOs", dtos);

        return page();
    }

    public Result filter() throws Exception {

        String[] categories = request.getParameterValues("category");
        System.out.println("Selected Categories: " + Arrays.toString(categories));

        List<Integer> catIds = (categories == null)
                ? List.of()
                : Arrays.stream(categories).map(Integer::valueOf).collect(Collectors.toList());

        Double priceMin = request.getParameter("priceMin") != null && !request.getParameter("priceMin").isEmpty()
                ? Double.valueOf(request.getParameter("priceMin"))
                : null;

        Double priceMax = request.getParameter("priceMax") != null && !request.getParameter("priceMax").isEmpty()
                ? Double.valueOf(request.getParameter("priceMax"))
                : null;

        Integer stockMin = request.getParameter("stockMin") != null && !request.getParameter("stockMin").isEmpty()
                ? Integer.valueOf(request.getParameter("stockMin"))
                : null;

        Integer stockMax = request.getParameter("stockMax") != null && !request.getParameter("stockMax").isEmpty()
                ? Integer.valueOf(request.getParameter("stockMax"))
                : null;

        Double ratingMin = request.getParameter("ratingMin") != null && !request.getParameter("ratingMin").isEmpty()
                ? Double.valueOf(request.getParameter("ratingMin"))
                : null;

        LocalDate dateFrom = request.getParameter("dateFrom") != null && !request.getParameter("dateFrom").isEmpty()
                ? LocalDate.parse(request.getParameter("dateFrom"))
                : null;

        LocalDate dateTo = request.getParameter("dateTo") != null && !request.getParameter("dateTo").isEmpty()
                ? LocalDate.parse(request.getParameter("dateTo"))
                : null;

        System.out.println("🔍 Selected Categories: " + Arrays.toString(categories));
        System.out.println("🔍 priceMin: " + request.getParameter("priceMin"));
        System.out.println("🔍 priceMax: " + request.getParameter("priceMax"));
        System.out.println("🔍 stockMin: " + request.getParameter("stockMin"));
        System.out.println("🔍 stockMax: " + request.getParameter("stockMax"));
        System.out.println("🔍 ratingMin: " + request.getParameter("ratingMin"));
        System.out.println("🔍 dateFrom: " + request.getParameter("dateFrom"));
        System.out.println("🔍 dateTo: " + request.getParameter("dateTo"));

        List<product> filtered = reportDAO.filterProducts(
                catIds, priceMin, priceMax,
                stockMin, stockMax,
                ratingMin, dateFrom, dateTo);

        System.out.println("✅ filterProducts returned " + filtered.size() + " items");

        List<Integer> ids = filtered.stream()
                .map(product::getId)
                .toList();

        Map<Integer, Double> avgMap = reportDAO.getAverageRatingsForProducts(ids);
        Map<Integer, Integer> soldMap = reportDAO.getTotalSoldForProducts(ids);

        // Take note
        List<productDTO> dtos = filtered.stream()
                .map(p -> new productDTO(
                        p,
                        avgMap.getOrDefault(p.getId(), 0.0),
                        soldMap.getOrDefault(p.getId(), 0)))
                .toList();
        System.out.println("✅ Built " + dtos.size() + " productDTOs");

        return json(dtos);

    }

    public Result dailyRevenue() throws Exception {

        // remember to accept the parameter from the request
        int days = Integer.parseInt(request.getParameter("days"));

        List<Object[]> daily = reportDAO.getDailyRevenue(days);

        System.out.println("---- Daily Revenue (last 7 days) ----");
        for (Object[] r : daily) {
            java.sql.Date day = (java.sql.Date) r[0];
            Number totalPaid = (Number) r[1]; // use Number
            System.out.printf(
                    "%s → RM%.2f%n",
                    day.toString(),
                    totalPaid.doubleValue() // doubleValue()
            );
        }

        var dailylist = daily.stream()
                // For each Object[] r, build a Map with two entries:
                .map(r -> Map.of(
                        // “day” → the first column, r[0], as a String
                        "day", r[0].toString(),
                        // “total” → the second column, r[1], as a double
                        "total", ((Number) r[1]).doubleValue()))
                // Collect into a List<Map<String,Object>>
                .toList();

        return json(dailylist);
    }

    public Result monthlyRevenue() throws Exception {

        // remember to accept the parameter from the request
        int months = Integer.parseInt(request.getParameter("months"));

        List<Object[]> monthly = reportDAO.getMonthlyRevenue(months);

        System.out.println("---- Monthly Revenue (last 12 months) ----");
        for (Object[] r : monthly) {
            java.sql.Date month = (java.sql.Date) r[0];
            Number totalPaid = (Number) r[1]; // use Number
            System.out.printf(
                    "%s → RM%.2f%n",
                    month.toString(),
                    totalPaid.doubleValue() // doubleValue()
            );
        }

        return page();
    }

    public Result staff() throws Exception {
        String searchTerm = request.getParameter("staff_search");
        List<User> staffList = userDA.getUsersByRole(RoleType.STAFF);
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            staffList = staffList.stream()
                    .filter(staff -> staff.getUsername().toLowerCase().contains(searchTerm.toLowerCase())
                            || staff.getEmail().toLowerCase().contains(searchTerm.toLowerCase()))
                    .toList();
        }
        request.setAttribute("staffList", staffList);
        return page();
    }

    @ActionAttribute(urlPattern = "staff/view")
    public Result viewStaff() throws Exception {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);
                User staff = userDA.getUserById(userId);

                if (staff != null && staff.getRole().getDescription().equals(RoleType.STAFF.get())) {
                    request.setAttribute("staff", staff);
                    return page();
                }
            } catch (NumberFormatException e) {
                return page("staff", "Dashboard");
            }
        }

        // Staff not found or invalid ID
        return page("staff", "Dashboard");
    }

    @HttpRequest(HttpMethod.POST)
    @ActionAttribute(urlPattern = "staff/add")
    @SyncCache(channel = "Users")
    public Result addStaff() throws Exception {

        String userName = request.getParameter("user_name");
        String userEmail = request.getParameter("user_email");
        String userBirthdate = request.getParameter("user_birthdate");
        String userPassword = request.getParameter("user_password");

        // Basic validation
        if (userName == null || userName.trim().isEmpty() ||
                userEmail == null || userEmail.trim().isEmpty() ||
                userPassword == null || userPassword.trim().isEmpty()) {

            request.setAttribute("error", "Name, email, and password are required");
            return page("staff", "Dashboard");
        }

        // Create new staff user
        User staff = new User();
        Role role = userDA.getRoleByName(RoleType.STAFF.get());
        staff.setUsername(userName);
        staff.setEmail(userEmail);
        staff.setPassword(userPassword);
        staff.setBirthdate(userBirthdate);
        staff.setRole(role);

        // Save the staff member
        boolean result = userDA.createUser(staff);

        if (result) {
            // Success
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return page("staff", "Dashboard");
        } else {
            // Error
            request.setAttribute("error", "Error adding staff member");
            return page("staff", "Dashboard");
        }
    }

    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "Users")
    @ActionAttribute(urlPattern = "staff/update")
    public Result editStaff() throws Exception {

        String userIdParam = request.getParameter("user_id");
        String userName = request.getParameter("user_name");
        String userEmail = request.getParameter("user_email");

        // Basic validation
        if (userIdParam == null || userIdParam.trim().isEmpty() ||
                userName == null || userName.trim().isEmpty() ||
                userEmail == null || userEmail.trim().isEmpty()) {

            request.setAttribute("error", "ID, name, and email are required");
            return page("staff", "Dashboard");
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get existing staff member
            User staff = userDA.getUserById(userId);

            if (staff == null || staff.getRole().getDescription() != RoleType.STAFF.get()) {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return page("staff", "Dashboard");
            }

            // Update
            staff.setUsername(userName);
            staff.setEmail(userEmail);

            // Update the staff member
            boolean success = userDA.updateUser(staff);

            if (success) {
                // Success
                return page("staff", "Dashboard");
            } else {
                // Error
                request.setAttribute("error", "Error updating staff member");
                return page("staff", "Dashboard");
            }

        } catch (NumberFormatException e) {
            return page("staff", "Dashboard");
        }
    }

    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "Users")
    @ActionAttribute(urlPattern = "staff/delete")
    public Result deleteStaff() throws Exception {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);

                // Delete the staff member
                boolean success = userDA.deleteUser(userId);

                if (success) {
                    // Success - no need for special handling
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
        }

        // Always redirect back to staff list
        return page("staff", "Dashboard");
    }

    public Result staff_view() throws Exception {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);
                User staff = userDA.getUserById(userId);

                if (staff != null && staff.getRole().getDescription().equals(RoleType.STAFF.get())) {
                    request.setAttribute("staff", staff);
                    return page();
                }
            } catch (NumberFormatException e) {
                return page("staff", "Dashboard");
            }
        }

        // Staff not found or invalid ID
        return page("staff", "Dashboard");
    }

    public Result customer() throws Exception {
        String searchTerm = request.getParameter("customer_search");
        List<User> customerList = userDA.getUsersByRole(RoleType.CUSTOMER);
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            customerList = customerList.stream()
                    .filter(customer -> customer.getUsername().toLowerCase().contains(searchTerm.toLowerCase())
                            || customer.getEmail().toLowerCase().contains(searchTerm.toLowerCase()))
                    .toList();
        }
        request.setAttribute("customerList", customerList);
        return page();
    }

    public Result vouchers() throws Exception {
        List<Voucher> vouchers = accountDA.getVouchers();
        request.setAttribute("vouchers", vouchers);
        return page();
    }

    @Authorization(accessUrls = "Dashboard/voucher/add")
    @ActionAttribute(urlPattern = "voucher/add")
    @SyncCache(channel = "Voucher")
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

    @Authorization(accessUrls = "Dashboard/voucher/status")
    @ActionAttribute(urlPattern = "voucher/status")
    @SyncCache(channel = "Voucher")
    @HttpRequest(HttpMethod.POST)
    public Result updateVoucherStatus(int voucherId, boolean status) throws Exception {
        boolean response = accountDA.updateVoucherStatus(voucherId, status);
        if (!response) {
            return error("Failed to update voucher to " + (status ? "active" : "inactive"));
        }
        return success();
    }

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

}
