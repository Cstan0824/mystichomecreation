<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Products.productVariationOptions" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="DTO.productDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="mvc.Helpers.SessionHelper" %>
<%@ page import="DTO.UserSession" %>
<%@ include file="/Views/product/addProduct.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Furniture Shop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css"/>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

</head>

 

<body class="bg-gray-50">
<%@ include file="/Views/Shared/Header.jsp" %>

<% 
        UserSession userSession = sessionHelper.getUserSession(); 
        boolean access = false;

        
%>

    <div class="content-wrapper">
        <!-- Header with search and cart -->
        <div class="flex flex-row justify-between items-center mb-6 gap-4">
            <!-- Search Container -->
            <div class="relative flex-1 md:flex-none md:w-96">
                <input type="text" placeholder="Search Product / Brand" name="keywords" id="searchInput" oninput="filterByCategory()"
                    class="w-full border border-gray-300 rounded-md py-2 pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-yellow-400">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>

            <% if (sessionHelper.isAuthenticated() && sessionHelper.getUserSession() != null) {
                    for (String accessUrl : sessionHelper.getAccessUrls()) {
                        if (accessUrl.startsWith("product/")) { 
                            access = true;
                            break;
                        }
                    }
                }
            %>
             <% if (access) { %> <!-- 🛠 Wrap the button with permission check -->

                <div class="flex items-center">
                <!-- Plus Icon -->
                <div class="relative">
                    <i class="fa-solid fa-plus cursor-pointer" onclick="openAddModal()"></i>                    

                </div>
            </div>

           <% } %>
            
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

                    <!--  Category -->
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
                    <!-- Header Section -->
                    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
                        <h2 class="text-xl font-bold">Searched Result</h2>
                        <div class="flex gap-2 w-full md:w-auto">
                            <!-- View Toggle Buttons -->
                            <button id="btnList" onclick="toggleView('list')" 
                                class="view-toggle hidden md:flex bg-gray-100 text-gray-600 px-4 py-2 rounded-md items-center gap-2">
                                <i class="fas fa-list"></i>
                                <span>List</span>
                            </button>
                            <button id="btnCard" onclick="toggleView('card')" 
                                class="view-toggle hidden md:flex bg-yellow-400 text-white px-4 py-2 rounded-md items-center gap-2">
                                <i class="fas fa-th"></i>
                                <span>Grid</span>
                            </button>
                        </div>
                    </div>

                    <% 
                        List<product> products = (List<product>) request.getAttribute("products");
                        boolean hasProducts = products != null && !products.isEmpty();
                        int itemsPerPage = 9; // Items per page
                    %>

                    <!-- Card View -->
                    <div id="cardView" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                        <% if (hasProducts) { 
                            
                            for (int i=0; i<products.size(); i++) { 
                                product p = products.get(i); %>
                                <div class="product-item page-<%= (i/itemsPerPage)+1 %>" data-page="<%= (i/itemsPerPage)+1 %>">                                   
                                    <a href="productPage?id=<%= p.getId() %>" class="block h-full hover:shadow-lg transition-shadow duration-200">
                                        <div class="bg-white rounded-lg overflow-hidden shadow h-full">
                                            <img loading="lazy" src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= p.getImage().getId() %>" 
                                                alt="<%= p.getTitle() %>" class="w-full h-48 object-cover rounded-t-md" />
                                            <div class="p-4">
                                                <h3 class="font-semibold text-lg truncate"><%= p.getTitle() %></h3>
                                                <p class="text-sm text-gray-500 mt-2 line-clamp-2"><%= p.getRetailInfo() %></p>
                                                <div class="flex justify-between items-center mt-4">
                                                    <span class="text-lg font-bold text-yellow-600">RM <%= String.format("%.2f", p.getPrice()) %></span>
                                                    <div class="flex items-center text-sm text-gray-500">
                                                        <i class="fas fa-box mr-2"></i>
                                                        <span><%= p.getStock() %> left</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            <% } 
                        } else { %>
                            <p class="text-center text-gray-500 col-span-full">No products found.</p>
                        <% } %>
                    </div>

                    <!-- List View -->
                    <div id="listView" class="hidden space-y-4 mb-6">
                        <% if (hasProducts) { 
                            
                            for (int i=0; i<products.size(); i++) { 
                                product p = products.get(i); %>
                                <div class="product-item page-<%= (i/itemsPerPage)+1 %>" data-page="<%= (i/itemsPerPage)+1 %>">                                    
                                    <a href="productPage?id=<%= p.getId() %>" class="flex flex-col sm:flex-row bg-white rounded-lg shadow hover:shadow-lg transition-shadow duration-200">
                                        <div class="sm:w-1/3">
                                            <img loading="lazy" src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= p.getImage().getId() %>" 
                                                alt="<%= p.getTitle() %>" class="w-full h-48 object-cover rounded-t-md sm:rounded-l-md sm:rounded-tr-none" />
                                        </div>
                                        <div class="p-4 sm:w-2/3">
                                            <h3 class="font-semibold text-xl truncate"><%= p.getTitle() %></h3>
                                            <p class="text-gray-500 mt-2"><%= p.getTypeId().gettype() %></p>
                                            <div class="flex justify-between items-center mt-4">
                                                <span class="text-2xl font-bold text-yellow-600">RM <%= String.format("%.2f", p.getPrice()) %></span>
                                                <div class="flex items-center text-sm text-gray-500">
                                                    <i class="fas fa-box mr-2"></i>
                                                    <span><%= p.getStock() %> left</span>
                                                </div>
                                            </div>
                                            <p class="text-sm text-gray-600 mt-3 line-clamp-3"><%= p.getRetailInfo() %></p>
                                        </div>
                                    </a>
                                </div>
                            <% } 
                        } else { %>
                            <p class="text-center text-gray-500">No products found.</p>
                        <% } %>
                    </div>

                    <!-- Pagination Controls -->
                    <% if (hasProducts) { 
                        int totalPages = (int) Math.ceil((double)products.size() / itemsPerPage); %>
                        <div class="pagination-controls mt-6 flex justify-center items-center gap-2">
                            <button onclick="changePage(currentPage - 1)" 
                                class="px-4 py-2 rounded-md bg-gray-100 hover:bg-gray-200">
                                &laquo; Previous
                            </button>
                            
                            <% for(int i=1; i<=totalPages; i++) { %>
                                <button onclick="changePage(<%= i %>)" 
                                    class="page-btn px-4 py-2 rounded-md <%= i==1 ? "bg-yellow-400 text-white" : "bg-gray-100 hover:bg-gray-200" %>">
                                    <%= i %>
                                </button>
                            <% } %>
                            
                            <button onclick="changePage(currentPage + 1)" 
                                class="px-4 py-2 rounded-md bg-gray-100 hover:bg-gray-200">
                                Next &raquo;
                            </button>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

    </div>




    <script>

    let currentPage = 1;
    const itemsPerPage = <%= itemsPerPage %>;

function toggleView(view) {
    const cardView = document.getElementById('cardView');
    const listView = document.getElementById('listView');
    const btnCard = document.getElementById('btnCard');
    const btnList = document.getElementById('btnList');
    
    if(view === 'card') {
        cardView.classList.remove('hidden');
        listView.classList.add('hidden');
        btnCard.classList.add('bg-yellow-400', 'text-white');
        btnList.classList.remove('bg-yellow-400', 'text-white');
        btnList.classList.add('bg-gray-100', 'text-gray-600');
    } else {
        listView.classList.remove('hidden');
        cardView.classList.add('hidden');
        btnList.classList.add('bg-yellow-400', 'text-white');
        btnCard.classList.remove('bg-yellow-400', 'text-white');
        btnCard.classList.add('bg-gray-100', 'text-gray-600');
    }
    changePage(1); 
}

function changePage(newPage) {
    const totalProducts = <%= hasProducts ? products.size() : 0 %>;

    // calculate total pages  , use math ceil to round up , even 1.1
    const totalPages = Math.ceil(totalProducts / itemsPerPage);
    
    if(newPage < 1 || newPage > totalPages) return;
    
    //when user click on the page number, we need to update the current page product available
    currentPage = newPage;
    
    // Update product visibility , if the data-page ==  currentPage 
    document.querySelectorAll('.product-item').forEach(item => {
        item.style.display = item.dataset.page == currentPage ? 'block' : 'none';
    });
    
    // Update pagination buttons
    document.querySelectorAll('.page-btn').forEach(btn => {
        btn.classList.toggle('bg-yellow-400', Number(btn.textContent) === currentPage);
        btn.classList.toggle('text-white', Number(btn.textContent) === currentPage);
    });
}

        


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
            var ctx = '<%= request.getContextPath() %>';
            const container = document.getElementById("cardView");
            const paginationContainer = document.querySelector('.pagination-controls');

            paginationContainer.innerHTML = ""; // 🛑 Clear old pagination buttons
            container.innerHTML = ""; 

            if (!products || products.length === 0) {
                container.innerHTML = "<p>No products found.</p>";
                return;
            }

            const itemsPerPage = 9; 

            for (let i = 0; i < products.length; i++) {
                let p = products[i];
                let pageNumber = Math.floor(i / itemsPerPage) + 1; 

                let html = ""
                    + "<div class='product-item page-" + pageNumber + "' data-page='" + pageNumber + "'>"
                    +   "<a href='productPage?id=" + p.id + "' class='block h-full hover:shadow-lg transition-shadow duration-200'>"
                    +     "<div class='bg-white rounded-lg overflow-hidden shadow h-full'>"
                    +         "<img src='" + ctx + "/File/Content/product/retrieve?id=" + p.productImageId + "' alt='" + p.title + "' class='w-full h-48 object-cover rounded-t-md' >"
                    +         "<div class='p-4'>"
                    +             "<h3 class='font-semibold text-lg truncate'>" + p.title + "</h3>"
                    +             "<p class='text-sm text-gray-500 mt-2 line-clamp-2'>" + p.retailInfo + "</p>"
                    +             "<div class='flex justify-between items-center mt-4'>"
                    +                 "<span class='text-lg font-bold text-yellow-600'>RM " + p.price.toFixed(2) + "</span>"
                    +                 "<div class='flex items-center text-sm text-gray-500'>"
                    +                     "<i class='fas fa-box mr-2'></i>"
                    +                     "<span>" + p.stock + " left</span>"
                    +                 "</div>"
                    +             "</div>"
                    +         "</div>"
                    +     "</div>"
                    +   "</a>"
                    + "</div>"; // ✅ wrap with div.product-item

                container.innerHTML += html;
            }

            const totalPages = Math.ceil(products.length / itemsPerPage);

            if (totalPages > 1) {
                    paginationContainer.innerHTML += ""
                        + "<button onclick='changePage(currentPage - 1)' class='prev-btn px-4 py-2 rounded-md bg-gray-100 hover:bg-gray-200'>"
                        + "&laquo; Previous"
                        + "</button>";

                    for (let i = 1; i <= totalPages; i++) {
                        paginationContainer.innerHTML += ""
                            + "<button onclick='changePage(" + i + ")' class='page-btn px-4 py-2 rounded-md "
                            + (i === 1 ? "bg-yellow-400 text-white" : "bg-gray-100 hover:bg-gray-200")
                            + "'>"
                            + i
                            + "</button>";
                    }

                    paginationContainer.innerHTML += ""
                        + "<button onclick='changePage(currentPage + 1)' class='next-btn px-4 py-2 rounded-md bg-gray-100 hover:bg-gray-200'>"
                        + "Next &raquo;"
                        + "</button>";
                }
            // 3. Always reset to page 1 after re-render
            currentPage = 1;
            changePage(currentPage);


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
            const typeId = params.get("productTypeId");
            
            if (typeId) {
                // Tick the matching checkbox
                const checkbox = document.querySelector(`input[name="categories"][value="`+ typeId +`"]`);
                if (checkbox) {
                    checkbox.checked = true;
                }

                // Trigger the filter
                filterByCategory();
            }

            if (params.get('created') === '1') {
                alert('✅ Product created successfully!');
                params.delete('created');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
            if (params.get('updated') === '1') {
                alert('✅ Product updated successfully!');
                params.delete('updated');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
            if (params.get('deleted') === '1') {
                alert('❌ Product deleted successfully!');
                params.delete('deleted');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            changePage(1);
        });



    </script>
</body>

</html>
