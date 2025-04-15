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

<body class="p-2 m-0">
  <!-- Header with Search Bar -->
  <div class="bg-white px-4 py-3">
    <!-- Top Row: Title & Controls -->
    <div class="flex justify-between items-center">
      <h2 class="font-semibold text-gray-800">My Transactions</h2>
      <div class="flex items-center gap-2 relative">
        <!-- Sort By Dropdown -->
        <div class="relative">
          <button id="sortToggle" class="flex items-center border px-3 py-1 rounded text-sm hover:bg-gray-100">
            <i class="fas fa-sort mr-1"></i> Sort By
          </button>
          <div id="sortMenu" class="absolute right-0 mt-1 bg-white border rounded shadow-lg w-52 hidden z-50 p-3 space-y-2">
            <label class="block text-sm text-gray-700 font-medium">Sort Field</label>
            <select id="sortField" class="w-full border px-2 py-1 rounded text-sm">
              <option value="date">Date</option>
              <option value="amount">Total Amount</option>
              <option value="status">Status</option>
            </select>
            <label class="block text-sm text-gray-700 font-medium mt-2">Order</label>
            <select id="sortOrder" class="w-full border px-2 py-1 rounded text-sm">
              <option value="asc">Ascending</option>
              <option value="desc">Descending</option>
            </select>
            <button id="applySort" class="mt-3 w-full px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700">Apply</button>
          </div>
        </div>

        <!-- Filter Dropdown -->
        <div class="relative">
          <button id="filterToggle" class="flex items-center border px-3 py-1 rounded text-sm hover:bg-gray-100">
            <i class="fas fa-filter mr-1"></i> Filter
          </button>
          <div id="filterMenu" class="absolute right-0 mt-1 bg-white border rounded shadow-lg w-72 hidden z-50 p-4 space-y-4 text-sm">
            <label class="block font-medium text-gray-700 mb-1">Filter By</label>
            <select id="filterType" class="w-full border rounded px-2 py-1">
              <option value="date">Date Range</option>
              <option value="price">Price Range</option>
              <option value="status">Order Status</option>
            </select>

            <!-- Dynamic Filter Fields -->
            <div id="filterDate" class="space-y-2">
              <label class="block font-medium text-gray-700 mb-1">Date Range</label>
              <div class="flex space-x-2">
                <input type="date" id="startDate" class="w-1/2 border rounded px-2 py-1" />
                <input type="date" id="endDate" class="w-1/2 border rounded px-2 py-1" />
              </div>
            </div>

            <div id="filterPrice" class="space-y-2 hidden">
              <label class="block font-medium text-gray-700 mb-1">Price Range (RM)</label>
              <div class="flex space-x-2">
                <input type="number" id="minPrice" placeholder="Min" class="w-1/2 border rounded px-2 py-1" />
                <input type="number" id="maxPrice" placeholder="Max" class="w-1/2 border rounded px-2 py-1" />
              </div>
            </div>

            <div id="filterStatus" class="hidden">
              <label class="block font-medium text-gray-700 mb-1">Order Status</label>
              <select id="statusFilter" class="w-full border rounded px-2 py-1">
                <option value="">All</option>
                <option value="Delivered">Delivered</option>
                <option value="Processing">Processing</option>
                <option value="Cancelled">Cancelled</option>
              </select>
            </div>

            <button id="applyFilter" class="w-full px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700">Apply</button>
          </div>
        </div>

        <!-- Search Input -->
        <div class="relative">
          <input
            type="text"
            placeholder="Search by name..."
            class="border px-3 py-1 pl-8 rounded text-sm w-40 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <i class="fas fa-search absolute top-2 left-2 text-gray-400 text-xs"></i>
        </div>
      </div>
    </div>

    <!-- Applied Filters -->
    <div id="appliedFilters" class="flex flex-wrap gap-2 mt-2"></div>
  </div>




  <div class="bg-white w-full p-4">
    <hr class="border-gray-200 p-2" />

    <!-- Transaction Cards -->
    <div class="space-y-3 py-2">
      <!-- Card 1 -->
      <div class="bg-gray-50 px-4 py-3 rounded shadow">
        <div class="flex justify-between items-center">
          <div class="text-sm">
            <p class="font-semibold text-gray-800">Order #123456</p>
            <p class="text-xs text-gray-500">3 items &middot; 2024-04-01</p>
            <a href="<%= request.getContextPath() %>/User/account/transactions/details" class="text-sm text-blue-600 hover:underline mt-1 inline-flex items-center gap-1">
              <i class="fas fa-receipt"></i> View Details
            </a>
          </div>
          <div class="text-right">
            <p class="font-semibold text-gray-800">RM57.24</p>
            <p class="text-sm text-green-600"><i class="fas fa-check-circle mr-1"></i>Delivered</p>
          </div>
        </div>
      </div>

      <!-- Card 2 -->
      <div class="bg-gray-50 px-4 py-3 rounded shadow">
        <div class="flex justify-between items-center">
          <div class="text-sm">
            <p class="font-semibold text-gray-800">Order #123457</p>
            <p class="text-xs text-gray-500">2 items &middot; 2024-03-21</p>
            <a href="<%= request.getContextPath() %>/User/account/transactions/details" class="text-sm text-blue-600 hover:underline mt-1 inline-flex items-center gap-1">
              <i class="fas fa-receipt"></i> View Details
            </a>
          </div>
          <div class="text-right">
            <p class="font-semibold text-gray-800">RM102.00</p>
            <p class="text-sm text-yellow-600"><i class="fas fa-clock mr-1"></i>Processing</p>
          </div>
        </div>
      </div>

      <!-- Card 3 -->
      <div class="bg-gray-50 px-4 py-3 rounded shadow">
        <div class="flex justify-between items-center">
          <div class="text-sm">
            <p class="font-semibold text-gray-800">Order #123458</p>
            <p class="text-xs text-gray-500">1 item &middot; 2024-03-10</p>
            <a href="<%= request.getContextPath() %>/User/account/transactions/details" class="text-sm text-blue-600 hover:underline mt-1 inline-flex items-center gap-1">
              <i class="fas fa-receipt"></i> View Details
            </a>
          </div>
          <div class="text-right">
            <p class="font-semibold text-gray-800">RM29.90</p>
            <p class="text-sm text-red-600"><i class="fas fa-times-circle mr-1"></i>Cancelled</p>
          </div>
        </div>
      </div>

      <!-- Card 3 -->
      <div class="bg-gray-50 px-4 py-3 rounded shadow">
        <div class="flex justify-between items-center">
          <div class="text-sm">
            <p class="font-semibold text-gray-800">Order #123458</p>
            <p class="text-xs text-gray-500">1 item &middot; 2024-03-10</p>
            <a href="<%= request.getContextPath() %>/User/account/transactions/details" class="text-sm text-blue-600 hover:underline mt-1 inline-flex items-center gap-1">
              <i class="fas fa-receipt"></i> View Details
            </a>
          </div>
          <div class="text-right">
            <p class="font-semibold text-gray-800">RM29.90</p>
            <p class="text-sm text-red-600"><i class="fas fa-times-circle mr-1"></i>Cancelled</p>
          </div>
        </div>
      </div>

      
    </div>

    <!-- Pagination -->
    <div class="fixed bottom-0 left-0 right-0  px-6 py-4 flex justify-end ">
      <nav class="inline-flex -space-x-px text-sm">
        <a href="#" class="px-3 py-1 border border-gray-300 rounded-l hover:bg-gray-100">
          <i class="fas fa-angle-left"></i> Previous
        </a>
        <a href="#" class="px-3 py-1 border-t border-b border-gray-300 bg-yellow-300 text-yellow-900">1</a>
        <a href="#" class="px-3 py-1 border-t border-b border-gray-300 hover:bg-gray-100">2</a>
        <a href="#" class="px-3 py-1 border-t border-b border-gray-300 hover:bg-gray-100">3</a>
        <a href="#" class="px-3 py-1 border border-gray-300 rounded-r hover:bg-gray-100">
          Next <i class="fas fa-angle-right"></i>
        </a>
      </nav>
    </div>

  </div>
  <script>
    $(function () {
      function updateFilterDisplay() {
        var selected = $('#filterType').val();
        $('#filterDate, #filterPrice, #filterStatus').addClass('hidden');
        if (selected === 'date') $('#filterDate').removeClass('hidden');
        else if (selected === 'price') $('#filterPrice').removeClass('hidden');
        else if (selected === 'status') $('#filterStatus').removeClass('hidden');
      }

      $('#filterType').on('change', updateFilterDisplay);
      updateFilterDisplay();

      $('#sortToggle').on('click', function () {
        $('#sortMenu').toggleClass('hidden');
        $('#filterMenu').addClass('hidden');
      });

      $('#filterToggle').on('click', function () {
        $('#filterMenu').toggleClass('hidden');
        $('#sortMenu').addClass('hidden');
      });

      $(document).on('click', function (e) {
        if (!$(e.target).closest('#sortToggle, #sortMenu').length) {
          $('#sortMenu').addClass('hidden');
        }
        if (!$(e.target).closest('#filterToggle, #filterMenu').length) {
          $('#filterMenu').addClass('hidden');
        }
      });

function updateOrAddBadge(prefix, value, color) {
  var key = prefix.trim(); // unique identifier
  var exists = false;
  $('#appliedFilters span').each(function () {
    if ($(this).data('key') === key) {
      $(this).html(prefix + value + ' <button data-remove="' + key + '" class="ml-1 text-xs text-red-500">&times;</button>');
      exists = true;
    }
  });
  if (!exists) {
    $('#appliedFilters').append(
      '<span data-key="' + key + '" class="' + color + ' text-xs px-2 py-1 rounded inline-flex items-center">' +
      prefix + value + ' <button data-remove="' + key + '" class="ml-1 text-xs text-red-500 hover:underline">&times;</button>' +
      '</span>'
    );
  }
}
      $('#applySort').on('click', function () {
        var field = $('#sortField').val();
        var order = $('#sortOrder').val();
        var label = 'Sort: ' + field.charAt(0).toUpperCase() + field.slice(1) + ' (' + order + ')';
        updateOrAddBadge('Sort: ' + field.charAt(0).toUpperCase() + field.slice(1), ' (' + order + ')', 'bg-blue-100 text-blue-800');
        $('#sortMenu').addClass('hidden');
      });

      $('#applyFilter').on('click', function () {
        var filterType = $('#filterType').val();
        if (filterType === 'date') {
          var start = $('#startDate').val();
          var end = $('#endDate').val();
          if (start || end) {
            updateOrAddBadge('Date: ', start + ' - ' + end, 'bg-green-100 text-green-800');
          }
        } else if (filterType === 'price') {
          var min = $('#minPrice').val();
          var max = $('#maxPrice').val();
          if (min || max) {
            updateOrAddBadge('Price: ', 'RM' + (min || '0') + ' - RM' + (max || '∞'), 'bg-green-100 text-green-800');
          }
        } else if (filterType === 'status') {
          var status = $('#statusFilter').val();
          if (status) {
            updateOrAddBadge('Status: ', status, 'bg-green-100 text-green-800');
          }
        }
        $('#filterMenu').addClass('hidden');
      });
      $(document).on('click', '[data-remove]', function () {
  var key = $(this).data('remove');
  $('#appliedFilters span[data-key="' + key + '"]').remove();

  // Optional: reset filter fields
  if (key === 'Date:') {
    $('#startDate').val('');
    $('#endDate').val('');
  } else if (key === 'Price:') {
    $('#minPrice').val('');
    $('#maxPrice').val('');
  } else if (key === 'Status:') {
    $('#statusFilter').val('');
  } else if (key.indexOf('Sort:') === 0) {
    $('#sortField').val('date');
    $('#sortOrder').val('asc');
  }
});
    });
  </script>
</body>
</html>
