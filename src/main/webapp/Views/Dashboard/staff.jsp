<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="../Shared/AdminHeader.jsp" %>
<%@ include file="../Shared/AdminNavigation.jsp" %>


<!-- Main Content Area with proper spacing -->
<div class="flex-1 p-6 overflow-auto">
  <!-- Page Header -->
  <div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Staff Management</h2>
    <button onclick="document.getElementById('addStaffModal').classList.remove('hidden')" 
            class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors">
      <i class="fas fa-plus mr-2"></i> Add Staff
    </button>
  </div>

  <!-- Global Error Message -->
  <c:if test="${not empty requestScope.error}">
    <div class="bg-red-50 border border-red-200 rounded-md p-4 mb-6" id="pageErrorContainer">
      <div class="flex">
        <div class="flex-shrink-0">
          <i class="fas fa-exclamation-triangle text-red-500"></i>
        </div>
        <div class="ml-3">
          <h3 class="text-sm font-medium text-red-800">Error</h3>
          <div class="text-sm text-red-700 mt-2">
            <c:out value="${requestScope.error}"/>
          </div>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button type="button" class="inline-flex rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none" 
                    onclick="document.getElementById('pageErrorContainer').remove()">
              <span class="sr-only">Dismiss</span>
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Search Staff -->
  <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
    <form action="<%= request.getContextPath() %>/Dashboard/staff" method="GET" class="flex items-end gap-4">
      <div class="flex-grow">
        <div class="relative">
          <input type="text" 
                name="staff_search" 
                id="staffSearch" 
                placeholder="Search by name or email..." 
                value="<c:out value="${staff_search}"/>" 
                class="pl-10 w-full py-2 pr-4 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none">
        </div>
      </div>
      <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors flex items-center">
        <i class="fas fa-search mr-2"></i> Search
      </button>
    </form>
  </div>

  <!-- Staff Table - full width with spacing -->
  <div class="bg-white rounded-lg shadow-sm overflow-hidden w-full">
    <div class="overflow-x-auto">
      <table class="w-full table-auto">
        <thead>
          <tr class="bg-gray-50 text-left">
            <th class="px-6 py-3 text-gray-500 font-medium">Username</th>
            <th class="px-6 py-3 text-gray-500 font-medium">Email</th>
            <th class="px-6 py-3 text-gray-500 font-medium">Birthdate</th>
            <th class="px-6 py-3 text-right text-gray-500 font-medium">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <c:forEach var="staff" items="${staffList}">
            <tr class="hover:bg-gray-50 transition-colors">
              <td class="px-6 py-4">
                <div class="flex items-center">
                  <span class="font-medium text-gray-900"><c:out value="${staff.username}"/></span>
                </div>
              </td>
              <td class="px-6 py-4 text-gray-600">
                <c:out value="${staff.email}"/>
              </td>
              <td class="px-6 py-4 text-gray-600">
                <div class="flex items-center">
                  <i class="far fa-calendar-alt mr-2 text-gray-400"></i>
                  <c:out value="${staff.birthdate}"/>
                </div>
              </td>
              <td class="px-6 py-4">
                <div class="flex gap-4 justify-end">
                  <!-- Edit -->
                  <button onclick="editStaff(${staff.id}, '${staff.username}', '${staff.email}', '${staff.birthdate}')" 
                          class="text-blue-600 hover:text-blue-900 transition-colors">
                    <i class="fas fa-pen"></i>
                  </button>
                  <!-- Delete -->
                  <button onclick="confirmDelete('Are you sure you want to delete this staff member?', '<%= request.getContextPath() %>/Dashboard/staff/delete?id=${staff.id}')" 
                          class="text-red-600 hover:text-red-900 transition-colors">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          
          <c:if test="${empty staffList}">
            <tr>
              <td colspan="4" class="px-6 py-10 text-center">
                <div class="flex flex-col items-center justify-center">
                  <i class="fas fa-users text-3xl mb-2 text-gray-300"></i>
                  <p class="text-gray-500">No staff members found</p>
                </div>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Add Staff Modal -->
<div id="addStaffModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-4">
  <div class="bg-white p-6 rounded-lg shadow-xl max-w-md w-full">
    <div class="flex justify-between items-center border-b pb-3 mb-4">
      <h2 class="text-xl font-semibold text-gray-800">Add New Staff</h2>
      <button onclick="document.getElementById('addStaffModal').classList.add('hidden')" 
              class="text-gray-400 hover:text-gray-600">
        <i class="fas fa-times"></i>
      </button>
    </div>
    
    <form action="<%= request.getContextPath() %>/Dashboard/staff/add" method="POST" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
        <input type="text" name="user_name" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" required>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
        <input type="email" name="user_email" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" required>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Birthdate</label>
        <input type="date" name="user_birthdate" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500">
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
        <input type="password" name="user_password" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" required>
      </div>
      
      <div class="flex justify-end gap-3 pt-4">
        <button type="button" 
                onclick="document.getElementById('addStaffModal').classList.add('hidden')"
                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50">
          Cancel
        </button>
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
          Add Staff
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Edit Staff Modal Container -->
<div id="editStaffModalContainer"></div>

<script>
  function editStaff(userId, userName, userEmail, userBirthdate) {
    
    const modalHtml = `
      <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-4" id="editStaffModal">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
          <div class="flex justify-between items-center border-b p-4">
            <h2 class="text-xl font-semibold text-gray-800">Edit Staff</h2>
            <button onclick="document.getElementById('editStaffModal').remove()" class="text-gray-400 hover:text-gray-600">
              <i class="fas fa-times"></i>
            </button>
          </div>
          
          <form action="<%= request.getContextPath() %>/Dashboard/staff/update" method="POST" class="p-6 space-y-4">
            <input type="hidden" name="user_id" value="\${userId}">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
              <input type="text" name="user_name" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" value="\${userName}" required>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input type="email" name="user_email" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" value="\${userEmail}" required>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Birthdate</label>
              <input type="date" name="user_birthdate" class="w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500" value="\${userBirthdate}">
            </div>
            
            <div class="flex justify-end gap-3 pt-4">
              <button type="button" 
                      onclick="document.getElementById('editStaffModal').remove()"
                      class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50">
                Cancel
              </button>
              <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700">
                Update Staff
              </button>
            </div>
          </form>
        </div>
      </div>
    `;
    
    document.getElementById('editStaffModalContainer').innerHTML = modalHtml;
  }
  
  function confirmDelete(message, url) {
    if (confirm(message)) {
      window.location.href = url;
    }
  }
</script>

<%@ include file="../Shared/AdminFooter.jsp" %>