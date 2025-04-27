<!DOCTYPE html>
<html lang="en">
<%@ page import="java.util.List" %>
<%@ page import="Models.Accounts.Voucher" %>
<%@ page import="mvc.Helpers.Helpers" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mystichome Creations</title>
    <!-- Tailwind & other resources -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>

<body class="p-2 m-0">
    <div class="bg-white px-4 py-3">
        <h1 class="text-lg font-bold text-gray-800">My Vouchers</h1>
    </div>

    <div class="bg-white w-full p-4">
        <hr class="border-gray-200 p-2" />
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

    <script>
        $(function () {
            $voucherModal = $(window.parent.document).find('#voucherModal');

		if ($voucherModal.hasClass('flex')) {
			$voucherModal.removeClass('flex').addClass('hidden');
		}
            function clearVoucherForm() {
                $modal = $(window.parent.document).find('#voucherModal');
                $modal.find('#voucherId').val('');
                $modal.find('#voucherName').val('');
                $modal.find('#voucherType').val('');
                $modal.find('#voucherAmount').val('');
                $modal.find('#minSpend').val('');
                $modal.find('#maxDiscount').val('');
                $modal.find('#usagePerMonth').val('');
            }

            $('#addVoucherTile').on('click', function () {
                clearVoucherForm();
                const parentDoc = $(window.parent.document);
                parentDoc.find('#voucherModal').removeClass('hidden').addClass('flex');
                parentDoc.find('#voucherForm')[0].reset();
                parentDoc.find('#modalTitle').text('Add Voucher');
                parentDoc.find('#voucherId').val('');
            });

            $(document).on('click', '.status-btn', function () {
                const isActive = $(this).data('status') === 'active';
                const voucherId = $(this).data('id');
                
                $.ajax({
                    url: '<%= request.getContextPath() %>/User/account/voucher/status',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        voucherId: voucherId,
                        status: !isActive
                    }),
                    success: function (response) {
                        if (response.status == 200) {
                            setTimeout(() => location.reload(), 300);
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function (xhr, status, error) {
						// Check if we got redirected to a login page or error page
                        if (xhr.status === 200 && xhr.responseText.includes('<html')) {
                            alert("An error occurred while update the voucher's status.");
                            return;
                        }
                        let response = xhr.responseJSON;
                        alert(response ? response.message : "An error occurred while update the voucher's status.");
                    }
                });
            });
            $(window.parent.document).on('click', '#voucherModal #saveModal', function () {
                //write ajax to add voucher
                $modal = $(window.parent.document).find('#voucherModal');
                const formData = {
                    voucherId: $modal.find('#voucherId').val(),
                    name: $modal.find('#voucherName').val(),
                    description: $modal.find('#voucherDescription').val(),
                    type: $modal.find('#voucherType').val(),
                    amount: $modal.find('#voucherAmount').val(),
                    minSpent: $modal.find('#minSpend').val(),
                    maxCoverage: $modal.find('#maxDiscount').val(),
                    usagePerMonth: $modal.find('#usagePerMonth').val(),

                };

                $.ajax({
                    url: '<%= request.getContextPath() %>/User/account/voucher/add',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                            voucher : formData
                        }),
                    success: function (response) {
                        if (response.status == 200) {
                            setTimeout(() => location.reload(), 500);
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function (xhr, status, error) {
						// Check if we got redirected to a login page or error page
                        if (xhr.status === 200 && xhr.responseText.includes('<html')) {
                            alert("An error occurred while saving the voucher.");
                            return;
                        }
                        let response = xhr.responseJSON;
                        alert(response ? response.message : "An error occurred while saving the voucher.");
                    }
                });
            });
        });
    </script>

</body>

</html>
