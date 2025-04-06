<!DOCTYPE html>
<html lang="en">

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

<body class=" m-0 p-2">
	<!-- Page Header -->
	<div class="bg-white px-4 py-3 ">
		<h1 class="text-lg font-bold text-gray-800">Addresses</h1>
	</div>
	<div class="bg-white w-full p-4">
		<hr class="border-gray-200 p-2" />
		<!-- Address 1: Default -->
		<div class="bg-gray-50 p-4 rounded shadow mb-4">
			<div class="flex items-start justify-between mb-2">
				<div class="text-sm">
					<p class="font-semibold text-gray-700">Home Address</p>
					<!-- Receiver + Tel on one line -->
					<p class="text-xs text-gray-500">
						Tan Choon Shen &middot; +60 1234 5678
					</p>
				</div>
				<span class="border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md">
					Default
				</span>
			</div>
			<div class="text-sm text-gray-600 space-y-1 pl-1">
				<p>123, Jalan Example</p>
				<p>50100 Kuala Lumpur</p>
				<p>Malaysia</p>
			</div>
		</div>

		<!-- Address 2: Set as default button -->
		<div class="bg-gray-50 p-4 rounded shadow mb-4">
			<div class="flex items-start justify-between mb-2">
				<div class="text-sm">
					<p class="font-semibold text-gray-700">Office Address</p>
					<!-- Receiver + Tel on one line -->
					<p class="text-xs text-gray-500">
						Tan Choon Shen &middot; +60 1234 5678
					</p>
				</div>
				<button class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">
					Set as default
				</button>
			</div>
			<div class="text-sm text-gray-600 space-y-1 pl-1">
				<p>A-2-3, Business Park</p>
				<p>47301 Petaling Jaya</p>
				<p>Malaysia</p>
			</div>
		</div>

		<!-- "Add New Address" Tile -->
		<div class="bg-white rounded-xl border-2 border-dashed border-gray-300 
             flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50">
			<div class="flex flex-col items-center space-y-2">
				<span class="text-2xl text-gray-400">+</span>
				<p class="text-gray-600 text-sm">Add New Address</p>
			</div>
		</div>

	</div>

	
	<script>
		$(function() {
			// Open modal
			$('.cursor-pointer').on('click', function() {
				const $modal = $(window.parent.document).find('#addressModal');
      $modal.removeClass('hidden').addClass('flex');
				gsap.from('#addressModal > div', {
					scale: 0.9,
					opacity: 0,
					duration: 0.3
				});
			});
			$('#addressModal').on('click', function(e) {
				if (!$(e.target).closest('#modalContent').length) {
					const $modal = $(window.parent.document).find('#addressModal');
      $modal.removeClass('hidden').addClass('flex');
				}
			});
			// Close modal
			$('#closeModal, #cancelModal').on('click', function() {
				const $modal = $(window.parent.document).find('#addressModal');
      $modal.removeClass('hidden').addClass('flex');
			});
			// Handle form submit (you can extend this with AJAX later)
			$('#addressForm').on('submit', function(e) {
				e.preventDefault();
				alert('Address saved!'); // Replace this with real logic
				const $modal = $(window.parent.document).find('#addressModal');
      $modal.removeClass('hidden').addClass('flex');
			});
		});
	</script>
</body>

</html>