<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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


</head>
<body class="content-wrapper bg-white  p-6">
  <div class="space-y-4">
    <h1 class="text-3xl font-bold text-black">Good morning, James!</h1>

      <!-- Top Metrics -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div class="bg-yellow-50 rounded-xl p-4 shadow text-center">
            <div class="text-lg font-semibold text-black">$143,624</div>
            <div class="text-sm text-gray-800">Total Earned</div>
          </div>

          <div class="bg-yellow-50 rounded-2xl p-4 shadow text-center">
            <div class="text-lg font-semibold text-black">12</div>
            <div class="text-sm text-gray-800">Pending transactions</div>
          </div>
          
          <div class="bg-yellow-50 rounded-2xl p-4 shadow text-center">
            <div class="text-lg font-semibold text-black">7</div>
            <div class="text-sm text-gray-800">Payment Preferences</div>
          </div>
          
          <div class="bg-yellow-50 rounded-2xl p-4 shadow text-center">
            <div class="text-lg font-semibold text-black">$3,287.49</div>
            <div class="text-sm text-gray-800">Voucher distributed </div>
          </div>
      </div>

    <!-- Middle Section: New Clients, Invoices, Revenue Chart -->
    <div class="grid grid-cols-3 gap-4">
      <!-- Left column for stacked cards -->
      <div class="col-span-1 space-y-4">
        <!-- New clients card -->
        <div class="bg-yellow-50 border rounded-2xl p-5 shadow-sm">
          <div>
            <div class="text-sm text-black font-medium mb-2">Total Users</div>
            <div class="flex items-baseline">
              <span class="text-5xl font-bold text-black">54</span>
              <span class="ml-2 px-2 py-0.5 bg-green-100 text-green-600 text-xs font-medium rounded-md">+ 18.7%</span>
            </div>
          </div>
        </div>

        <!-- Invoices overdue card -->
        <div class="bg-yellow-50 border rounded-2xl p-5 shadow-sm">
          <div>
            <div class="text-sm text-black font-medium mb-2">Total Staff</div>
            <div class="flex items-baseline">
              <span class="text-5xl font-bold text-black">6</span>
              <span class="ml-2 px-2 py-0.5 bg-red-100 text-red-500 text-xs font-medium rounded-md">+ 2.7%</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Revenue chart card taking 2/3 of the width -->
      <div class="col-span-2 bg-yellow-50 border rounded-2xl p-5 shadow-sm">
        <div>
          <div class="flex justify-between items-center mb-3">
            <div class="text-sm text-black font-medium">Revenue</div>
            <div class="text-xs text-gray-700">Last 7 days VS prior week</div>
          </div>
        </div>
      </div>

      <!-- Full-width section -->
      <div class="col-span-4 bg-yellow-50 borderrounded-3xl p-8 shadow-sm">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-black">Team Performance</h2>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div class="text-center">
            <div class="text-3xl font-bold text-black">85%</div>
            <div class="text-base text-gray-800">Task Completion</div>
          </div>
          <div class="text-center">
            <div class="text-3xl font-bold text-black">120</div>
            <div class="text-base text-gray-800">Projects Completed</div>
          </div>
          <div class="text-center">
            <div class="text-3xl font-bold text-black">15</div>
            <div class="text-base text-gray-800">Ongoing Projects</div>
          </div>
          <div class="text-center">
            <div class="text-3xl font-bold text-black">98%</div>
            <div class="text-base text-gray-800">Client Satisfaction</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
