<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../Shared/AdminHeader.jsp" %>
<%@ include file="../Shared/AdminNavigation.jsp" %>
<%@ include file="/Views/Dashboard/sortModal.jsp" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@ page import="java.lang.Long" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="DTO.productDTO" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Main Content -->
<div class="flex-1 p-6 overflow-y-auto bg-gray-100 font-sans p-6">


  <div class="max-w-7xl mx-auto space-y-8">
    <!-- Page Heading -->
    <h1 class="text-3xl font-bold text-gray-900">Report Dashboard</h1>

    <!-- === Upper 4-column Section === -->
    <%  
      Integer ordersThisMonth = (Integer) request.getAttribute("ordersThisMonth");
      String changeLabel    = (String)  request.getAttribute("orderChangeLabel");
      boolean changeUp      = (Boolean) request.getAttribute("orderChangeUp");
      List<Object[]> sales = (List<Object[]>) request.getAttribute("salesByCategory");
      List<Object[]> prefs = (List<Object[]>) request.getAttribute("paymentPreferences");
      double totalRevenue = (double) request.getAttribute("totalRevenue");
    %>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- 1. Number of Orders Each Month -->
      <div class="bg-white rounded-2xl p-6 shadow hover:shadow-lg transition-shadow duration-300">
        <div class="flex items-center mb-4">
          <div class="p-3 bg-blue-100 rounded-full mr-4 flex items-center justify-center w-12 h-12">
            <i class="fas fa-shopping-bag text-blue-600"></i>
          </div>
          <h3 class="text-sm font-medium text-gray-500">Orders | <%= java.time.YearMonth.now().format(java.time.format.DateTimeFormatter.ofPattern("MMM yyyy"))%></h3>
        </div>
        <div class="flex items-baseline">
          <div class="text-3xl font-extrabold text-gray-900 mr-2"><%= ordersThisMonth %></div>
          <div class="text-sm font-medium 
            <%= changeUp ? "text-green-600" : "text-red-600" %>">
            <i class="fas fa-arrow-<%= changeUp ? "up" : "down" %> mr-1"></i>
            <%= changeLabel %>
          </div>
        </div>
        <div class="mt-4 text-xs text-gray-500">Compared to last month</div>
      </div>

      <!-- 2. Payment Preferences -->
      <div class="bg-white rounded-2xl p-6 shadow hover:shadow-lg transition-shadow duration-300">
        <div class="flex items-center mb-4">
          <div class="p-3 bg-purple-100 rounded-full mr-4 flex items-center justify-center w-12 h-12">
            <i class="fas fa-money-check-alt text-purple-600"></i>
          </div>
          <h3 class="text-sm font-medium text-gray-500">Top Payment Methods</h3>
        </div>
        <div class="space-y-3">
          <% for (Object[] row : prefs) {
            String method = (String) row[0];
            long count = ((Number)row[1]).longValue();
          %>
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <div class="w-8 h-8 rounded-full flex items-center justify-center 
                <%= 
                  method.toLowerCase().contains("cash") ? "bg-yellow-100 text-yellow-600" :
                  method.toLowerCase().contains("online") ? "bg-blue-100 text-blue-600" : 
                  method.toLowerCase().contains("credit") ? "bg-red-100 text-red-600" : 
                  "bg-green-100 text-green-600" %>">
                <i class="fas <%= 
                  method.toLowerCase().contains("cash") ? "fa-money-bill" :
                  method.toLowerCase().contains("online") ? "fa-globe" : 
                  method.toLowerCase().contains("credit") ? "fa-credit-card" : 
                  "fa-money-bill-wave" %>"></i>
              </div>
              <span class="ml-3 font-medium text-gray-700">
                <%= 
                  method.toLowerCase().contains("cash") ? "Cash On Delivery" : 
                  method.toLowerCase().contains("online") ? "Online Banking" : 
                  method.toLowerCase().contains("credit") ? "Credit Card" : 
                  "Cash on Delivery" %>
              </span>
            </div>
            <span class="font-bold text-gray-900"><%= count %></span>
          </div>
          <% } %>
        </div>
      </div>

      <!-- 3. Total Revenue -->
      <div class="bg-white rounded-2xl p-6 shadow hover:shadow-lg transition-shadow duration-300">
        <div class="flex items-center mb-4">
          <div class="p-3 bg-green-100 rounded-full mr-4 flex items-center justify-center w-12 h-12">
            <i class="fas fa-chart-line text-green-600"></i>
          </div>
          <h3 class="text-sm font-medium text-gray-500">Total Revenue Of All Time</h3>
        </div>
        <div class="flex items-baseline">
          <div class="text-3xl font-extrabold text-gray-900 mr-2">RM <%= String.format("%,.2f", totalRevenue) %></div>
        </div>
      </div>
    </div>

    <!-- === Middle Section === -->
    <div class="grid grid-cols-12 gap-4 items-stretch">
      <!-- Left Column: Customer, Staff, and Sales by Category -->
      <div class="col-span-4 space-y-4">
        <!-- Total Customer -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm hover:shadow-md transition-all duration-300">
          <div class="flex justify-between items-center mb-3">
            <div class="text-sm text-gray-500 font-medium">Total Customer</div>
            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
              <i class="fas fa-users text-blue-600"></i>
            </div>
          </div>
          <div class="flex items-baseline">
            <% int totalCustomers = (int) request.getAttribute("totalCustomers"); %>
            <span class="text-4xl font-bold text-gray-900"><%= totalCustomers %></span>
          </div>
        </div>

        <!-- Total Staff -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm hover:shadow-md transition-all duration-300">
          <div class="flex justify-between items-center mb-3">
            <div class="text-sm text-gray-500 font-medium">Total Staff</div>
            <div class="w-8 h-8 bg-purple-100 rounded-full flex items-center justify-center">
              <i class="fas fa-user-tie text-purple-600"></i>
            </div>
          </div>
          <div class="flex items-baseline">
            <% int totalStaff = (int) request.getAttribute("totalStaff"); %>
            <span class="text-4xl font-bold text-gray-900"><%= totalStaff %></span>
          </div>
        </div>

        <!-- Sales by Category -->
        <div class="bg-white border rounded-2xl p-5 shadow-sm hover:shadow-md transition-all duration-300">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-sm font-medium text-gray-500">Sales by Category</h3>
          </div>
          <div class="w-full h-64">
            <canvas id="salesByCategoryChart" class="w-full h-full"></canvas>
          </div>
        </div>
      </div>

      <!-- Right Column: Revenue Chart -->
      <div class="col-span-8">
        <div class="h-full bg-white border rounded-2xl p-4 shadow-sm hover:shadow-md transition-all duration-300">
          <!-- Header Section -->
          <div class="flex justify-between items-center mb-4">
            <div>
              <h3 class="text-base font-medium text-gray-700">Revenue</h3>
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
          <div class="flex-1 bg-gray-50 min-h-[500px] rounded-xl p-4">
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
    <% List<productDTO> products = (List<productDTO>) request.getAttribute("productDTOs"); %>
    <div class="bg-white rounded-2xl p-6 shadow hover:shadow-lg transition-shadow duration-300">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">Product List</h2>
        <div class="flex items-center space-x-4">
         <button onclick="generateSalesReport()" class="flex items-center bg-blue-600 text-white px-4 py-2 rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300">
            <i class="fa-solid fa-download mr-2"></i>
            <span>Download Report</span>
          </button>

          <!-- Filter Button -->
          <button onclick="openFilterModal()" class="flex items-center bg-yellow-500 text-white px-4 py-2 rounded-lg shadow-md hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-yellow-300">
            <i class="fa-solid fa-filter mr-2"></i>
            <span>Filter</span>
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
                <th id="th-totalSold" class="w-2/12 px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer" onclick="sortTotalSold()">
                  Total Sold
                  <i id="icon-totalSold" class="fa-solid fa-sort ml-1"></i>
                </th>
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

  <%@ include file="/Views/Report/sortModal.jsp" %>


