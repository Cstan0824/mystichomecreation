<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.productVariationOptions" %>
<%@ page import="Models.product" %>
<%@ page import="Models.productType" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Furniture Shop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>

<body class="bg-gray-50">
    <div class="content-wrapper">
        <!-- Header with search and cart -->
        <div class="flex flex-row justify-between items-center mb-6 gap-4">
            <!-- Search Container -->
            <div class="relative flex-1 md:flex-none md:w-96">
                <input type="text" placeholder="Search Product / Brand"
                    class="w-full border border-gray-300 rounded-md py-2 pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-yellow-400">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>

            <!-- Cart Container -->
            <div class="flex items-center">
                <!-- Cart Icon with Badge -->
                <div class="relative">
                    <i class="fas fa-shopping-cart text-gray-700 text-xl hover:text-yellow-500 transition-colors"></i>
                    <span
                        class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                        3
                    </span>
                </div>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-4">
            <!-- Sidebar filters for desktop -->
            <div class="w-full md:w-64 mr-6 bg-white rounded-lg shadow-lg p-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-bold text-lg">Filter</h2>
                    <button class="text-yellow-500 text-sm">Clear All</button>
                </div>

                <!-- Price Range Section -->
                <div class="border-b pb-3 mb-3">
                    <h3 class="text-gray-600 font-semibold mb-2">Price Range</h3>
                    <div class="flex gap-2">
                        <input type="number" name="minPrice" placeholder="Min"
                            class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                        <input type="number" name="maxPrice" placeholder="Max"
                            class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                    </div>
                </div>

                <!-- Sort By Section -->
                <div class="border-b pb-3 mb-3">
                    <h3 class="text-gray-600 font-semibold mb-2">Sort By</h3>
                    <select name="sortBy" class="w-full border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                        <option value="">Select...</option>
                        <option value="priceLowHigh">Price: Low to High</option>
                        <option value="priceHighLow">Price: High to Low</option>
                        <option value="newest">Newest</option>
                        <option value="popularity">Popularity</option>
                    </select>
                </div>

                <!-- Category Section -->
                <div class="border-b pb-3 mb-3">
                    <h3 class="text-gray-600 font-semibold mb-2">Category</h3>
                    <div class="space-y-1">
                        <%
                            List<productType> type = (List<productType>) request.getAttribute("productTypes");
                            if (type != null && !type.isEmpty()) {
                                for (productType t : type) {
                        %>
                            <label class="flex items-center">
                                <input type="checkbox" name="categories" value="<%= t.gettype() %>" class="form-checkbox text-yellow-500" onchange="filterByCategory()" />
                                <span class="ml-2 text-sm text-gray-600"><%= t.gettype() %></span>
                            </label>
                        <% }} %>
                    </div>
                </div>
            </div>

            <!-- Main content -->
            <div class="flex-1 rounded-lg bg-white p-6 shadow-lg">
                <div class="mb-6">
                    <!-- Search Results header with tabs on same line -->
                    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
                        <h2 class="text-xl font-bold">Searched Result</h2>
                        <div class="flex gap-2 w-full md:w-auto">
                            <!-- List View Button -->
                            <button id="btnList"
                                class="bg-white text-gray-700 rounded-md py-2 px-4 flex items-center justify-center shadow w-1/2 md:w-auto"
                                onclick="toggleView('list')">
                                <i class="fas fa-list text-lg"></i>
                            </button>
                            <!-- Card View Button -->
                            <button id="btnCard"
                                class="bg-yellow-400 text-white rounded-md py-2 px-4 flex items-center justify-center shadow w-1/2 md:w-auto"
                                onclick="toggleView('card')">
                                <i class="fas fa-th text-lg"></i>
                            </button>
                        </div>
                    </div>

                    <div id="cardView" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 mb-6">
                        <%
                        List<product> products = (List<product>) request.getAttribute("products");
                        if (products != null && !products.isEmpty()) {
                            for (product p : products) {
                        %>
                            <a href="productPage?id=<%= p.getId() %>" class="block hover:shadow-lg transition-shadow duration-200">
                                <div class="bg-white rounded-lg overflow-hidden shadow relative">
                                    <img src="<%= p.getImageUrl() %>" alt="<%= p.getTitle() %>" class="w-full h-40 object-cover">
                                    <div class="p-3">
                                        <h3 class="font-medium"><%= p.getTitle() %></h3>
                                        <p class="text-xs text-gray-500"><%= p.getRetailInfo() %></p>
                                        <div class="flex justify-between items-center mt-2">
                                            <span class="font-bold">RM <%= String.format("%.2f", p.getPrice()) %></span>
                                            <div class="flex items-center text-xs text-gray-500">
                                                <i class="fas fa-box mr-1"></i>
                                                <span><%= p.getStock() %> left</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        <% } } else { %>
                            <p>No products found.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript for toggling the mobile filter modal -->
        
    </div>
    <script>
            function toggleFilterModal() {
                const modal = document.getElementById('mobileFilterModal');
                modal.classList.toggle('hidden');
            }

            function clearAllFilters() {
                alert("Clear all filters");
                // Implement your clear logic here.
            }

            function toggleFilterSection(sectionId) {
                const section = document.getElementById(sectionId);
                section.classList.toggle('hidden');
                const icon = document.getElementById('icon-' + sectionId.replace('Section', ''));
                if (icon) {
                    icon.classList.toggle('rotate-180');
                }
            }

            function clearAllFilters() {
                document.getElementById('filterForm').reset();
                const sections = ['priceSection', 'sortSection', 'categorySection'];
                sections.forEach(id => {
                    const el = document.getElementById(id);
                    if (el && !el.classList.contains('hidden')) {
                        el.classList.add('hidden');
                    }
                    const icon = document.getElementById('icon-' + id.replace('Section', ''));
                    if (icon && icon.classList.contains('rotate-180')) {
                        icon.classList.remove('rotate-180');
                    }
                });
            }

            async function filterByCategory() {
                var checkboxes = document.getElementsByName("categories");
                var selected = [];
                for (var i = 0; i < checkboxes.length; i++) {
                    if (checkboxes[i].checked) {
                        selected.push("categories=" + encodeURIComponent(checkboxes[i].value));
                    }
                }
                var queryString = selected.join("&");

                try {
                    const response = await fetch(`/product/productCatalog/Categories?${queryString}`);
                    const products = await response.json();
                    console.log("✅ Filtered products:", products);
                    renderProducts(products); // make sure this function exists to re-render the UI
                } catch (err) {
                    console.error("❌ Failed to fetch filtered products:", err);
                }
            }


           
        </script>
</body>

</html>
