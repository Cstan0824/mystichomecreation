<!DOCTYPE html>
<html lang="en">
<%@ page import="java.util.List" %>
<%@ page import="Models.PaymentCard" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.DateTimeParseException" %>
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
<body class="m-0 p-2">
<!-- Page Header -->
<div class="bg-white px-4 py-3">
  <h1 class="text-lg font-bold text-gray-800">Banks & Cards</h1>
</div>

  <!-- Outer container -->
  <div class="bg-white w-full p-4">
      <hr class="border-gray-200 p-2" />
	  <%
		// Get the PaymentCards list from request attributes
		List<PaymentCard> paymentCards = 
			(List<PaymentCard>)request.getAttribute("paymentCards");
		
		// Check if there are any cards to display
		if(paymentCards != null && !paymentCards.isEmpty()) {
			for(PaymentCard payment : paymentCards) {
		%>
			<!-- Payments Card -->
			<div class="bg-gray-50 p-4 rounded shadow mb-4 flex flex-col space-y-2 relative">
				<div class="flex items-start justify-between">
					<!-- Card Logo + Info -->
					<div class="flex space-x-3 items-start">
					<img 
						src="<%= request.getContextPath() + "/Content" + payment.getBankType().getLogoPath() %>" 
						alt="Bank Logo" 
						class="w-12 h-12 object-contain rounded-full" 
					/>
					<div>
						<p class="font-semibold text-gray-700 text-sm"><%= payment.getName() %></p>
						<p class="text-gray-500 text-xs"> **** **** **** <%= payment.getCardNumber().substring(12) %></p>
					</div>
				</div>
				<!-- Label: Default -->
				<% if(payment.isDefault()) { %>
					<span class="border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md">
						Default
					</span>
				<% } else { %>
					<button onclick="setDefaultCard(<%= payment.getId() %>)"
						class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">
						Set as default
					</button>
				<% } %>
				</div>
					<%
						String expiryStr = payment.getExpiryDate(); // e.g. "2026-08-31"
						LocalDate today = LocalDate.now();
						LocalDate expiryDate = null;
						boolean isOngoing = false;

						try {
							expiryDate = LocalDate.parse(expiryStr); // assumes yyyy-MM-dd
							isOngoing = expiryDate.isAfter(today);
						} catch (DateTimeParseException e) {
							// Optional: log or handle parse failure
						}
					%>
					<div>
						<p class="text-gray-400 text-xs uppercase">
							<%= isOngoing ? "Ongoing" : "Expired" %>
						</p>
						
					</div>

					<div class="flex justify-between items-center">
					<p class="text-gray-700 text-sm"><%= expiryStr %></p>
					<div class="space-x-3 text-xs">
						<button
							onclick="editPaymentCard(<%= payment.getId() %>, '<%= payment.getName() %>', '<%= payment.getCardNumber() %>', '<%= payment.getExpiryDate() %>', '<%= payment.getBankTypeId() %>')"
							class="text-blue-500 hover:underline">Edit</button>
						<button onclick="deletePaymentCard(<%= payment.getId() %>)"
							class="text-red-500 hover:underline">Delete</button>
					</div>
				</div>
			</div>
		<%
			}
		} else {
		%>
		<div class="text-center py-6 text-gray-500">
			<p>No saved Payment Card yet.</p>
		</div>
		<%
		}
		%>

    <!-- "Add New Card" Tile -->
    <div
      class="bg-white rounded-xl border-2 border-dashed border-gray-300 
             flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50">
      <div class="flex flex-col items-center space-y-2">
        <span class="text-2xl text-gray-400">+</span>
        <p class="text-gray-600 text-sm">Add New Card</p>
      </div>
    </div>

  </div>
  <script>
	function setDefaultCard(cardId) {
		$.ajax({
			url: "<%= request.getContextPath() %>/User/account/payments/default",
			method: "POST",
			contentType: "application/json",
			dataType: "json",
			data: JSON.stringify({ paymentCardId: cardId }),
			success: function (response) {
				if (response.status == 200) {
					setTimeout(() => location.reload(), 150);
				} else {
					alert(response.message);
				}
			},
			error: function () {
				alert("An error occurred while setting the default card.");
			}
		});
	}

	function editPaymentCard(id, name, number, expiryDate, bankTypeId) {
		clearCardForm();
		const $modal = $(window.parent.document).find('#cardModal');
		$modal.data('mode', 'edit');
		$modal.find('#cardId').val(id);
		$modal.find('#cardHolderName').val(name);
		$modal.find('#cardNumber').val(number);
		$modal.find('#expiryDate').val(expiryDate);
		$modal.find('#bankType').val(bankTypeId);
		$modal.removeClass('hidden').addClass('flex');
	}

	function deletePaymentCard(id) {
		if (confirm("Are you sure you want to delete this card?")) {
			$.ajax({
				url: "<%= request.getContextPath() %>/User/account/payments/delete",
				method: "POST",
				contentType: "application/json",
				dataType: "json",
				data: JSON.stringify({ paymentCardId: id }),
				success: function (response) {
					if (response.status == 200) {
						setTimeout(() => location.reload(), 150);
					} else {
						alert(response.message);
					}
				},
				error: function () {
					alert("Something went wrong while deleting the card.");
				}
			});
		}
	}

	function clearCardForm() {
		const $modal = $(window.parent.document).find('#cardModal');
		$modal.find('#cardHolderName').val('');
		$modal.find('#cardNumber').val('');
		$modal.find('#expiryDate').val('');
		$modal.find('#bankType').val('');
	}

	$(function () {
		const $modal = $(window.parent.document).find('#cardModal');

		if ($modal.hasClass('flex')) {
			$modal.removeClass('flex').addClass('hidden');
		}

		$('.cursor-pointer').on('click', function () {
			const $modal = $(window.parent.document).find('#cardModal');
			$modal.removeClass('hidden').addClass('flex');
    	});

		// Save logic
		$(window.parent.document).on('click', '#cardModal #saveModal', function () {
			const mode = $modal.data('mode');
			const cardId = $modal.find('#cardId').val();
			const cardInfo = {
				name: $modal.find('#cardHolderName').val(),
				cardNumber: $modal.find('#cardNumber').val(),
				expiryDate: $modal.find('#expiryDate').val(),
				bankTypeId: $modal.find('#bankType').val()
			};
			if (mode === 'edit') {
				cardInfo.id = cardId;
			}

			$.ajax({
				url: "<%= request.getContextPath() %>/User/account/payments/" + mode,
				method: "POST",
				contentType: "application/json",
				data: JSON.stringify({ paymentCard: cardInfo }),
				success: function (response) {
					if (response.status == 200) {
						setTimeout(() => location.reload(), 150);
					} else {
						alert(response.message);
					}
				},
				error: function () {
					alert("Something went wrong while saving the card.");
				}
			});
		});
	});
</script>

</body>
</html>
