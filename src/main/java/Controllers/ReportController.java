package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Http.HttpMethod;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.ReportDAO;
import DAO.productDAO;
import Models.Accounts.Voucher;
import jakarta.servlet.annotation.WebServlet;


@WebServlet("/Report/*")
public class ReportController extends ControllerBase{

    @ActionAttribute(urlPattern = "report")
    public Result report() throws Exception {
        ReportDAO reportDAO = new ReportDAO();  

        try{

        
            // BigDecimal totalEarned = reportDAO.getTotalEarned();    
            Long pendingOrdersCount = reportDAO.getPendingOrdersCount();
            // List<Object[]> paymentMethodStats = reportDAO.getPaymentMethodStats();
            Long totalUsersCount = reportDAO.getTotalUsersCount();
            Long totalStaffCount = reportDAO.getTotalStaffCount();
            // List<Object[]> mostUsedVoucher = reportDAO.getMostUsedVouchers();

            
            // Print metrics to console for debugging
            System.out.println("Dashboard Metrics:");
            // System.out.println(" ⭐ totalEarned = " + totalEarned);
            System.out.println("⭐  pendingOrdersCount = " + pendingOrdersCount);
            // System.out.println(" ⭐ paymentMethodStats size = " + paymentMethodStats.size());
            System.out.println(" ⭐ totalUsersCount = " + totalUsersCount);
            System.out.println(" ⭐ totalStaffCount = " + totalStaffCount);
            // System.out.println(" ⭐ mostUsedVoucher = " + mostUsedVoucher);

            // Debugging: Check if each field is successfully retrieved
            System.out.println("Debugging Field Status:");
            // System.out.println("✅  totalEarned retrieved: " + (totalEarned != null));
            System.out.println(" ✅ pendingOrdersCount retrieved: " + (pendingOrdersCount != null));
            // System.out.println(" ✅ paymentMethodStats retrieved: " + (paymentMethodStats != null && !paymentMethodStats.isEmpty()));
            System.out.println("  ✅totalUsersCount retrieved: " + (totalUsersCount != null));
            System.out.println("  ✅totalStaffCount retrieved: " + (totalStaffCount != null));
            // System.out.println(" ✅ mostUsedVoucher retrieved: " + (mostUsedVoucher != null && !mostUsedVoucher.isEmpty()));

            // Set request attributes for JSP rendering
            // request.setAttribute("totalEarned", totalEarned);
            request.setAttribute("pendingOrdersCount", pendingOrdersCount);
            // request.setAttribute("paymentMethodStats", paymentMethodStats);
            request.setAttribute("totalUsersCount", totalUsersCount);
            request.setAttribute("totalStaffCount", totalStaffCount);
            // request.setAttribute("mostUsedVoucher", mostUsedVoucher);
        }catch(Exception e){
            e.printStackTrace();
            return error(); 
        }

        return page();
    }







    
}
