package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import DAO.ReportDAO;
import DAO.productDAO;
import Models.Products.product;
import Models.Products.productType;
import jakarta.servlet.annotation.WebServlet;
import Models.Products.productDTO;




@WebServlet("/Report/*")
public class ReportController extends ControllerBase{
    ReportDAO reportDAO = new ReportDAO();  
    productDAO productDAO = new productDAO();
   

    @ActionAttribute(urlPattern = "report")
    public Result report() throws Exception {

        //#region accept parameter 

        



        // #variable declaration
        int totalCustomers = reportDAO.getTotalCustomers();
        int totalStuff = reportDAO.getTotalStaff();
        // List<product> lowStock = reportDAO.getLowStockProducts(5);
        // List<Object[]> feedbackRatings = reportDAO.getFeedbackRatings();
        List<Object[]> paymentPreferences = reportDAO.getPaymentPreferences();
        // List<Object[]> salesByCategory = reportDAO.getSalesByCategory();
        int thisMonthCount = reportDAO.getOrdersThisMonth();
        request.setAttribute("ordersThisMonth", thisMonthCount);       
         double totalRevenue = reportDAO.getTotalRevenue();
        // List<Object[]> topSelling = reportDAO.getTopSellingProductsEachMonth();
        List<productType> productTypes = productDAO.getAllProductTypes();

        List<product> products = reportDAO.getAllProducts();

        List<Integer> ids = products.stream()
        .map(product::getId)
        .toList();

        Map<Integer,Double> avgMap   = reportDAO.getAverageRatingsForProducts(ids);
        Map<Integer,Integer> soldMap = reportDAO.getTotalSoldForProducts(ids);

        List<productDTO> dtos = products.stream()
            .map(p -> new productDTO(
                p,
                avgMap.getOrDefault(p.getId(), 0.0),
                soldMap.getOrDefault(p.getId(), 0)
            ))
            .toList();






        // #Debugging output
        System.out.println("✅ Total Customers: " + totalCustomers);
        System.out.println("✅ Total Staff: " + totalStuff);
        System.out.println("✅ productList count = " + products.size());

        // for (Object[] row : paymentPreferences) {
        //     String method = (String) row[0];
        //     long   count  = ((Number) row[1]).longValue();
        //     System.out.printf("🔹 %d × %s%n", count, method);
        // }

        // System.out.printf(
        //     "✅ salesByCategory count=%d categories: %s%n",
        //     salesByCategory.size(),
        //     salesByCategory.stream()
        //                     .map(r -> String.format("%s=RM%.2f", r[0], ((Number)r[1]).doubleValue()))
        //                     .toList()
        // );

        // System.out.printf("✅ months=%d → %s%n",
        //     ordersByMonth.size(),
        //     ordersByMonth.stream()
        //         .map(r -> String.format("%d-%02d=%d",
        //             ((Number)r[0]).intValue(),
        //             ((Number)r[1]).intValue(),
        //             ((Number)r[2]).intValue()))
        //         .toList()
        //     );
                    
        //     System.out.printf("✅ totalRevenue=RM%.2f%n", totalRevenue);


            // System.out.printf(
            // "✅ topSelling count=%d months: %s%n",
            // topSelling.size(),
            // topSelling.stream()
            //     .map(r -> String.format("%d-%02d→%s(%d)",
            //     ((Number)r[0]).intValue(),
            //     ((Number)r[1]).intValue(),
            //     r[2],
            //     ((Number)r[3]).intValue()))
            //     .toList()
            // );




        // #Set attributes for the view
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalStaff", totalStuff);
        // request.setAttribute("lowStock", lowStock);
        // request.setAttribute("feedbackRatings", feedbackRatings);
        request.setAttribute("paymentPreferences", paymentPreferences);
        // request.setAttribute("ordersByMonth", ordersByMonth);
        request.setAttribute("totalRevenue", totalRevenue);
        // request.setAttribute("topSelling", topSelling);
        // request.setAttribute("salesByCategory", salesByCategory);


        // display purpose only 
        request.setAttribute("productList", products);
        request.setAttribute("productTypes", productTypes);
        request.setAttribute("productDTOs", dtos);







        

        return page();
    }

