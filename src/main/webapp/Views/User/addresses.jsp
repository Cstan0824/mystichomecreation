<!DOCTYPE html>
<html lang="en">
<%@ page import="java.util.List" %>
<%@ page import="Models.Accounts.ShippingInformation" %>
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
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body class="m-0 p-2">
	<!-- Page Header -->
	<div class="bg-white px-4 py-3">
		<h1 class="text-lg font-bold text-gray-800">Addresses</h1>
	</div>
	<div class="bg-white w-full p-4">
		<hr class="border-gray-200 p-2" />

		<%
		// Get the ShippingAddresses list from request attributes
		List<ShippingInformation> shippingAddresses = 
			(List<ShippingInformation>)request.getAttribute("ShippingAddresses");
		
		// Check if there are any addresses to display
		if(shippingAddresses != null && !shippingAddresses.isEmpty()) {
			// Loop through each shipping address
			for(ShippingInformation address : shippingAddresses) {
		%>
		<!-- Address Card -->
		<div class="relative bg-gray-50 p-4 rounded shadow mb-4">
			<div class="flex items-start justify-between">
				<div class="text-sm">
					<p class="font-semibold text-gray-700"><%= StringEscapeUtils.escapeHtml4(address.getLabel()) %></p>
					<p class="text-xs text-gray-500">
						<%= StringEscapeUtils.escapeHtml4(address.getReceiverName()) %> &middot; <%= StringEscapeUtils.escapeHtml4(address.getPhoneNumber()) %>
					</p>
				</div>
				<% if(address.isDefault()) { %>
				<span class="border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md">
					Default
				</span>
				<% } else { %>
				<button onclick="setDefaultAddress(<%= address.getId() %>)"
					class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">
					Set as default
				</button>
				<% } %>
			</div>

			<div class="text-sm text-gray-600 space-y-1 pl-1 mt-2">
				<p><%= StringEscapeUtils.escapeHtml4(address.getAddressLine1()) %></p>

				<% if(address.getAddressLine2() != null && !address.getAddressLine2().isEmpty()) { %>
				<p><%= StringEscapeUtils.escapeHtml4(address.getAddressLine2()) %></p>
				<% } %>

				<div class="flex justify-between items-center">
					<p><%= StringEscapeUtils.escapeHtml4(address.getPostCode()) %> <%= StringEscapeUtils.escapeHtml4(address.getState()) %></p>
					<div class="space-x-3 text-xs">
						<button
							onclick="editAddress(<%= address.getId() %>, 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getLabel())) %>', 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getReceiverName())) %>', 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getPhoneNumber())) %>', 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getState())) %>', 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getPostCode())) %>', 
							'<%= StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getAddressLine1())) %>', 
							'<%= address.getAddressLine2() != null ? StringEscapeUtils.escapeEcmaScript(StringEscapeUtils.escapeHtml4(address.getAddressLine2())) : "" %>')"
							class="text-blue-500 hover:underline">Edit</button>
						<button onclick="deleteAddress(<%= address.getId() %>)"
							class="text-red-500 hover:underline">Delete</button>
					</div>
				</div>
			</div>
		</div>

		<%
			}
		} else {
		%>
		<div class="text-center py-6 text-gray-500">
			<p>No saved addresses yet.</p>
		</div>
		<%
		}
		%>

		<!-- "Add New Address" Tile -->
		<div class="bg-white rounded-xl border-2 border-dashed border-gray-300 
			 flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50" id="addNewAddressBtn">
			<div class="flex flex-col items-center space-y-2">
				<span class="text-2xl text-gray-400">+</span>
				<p class="text-gray-600 text-sm">Add New Address</p>
			</div>
		</div>
	</div>

	<script>
		// Function to set default address
		function setDefaultAddress(addressId) {
			// AJAX request to set default address
			$.ajax({
				url: "<%= request.getContextPath() %>/User/account/addresses/default",
				type: "POST",
				contentType: "application/json",
				dataType: "json",
				data: JSON.stringify({
					ShippingAddressId: addressId
				}),
				success: function(response) {
					if (response.status == 200) {
						setTimeout(() => {
							location.reload();
						}, 500); // 300ms delay

					} else {
						Swal.fire({
							icon: 'error',
							title: 'Error',
							text: response.message || "An error occurred while set the address to default status.",
						});
					}
				},
				error: function (xhr, status, error) {
					// Check if we got redirected to a login page or error page
					if (xhr.status === 200 && xhr.responseText.includes('<html')) {
						Swal.fire({
							icon: 'error',
							title: 'Error',
							text: "An error occurred while set the address to default status.",
						});
						return;
					}
					
					let response = xhr.responseJSON;
					Swal.fire({
						icon: 'error',
						title: 'Error',
						text: response ? response.message : "An error occurred while set the address to default status.",
					});
				}
			});
		}
		// Function to edit address
		function editAddress(id, label, receiverName, phone, state, postCode, address1, address2) {
			clearAddressForm(); // Show modal
			const $modal = $(window.parent.document).find('#addressModal');
			$modal.data('mode', 'edit'); // Store address ID in modal data
			// Fill in form fields
			$modal.find('#addressId').val(id); // Store address ID in modal data
			$modal.find('#addressLabel').val(label);
			$modal.find('#receiverName').val(receiverName);
			$modal.find('#phoneNumber').val(phone);
			$modal.find('#state').val(state);
			$modal.find('#postCode').val(postCode);
			$modal.find('#addressLine1').val(address1);
			$modal.find('#addressLine2').val(address2);
			$modal.removeClass('hidden').addClass('flex');
		}

		function clearAddressForm() {
			const $modal = $(window.parent.document).find('#addressModal');
			$modal.find('#addressLabel').val('');
			$modal.find('#receiverName').val('');
			$modal.find('#phoneNumber').val('');
			$modal.find('#state').val('');
			$modal.find('#postCode').val('');
			$modal.find('#addressLine1').val('');
			$modal.find('#addressLine2').val('');
		}
		// Function to delete address
		function deleteAddress(addressId) {
			if (confirm("Are you sure you want to delete this address?")) {
				$.ajax({
					url: "<%= request.getContextPath() %>/User/account/addresses/delete",
					method: "POST",
					contentType: "application/json",
					dataType: "json",
					data: JSON.stringify({
						shippingAddressId: addressId
					}),
					success: function(response) {
						if (response.status == 200) {
							setTimeout(() => {
								location.reload();
							}, 500); // 300ms delay
						} else {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: response.message || "An error occurred while delete the address.",
							});
						}
					},
					error: function (xhr, status, error) {
						// Check if we got redirected to a login page or error page
						if (xhr.status === 200 && xhr.responseText.includes('<html')) {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: "An error occurred while delete the address.",
							});
							return;
						}
						
						let response = xhr.responseJSON;
						Swal.fire({
							icon: 'error',
							title: 'Error',
							text: response ? response.message : "An error occurred while delete the address.",
						});
					}
				});

			}
		}
		$(function() {
			//hide the modal if it consists of class flex and exclude hidden class whenever page refresh
			const $modal = $(window.parent.document).find('#addressModal');
			if ($modal.hasClass('flex')) {
				$modal.removeClass('flex').addClass('hidden');
			}

			
			// Open modal when clicking "Add New Address"
			$('#addNewAddressBtn').on('click', function() {
				clearAddressForm();
				const $modal = $(window.parent.document).find('#addressModal');
				$modal.data('mode', 'add'); // Store address ID in modal data
				$modal.removeClass('hidden').addClass('flex');
				gsap.from('#addressModal > div', {
					scale: 0.9,
					opacity: 0,
					duration: 0.3
				});
			});
			$(window.parent.document).on('click', '#addressModal #saveModal', function() {
				const $modal = $(window.parent.document).find('#addressModal');
				const mode = $modal.data('mode');
				const addressId = $modal.find('#addressId').val();
				const shippingInformation = {
					label: $modal.find('#addressLabel').val(),
					receiverName: $modal.find('#receiverName').val(),
					phoneNumber: $modal.find('#phoneNumber').val(),
					state: $modal.find('#state').val(),
					postCode: $modal.find('#postCode').val(),
					addressLine1: $modal.find('#addressLine1').val(),
					addressLine2: $modal.find('#addressLine2').val()
				};
				if (mode === 'edit') {
					shippingInformation.id = addressId;
				}
				$.ajax({
					url: "<%= request.getContextPath() %>/User/account/addresses/" + mode,
					method: "POST",
					data: JSON.stringify({shippingInformation : shippingInformation}),
					contentType: "application/json",
					dataType: "json", // Explicitly specify expected data type
					success: function(response) {
						if (response && response.status == 200) {
							setTimeout(() => {
								location.reload();
							}, 500);
						} else if (response && response.message) {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: response.message,
							});
						} else {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: "An unexpected error occurred.",
							});
							console.log("Unexpected response:", response);
						}
					},
					error: function (xhr, status, error) {
						// Check if we got redirected to a login page or error page
						if (xhr.status === 200 && xhr.responseText.includes('<html')) {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: "An error occurred while saving the address.",
							});
							return;
						}
						
						let response = xhr.responseJSON;
						Swal.fire({
							icon: 'error',
							title: 'Error',
							text: response ? response.message : "An error occurred while saving the address.",
						});
				});
			});
		});
	</script>
</body>

</html>