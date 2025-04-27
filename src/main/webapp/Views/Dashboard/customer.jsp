<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ page import="Models.Users.User" %>
<%@ page import="mvc.Helpers.JsonConverter" %>

<%@ include file="../Shared/AdminHeader.jsp" %>
<%@ include file="../Shared/AdminNavigation.jsp" %>

<!-- Main Content Area with proper spacing -->
<div class="flex-1 p-6 overflow-auto">
  <!-- Page Header -->
  <div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Customer Management</h2>
  </div>

  <!-- Search Customer -->
  <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
    <form action="<%= request.getContextPath() %>/Admin/Dashboard/customer" method="GET" class="flex items-end gap-4">
      <div class="flex-grow">
        <div class="relative">
          <input type="text" 
                name="customer_search" 
                id="customerSearch" 
                placeholder="Search by name or email..." 
                value="<c:out value="${customer_search}"/>" 
                class="pl-10 w-full py-2 pr-4 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none">
        </div>
      </div>
      <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors flex items-center">
        <i class="fas fa-search mr-2"></i> Search
      </button>
    </form>
  </div>

  <!-- Customer Table -->
  <div class="bg-white rounded-lg shadow-sm overflow-hidden w-full">
    <div class="overflow-x-auto">
      <table class="w-full table-auto">
        <thead>
          <tr class="bg-gray-50 text-left">
            <th class="px-6 py-3 text-gray-500 font-medium">Username</th>
            <th class="px-6 py-3 text-gray-500 font-medium">Email</th>
            <th class="px-6 py-3 text-gray-500 font-medium">Birthdate</th>
            <th class="px-6 py-3 text-gray-500 font-medium">Total Spent</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <c:forEach var="customer" items="${customerList}">
            <tr class="hover:bg-gray-50 transition-colors">
              <td class="px-6 py-4">
                <div class="flex items-center">
                  <span class="font-medium text-gray-900"><c:out value="${customer.username}"/></span>
                </div>
              </td>
              <td class="px-6 py-4 text-gray-600">
                <div class="flex items-center">
                  <i class="far fa-envelope text-gray-400 mr-2"></i>
                  <c:out value="${customer.email}"/>
                </div>
              </td>
              <td class="px-6 py-4 text-gray-600">
                <div class="flex items-center">
                  <i class="far fa-calendar-alt text-gray-400 mr-2"></i>
                  <c:out value="${customer.birthdate}"/>
                </div>
              </td>
              <td class="px-6 py-4 text-gray-600">
                <div class="flex items-center">
                  <c:out value="RM99.99"/>
                </div>
              </td>
            </tr>
          </c:forEach>
          
          <c:if test="${empty customerList}">
            <tr>
              <td colspan="5" class="px-6 py-10 text-center">
                <div class="flex flex-col items-center justify-center">
                  <i class="fas fa-users text-3xl mb-2 text-gray-300"></i>
                  <p class="text-gray-500">No customers found</p>
                </div>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Pagination (if needed) -->
  <c:if test="${totalPages > 1}">
    <div class="flex justify-center mt-6">
      <nav class="flex items-center space-x-1">
        <!-- Previous Page -->
        <c:if test="${currentPage > 1}">
          <a href="<%= request.getContextPath() %>/Admin/Dashboard/customer?page=${currentPage-1}&customer_search=${customer_search}"
             class="px-3 py-2 rounded-md border hover:bg-gray-100 transition-colors">
            <i class="fas fa-chevron-left"></i>
          </a>
        </c:if>
        
        <!-- Page Numbers -->
        <c:forEach begin="1" end="${totalPages}" var="pageNumber">
          <a href="<%= request.getContextPath() %>/Admin/Dashboard/customer?page=${pageNumber}&customer_search=${customer_search}"
             class="px-3 py-1 rounded-md border ${pageNumber == currentPage ? 'bg-blue-500 text-white' : 'hover:bg-gray-100'} transition-colors">
            ${pageNumber}
          </a>
        </c:forEach>
        
        <!-- Next Page -->
        <c:if test="${currentPage < totalPages}">
          <a href="<%= request.getContextPath() %>/Admin/Dashboard/customer?page=${currentPage+1}&customer_search=${customer_search}"
             class="px-3 py-2 rounded-md border hover:bg-gray-100 transition-colors">
            <i class="fas fa-chevron-right"></i>
          </a>
        </c:if>
      </nav>
    </div>
  </c:if>
</div>

<%@ include file="../Shared/AdminFooter.jsp" %>