    @ActionAttribute(urlPattern = "report/filter")
    public Result filter() throws Exception {

        String[] categories  = request.getParameterValues("category");
        System.out.println("Selected Categories: " + Arrays.toString(categories));

         List<Integer> catIds = (categories == null)
            ? List.of()
            : Arrays.stream(categories).map(Integer::valueOf).collect(Collectors.toList());

        Double priceMin = request.getParameter("priceMin")  != null && !request.getParameter("priceMin").isEmpty()
            ? Double.valueOf(request.getParameter("priceMin"))
            : null;

        Double priceMax = request.getParameter("priceMax")  != null && !request.getParameter("priceMax").isEmpty()
            ? Double.valueOf(request.getParameter("priceMax"))
            : null;

        Integer stockMin= request.getParameter("stockMin") != null && !request.getParameter("stockMin").isEmpty()
            ? Integer.valueOf(request.getParameter("stockMin"))
            : null;

        Integer stockMax= request.getParameter("stockMax") != null && !request.getParameter("stockMax").isEmpty()
            ? Integer.valueOf(request.getParameter("stockMax"))
            : null;

        Double ratingMin= request.getParameter("ratingMin") != null && !request.getParameter("ratingMin").isEmpty()
            ? Double.valueOf(request.getParameter("ratingMin"))
            : null;
        
         LocalDate dateFrom = request.getParameter("dateFrom") != null && !request.getParameter("dateFrom").isEmpty()
            ? LocalDate.parse(request.getParameter("dateFrom"))
            : null;

        LocalDate dateTo   = request.getParameter("dateTo")   != null && !request.getParameter("dateTo").isEmpty()
            ? LocalDate.parse(request.getParameter("dateTo"))
            : null;


            System.out.println("🔍 Selected Categories: " + Arrays.toString(categories));
            System.out.println("🔍 priceMin: "   + request.getParameter("priceMin"));
            System.out.println("🔍 priceMax: "   + request.getParameter("priceMax"));
            System.out.println("🔍 stockMin: "   + request.getParameter("stockMin"));
            System.out.println("🔍 stockMax: "   + request.getParameter("stockMax"));
            System.out.println("🔍 ratingMin: "  + request.getParameter("ratingMin"));
            System.out.println("🔍 dateFrom: "   + request.getParameter("dateFrom"));
            System.out.println("🔍 dateTo: "     + request.getParameter("dateTo"));

            List<product> filtered = reportDAO.filterProducts(
                catIds, priceMin, priceMax,
                stockMin, stockMax,
                ratingMin, dateFrom, dateTo
            );

            System.out.println("✅ filterProducts returned " + filtered.size() + " items");


            List<Integer> ids = filtered.stream()
            .map(product::getId)
            .toList();

            Map<Integer,Double> avgMap   = reportDAO.getAverageRatingsForProducts(ids);
            Map<Integer,Integer> soldMap = reportDAO.getTotalSoldForProducts(ids);


        // Take note
        List<productDTO> dtos = filtered.stream()
        .map(p -> new productDTO(
            p,
            avgMap.getOrDefault(p.getId(), 0.0),
            soldMap.getOrDefault(p.getId(), 0)
        ))
        .toList();
        System.out.println("✅ Built " + dtos.size() + " productDTOs");

        return json(dtos);


       

    }

    @ActionAttribute(urlPattern = "report/dailyRevenue")
    public Result dailyRevenue() throws Exception {
        int days = Integer.parseInt(request.getParameter("days"));
        System.out.println("🔍 [dailyRevenue] raw daysParam = " + days);

        List<Object[]> daily = reportDAO.getDailyRevenue(days);

        System.out.println("---- Daily Revenue (last " + days + " days) ----");
        for (Object[] r : daily) {
            java.sql.Date day = (java.sql.Date) r[0];
            Number totalPaid = (Number) r[1];
            System.out.printf(
                "%s → RM%.2f%n",
                day.toString(),
                totalPaid.doubleValue()
            );
        }

        var dailylist = daily.stream()
            .map(r -> Arrays.asList(
                r[0].toString(),
                ((Number)r[1]).doubleValue()
            ))
            .toList();

        return json(dailylist);
    }

    @ActionAttribute(urlPattern = "report/monthlyRevenue")
    public Result monthlyRevenue() throws Exception {
        int months = Integer.parseInt(request.getParameter("months"));
        System.out.println("🔍 [monthlyRevenue] raw monthsParam = " + months);
    
        List<Object[]> monthly = reportDAO.getMonthlyRevenue(months);
    
        System.out.println("---- Monthly Revenue (last " + months + " months) ----");
        for (Object[] r : monthly) {
            int y = ((Number) r[0]).intValue();
            int m = ((Number) r[1]).intValue();
            double tot = ((Number) r[2]).doubleValue();
            System.out.printf("%d-%02d → RM%.2f%n", y, m, tot);
        }
    
        var monthlyList = monthly.stream()
            .map(r -> {
                int y = ((Number)r[0]).intValue();
                int m = ((Number)r[1]).intValue();
                double tot = ((Number)r[2]).doubleValue();
                String label = String.format("%d-%02d", y, m);
                return Arrays.asList(label, tot);
            })
            .toList();
    
        return json(monthlyList);
    }

    @ActionAttribute(urlPattern = "report/salesByCategory")
    public Result salesByCategory() throws Exception {
        List<Object[]> sales = reportDAO.getSalesByCategoryNative();

        System.out.println("---- Sales by Category ----");
        for (Object[] r : sales) {
            String catName = (String) r[0];
            double total = ((Number) r[1]).doubleValue();
            System.out.printf("%s → RM%.2f%n", catName, total);
        }

        var salesList = sales.stream()
            .map(r -> Arrays.asList(
                r[0].toString(),
                ((Number)r[1]).doubleValue()
            ))
            .toList();

        return json(salesList);
    }

    @ActionAttribute(urlPattern = "report/topSellingProducts")
    public Result topSellingProducts() throws Exception {

     
        
        return page();
    }


    
}
