<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.productVariationOptions" %>
<%@ page import="Models.product" %>
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

        <!-- Mobile Filter Button (visible only on mobile) -->
        <div class="md:hidden mb-4">
            <button class="w-full bg-yellow-400 text-white py-2 rounded-md flex items-center justify-center"
                onclick="toggleFilterModal()">
                <i class="fas fa-filter mr-2"></i> Filter
            </button>
        </div>

        <div class="flex flex-col md:flex-row gap-4">
            <!-- Sidebar filters for desktop -->
            <div class="hidden md:block w-full md:w-64 mr-6 bg-white rounded-lg shadow-lg p-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-bold text-lg">Filter</h2>
                    <button class="text-yellow-500 text-sm" onclick="clearAllFilters()">Clear All</button>
                </div>
                <form id="filterForm" method="GET" action="/your-backend-endpoint">
                    <!-- Price Range Section -->
                    <div class="border-b pb-3 mb-3">
                        <div class="flex justify-between items-center cursor-pointer"
                            onclick="toggleFilterSection('priceSection')">
                            <h3 class="text-gray-600 font-semibold">Price Range</h3>
                            <i id="icon-price" class="fas fa-chevron-down text-gray-400 transition-transform"></i>
                        </div>
                        <div id="priceSection" class="hidden mt-2">
                            <div class="flex gap-2">
                                <input type="number" name="minPrice" placeholder="Min"
                                    class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                                <input type="number" name="maxPrice" placeholder="Max"
                                    class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                            </div>
                        </div>
                    </div>
                    <!-- Sort By Section -->
                    <div class="border-b pb-3 mb-3">
                        <div class="flex justify-between items-center cursor-pointer"
                            onclick="toggleFilterSection('sortSection')">
                            <h3 class="text-gray-600 font-semibold">Sort By</h3>
                            <i id="icon-sort" class="fas fa-chevron-down text-gray-400 transition-transform"></i>
                        </div>
                        <div id="sortSection" class="hidden mt-2">
                            <select name="sortBy" class="w-full border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                                <option value="">Select...</option>
                                <option value="priceLowHigh">Price: Low to High</option>
                                <option value="priceHighLow">Price: High to Low</option>
                                <option value="newest">Newest</option>
                                <option value="popularity">Popularity</option>
                            </select>
                        </div>
                    </div>
                    <!-- Category Section -->
                    <div class="border-b pb-3 mb-3">
                        <div class="flex justify-between items-center cursor-pointer"
                            onclick="toggleFilterSection('categorySection')">
                            <h3 class="text-gray-600 font-semibold">Category</h3>
                            <i id="icon-category" class="fas fa-chevron-down text-gray-400 transition-transform"></i>
                        </div>
                        <div id="categorySection" class="hidden mt-2">
                            <div class="space-y-1">
                                <label class="flex items-center">
                                    <input type="checkbox" name="category[]" value="sofa"
                                        class="form-checkbox text-yellow-500">
                                    <span class="ml-2 text-sm text-gray-600">Sofa</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="category[]" value="tvCabinet"
                                        class="form-checkbox text-yellow-500">
                                    <span class="ml-2 text-sm text-gray-600">TV Cabinet</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="category[]" value="coffeeTable"
                                        class="form-checkbox text-yellow-500">
                                    <span class="ml-2 text-sm text-gray-600">Coffee Table</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="category[]" value="bed"
                                        class="form-checkbox text-yellow-500">
                                    <span class="ml-2 text-sm text-gray-600">Bed</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Mobile Filter Modal (hidden by default) -->
            <div id="mobileFilterModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden">
                <!-- Modal Panel -->
                <div
                    class="absolute top-0 right-0 w-3/4 sm:w-1/2 md:w-1/3 h-full bg-white shadow-lg p-4 overflow-y-auto">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="font-bold text-lg">Filter</h2>
                        <button class="text-yellow-500 text-sm" onclick="clearAllFilters()">Clear All</button>
                        <button class="text-gray-500 text-xl" onclick="toggleFilterModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <!-- Put the same filter sections here as the sidebar -->
                    <div class="space-y-4">
                        <div class="border-b pb-3">
                            <div class="flex justify-between items-center">
                                <h3 class="text-gray-600">Price Range</h3>
                                <i class="fas fa-chevron-down text-gray-400"></i>
                            </div>
                        </div>
                        <div class="border-b pb-3">
                            <div class="flex justify-between items-center">
                                <h3 class="text-gray-600">Sort By</h3>
                                <i class="fas fa-chevron-down text-gray-400"></i>
                            </div>
                        </div>
                        <div class="border-b pb-3">
                            <div class="flex justify-between items-center">
                                <h3 class="text-gray-600">Category</h3>
                                <i class="fas fa-chevron-down text-gray-400"></i>
                            </div>
                        </div>
                        <!-- ... more filter items as needed ... -->
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
                                class="bg-white text-gray-700  rounded-md py-2 px-4 flex items-center justify-center shadow w-1/2 md:w-auto"
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

                    <%
                        List<product> products = (List<product>) request.getAttribute("products");
                        if (products != null && !products.isEmpty()) {
                            for (product p : products) {
                    %>

                    <!-- Featured Products Row 1 -->
                    <div id="cardView" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 mb-6">
                        <!-- Product 1 (Card) -->
                        <div class="bg-white rounded-lg overflow-hidden shadow relative">
                            <img src="<%= p.getImageUrl() %>" alt="<%= p.getTitle() %>" class="w-full h-40 object-cover">
                            <div class="p-3">
                                <h3 class="font-medium"><%= p.getTitle() %></h3>
                                <p class="text-xs text-gray-500"><%= p.getRetailInfo() %></p>
                                <div class="flex justify-between items-center mt-2">
                                    <span class="font-bold">RM <%= p.getPrice() %></span>
                                    <div class="flex items-center text-xs text-gray-500">
                                        <i class="fas fa-box mr-1"></i>
                                        <span><%= p.getStock() %> left</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            } else {
                        %>
                            <p>No products found.</p>
                        <%
                            }
                        %>
                    </div>

                    <!-- Product Container: List View (hidden by default) -->
                    <div id="listView" class="hidden space-y-4 mb-6">
                        <!-- Product 1 (List) -->
                        <div class="flex bg-white rounded-lg overflow-hidden shadow relative">
                            <!-- Optional: FEATURED badge -->
                            <div
                                class="hidden md:block absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-xs">
                                FEATURED
                            </div>
                            <!-- Image -->
                            <div class="w-1/3">
                                <img src="/src/cupboard.avif" alt="L-shape Sofa" class="w-full h-fit object-cover">
                            </div>
                            <!-- Details -->
                            <div class="p-4 flex flex-col justify-between w-2/3">
                                <div>
                                    <h3 class="font-medium text-lg">MARCO L-shape Sofa</h3>
                                    <p class="text-md text-gray-500">Hoi Kong Furnitureakjngkjabgkjaegjknaegkjnaekjgn
                                        kjabefkjgbaekjgb</p>
                                </div>
                                <div class="flex justify-between items-center mt-2">
                                    <span class="font-bold text-xl">RM 2,499.00</span>
                                    <div class="flex items-center text-xs text-gray-500">
                                        <i class="fas fa-box mr-1"></i>
                                        <span>3 left</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Product 2 (List) -->
                        <div class="flex bg-white rounded-lg overflow-hidden shadow relative">
                            <div
                                class="hidden md:block absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-xs">
                                FEATURED
                            </div>
                            <div class="w-1/3">
                                <img src="/api/placeholder/400/320" alt="TV Cabinet" class="w-full h-full object-cover">
                            </div>
                            <div class="p-4 flex flex-col justify-between w-2/3">
                                <div>
                                    <h3 class="font-medium text-lg">GORDY TV Cabinet (Cocoa)</h3>
                                    <p class="text-xs text-gray-500">Hin Lim Furniture... (Hin Lim)</p>
                                </div>
                                <div class="flex justify-between items-center mt-2">
                                    <span class="font-bold text-xl">RM 407.00</span>
                                    <div class="flex items-center text-xs text-gray-500">
                                        <i class="fas fa-box mr-1"></i>
                                        <span>15 left</span>
                                    </div>
                                </div>
                            </div>
                        </div>




                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript for toggling the mobile filter modal -->
        <script>
            function toggleFilterModal() {
                const modal = document.getElementById('mobileFilterModal');
                modal.classList.toggle('hidden');
            }
            function clearAllFilters() {
                alert("Clear all filters");
                // Implement your clear logic here.
            }

            function toggleView(view) {
                const cardView = document.getElementById('cardView');
                const listView = document.getElementById('listView');
                const btnCard = document.getElementById('btnCard');
                const btnList = document.getElementById('btnList');

                if (view === 'card') {
                    cardView.classList.remove('hidden');
                    listView.classList.add('hidden');
                    // Update button styles for card view
                    btnCard.classList.add('bg-yellow-400', 'text-white');
                    btnCard.classList.remove('bg-white', 'text-gray-700');
                    btnList.classList.add('bg-white', 'text-gray-700');
                    btnList.classList.remove('bg-yellow-400', 'text-white');
                } else if (view === 'list') {
                    cardView.classList.add('hidden');
                    listView.classList.remove('hidden');
                    // Update button styles for list view
                    btnList.classList.add('bg-yellow-400', 'text-white');
                    btnList.classList.remove('bg-white', 'text-gray-700');
                    btnCard.classList.add('bg-white', 'text-gray-700');
                    btnCard.classList.remove('bg-yellow-400', 'text-white');
                }
            }

            function toggleFilterSection(sectionId) {
                const section = document.getElementById(sectionId);
                section.classList.toggle('hidden');
                // Toggle chevron rotation based on section id:
                const icon = document.getElementById('icon-' + sectionId.replace('Section', ''));
                if (icon) {
                    icon.classList.toggle('rotate-180');
                }
            }
            function clearAllFilters() {
                // Reset the form inputs
                document.getElementById('filterForm').reset();
                // Collapse all sections
                const sections = ['priceSection', 'sortSection', 'categorySection'];
                sections.forEach(id => {
                    const el = document.getElementById(id);
                    if (el && !el.classList.contains('hidden')) {
                        el.classList.add('hidden');
                    }
                    // Reset chevron rotation:
                    const icon = document.getElementById('icon-' + id.replace('Section', ''));
                    if (icon && icon.classList.contains('rotate-180')) {
                        icon.classList.remove('rotate-180');
                    }
                });
            }
        </script>

</body>

</html>