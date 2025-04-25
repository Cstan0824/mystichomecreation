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
        List<Object[]> sales = (List<Object[]>) request.getAttribute("salesByCategory");
        List<Object[]> prefs = (List<Object[]>) request.getAttribute("paymentPreferences");
        double totalRevenue = (double) request.getAttribute("totalRevenue");
      
        int defaultCount = 0;
        if (ordersByMonth != null && !ordersByMonth.isEmpty()) {
            defaultCount = Integer.parseInt(ordersByMonth.get(0)[2].toString());
        }
    %>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
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
    <div class="grid grid-cols-12 gap-4 items-stretch">
      <!-- Left Column: Customer, Staff, and Sales by Category -->
      <div class="col-span-4 space-y-4">
        <!-- Total Customer -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm">
          <div class="text-sm text-gray-500 font-medium mb-2">Total Customer</div>
          <div class="flex items-baseline">
            <% int totalCustomers = (int) request.getAttribute("totalCustomers"); %>
            <span class="text-5xl font-bold text-gray-900"><%= totalCustomers %></span>
            <span class="ml-2 px-2 py-0.5 bg-green-100 text-green-600 text-xs font-medium rounded-md">+18.7%</span>
          </div>
        </div>
        
        <!-- Total Staff -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm">
          <div class="text-sm text-gray-500 font-medium mb-2">Total Staff</div>
          <div class="flex items-baseline">
            <% int totalStaff = (int) request.getAttribute("totalStaff"); %>
            <span class="text-5xl font-bold text-gray-900"><%= totalStaff %></span>
            <span class="ml-2 px-2 py-0.5 bg-red-100 text-red-500 text-xs font-medium rounded-md">+2.7%</span>
          </div>
        </div>
        
        <!-- Sales by Category -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm">
          <h3 class="text-sm font-medium text-gray-500 mb-4">Sales by Category</h3>
            <div class="w-full h-64">
              <canvas id="salesByCategoryChart" class="w-full h-full"></canvas>
            </div>
          
          <%-- <% for (Object[] row : sales) {
            String category = (String) row[0];
            double amount = ((Number)row[1]).doubleValue();
          %>
          <div class="py-2 border-b border-gray-100">
            <div class="flex justify-between items-center">
              <span class="text-sm text-gray-700"><%= category %></span>
              <span class="font-medium">RM <%= String.format("%.2f", amount) %></span>
            </div>
          </div>
          <% } %> --%>
        </div>
      </div>
      
      <!-- Right Column: Revenue Chart -->
      <div class="col-span-8">
        <div class="h-full bg-white border rounded-2xl p-5 shadow-sm">
          <!-- Header Section -->
          <div class="flex justify-between items-center mb-4">
            <div>
              <h3 class="text-base font-medium text-gray-700">Revenue</h3>
              <p class="text-xs text-gray-400 mt-1">Sales performance overview</p>
            </div>
            
            <!-- Controls Container -->
            <div class="flex gap-3 items-center">
              <select id="rangePreset" class="w-48 px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-400 transition-all">
                <option data-unit="days" value="7">Last 7 days</option>
                <option data-unit="days" value="30">Last 30 days</option>
                <option data-unit="months" value="12">Last 12 months</option>
              </select>
            </div>
          </div>
          <!-- Chart Area -->
          <div class="flex-1 bg-gray-50 min-h-[500px] rounded-xl">
            <!-- Daily Chart -->
            <div id="dailyChartContainer" class="block h-[500px] w-full">
              <canvas id="dailyRevenueChart"></canvas>
            </div>
            <div id="monthlyChartContainer" class="hidden h-[500px] w-full">
              <canvas id="monthlyRevenueChart"></canvas>
            </div>
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

