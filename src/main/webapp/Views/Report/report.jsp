<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@ page import="java.lang.Long" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="Models.Products.productDTO" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
  <title>Report Page</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
  <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 font-sans p-6">
  <div class="max-w-7xl mx-auto space-y-8">
    <!-- Page Heading -->
    <h1 class="text-3xl font-bold text-gray-900">Report Dashboard</h1>

    <!-- === Upper 4-column Section === -->
    <%  
        List<Object[]> ordersByMonth = (List<Object[]>) request.getAttribute("ordersByMonth");  
        int defaultCount = 0;
        if (ordersByMonth != null && !ordersByMonth.isEmpty()) {
            defaultCount = Integer.parseInt(ordersByMonth.get(0)[2].toString());
        }
    %>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <!-- 1. Number of Orders Each Month -->
      <div class="bg-white rounded-2xl p-5 shadow">
        <div class="flex justify-between items-center">
          <h3 class="text-sm font-medium text-gray-500">Total Orders </h3>
          <select class="text-sm text-gray-700 border border-gray-300 rounded px-2 py-1">
            <% 
              for (Object[] row : ordersByMonth) {
              int yr  = Integer.parseInt(row[0].toString());
              int mo  = Integer.parseInt(row[1].toString());
              int ct  = Integer.parseInt(row[2].toString());            
            %>
            <option value="<%= yr %>-<%= mo %>"></option>
           <% } %>
          </select>
        </div>
        <p class="mt-2 text-2xl font-bold text-gray-900"><%= defaultCount %></p>
      </div>

      <!-- 2. Sales by Category -->
      <div class="bg-white rounded-2xl p-5 shadow"> 
        <%
          List<Object[]> sales = (List<Object[]>) request.getAttribute("salesByCategory");
          List<Object[]> prefs = (List<Object[]>) request.getAttribute("paymentPreferences");
          double totalRevenue = (double) request.getAttribute("totalRevenue");
        %>
          <h3 class="text-sm font-medium text-gray-500">Sales by Category</h3>
          <% for (Object[] row : sales) {
            String category = (String) row[0];
            double amount = ((Number)row[1]).doubleValue();
          %>
              <ul class="mt-2 text-sm text-gray-700 space-y-1">
                <li><%= category %> : RM <%= amount %></li>
              </ul>
          <% } %>
      </div>

      <!-- 3. Payment Preferences -->
      <div class="bg-white rounded-2xl p-5 shadow">
        <h3 class="text-sm font-medium text-gray-500">Top Payment Method</h3>
         <% for (Object[] row : prefs) {
              String method = (String) row[0];
              long  count    = ((Number)row[1]).longValue();
          %>
              <p class="mt-2 text-2xl font-bold text-gray-900"><%= count %> x  <%= method %> </p>
          <% } %>
      </div>

      <!-- 4. Total Revenue -->
      <div class="bg-white rounded-2xl p-5 shadow">
        <h3 class="text-sm font-medium text-gray-500">Total Revenue</h3>
        <p class="mt-2 text-2xl font-bold text-gray-900"><%= String.format("%.2f", totalRevenue) %></p>
      </div>
    </div>

    <!-- === Middle Section === -->
    <div class="grid grid-cols-3 gap-4 items-stretch">
      <!-- Left column for stacked cards -->
      <div class="col-span-1 space-y-4 h-full">
        <!-- New clients card -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm">
          <div>
            <div class="text-sm text-gray-500 font-medium mb-2">Total Customer </div>
            <div class="flex items-baseline">
              <% int totalCustomers = (int) request.getAttribute("totalCustomers"); %>
              <span class="text-5xl font-bold text-gray-900"><%= totalCustomers %></span>
              <span class="ml-2 px-2 py-0.5 bg-green-100 text-green-600 text-xs font-medium rounded-md">+18.7%</span>
            </div>
          </div>
        </div>
        <div class="bg-white border rounded-2xl p-5 shadow-sm">
          <div>
            <div class="text-sm text-gray-500 font-medium mb-2">Total Staff </div>
            <div class="flex items-baseline">
              <% int totalStaff = (int) request.getAttribute("totalStaff"); %>
              <span class="text-5xl font-bold text-gray-900"><%= totalStaff %></span>
              <span class="ml-2 px-2 py-0.5 bg-red-100 text-red-500 text-xs font-medium rounded-md">+2.7%</span>
            </div>
          </div>
        </div>
      </div>
      <!-- Revenue chart card taking 2/3 of the width -->
      <div class="col-span-2 bg-white border rounded-2xl p-5 shadow-sm h-full">
        <div class="flex flex-col h-full justify-between">
          <!-- Header Section -->
          <div class="flex justify-between items-center mb-4">
            <div>
              <h3 class="text-base font-medium text-gray-700">Revenue</h3>
              <p class="text-xs text-gray-400 mt-1">Sales performance overview</p>
            </div>
            
            <!-- Controls Container -->
            <div class="flex gap-3 items-center">
              <div class="space-y-1">
                <label for="days" class="block text-xs text-gray-500 font-medium">Days</label>
                <input type="number" id="days" name="days" value="7" min="1" max="30" 
                      class="w-20 px-2 py-1.5 border border-gray-200 rounded-md text-sm focus:ring-1 focus:ring-blue-200">
              </div>
              
              <div class="space-y-1">
                <label for="months" class="block text-xs text-gray-500 font-medium">Months</label>
                <input type="number" id="months" name="months" value="0" min="1" max="12" 
                      class="w-20 px-2 py-1.5 border border-gray-200 rounded-md text-sm focus:ring-1 focus:ring-blue-200">
              </div>
            </div>
          </div>

          <!-- Chart Area -->
          <div class="flex-1 bg-gray-50 rounded-xl flex items-center justify-center">
            <canvas id="dailyRevenueChart" height="200"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- === Bottom Section: Product List with Sort Menu === -->
    <%List<productDTO> products = (List<productDTO>) request.getAttribute("productDTOs");%>
    <div class="bg-white rounded-2xl p-6 shadow">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">Product List</h2>
        <div class="relative">
          <button onclick="openFilterModal()" class="p-2 rounded-full hover:text-yellow-300 focus:outline-none"> 
              <i class="fa-solid fa-filter"></i>
          </button>
        </div>
      </div>
      <div class="overflow-x-auto">
        <!-- Fixed-header table -->
        <div class="max-h-80 overflow-y-auto border-b border-gray-200">
          <table id="productTable" class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th class="w-3/12 px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                <th class="w-2/12 px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
                <th class="w-2/12 px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Price(RM)</th>
                <th class="w-1/12 px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>
                <th class="w-2/12 px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Avg. Rating</th>
                <th class="w-2/12 px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Total Sold</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <% for (productDTO p : products) { %>
                <tr class="hover:bg-gray-50">
                  <td class="px-4 py-3 text-sm text-gray-900 align-middle whitespace-nowrap"><%= p.title %></td>
                  <td class="px-4 py-3 text-sm text-gray-700 align-middle"><%= p.type %></td>
                  <td class="px-4 py-3 text-sm text-gray-900 text-right align-middle"><%= String.format("%.2f", p.price) %></td>
                    <td class="px-4 py-3 text-sm text-gray-900 text-right align-middle"><%= p.stock %>
                    <% if (p.stock < 10) { %>
                      <i class="fa-solid fa-exclamation-circle text-red-500 ml-2" title="Low stock"></i>
                    <% } %>
                    </td>
                  <td class="px-4 py-3 text-sm text-gray-900 text-right align-middle"><%= String.format("%.1f", p.avgRating) %></td>
                  <td class="px-4 py-3 text-sm text-gray-900 text-right align-middle"><%= p.totalSold %></td>
                </tr>
              <% } %>
              <% if (products.isEmpty()) { %>
                <tr>
                  <td colspan="6" class="px-4 py-6 text-center text-sm text-gray-500">
                    No products found
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
        </div>
      </div>
    </div>
  </div>
    <%@ include file="/Views/Report/sortModal.jsp" %>

 
</body>


 <!-- Optional: Close dropdown when clicking outside -->
  <script>





    const ctx = '<%= request.getContextPath() %>';

    function openFilterModal() {
      document.getElementById('filterModal').classList.remove('hidden');
      document.body.classList.add('overflow-hidden');
    }
    function closeFilterModal() {
      document.getElementById('filterModal').classList.add('hidden');
      document.body.classList.remove('overflow-hidden');
    }

     function clearFilters() {
      // 1) Reset the form back to its HTML defaults
      var form = document.getElementById('filterForm');
      form.reset();

      applyFilters();

      // 3) Close the modal
      closeFilterModal();
    }

    function applyFilters() {
      const form = document.getElementById("filterForm");
      const formData = new FormData(form);

      const params = new URLSearchParams(formData).toString();



      // const ctx = '<%= request.getContextPath() %>';
      const url = ctx + '/Report/report/filter?' + params.toString();
      console.log("➡️ Fetching:", url);


      fetch(url)
        .then(function(res) {
          console.log("⬅️ Response status:", res.status);
          return res.json();           // get the raw JSON string
        })
        .then(function(envelope) {
         let products;
          try {
            products = JSON.parse(envelope.data);
            console.log("✅ Parsed products array:", products);
          } catch (e) {
            console.error("❌ JSON.parse failed on envelope.data:", e);
            products = [];
          }

          renderProducts(products);
        })
        .catch(function(err) {
          console.error("🔥 Fetch error:", err);
          alert("Failed to load report data. See console for details.");
        })
        .finally(function() {
          closeFilterModal();
        });
  



   
    }

    function renderProducts(products) {
      const tbody = document.querySelector('#productTable tbody');
      tbody.innerHTML = '';

      if (!products.length) {
        tbody.innerHTML = 
          '<tr>' +
            '<td colspan="6" class="px-6 py-4 text-center text-gray-500">' +
              'No products match those filters.' +
            '</td>' +
          '</tr>';
        return;
      }

      products.forEach(p => {
        const row  = 
          '<tr class="hover:bg-gray-50">' +
            '<td class="px-6 py-4 text-sm text-gray-900">'   + p.title      + '</td>' +
            '<td class="px-6 py-4 text-sm text-gray-700">'   + p.type       + '</td>' +
            '<td class="px-6 py-4 text-sm text-gray-900 text-right">RM ' + p.price.toFixed(2) + '</td>' +
            '<td class="px-6 py-4 text-sm text-gray-900 text-right">'  + p.stock      + '</td>' +
            '<td class="px-6 py-4 text-sm text-gray-900 text-right">'  + p.avgRating.toFixed(1) + '</td>' +
            '<td class="px-6 py-4 text-sm text-gray-900 text-right">'  + p.totalSold  + '</td>' +
          '</tr>';
        tbody.innerHTML += row;
      });
    }

    function fetchDailyRevenue() {
      console.log("🔄 fetchDailyRevenue() called");

      const days = document.getElementById('days').value;
      console.log("🔄 fetchDailyRevenue, days =", days);


      fetch(ctx + '/Report/report/dailyRevenue?days=' + days)
        .then(function(res) {
          console.log("⬅️ Daily status:", res.status);

          if (!res.ok) throw new Error(res.statusText);
          return res.json();

        })
        .then(function(data) {
          console.log('📊 Daily revenue data:', data);
          // data should be [ { day: "YYYY-MM-DD", total: 1234.56 }, … ]
          const labels = data.map(d => d.day);
          const values = data.map(d => d.total);

          updateDailyChart(labels, values);

        })
        .catch(function(err) {
          console.error('🔥 Error fetching daily revenue:', err);
        });
    }



    // Initialize the chart
  document.addEventListener('DOMContentLoaded', function() {
    fetchDailyRevenue();
    fetchMonthlyRevenue();


    dailyChart = new Chart(
    document.getElementById('dailyRevenueChart'),
    {
      type: 'line',
      data: {
        labels: [],
        datasets: [{
          label: 'Revenue (RM)',
          data: [],
          fill: false,
          borderWidth: 2
        }]
      },
      options: {
        responsive: true,
        scales: {
          x: {
            title: { display: true, text: 'Date' }
          },
          y: {
            title: { display: true, text: 'Revenue (RM)' }
          }
        }
      }
    }
  );

  

  });


  function updateDailyChart(labels, values) {
    dailyChart.data.labels = labels;
    dailyChart.data.datasets[0].data = values;
    dailyChart.update();
  }






     







  </script>


</html>