<script>
  const ctx = '<%= request.getContextPath() %>';

  // ==================== Filter Modal ====================

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

   function generateSalesReport() {
   $.ajax({
        url: '<%= request.getContextPath() %>/Report/report/generateSalesReport',
        type: 'POST',
        contentType: 'application/json',
        xhr: function() {
            var xhr = new XMLHttpRequest();
            xhr.responseType = 'blob'; // ✅ Correct way for binary download
            return xhr;
        },
        success: function(blob) {
            const blobUrl = URL.createObjectURL(blob);

            const a = document.createElement('a');
            a.href = blobUrl;
            a.download = 'Sales_Report_' + new Date().toISOString().split('T')[0] + '.pdf';
            document.body.appendChild(a);
            a.click();

            document.body.removeChild(a);
            URL.revokeObjectURL(blobUrl);

            Swal.fire({
                icon: 'success',
                title: 'Sales Report Generated',
                text: 'The sales report has been downloaded.'
            });
        },
        error: function() {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to generate sales report.'
            });
        }
    });
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
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: 'Failed to fetch products. Please try again.'
        });
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

  // ==================== Sorting total sold ====================
  function sortTotalSold() {
    let asc = false; // Set to false for sorting from largest to smallest
    const tbody = document.querySelector('#productTable tbody');
    const rows  = Array.from(tbody.rows);
    rows.sort((a, b) => {
      // Grab the 6th cell of the table
      const vA = parseInt(a.cells[5].textContent, 10) || 0;
      const vB = parseInt(b.cells[5].textContent, 10) || 0;
      return asc ? vA - vB : vB - vA;
    });
    rows.forEach(r => tbody.appendChild(r));

    const icon = document.getElementById('icon-totalSold');
    icon.classList.toggle('fa-sort-up',  asc);
    icon.classList.toggle('fa-sort-down', !asc);
    icon.classList.toggle('fa-sort',      false);
    asc = !asc;
  }

