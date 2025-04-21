<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Products.productVariationOptions" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="Models.Products.productDTO" %>
<%@ page import="java.util.List" %>
<%@ include file="/Views/product/addProduct.jsp" %>

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
                <input type="text" placeholder="Search Product / Brand" name="keywords" id="searchInput" oninput="filterByCategory()"
                    class="w-full border border-gray-300 rounded-md py-2 pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-yellow-400">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>

            <!-- Cart Container -->
            <div class="flex items-center">
                <!-- Plus Icon -->
                <div class="relative">
                <i class="fa-solid fa-plus cursor-pointer" onclick="openAddModal()"></i>                    

                </div>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-4">
            <!-- Sidebar filters for desktop -->
            <div class="w-full md:w-64 mr-6 bg-white rounded-lg shadow-lg p-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-bold text-lg">Filter</h2>
                    <button onclick="clearAllFilters()" class="text-yellow-500 text-sm">Clear All</button>
                </div>

               <form id="filterForm" oninput="filterByCategory()">
                    <!-- 🔽 Price Range -->
                    <div class="border-b pb-3 mb-3">
                        <h3 class="text-gray-600 font-semibold mb-2">Price Range</h3>
                        <div class="flex gap-2">
                            <input type="number" name="minPrice" placeholder="Min"
                                class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                            <input type="number" name="maxPrice" placeholder="Max"
                                class="w-1/2 border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                        </div>
                    </div>

                    <!-- 🔽 Sort By -->
                    <div class="border-b pb-3 mb-3">
                        <h3 class="text-gray-600 font-semibold mb-2">Sort By</h3>
                        <select name="sortBy" class="w-full border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                            <option value="">Select...</option>
                            <option value="priceLowHigh">Price: Low to High</option>
                            <option value="priceHighLow">Price: High to Low</option>
                            <option value="newest">Newest</option>
                        </select>
                    </div>

                    <!-- 🔽 Category -->
                    <div class="border-b pb-3 mb-3">
                        <h3 class="text-gray-600 font-semibold mb-2">Category</h3>
                        <div class="space-y-1">
                            <%
                                List<productType> type = (List<productType>) request.getAttribute("productTypes");
                                if (type != null && !type.isEmpty()) {
                                    for (productType t : type) {
                            %>
                                <label class="flex items-center">
                                    <input type="checkbox" name="categories" value="<%= t.getId() %>" class="form-checkbox text-yellow-500">
                                    <span class="ml-2 text-sm text-gray-600"><%= t.gettype() %></span>
                                </label>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </form>
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
        function clearAllFilters() {
            // Reset the form to its initial state
            document.getElementById('filterForm').reset();

            // Clear the search input field
            document.getElementById('searchInput').value = '';

            // Trigger the filter function to refresh the product list
            filterByCategory();
        }

        function filterByCategory() {
            const form = document.getElementById("filterForm");

            // Step 1: Grab all the form data
            const formData = new FormData(form);

            const keywords = document.getElementById("searchInput").value;
            if (keywords) {
                formData.append("keyword", keywords);
            }

            // Step 2: Convert to URL parameters
            const params = new URLSearchParams(formData).toString();

            // Step 3: Debug output
            console.log("✅ Collected filter params:", params);

            // Step 4: Send AJAX request
            fetch("<%= request.getContextPath() %>/product/productCatalog/Categories?" + params)
                .then(function(response) {
                    console.log("📥 Server responded:", response);
                    // Use .text() first for debug
                    return response.json(); 
                })
                .then(function(data) {
                    let products;
                    try {
                        products = JSON.parse(data.data); // data.data is a string
                        console.log("✅ Parsed products from string:", products);
                        renderProducts(products);
                    } catch (e) {
                        console.error("❌ JSON parse error:", e);
                        console.warn("🚨 Backend might be sending stringified JSON.");
                    }
                })
                .catch(function(err) {
                    console.error("🔥 Fetch error:", err);
                });
        }

        function renderProducts(products) {
            const container = document.getElementById("cardView");
            container.innerHTML = ""; 

            if (!products || products.length === 0) {
                container.innerHTML = "<p>No products found.</p>";
                return;
            }
            
            for (let i = 0; i < products.length; i++) {
                let p = products[i];

                let html = ""
                    + "<a href='productPage?id=" + p.id + "' class='block hover:shadow-lg transition-shadow duration-200'>"
                    +     "<div class='bg-white rounded-lg overflow-hidden shadow relative'>"
                    +         "<img src='" + p.imageUrl + "' alt='" + p.title + "' class='w-full h-40 object-cover'>"
                    +         "<div class='p-3'>"
                    +             "<h3 class='font-medium'>" + p.title + "</h3>"
                    +             "<p class='text-xs text-gray-500'>" + p.retailInfo + "</p>"
                    +             "<div class='flex justify-between items-center mt-2'>"
                    +                 "<span class='font-bold'>RM " + p.price.toFixed(2) + "</span>"
                    +                 "<div class='flex items-center text-xs text-gray-500'>"
                    +                     "<i class='fas fa-box mr-1'></i>"
                    +                     "<span>" + p.stock + " left</span>"
                    +                 "</div>"
                    +             "</div>"
                    +         "</div>"
                    +     "</div>"
                    + "</a>";

                container.innerHTML += html;

                console.log("✅ Rendered " + products.length + " products to frontend.");
            }
        }

        function openAddModal() {
            const m = document.getElementById("addProductModal");
            m.classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }
        function closeAddModal() {
            const m = document.getElementById("addProductModal");
            m.classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        document.addEventListener('DOMContentLoaded', function() {
            const params = new URLSearchParams(window.location.search);
            if (params.get('created') === '1') {
                alert('✅ Product created successfully!');
                params.delete('created');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
        });



    </script>
</body>

</html>
