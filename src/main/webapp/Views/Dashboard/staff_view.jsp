<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="../Shared/AdminHeader.jsp" %>
<%@ include file="../Shared/AdminNavigation.jsp" %>

<!-- Main Content -->
<div class="flex-1 p-6 overflow-y-auto">
  <div class="max-w-md mx-auto bg-white p-6 rounded shadow">
    <h2 class="text-xl font-semibold mb-4">Staff Details</h2>
    <p><strong>Name:</strong> <c:out value="${staff.username}"/></p>
    <p><strong>Email:</strong> <c:out value="${staff.email}"/></p>
    <p><strong>Birthdate:</strong>  <c:out value="${staff.birthdate}"/></p>
    <a href="${pageContext.request.contextPath}/Dashboard/staff" class="mt-4 inline-block text-blue-600">Back to Staff</a>
  </div>
</div>

<%@ include file="../Shared/AdminFooter.jsp" %>