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
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>
<%@ page import="java.util.List" %>
<%@ page import="Models.Orders.Order" %>
<%@ page import="Models.Orders.OrderStatus" %>
<%@ page import="mvc.Helpers.Helpers" %>
<body class="p-2 m-0">

  <%
      List<Order> orders = (List<Order>) request.getAttribute("orders");
      List<OrderStatus> statuses = (List<OrderStatus>) request.getAttribute("orderStatuses");
  %>

  <!-- Header -->
  <div class="bg-white px-4 py-3">
    <!-- Top Row: Title & Controls -->
    <div class="flex justify-between items-center">
      <h2 class="font-semibold text-gray-800">My Transactions</h2>
    </div>
  </div>

  <!-- Main Content Area -->
  <div class="bg-white w-full p-4">
    <hr class="border-gray-200 p-2" />

  <!-- Transaction Cards -->
  <div class="space-y-3 py-2" id="transactionCards">
    <!-- Card 1 -->
    <% if (orders != null && !orders.isEmpty()){ %>
      <% for(Order order : orders) { %>
        <div class="order-card bg-gray-50 px-4 py-3 rounded shadow hidden">
          <div class="flex justify-between items-center">
            <div class="text-sm">
              <p class="font-semibold text-gray-800"><%= order.getOrderRefNo() %></p>
              <p class="text-xs text-gray-500"><%= order.getOrderDate() %></p>
              <a href="<%= request.getContextPath() %>/Order/orderInfo?orderId=<%= order.getId() %>" class="text-sm text-blue-600 hover:underline mt-1 inline-flex items-center gap-1">
                <i class="fa-solid fa-receipt"></i> View Details
              </a>
            </div>
            <div class="text-right">
              <p class="font-semibold text-gray-800">RM<%= String.format("%.2f", order.getPayment().getTotalPaid()) %></p>
              <%
                switch (order.getStatus().getStatusDesc()) {
                  case "Pending":
                  %><p class="text-sm text-black"><i class="fa-solid fa-clock mr-1"></i><%= order.getStatus().getStatusDesc()%></p><%
                  break;
                  case "Packing":
                  %><p class="text-sm text-blue-500"><i class="fa-solid fa-boxes-packing mr-1"></i></i><%= order.getStatus().getStatusDesc()%></p><%
                  break;
                  case "Shipping":
                  %><p class="text-sm text-yellow-600"><i class="fa-solid fa-truck mr-1"></i><%= order.getStatus().getStatusDesc()%></p><%
                  break;
                  case "Received":
                  %><p class="text-sm text-green-600"><i class="fa-solid fa-check-circle mr-1"></i><%= order.getStatus().getStatusDesc()%></p><%
                  break;
                  case "Cancelled":
                  %><p class="text-sm text-red-600"><i class="fa-solid fa-times-circle mr-1"></i><%= order.getStatus().getStatusDesc()%></p><%
                  break;
                  default:
                  %><p class="text-sm text-gray-600"><i class="fa-solid fa-question-circle mr-1"></i>Unknown</p><%
                  break;
                }
              %>
            </div>
          </div>
        </div>
      <% } %>
    <% } else { %>
      <div class="bg-gray-50 px-4 py-3 rounded shadow text-center">
        <p class="text-gray-500">No transactions found.</p>
      </div>
    <% } %>

  </div>

  <!-- PAGINATION CONTROLS -->
  <div id="paginationControls" class="flex justify-center mt-4 space-x-2">
    <button id="prevPage" class="px-3 py-1 bg-gray-200 rounded disabled:opacity-50" disabled>Prev</button>
    <button id="nextPage" class="px-3 py-1 bg-gray-200 rounded">Next</button>
  </div>

  </div>
  <script>
 
  const itemsPerPage = 4;
  let currentPage = 1;

  const cards = document.querySelectorAll('.order-card');
  const totalPages = Math.ceil(cards.length / itemsPerPage);
  const prevBtn = document.getElementById('prevPage');
  const nextBtn = document.getElementById('nextPage');

  function showPage(page) {
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;

    cards.forEach((card, index) => {
      card.classList.toggle('hidden', index < start || index >= end);
    });

    prevBtn.disabled = page === 1;
    nextBtn.disabled = page === totalPages;
  }

  prevBtn.addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      showPage(currentPage);
    }
  });

  nextBtn.addEventListener('click', () => {
    if (currentPage < totalPages) {
      currentPage++;
      showPage(currentPage);
    }
  });

  // Initial load
  if (cards.length > 0) {
    showPage(currentPage);
    document.getElementById('paginationControls').classList.remove('hidden');
  } else {
    document.getElementById('paginationControls').classList.add('hidden');
  }

  </script>
</body>
</html>
