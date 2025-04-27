<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../Shared/AdminHeader.jsp" %>
<%@ include file="../Shared/AdminNavigation.jsp" %>

<%@ page import="java.util.List" %>
<%@ page import="Models.Accounts.Voucher" %>
<%@ page import="DTO.VoucherInfoDTO" %>
<%@ page import="mvc.Helpers.Helpers" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>
<!-- Main Content -->

<div class="flex-1 p-6 overflow-y-auto">
 <!-- Page Header -->
  <div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Voucher Management</h2>
  </div>
<div class="bg-white px-4 py-3">
    <div class="bg-white w-full p-4">
        <%
            List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
            if(vouchers != null){
                for(Voucher voucher : vouchers){
            %>
            <div class="bg-gray-50 p-4 rounded shadow mb-4">
                <div class="flex justify-between">
                    <div class="text-sm">
                        <p class="font-semibold text-gray-700">
                            <%= StringEscapeUtils.escapeHtml4(voucher.getName()) %> &middot; 
                            <%= voucher.getType().equals("Percent") ? 
                                StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getAmount())) + "%" : 
                                "RM" + StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getAmount())) %>
                        </p>
                        <p class="text-xs text-gray-500"><%= StringEscapeUtils.escapeHtml4(voucher.getDescription()) %></p>
                        <p class="text-xs text-gray-400">
                            MIN: RM<%= StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getMinSpent())) %> &middot; 
                            MAX: RM<%= StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getMaxCoverage())) %>
                        </p>
                        <p class="text-xs text-gray-400">Usage: 2/3</p>
                    </div>
                    <div class="flex space-x-2 items-start">
                        <% if(voucher.getStatus() == 1) { %>
                            <button
                            class="status-btn border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md hover:bg-green-50"
                            data-status="active" data-id="<%= StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getId())) %>">
                            Active
                            </button>
                        <% } else { %>
                            <button
                            class="status-btn border border-gray-900 text-gray-900 text-xs px-3 py-1 rounded-md hover:bg-gray-100"
                            data-status="inactive" data-id="<%= StringEscapeUtils.escapeHtml4(String.valueOf(voucher.getId())) %>">
                            Inactive
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
            <% 
                }
            } else {
                
            %>
            <div class="text-center py-6 text-gray-500">
                <p>No saved Vouchers yet.</p>
            </div>
            <% 
            }
            %>

        <!-- Add New Voucher -->
        <div class="bg-white rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50"
            id="addVoucherTile">
            <div class="flex flex-col items-center space-y-2">
                <span class="text-2xl text-gray-400">+</span>
                <p class="text-gray-600 text-sm">Add New Voucher</p>
            </div>
        </div>
    </div>

    

</div>

<%@ include file="../Shared/AdminFooter.jsp" %>

