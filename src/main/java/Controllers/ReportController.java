package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
        List<Object[]> salesByCategory = reportDAO.getSalesByCategory();
        List<Object[]> ordersByMonth = reportDAO.getOrdersPerMonth();
        double totalRevenue = reportDAO.getTotalRevenue();
        List<Object[]> topSelling = reportDAO.getTopSellingProductsEachMonth();
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
        // System.out.println("✅ Low Stock Products: " + lowStock.size() + " items found.");
        // System.out.println("✅ Feedback Ratings: " + feedbackRatings.size() + " items found.");
        System.out.println("✅ productList count = " + products.size());

        for (Object[] row : paymentPreferences) {
            String method = (String) row[0];
            long   count  = ((Number) row[1]).longValue();
            System.out.printf("🔹 %d × %s%n", count, method);
        }

        System.out.printf(
            "✅ salesByCategory count=%d categories: %s%n",
            salesByCategory.size(),
            salesByCategory.stream()
                            .map(r -> String.format("%s=RM%.2f", r[0], ((Number)r[1]).doubleValue()))
                            .toList()
        );

        System.out.printf("✅ months=%d → %s%n",
            ordersByMonth.size(),
            ordersByMonth.stream()
                .map(r -> String.format("%d-%02d=%d",
                    ((Number)r[0]).intValue(),
                    ((Number)r[1]).intValue(),
                    ((Number)r[2]).intValue()))
                .toList()
            );
                    
            System.out.printf("✅ totalRevenue=RM%.2f%n", totalRevenue);


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
        request.setAttribute("ordersByMonth", ordersByMonth);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topSelling", topSelling);
        request.setAttribute("salesByCategory", salesByCategory);


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

        // remember to accept the parameter from the request 
        int days = Integer.parseInt(request.getParameter("days"));



        List<Object[]> daily  = reportDAO.getDailyRevenue(days);


        System.out.println("---- Daily Revenue (last 7 days) ----");
        for (Object[] r : daily) {
            java.sql.Date day     = (java.sql.Date) r[0];
            Number      totalPaid = (Number)    r[1];   // use Number
            System.out.printf(
              "%s → RM%.2f%n",
              day.toString(),
              totalPaid.doubleValue()           // doubleValue()
            );
        }


        var dailylist = daily.stream()
        // For each Object[] r, build a Map with two entries:
        .map(r -> Map.of(
            // “day” → the first column, r[0], as a String
            "day",   r[0].toString(),
            // “total” → the second column, r[1], as a double
            "total", ((Number)r[1]).doubleValue()
        ))
        // Collect into a List<Map<String,Object>>
        .toList();

     


       
        return json(dailylist);
    }


    @ActionAttribute(urlPattern = "report/monthlyRevenue")
    public Result monthlyRevenue() throws Exception {

        // remember to accept the parameter from the request    
        int months = Integer.parseInt(request.getParameter("months"));



        List<Object[]> monthly  = reportDAO.getMonthlyRevenue(months);


        System.out.println("---- Monthly Revenue (last 12 months) ----");
        for (Object[] r : monthly) {
            java.sql.Date month     = (java.sql.Date) r[0];
            Number      totalPaid = (Number)    r[1];   // use Number
            System.out.printf(
              "%s → RM%.2f%n",
              month.toString(),
              totalPaid.doubleValue()           // doubleValue()
            );
        }

     


       
        return page();
    }




    
}
