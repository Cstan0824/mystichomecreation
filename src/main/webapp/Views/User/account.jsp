<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Mystichome Creations</title>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
	<link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css" />
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
	<style>
		.sidebar-link {
			display: block;
			transition: color 0.2s;
		}

		.sidebar-link:hover {
			color: #facc15;
			/* Tailwind yellow-400 */
		}

		.sub-sidebar-link {
			overflow: hidden;
			display: none;
			/* hidden by default */
		}
	</style>

</head>

<body class="bg-white text-gray-800 selection:bg-yellow-400 selection:text-white">

	<div class="">
		<div class="mx-20 my-16">
			<div class="flex w-full gap-6">

				<!-- Container A: Sidebar (20%) -->
				<aside class="basis-[20%] bg-white border p-6 rounded shadow">
					<div class="mb-8">
						<p class="text-xl font-semibold text-gray-800">Tan Choon Shen</p>
						<a href="#profile"
							class="text-sm hover:underline hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-500">✎
							Edit Profile</a>
					</div>
					<nav class="space-y-4 text-sm">

						<div class="font-bold text-sm text-gray-700">
							<a href="#transactions" data-item="account"
								class="sidebar-link hover:bold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700"
								onclick="return loadPage('profile');">My Account</a>
						</div>
						<ul class="sub-sidebar-link space-y-2">
							<li><a href="#profile" data-parent="account" data-item="profile"
									class="sidebar-link ms-4 font-normal  hover:font-semibold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700"
									onclick="return loadPage('profile');">Profile</a></li>
							<li><a href="#payments" data-parent="account" data-item="payments"
									class="sidebar-link ms-4 font-normal  hover:font-semibold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700"
									onclick="return loadPage('payments');">Banks & Cards</a></li>
							<li><a href="#addresses" data-parent="account" data-item="addresses"
									class="sidebar-link ms-4 font-normal  hover:font-semibold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700 "
									onclick="return loadPage('addresses');">Addresses</a></li>
							<li><a href="#password" data-parent="account" data-item="password"
									class="sidebar-link ms-4 font-normal hover:font-semibold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700 "
									onclick="return loadPage('password');">Reset your Password</a></li>
						</ul>
						<div class="mt-4 space-y-1">
							<div class="font-bold text-sm text-gray-700">
								<a href="#transactions" data-item="transactions"
									class="sidebar-link hover:bold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700"
									onclick="return loadPage('transactions');">My Purchase</a>
							</div>
							<div class="font-bold text-sm text-gray-700 pt-2">
								<a href="#vouchers" data-item="vouchers"
									class="sidebar-link hover:bold hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative text-gray-700"
									onclick="return loadPage('vouchers');">My Vouchers</a>
							</div>
						</div>
					</nav>
				</aside>

				<!-- Container B: Main content (80%) -->
				<main class="basis-[80%] bg-white rounded shadow">
					<iframe id="contentFrame" src="<%= request.getContextPath() %>/User/account/profile"
						style="width: 100%; height: 580px; border: none;">
					</iframe>
				</main>
			</div>
		</div>
	</div>
	<!-- Add New Card Modal -->
	<div id="cardModal"
		class="fixed inset-0 z-50 hidden items-center justify-center bg-[rgba(0,0,0,0.4)] backdrop-blur-sm">
		<div id="cardModalContent"
			class="bg-white rounded-lg w-full max-w-[550px] p-6 space-y-4 max-h-[90vh] overflow-y-auto">
			<div class="flex justify-between items-center mb-2">
				<h2 class="text-lg font-semibold text-gray-800">Add New Card</h2>
				<button id="closeCardModal" class="text-gray-400 hover:text-gray-600 text-xl">&times;</button>
			</div>

			<form id="cardForm" class="space-y-4">
				<div>
					<label class="block text-sm font-medium text-gray-700">Name on Card</label>
					<input type="text" placeholder="e.g. Tan Choon Shen"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>
				<div>
					<label class="block text-sm font-medium text-gray-700">Card Number</label>
					<input type="text" placeholder="**** **** **** 1234"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>
				<div class="grid sm:grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">Expiry Date</label>
						<input type="text" placeholder="MM/YYYY"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">CVV</label>
						<input type="text" placeholder="123"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
				</div>
				<div class="flex justify-end space-x-2 pt-2">
					<button type="button" id="cancelCardModal"
						class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Cancel</button>
					<button type="submit"
						class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Save</button>
				</div>
			</form>
		</div>
	</div>

	<!-- Address Modal -->
	<div id="addressModal" class="fixed inset-0 z-50 hidden items-center justify-center w-full  bg-[rgba(0,0,0,0.4)]
             backdrop-blur-sm">
		<div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 space-y-4 
            max-h-[90vh] overflow-y-auto" id="modalContent">

			<div class="flex justify-between items-center mb-2">
				<h2 class="text-lg font-semibold text-gray-800">Add New Address</h2>
				<button id="closeModal" class="text-gray-400 hover:text-gray-600 text-xl">&times;</button>
			</div>

			<form id="addressForm" class="space-y-4">
				<div>
					<label class="block text-sm font-medium text-gray-700">Address Label</label>
					<input type="text" placeholder="e.g. Home, Office"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<div>
					<label class="block text-sm font-medium text-gray-700">Receiver Name</label>
					<input type="text" placeholder="Full name"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<div>
					<label class="block text-sm font-medium text-gray-700">Phone Number</label>
					<input type="tel" placeholder="e.g. +60 1234 5678"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<!-- State + Postal Code side-by-side (50% each) -->
				<div class="grid grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">State</label>
						<select
							class="w-full border rounded px-3 py-2 mt-1 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">
							<option value="">Select State</option>
							<option>Selangor</option>
							<option>Kuala Lumpur</option>
							<option>Penang</option>
							<option>Johor</option>
							<option>Sabah</option>
							<option>Sarawak</option>
						</select>
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">Postal Code</label>
						<input type="text" placeholder="e.g. 41200"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
				</div>

				<div>
					<label class="block text-sm font-medium text-gray-700">Address Line 1</label>
					<input type="text" placeholder="Street, building, etc."
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<div>
					<label class="block text-sm font-medium text-gray-700">Address Line 2</label>
					<input type="text" placeholder="Apartment, unit, floor, etc. (optional)"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<div class="flex justify-end space-x-2 pt-2">
					<button type="button" id="cancelModal"
						class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Cancel</button>
					<button type="submit"
						class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Save</button>
				</div>
			</form>

		</div>
	</div>
	<!-- Voucher Modal -->
	<div id="voucherModal"
		class="fixed inset-0 z-50 hidden items-center justify-center bg-[rgba(0,0,0,0.4)] backdrop-blur-sm">
		<div id="voucherModalContent"
			class="bg-white rounded-lg w-full max-w-[550px] p-6 space-y-4 max-h-[90vh] overflow-y-auto">
			<div class="flex justify-between items-center mb-2">
				<h2 class="text-lg font-semibold text-gray-800">Add New Voucher</h2>
				<button id="closeVoucherModal" class="text-gray-400 hover:text-gray-600 text-xl">&times;</button>
			</div>

			<form id="voucherForm" class="space-y-4">
				<div>
					<label class="block text-sm font-medium text-gray-700">Voucher Name</label>
					<input type="text" placeholder="e.g. Mega Saver"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>

				<div>
					<label class="block text-sm font-medium text-gray-700">Description</label>
					<textarea rows="2" placeholder="e.g. Valid for all orders above RM50"
						class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">Voucher Amount</label>
						<input type="number" placeholder="e.g. 300"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">Voucher Type</label>
						<select
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
							<option value="flat">RM Amount</option>
							<option value="percentage">Percentage (%)</option>
						</select>
					</div>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div>
						<label class="block text-sm font-medium text-gray-700">Min Spend</label>
						<input type="number" placeholder="e.g. 50"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700">Max Discount</label>
						<input type="number" placeholder="e.g. 300"
							class="w-full border rounded px-3 py-2 mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
					</div>
				</div>

				<div class="flex justify-end space-x-2 pt-2">
					<button type="button" id="cancelVoucherModal"
						class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Cancel</button>
					<button type="submit"
						class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Save</button>
				</div>
			</form>
		</div>
	</div>
	<script>
		const PAGE_MAP = {
			'': '<%= request.getContextPath() %>/User/account/profile',
			'profile': '<%= request.getContextPath() %>/User/account/profile',
			'payments': '<%= request.getContextPath() %>/User/account/payments',
			'addresses': '<%= request.getContextPath() %>/User/account/addresses',
			'vouchers': '<%= request.getContextPath() %>/User/account/vouchers',
			'transactions': '<%= request.getContextPath() %>/User/account/transactions',
			'password': '<%= request.getContextPath() %>/User/account/password'
		};
		let $previousSubSidebarLink = null;

		function loadPage(hash) {
			window.location.hash = hash;
			return false;
		}

		function getHash() {
			return window.location.hash.replace('#', '') || '';
		}

		function updateNavigationBar() {
			const hash = getHash() || 'profile'; // Default to 'profile' if no hash is present
			if (hash === "account") {
				hash = "profile";
			}
			const $sidebarLink = $(".sidebar-link[data-item='" + hash + "']");
			if (!$sidebarLink.length) {
				return;
			}
			$(".sidebar-link").removeClass("font-semibold text-yellow-500");
			$(".sub-sidebar-link").hide();
			$sidebarLink.addClass("font-semibold text-yellow-500");
			const $subSidebar = $sidebarLink.closest(".sub-sidebar-link");
			if ($subSidebar.length) {
				$subSidebar.show();
			}
		}

		function updateIFrameSrc() {
			const hash = getHash();
			const iframeSrc = PAGE_MAP[hash] || PAGE_MAP[''];
			$('#contentFrame').attr('src', iframeSrc);
		}

		function triggerHashChangedAction() {
			updateIFrameSrc();
			updateNavigationBar();
		}
		$(document).ready(function() {
			triggerHashChangedAction();
			$(window).on('hashchange', triggerHashChangedAction);
			$(function() {
				const $addressModal = $('#addressModal');
				$('#closeModal, #cancelModal').on('click', function() {
					$addressModal.addClass('hidden').removeClass('flex');
				});
				$('#addressForm').on('submit', function(e) {
					e.preventDefault();
					alert('Address saved!');
					$addressModal.addClass('hidden').removeClass('flex');
				});
				// Optional: close on backdrop click
				$addressModal.on('click', function(e) {
					if (!$(e.target).closest('#modalContent').length) {
						$addressModal.addClass('hidden').removeClass('flex');
					}
				});
				const $cardModal = $('#cardModal');
				// Close modal
				$('#closeCardModal, #cancelCardModal').on('click', function() {
					$cardModal.addClass('hidden').removeClass('flex');
				});
				// Close when clicking outside modal
				$cardModal.on('click', function(e) {
					if (!$(e.target).closest('#cardModalContent').length) {
						$cardModal.addClass('hidden').removeClass('flex');
					}
				});
				// On form submit
				$('#cardForm').on('submit', function(e) {
					e.preventDefault();
					alert('💳 Card added!');
					$cardModal.addClass('hidden').removeClass('flex');
				});
			});
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
				alert('Voucher saved!');
				$voucherModal.addClass('hidden').removeClass('flex');
			});
		});
	</script>

</body>

</html>