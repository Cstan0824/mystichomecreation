package Controllers;

import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDAO;
import DAO.ReportDAO;
import DAO.UserDAO;
import DAO.productDAO;
import DTO.CustomerDTO;
import DTO.productDTO;
import DTO.CustomerDTO;
import Models.Accounts.Voucher;
import Models.Products.product;
import Models.Products.productType;
import Models.Users.Role;
import Models.Users.RoleType;
import Models.Users.User;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.ControllerBase;
import mvc.FileType;
import mvc.Helpers.Helpers;
import mvc.Helpers.pdf.PdfService;
import mvc.Helpers.pdf.PdfService.PdfOrientation;
import mvc.Helpers.pdf.PdfType;
import mvc.Http.HttpMethod;
import mvc.Result;


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

    @ActionAttribute(urlPattern = "report/generateSalesReport")
    @HttpRequest(HttpMethod.POST)
    public Result generateSalesReport() throws Exception {
        System.out.println("Generate Sales Report");

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();

        List<Object[]> topSellingProducts = reportDAO.getTopSellingProducts(5);

        //debug 
        System.out.println("🔍 Fetching top 5 selling products...");
        System.out.println("✅ Retrieved " + topSellingProducts.size() + " top-selling products.");
        for (Object[] row : topSellingProducts) {
            System.out.printf(
            "Product: %s, Category: %s, Price: RM%.2f, Total Sold: %d%n",
            row[0], row[1], (double) row[2], ((Number) row[3]).longValue()
            );
        }
        
        StringBuilder topSellingRows = new StringBuilder();
        for (Object[] row : topSellingProducts) {
            String productTitle = (String) row[0];
            String categoryName = (String) row[1];
            BigDecimal price = BigDecimal.valueOf((double) row[2]);
            Long totalSold = ((Number) row[3]).longValue(); // safer for big qty
        
            topSellingRows.append("<tr>")
                .append("<td>").append(productTitle).append("</td>")
                .append("<td>").append(categoryName).append("</td>")
                .append("<td>RM ").append(String.format("%.2f", price)).append("</td>")
                .append("<td>").append(totalSold).append("</td>")
                .append("</tr>");
        }

        //get the monthly Revenue 
        List<Object[]> monthlyRevenue = reportDAO.getMonthlyRevenue(12);

        System.out.println("🔍 Fetching monthly revenue for the last 12 months...");
        System.out.println("✅ Retrieved " + monthlyRevenue.size() + " monthly revenue records.");
        for (Object[] row : monthlyRevenue) {
            int year = ((Number) row[0]).intValue();
            int month = ((Number) row[1]).intValue();
            double revenue = ((Number) row[2]).doubleValue();
            System.out.printf("Year: %d, Month: %02d, Revenue: RM%.2f%n", year, month, revenue);
        }

        StringBuilder monthlyRevenueRows = new StringBuilder();
        for (Object[] row : monthlyRevenue) {
            int year = ((Number) row[0]).intValue();
            int month = ((Number) row[1]).intValue();
            double revenue = ((Number) row[2]).doubleValue();
            java.time.Month m = java.time.Month.of(month);
            String formattedMonth = m.toString().substring(0,1).toUpperCase() + m.toString().substring(1).toLowerCase();






            monthlyRevenueRows.append("<tr>")
                .append("<td>").append(year).append("</td>")
                .append("<td>").append(formattedMonth).append("</td>")
                .append("<td>RM ").append(String.format("%.2f", revenue)).append("</td>")
                .append("</tr>");
        }   


        Map<String, String> values = new HashMap<>();
        values.put("reportDate", java.time.LocalDate.now().toString());
        values.put("topProductsRows", topSellingRows.toString());
        values.put("monthlyRevenueRows", monthlyRevenueRows.toString());



        PdfService service = new PdfService(PdfType.REPORT, values, PdfOrientation.LANDSCAPE);
        File pdf = service.convert();

        if (pdf != null) {
            byte[] pdfFile = Files.readAllBytes(pdf.toPath());
            FileType fileType = Helpers.getFileTypeFromBytes(pdfFile);
            ((ObjectNode) jsonResponse).put("pdf_success", true);
            ((ObjectNode) jsonResponse).put("pdf_path", pdf.getAbsolutePath());
            return source(pdfFile, "Sales Report", fileType);
            
        } else {
            System.out.println("Failed to generate PDF.");
            jsonResponse.put("status", "error");
            return json(jsonResponse);

        }


        
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
    @SyncCache(channel = "User")
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
            return page("staff");
        }

        // check if the username or email exists inside the database
        User existsUser = userDA.getUserByEmailUsername(userEmail, userName);
        if (existsUser != null) {

            // check if username same
            if (existsUser.getUsername().equals(userName)) {
                request.setAttribute("error", "Username already exists");
                return page("staff");
            }

            // check if email same
            if (existsUser.getEmail().equals(userEmail)) {
                request.setAttribute("error", "Email already exists");
                return page("staff");
            }
            return page("staff");
        }

        // Create new staff user
        User staff = new User();
        Role role = userDA.getRoleByName(RoleType.STAFF.get());
        staff.setUsername(userName);
        staff.setEmail(userEmail);
        userPassword = Helpers.hashPassword(userPassword);
        staff.setPassword(userPassword);
        staff.setBirthdate(userBirthdate);
        staff.setRole(role);

        // Save the staff member
        boolean result = userDA.createUser(staff);

        if (result) {
            return page("staff");
        } else {
            request.setAttribute("error", "Error adding staff member");
            return page("staff");
        }
    }

    @HttpRequest(HttpMethod.POST)
    @ActionAttribute(urlPattern = "staff/update")
    @SyncCache(channel = "User")
    public Result editStaff() throws Exception {
        System.out.println("🔍 DEBUG: editStaff() method started");

        String userIdParam = request.getParameter("user_id");
        String userName = request.getParameter("user_name");
        String userEmail = request.getParameter("user_email");
        String userBirthdate = request.getParameter("user_birthdate");

        System.out.println("🔍 DEBUG: Received parameters - userId: " + userIdParam +
                ", userName: " + userName +
                ", userEmail: " + userEmail +
                ", userBirthdate: " + userBirthdate);

        // Basic validation
        if (userIdParam == null || userIdParam.trim().isEmpty() ||
                userName == null || userName.trim().isEmpty() ||
                userEmail == null || userEmail.trim().isEmpty()) {
            System.out.println("⚠️ DEBUG: Validation failed - missing required fields");
            request.setAttribute("error", "ID, name, and email are required");
            return page("staff");
        }

        // check if the username or email exists inside the database
        System.out.println("🔍 DEBUG: Checking if username or email already exists");
        User existsUser = userDA.getUserByEmailUsername(userEmail, userName);
        if (existsUser != null) {
            System.out.println("🔍 DEBUG: Found existing user: " + existsUser.getId() + ", username: "
                    + existsUser.getUsername() + ", email: " + existsUser.getEmail());

            // check if username same
            if (existsUser.getUsername().equals(userName)) {
                System.out.println("⚠️ DEBUG: Username already exists");
                request.setAttribute("error", "Username already exists");
                return page("staff");
            }

            // check if email same
            if (existsUser.getEmail().equals(userEmail)) {
                System.out.println("⚠️ DEBUG: Email already exists");
                request.setAttribute("error", "Email already exists");
                return page("staff");
            }
            System.out.println("⚠️ DEBUG: Some other conflict with existing user");
            return page("staff");
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            System.out.println("🔍 DEBUG: Parsed userId: " + userId);

            // Get existing staff member
            System.out.println("🔍 DEBUG: Fetching staff user with ID: " + userId);
            User staff = userDA.getUserById(userId);

            if (staff == null) {
                System.out.println("⚠️ DEBUG: Staff not found with ID: " + userId);
                return page("staff");
            }

            if (!RoleType.STAFF.get().equalsIgnoreCase(staff.getRole().getDescription())) {
                System.out.println("⚠️ DEBUG: User with ID " + userId + " is not a staff member. Role: "
                        + staff.getRole().getDescription());
                return page("staff");
            }

            System.out.println("🔍 DEBUG: Found staff user: " + staff.getUsername() + " (ID: " + staff.getId() + ")");

            // Update
            System.out.println("🔍 DEBUG: Updating staff information - userName: " + userName + ", userEmail: "
                    + userEmail + ", birthdate: " + userBirthdate);
            staff.setUsername(userName);
            staff.setEmail(userEmail);
            staff.setBirthdate(userBirthdate);

            // Update the staff member
            System.out.println("🔍 DEBUG: Calling userDA.updateUser()");
            boolean success = userDA.updateUser(staff);

            if (success) {
                // Success
                System.out.println("✅ DEBUG: Staff updated successfully");
                // freeze current thread for 500ms
                Thread.sleep(500);
                return page("staff");
            } else {
                // Error
                System.out.println("❌ DEBUG: Failed to update staff - database returned false");
                request.setAttribute("error", "Error updating staff member");
                return page("staff");
            }

        } catch (NumberFormatException e) {
            System.out.println("❌ DEBUG: Invalid user ID format: " + userIdParam + " - " + e.getMessage());
            return page("staff");
        } catch (Exception e) {
            System.out.println("❌ DEBUG: Unexpected error in editStaff: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred");
            return page("staff");
        }
    }

    @SyncCache(channel = "User")
    @ActionAttribute(urlPattern = "staff/delete")
    public Result deleteStaff() throws Exception {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);

                // Delete the staff member
                boolean success = userDA.deleteUser(userId);
                System.out.println("Result: " + success);
                if (success) {
                    return page("staff");
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
        }

        // Always redirect back to staff list
        return page("staff");
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
        List<CustomerDTO> customerList = userDA.getCustomers();
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

    // @Authorization(accessUrls = "Dashboard/voucher/add")
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

    // @Authorization(accessUrls = "Dashboard/voucher/status")
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
