<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Sidebar -->
<div class="w-64 bg-white shadow-md">
  <div class="p-6 text-2xl font-bold border-b"><i class="fa-solid fa-users-gear"></i>&nbsp; Admin Portal</div>
  
  <% 
    // Get current URL to determine active page
    String currentUrl = request.getRequestURI();
    boolean isDashboardActive = currentUrl.endsWith("/Admin/Dashboard");
    boolean isStaffActive = currentUrl.contains("/Admin/Dashboard/staff");
    boolean isCustomerActive = currentUrl.contains("/Admin/Dashboard/customer");
    boolean isVouchersActive = currentUrl.contains("/Admin/Dashboard/vouchers");
  %>
  
  <nav class="p-4 space-y-2">
    <a href="<%= request.getContextPath() %>/Admin/Dashboard" 
       class="block px-4 py-2 rounded transition <%= isDashboardActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-gauge-high mr-2"></i> Dashboard
    </a>
    
    <a href="<%= request.getContextPath() %>/Admin/Dashboard/staff" 
       class="block px-4 py-2 rounded transition <%= isStaffActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-user-tie mr-2"></i> Staff
    </a>
    
    <a href="<%= request.getContextPath() %>/Admin/Dashboard/customer" 
       class="block px-4 py-2 rounded transition <%= isCustomerActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-users mr-2"></i> Customer
    </a>

    <a href="<%= request.getContextPath() %>/Admin/Dashboard/vouchers" 
       class="block px-4 py-2 rounded transition <%= isVouchersActive ? "bg-blue-100 text-blue-700 font-medium border-l-4 border-blue-500" : "hover:bg-gray-200" %>">
      <i class="fa-solid fa-ticket mr-2"></i> Vouchers
    </a>
  </nav>
</div>