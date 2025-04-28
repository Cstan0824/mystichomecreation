<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="mvc.Helpers.SessionHelper" %>
<%@ page import="java.util.List" %>
<!-- Sidebar -->
<div class="w-64 bg-white shadow-md">
  <div class="p-6 text-2xl font-bold border-b"><i class="fa-solid fa-users-gear"></i>&nbsp; Admin Portal</div>
  
  <% 
    // Get current URL to determine active page - more robust pattern matching
    String currentUrl = request.getRequestURI();
    String contextPath = request.getContextPath();
    
    // Remove context path from URL for cleaner comparison
    if (currentUrl.startsWith(contextPath)) {
      currentUrl = currentUrl.substring(contextPath.length());
    }

    boolean isDashboardActive = currentUrl.endsWith("/Dashboard") || currentUrl.endsWith("/Dashboard/") || currentUrl.endsWith("/Dashboard/index.jsp");
    boolean isStaffActive = currentUrl.contains("/Dashboard/staff");
    boolean isCustomerActive = currentUrl.contains("/Dashboard/customer");
    boolean isVouchersActive = currentUrl.contains("/Dashboard/vouchers");
    
    // Get session helper and check permissions
    SessionHelper sessionHelper = new SessionHelper(request.getSession());
    boolean isAuthenticated = sessionHelper.isAuthenticated();
    List<String> accessUrls = sessionHelper.getAccessUrls();
    
    %>
  
  <nav class="p-4 space-y-2">
    <% if (isAuthenticated && accessUrls.contains("Dashboard")) { %>
    <a href="<%= request.getContextPath() %>/Dashboard" 
       class="block px-4 py-2 rounded transition <%= isDashboardActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-gauge-high mr-2"></i> Dashboard
    </a>
    <% } %>
    
    <% if (isAuthenticated && accessUrls.contains("Dashboard/staff")) { %>
    <a href="<%= request.getContextPath() %>/Dashboard/staff" 
       class="block px-4 py-2 rounded transition <%= isStaffActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-user-tie mr-2"></i> Staff
    </a>
    <% } %>
    
    <% if (isAuthenticated && accessUrls.contains("Dashboard/customer")) { %>
    <a href="<%= request.getContextPath() %>/Dashboard/customer" 
       class="block px-4 py-2 rounded transition <%= isCustomerActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-users mr-2"></i> Customer
    </a>
    <% } %>

    <% if (isAuthenticated && accessUrls.contains("Dashboard/vouchers")) { %>
    <a href="<%= request.getContextPath() %>/Dashboard/vouchers" 
       class="block px-4 py-2 rounded transition <%= isVouchersActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-ticket mr-2"></i> Vouchers
    </a>
    <% } %>
  </nav>
</div>