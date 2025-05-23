<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Panel - MysticHome Creations</title>
      <!-- Tailwind & other resources -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.9/dist/chart.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="h-screen bg-gray-100 font-sans">

<header class="bg-gray-700 text-white shadow flex items-center justify-between px-6 py-4">
    <h1 class="text-xl font-semibold">MysticHome Creations</h1>
    <nav class="space-x-4">
      <a href="<%= request.getContextPath() %>/Dashboard" class="text-gray-400 hover:text-blue-600">Home</a>
      <a href="<%= request.getContextPath() %>/Landing" class="text-gray-400 hover:text-blue-600">Back to Main Page</a>
	  <form id="logoutForm" action="<%= request.getContextPath()%>/Landing/logout" method="post" enctype="multipart/form-data">
			<button class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" type="button" onclick="javascript:logout()">Logout</button>
		</form>
    </nav>
</header>

<div id="voucherModal" data-mode="add"
		class="fixed inset-0 z-50 hidden items-center justify-center bg-[rgba(0,0,0,0.4)] backdrop-blur-sm">
		<div id="voucherModalContent"
			class="bg-white rounded-lg w-full max-w-[550px] p-6 space-y-4 max-h-[90vh] overflow-y-auto">
			<div class="flex justify-between items-center mb-2">
				<h2 class="text-lg font-semibold text-gray-800">Add New Voucher</h2>
				<button id="closeVoucherModal" class="text-gray-400 hover:text-gray-600 text-xl">&times;</button>
			</div>

			<div id="voucherForm" class="space-y-4">
				<div class="grid grid-cols-10 gap-4">
					<div class="col-span-6">
						<label class="block text-sm font-medium text-gray-700">Voucher Name</label>
						<input type="text" placeholder="e.g. Mega Saver" id="voucherName"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">	
					</div>
					<div class="col-span-4">
						<label class="block text-sm font-medium text-gray-700">Voucher Usage Per Month</label>
						<input type="number" placeholder="e.g. 3" id="usagePerMonth"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
				</div>
				<div>
					<label class="block text-sm font-medium text-gray-700">Description</label>
					<textarea rows="2" placeholder="e.g. Valid for all orders above RM50" id="voucherDescription"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">Voucher Amount</label>
						<input type="number" placeholder="e.g. 300" id="voucherAmount"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">Voucher Type</label>
						<select id="voucherType"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
							<option value="flat">RM Amount</option>
							<option value="percentage">Percentage (%)</option>
						</select>
					</div>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">Min Spend</label>
						<input type="number" placeholder="e.g. 50" id="minSpend"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">Max Discount</label>
						<input type="number" placeholder="e.g. 300" id="maxDiscount"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
				</div>

				<div class="flex justify-end space-x-2 pt-2">
					<button type="button" id="cancelVoucherModal"
						class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Cancel</button>
					<button type="submit" id="saveModal"
						class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Save</button>
				</div>
			</div>
		</div>
	</div>
<script>
function logout() {   
		const logoutForm = document.getElementById('logoutForm');
		Swal.fire({
			title: "Are you sure?",
			text: "You will be signed out of your account.",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6", // Blue button
			cancelButtonColor: "#d33",     // Red button
			confirmButtonText: "Yes, sign me out",
			cancelButtonText: "Cancel"
		}).then((result) => {
			if (result.isConfirmed) {
				logoutForm.submit();
			}
		});
	}
$(function () {
	const $voucherModal = $('#voucherModal');
    $('#closeVoucherModal, #cancelVoucherModal').on('click', function() {
        $voucherModal.addClass('hidden').removeClass('flex');
    });
    $voucherModal.on('click', function(e) {
        if (!$(e.target).closest('#voucherModalContent').length) {
            $voucherModal.addClass('hidden').removeClass('flex');
        }
    });
    $('#voucherForm').on('submit', function(e) {
        e.preventDefault();
        Swal.fire({
			title: "Success!",
			text: "Voucher has been saved.",
			icon: "success",
			confirmButtonText: "OK"
		});
        $voucherModal.addClass('hidden').removeClass('flex');
    });      
	
});
    

</script>
<div class="flex flex-1 h-[calc(100vh-72px)]">