//#region testing
// ==========================Testing ==========================
let dailyChart = null;
let monthlyChart = null;
let salesPieChart = null;

// Simplified unwrapEnvelope
function unwrapEnvelope(payload) {
  console.log("🔍 Unwrapping payload:", payload);
  if (Array.isArray(payload)) {
    console.log("✅ Payload is already an array:", payload);
    return payload;
  }
  if (payload && payload.data) {
    if (typeof payload.data === 'string') {
      try {
        const parsed = JSON.parse(payload.data);
        console.log("🔄 Parsed inner data:", parsed);
        return parsed;
      } catch (e) {
        console.error("❌ Failed to parse envelope.data:", payload.data, e);
        return [];
      }
    }
    console.log("🔄 Returning payload.data:", payload.data);
    return payload.data;
  }
  console.warn("⚠️ Unexpected payload shape, returning empty array:", payload);
  return [];
}

// Toggle daily/monthly charts
function onPresetChange() {
  const sel = document.getElementById('rangePreset');
  const count = parseInt(sel.value, 10);
  const unit = sel.selectedOptions[0].dataset.unit;
  console.log("🔄 onPresetChange, count =", count, "unit =", unit);

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
      return res.json();
    })
    .then(envelope => {
      console.log("⬅️ Raw dailyRevenue response:", envelope);
      const rows = unwrapEnvelope(envelope);
      console.log("📊 Parsed rows:", rows);
      const labels = rows.map(d => d[0] || 'Unknown');
      const values = rows.map(d => Number(d[1]) || 0);
      console.log("🏷️ Daily chart labels:", labels);
      console.log("🏷️ Daily chart values:", values);
      if (rows.length === 0 || values.every(v => v === 0)) {
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
      return res.json();
    })
    .then(envelope => {
      console.log("⬅️ Raw monthlyRevenue response:", envelope);
      const rows = unwrapEnvelope(envelope);
      console.log("📊 Parsed rows:", rows);
      const labels = rows.map(d => d[0] || 'Unknown');
      const values = rows.map(d => Number(d[1]) || 0);
      console.log("🏷️ Monthly chart labels:", labels);
      console.log("🏷️ Monthly chart values:", values);
      if (rows.length === 0 || values.every(v => v === 0)) {
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
      return res.json();
    })
    .then(envelope => {
      console.group("🏷️ Raw salesByCategory envelope");
      console.log(envelope);
      console.groupEnd();
      const rows = unwrapEnvelope(envelope);
      console.log("📊 Unwrapped rows:", rows);
      const labels = rows.map(r => r[0] || 'Unknown');
      const values = rows.map(r => Number(r[1]) || 0);
      console.log("🏷️ Pie chart labels:", labels);
      console.log("🏷️ Pie chart values:", values);
      if (rows.length === 0 || values.every(v => v === 0)) {
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
  console.log("🎨 updateDailyChart with labels:", labels, "values:", values);
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
  console.log("🎨 updateMonthlyChart with labels:", labels, "values:", values);
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
  console.log("🎨 updatePieChart with labels:", labels, "values:", values);
  const canvas = document.getElementById('salesByCategoryChart');
  if (!canvas) {
    console.error("❌ Canvas 'salesByCategoryChart' not found");
    return;
  }

  const ctx2d = canvas.getContext('2d');
  if (!salesPieChart) {
    salesPieChart = new Chart(ctx2d, {
          type: 'pie',
          data: {
            labels: labels,
            datasets: [{
              data: values,
              backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF'],
              borderColor: ['#FFFFFF'],
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: { position: 'right' },
              tooltip: {
                enabled: true,
                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                titleColor: '#FFFFFF',
                bodyColor: '#FFFFFF',
                titleFont: { size: 14 },
                bodyFont: { size: 12 },
                callbacks: {
                  label: function(ctx) {
                    console.log("🔍 Tooltip context:", ctx);
                    const label = ctx.label || 'Unknown';
                    const value = ctx.parsed || 0;
                    const formatted = value.toLocaleString('en-MY', { minimumFractionDigits: 2 });
                    const result = label + ': RM' + formatted;
                    console.log("🔍 Tooltip output:", result);
                    return result;
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
  console.log("🔄 Initializing charts, Chart.js version:", Chart.version);
  
  // Initialize daily chart
  dailyChart = new Chart(document.getElementById('dailyRevenueChart'), {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: 'Revenue (RM)',
        data: [],
        borderColor: '#36A2EB',
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        fill: true,
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: { title: { display: true, text: 'Date' } },
        y: { title: { display: true, text: 'Revenue (RM)' } }
      },
      plugins: {
        legend: { position: 'top' },
        tooltip: {
          enabled: true,
          callbacks: {
            label: function(ctx) {
              const value = ctx.parsed.y || 0;
              return 'RM' + value.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            }
          }
        }
      }
    }
  });

  // Initialize monthly chart (bar chart, change to 'line' if preferred)
  monthlyChart = new Chart(document.getElementById('monthlyRevenueChart'), {
    type: 'bar', // Or 'line' to match your previous code
    data: {
      labels: [],
      datasets: [{
        label: 'Revenue (RM)',
        data: [],
        backgroundColor: '#FF6384',
        borderColor: '#FFFFFF',
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: { title: { display: true, text: 'Month' } },
        y: { title: { display: true, text: 'Revenue (RM)' } }
      },
      plugins: {
        legend: { position: 'top' },
        tooltip: {
          enabled: true,
          callbacks: {
            label: function(ctx) {
              const value = ctx.parsed.y || 0;
              return 'RM' + value.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            }
          }
        }
      }
    }
  });

  // Add preset listener and trigger initial fetch
  const preset = document.getElementById('rangePreset');
  preset.addEventListener('change', onPresetChange);
  preset.dispatchEvent(new Event('change'));
  
  // Fetch salesByCategory with delay
  setTimeout(function() {
    fetchSalesByCategory();
  }, 500);
});







</script>

</div>

<%@ include file="../Shared/AdminFooter.jsp" %>


