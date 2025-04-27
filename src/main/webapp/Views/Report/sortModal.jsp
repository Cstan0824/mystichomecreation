<%@ page contentType="text/html; charset=UTF-8" %>

<div id="filterModal" class="fixed inset-0 bg-black/30 backdrop-blur-sm flex items-center justify-center hidden z-50 animate-fade-in">
  <div class="bg-white rounded-xl shadow-2xl w-full max-w-md mx-4 overflow-hidden">
    <!-- Header -->
    <div class="border-b border-gray-100 p-6 pb-4">
      <div class="flex items-center justify-between">
        <h3 class="text-2xl font-semibold text-gray-800">
          <i class="fas fa-filter mr-2 text-blue-500"></i>
          Filter Products
        </h3>
       <button type="button" onclick="clearFilters()" class="text-gray-400 hover:text-gray-600 transition-colors">
        <i class="fa-solid fa-filter-circle-xmark"></i>
        </button>
      </div>
    </div>

    <!-- Form Content -->
    <div class="max-h-[70vh] overflow-y-auto p-6 space-y-6">
      <form id="filterForm" class="space-y-6">
        <!-- Category Section -->
       <div class="space-y-2">
            <legend class="text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-tag mr-2 text-gray-500 text-sm"></i>
                Categories
            </legend>

            <div class="grid grid-cols-2 gap-3">

              <%
                List<productType> categories = (List<productType>) request.getAttribute("productTypes");
                if (categories == null) {
                  categories = new java.util.ArrayList<>();
                }
              %>

              <!-- Category Checkboxes -->
              <% for (productType ct : categories) { %>
                <div class="flex items-center space-x-2">
                  <input type="checkbox" name="category" value="<%= ct.getId() %>" id="cat-<%= ct.getId() %>" class="h-4 w-4 text-blue-600 border-gray-300 rounded"/>
                  <label for="cat-<%= ct.getId() %>" class="text-sm text-gray-700">
                    <%= ct.gettype() %>
                  </label>
                </div>
              <% } %>

            </div>
            
        </div>

        <!-- Price Range -->
        <div class="space-y-2">
          <legend class="text-sm font-medium text-gray-700 flex items-center">
            <i class="fas fa-dollar-sign mr-2 text-gray-500 text-sm"></i>
            Price Range (RM)
          </legend>
          <div class="grid grid-cols-2 gap-3">
            <div class="relative">
              <input type="number" name="priceMin" placeholder="Minimum (RM)" 
                     class="w-full pl-8 pr-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm"
                     min="0">
            </div>
            <div class="relative">
              <input type="number" name="priceMax" placeholder="Maximum (RM)" 
                     class="w-full pl-8 pr-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm"
                     min="0">
            </div>
          </div>
        </div>

        <!-- Stock Range -->
        <div class="space-y-2">
          <legend class="text-sm font-medium text-gray-700 flex items-center">
            <i class="fas fa-cubes mr-2 text-gray-500 text-sm"></i>
            Stock Availability
          </legend>
          <div class="grid grid-cols-2 gap-3">
            <input type="number" name="stockMin" placeholder="Min stock" 
                   class="w-full px-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm">
            <input type="number" name="stockMax" placeholder="Max stock" 
                   class="w-full px-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm">
          </div>
        </div>

        <!-- Rating -->
        <div class="space-y-2">
          <legend class="text-sm font-medium text-gray-700 flex items-center">
            <i class="fas fa-star mr-2 text-gray-500 text-sm"></i>
            Minimum Rating
          </legend>
          <select name="ratingMin" 
                  class="w-full px-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm">
            <option value="">Any Rating</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
          </select>
        </div>

        <!-- Date Range -->
        <div class="space-y-2">
          <legend class="text-sm font-medium text-gray-700 flex items-center">
            <i class="fas fa-calendar-alt mr-2 text-gray-500 text-sm"></i>
            Creation Date
          </legend>
          <div class="grid grid-cols-2 gap-3">
            <input type="date" name="dateFrom" 
                   class="w-full px-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm">
            <input type="date" name="dateTo" 
                   class="w-full px-3 py-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-400 text-sm">
          </div>
        </div>
      </form>
    </div>


    <div class="border-t border-gray-100 p-6 pt-4 bg-gray-50">
      <div class="flex justify-end gap-2">
        <button type="button" onclick="closeFilterModal()"
                class="px-5 py-2 text-sm font-medium text-gray-600 hover:text-gray-800 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-all">
          Cancel
        </button>
        <button type="button" onclick="applyFilters()" 
                class="px-5 py-2 text-sm font-medium text-white bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg hover:from-blue-600 hover:to-blue-700 shadow-sm transition-all">
          Apply Filters
        </button>
      </div>
    </div>
  </div>
</div>



<script>
// Add date input constraints
document.addEventListener('DOMContentLoaded', function() {
  const dateTo = document.querySelector('input[name="dateTo"]');
  const dateFrom = document.querySelector('input[name="dateFrom"]');
  
  // Set max date to today
  const today = new Date().toISOString().split('T')[0];
  dateTo.max = today;
  dateFrom.max = today;
  
  // Set default from date to 1 week ago
  const oneWeekAgo = new Date();
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
  dateFrom.value = oneWeekAgo.toISOString().split('T')[0];
});


</script>