</body>

  <%@ include file="/Views/Report/sortModal.jsp" %>


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
    var form = document.getElementById('filterForm');
    form.reset();
    applyFilters();
    closeFilterModal();
  }

  function applyFilters() {
    const form = document.getElementById("filterForm");
    const formData = new FormData(form);
    const params = new URLSearchParams(formData).toString();
    const url = ctx + '/Report/report/filter?' + params.toString();
    console.log("➡️ Fetching:", url);

    fetch(url)
      .then(function(res) {
        console.log("⬅️ Response status:", res.status);
        return res.json();
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

  // ================= Chart.js ===================

  // gather the parameter for line chart 
// Global chart instances
let dailyChart = null;
let monthlyChart = null;
let salesPieChart = null;

// Enhanced unwrapEnvelope
function unwrapEnvelope(payload) {
  console.log("🔍 Unwrapping payload:", payload);
  if (Array.isArray(payload)) {
    console.log("✅ Payload is already an array:", payload);
    return payload;
  }
  if (payload && payload.data) {
    if (typeof payload.data === 'string') {
      try {
        const cleanedData = payload.data.replace(/\\"/g, '"').replace(/\\+/g, '\\');
        const inner = JSON.parse(cleanedData);
        console.log("🔄 Parsed inner data:", inner);
        // Check if inner has a data field (double-nested)
        if (inner && inner.data) {
          return inner.data;
        }
        return inner;
      } catch (e) {
        console.error("❌ Failed to parse envelope.data:", payload.data, e);
        return [];
      }
    }
    console.log("🔄 Returning payload.data:", payload.data);
    return payload.data; // Direct data for fixed responses
  }
  console.warn("⚠️ Unexpected payload shape, returning empty array:", payload);
  return [];
}

// Toggle daily/monthly charts
function onPresetChange() {
  const sel = document.getElementById('rangePreset');
  const count = parseInt(sel.value, 10);
  const unit = sel.selectedOptions[0].dataset.unit;

  if (unit === 'days') {
    document.getElementById('dailyChartContainer').classList.remove('hidden');
    document.getElementById('monthlyChartContainer').classList.add('hidden');
    fetchDailyRevenue(count);
  } else {
    document.getElementById('monthlyChartContainer').classList.remove('hidden');
    document.getElementById('dailyChartContainer').classList.add('hidden');
    fetchMonthlyRevenue(count);
  }
}

// Fetch daily revenue
function fetchDailyRevenue(days) {
  console.log("🔄 fetchDailyRevenue, days =", days);
  fetch(ctx + '/Report/report/dailyRevenue?days=' + days)
    .then(res => {
      if (!res.ok) throw new Error(res.statusText);
      return res.text();
    })
    .then(text => {
      console.log("⬅️ Raw dailyRevenue response:", text);
      let envelope;
      try {
        envelope = JSON.parse(text);
      } catch (e) {
        console.error("❌ Failed to parse response as JSON:", text, e);
        return [];
      }
      const rows = unwrapEnvelope(envelope);
      console.log("📊 Parsed rows:", rows);
      const labels = rows.map(d => d.day || 'Unknown');
      const values = rows.map(d => Number(d.total) || 0);
      if (rows.length === 0) {
        document.getElementById('dailyRevenueChart').parentElement.innerHTML +=
          '<p class="text-red-500">No data available</p>';
      } else {
        updateDailyChart(labels, values);
      }
    })
    .catch(err => {
      console.error('🔥 Error fetching daily revenue:', err);
      document.getElementById('dailyRevenueChart').parentElement.innerHTML +=
        '<p class="text-red-500">Error loading chart</p>';
    });
}

// Fetch monthly revenue
function fetchMonthlyRevenue(months) {
  console.log("🔄 fetchMonthlyRevenue, months =", months);
  fetch(ctx + '/Report/report/monthlyRevenue?months=' + months)
    .then(res => {
      if (!res.ok) throw new Error(res.statusText);
      return res.text();
    })
    .then(text => {
      console.log("⬅️ Raw monthlyRevenue response:", text);
      let envelope;
      try {
        envelope = JSON.parse(text);
      } catch (e) {
        console.error("❌ Failed to parse response as JSON:", text, e);
        return [];
      }
      const rows = unwrapEnvelope(envelope);
      console.log("📊 Parsed rows:", rows);
      const labels = rows.map(d => d.month || 'Unknown');
      const values = rows.map(d => Number(d.total) || 0);
      if (rows.length === 0) {
        document.getElementById('monthlyRevenueChart').parentElement.innerHTML +=
          '<p class="text-red-500">No data available</p>';
      } else {
        updateMonthlyChart(labels, values);
      }
    })
    .catch(err => {
      console.error('🔥 Error fetching monthly revenue:', err);
      document.getElementById('monthlyRevenueChart').parentElement.innerHTML +=
        '<p class="text-red-500">Error loading chart</p>';
    });
}

// Fetch sales by category
function fetchSalesByCategory() {
  console.log("🔄 fetchSalesByCategory()");
  fetch(ctx + '/Report/report/salesByCategory')
    .then(res => {
      if (!res.ok) throw new Error(res.statusText);
      return res.text();
    })
    .then(text => {
      console.log("⬅️ Raw salesByCategory response:", text);
      let envelope;
      try {
        envelope = JSON.parse(text);
      } catch (e) {
        console.error("❌ Failed to parse response as JSON:", text, e);
        return [];
      }
      console.group("🏷️ Raw salesByCategory envelope");
      console.log(envelope);
      console.groupEnd();

      const rows = unwrapEnvelope(envelope);
      console.log("📊 Unwrapped rows:", rows);
      const labels = rows.map(r => r[0] || 'Unknown');
      const values = rows.map(r => Number(r[1]) || 0);

      console.log("🏷️ Pie chart labels:", labels);
      console.log("🏷️ Pie chart values:", values);


      if (rows.length === 0) {
        document.getElementById('salesByCategoryChart').parentElement.innerHTML +=
          '<p class="text-red-500">No data available</p>';
      } else {
        updatePieChart(labels, values);
      }
    })
    .catch(err => {
      console.error("🔥 Error fetching sales by category:", err);
      document.getElementById('salesByCategoryChart').parentElement.innerHTML +=
        '<p class="text-red-500">Error loading chart</p>';
    });
}

// Update daily chart
function updateDailyChart(labels, values) {
  if (!dailyChart) {
    console.error("❌ dailyChart not initialized");
    return;
  }
  dailyChart.data.labels = labels;
  dailyChart.data.datasets[0].data = values;
  dailyChart.update();
}

// Update monthly chart
function updateMonthlyChart(labels, values) {
  if (!monthlyChart) {
    console.error("❌ monthlyChart not initialized");
    return;
  }
  monthlyChart.data.labels = labels;
  monthlyChart.data.datasets[0].data = values;
  monthlyChart.update();
}

// Update pie chart
function updatePieChart(labels, values) {
  const canvas = document.getElementById('salesByCategoryChart');
  if (!canvas) {
    console.error("❌ Canvas 'salesByCategoryChart' not found");
    return;
  }

  const ctx2d = canvas.getContext('2d');
  if (!salesPieChart) {
    salesPieChart = new Chart(ctx2d, {
      type: 'pie',
      data: { labels, datasets: [{ data: values }] },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'right' },
          tooltip: {
            enabled: true, // Explicitly enable tooltips
            callbacks: {
              label: function(ctx) {     
                console.log("🔍 Tooltip context:", ctx); // Debug tooltip data           
                const label = ctx.label || 'Unknown';                
                const value = ctx.parsed !== undefined ? ctx.parsed : (ctx.dataset.data[ctx.index] || 0);                
                return `${cat}: RM ${val.toLocaleString(undefined, {
                  minimumFractionDigits: 2
                })}`;
              }
            }
          }
        }
      }
    });
  } else {
    salesPieChart.data.labels = labels;
    salesPieChart.data.datasets[0].data = values;
    salesPieChart.update();
  }
}

// Single DOMContentLoaded listener
document.addEventListener('DOMContentLoaded', function() {
  const preset = document.getElementById('rangePreset');
  preset.addEventListener('change', onPresetChange);

  dailyChart = new Chart(document.getElementById('dailyRevenueChart'), {
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
      maintainAspectRatio: false,
      scales: {
        x: { title: { display: true, text: 'Date' } },
        y: { title: { display: true, text: 'Revenue (RM)' } }
      }
    }
  });

  monthlyChart = new Chart(document.getElementById('monthlyRevenueChart'), {
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
      maintainAspectRatio: false,
      scales: {
        x: { title: { display: true, text: 'Date' } },
        y: { title: { display: true, text: 'Revenue (RM)' } }
      }
    }
  });

  preset.dispatchEvent(new Event('change'));
  setTimeout(() => fetchSalesByCategory(), 500);
  console.log(Chart.version);
});



</script>
</html>
