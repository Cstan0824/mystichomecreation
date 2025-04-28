<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<%@ page import="mvc.Helpers.SessionHelper" %>
<%@ page import="DTO.UserSession" %>
<body class="font-poppins overflow-x-hidden">
    <% 
        SessionHelper sessionHelper = new SessionHelper(request.getSession());
    %>

    <!-- Header -->
    <div class="flex max-w-vw w-full p-4 items-center sticky top-0 z-[300] bg-white" id="nav-bar">

        <!--logo-->
        <div class="basis-1/5 flex justify-center w-full cursor-pointer">
            <img src="<%= request.getContextPath()%>/Content/assets/image/MystichomeCreationLogo.jpg" onClick="redirectUrl('<%= request.getContextPath()%>/Landing')" class="w-[50px] h-[50px] object-cover rounded-full" alt="logo">
        </div>

        <!--hamburger menu-->
        <div class="basis-3/5 md:hidden flex justify-center items-center w-full">
            <div class="md:hidden flex items-center cursor-pointer" id="nav-toggle">
                <i class="fas fa-bars fa-2x"></i>
            </div>
        </div>

        <!-- user, cart, and notification icons for mobile-->
        <div class="basis-1/5 md:hidden flex justify-end items-center gap-2 sm:gap-4 w-full">
            <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="cart-toggle">
                <i class="fa-solid fa-cart-shopping fa-lg"></i>
            </div>
            
            <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="notification-button" onClick="goToNotification()">
                <i class="fa-solid fa-bell fa-lg"></i>
            </div>
            
            <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="user-toggle">
                <i class="fa-solid fa-user fa-lg"></i>
            </div>  
        </div>


        <!--nav-->
        <div class="basis-3/5 hidden md:block">
            <ul class="flex justify-center gap-2 text-xl">
                <%
                    String currentUrl = request.getRequestURI();
                    boolean isProductPage = currentUrl.contains("/product/");
                    boolean isHomePage = currentUrl.contains("/Landing") || currentUrl.equals(request.getContextPath() + "/");
                    boolean isAdminPage = currentUrl.contains("/Dashboard");
                    boolean isOrderPage = currentUrl.contains("/Order/orders");
                %>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="<%= request.getContextPath() %>/product/productCatalog" 
                       class="<%= isProductPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                        Products
                    </a>
                </li>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="<%= request.getContextPath() %>/Landing" 
                       class="<%= isHomePage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                        Home
                    </a>
                </li>
                <% 
                if(sessionHelper.isAuthenticated() && sessionHelper.getUserSession() != null) {
                   
                    for(String accessUrl : sessionHelper.getAccessUrls()) {
                        if(!accessUrl.equals("Order/orders")) {
                            continue;
                        }
                        %> 
                        <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                            <a href="<%= request.getContextPath() %>/Order/orders" 
                            class="<%= isOrderPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                                Orders
                            </a>
                        </li>
                        <% break;
                    }
                } %>
                <% 
                if(sessionHelper.isAuthenticated() && sessionHelper.getUserSession() != null) {
                    boolean hasDashboardAccess = false;
                    boolean hasCustomerAccess = false;
                    String adminLink = "#";
                    
                    // Check what dashboard permissions the user has
                    for(String accessUrl : sessionHelper.getAccessUrls()) {
                        if(accessUrl.equals("Dashboard")) {
                            hasDashboardAccess = true;
                        }
                        if(accessUrl.equals("Dashboard/customer")) {
                            hasCustomerAccess = true;
                        }
                        if(accessUrl.startsWith("Dashboard")) {
                            // Set default link if we find any dashboard permission
                            if(adminLink.equals("#")) {
                                adminLink = accessUrl;
                            }
                        }
                    }
                    
                    // Determine the link destination based on permissions
                    if(hasDashboardAccess) {
                        adminLink = request.getContextPath() + "/Dashboard";
                    } else if(hasCustomerAccess) {
                        adminLink = request.getContextPath() + "/Dashboard/customer";
                    } else if(!adminLink.equals("#")) {
                        // User has some other Dashboard access
                        adminLink = request.getContextPath() + "/" + adminLink;
                    }
                    
                    // Only show Admin link if user has any Dashboard permissions
                    if(!adminLink.equals("#")) {
                    %> 
                    <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                        <a href="<%= adminLink %>" 
                        class="<%= isAdminPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                            Admin
                        </a>
                    </li>
                    <% 
                    }
                } 
                %>
            </ul>
        </div>

        <!--user and cart-->
        <div class="basis-1/5 hidden md:block">
            <ul class="flex justify-center items-center gap-2">
                <li>
                    <div class="relative inline-block">
                        <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="cart-button">
                            <i class="fa-solid fa-cart-shopping fa-lg"></i>
                        </div>
                        <!--Popover Cart-->
                        <div class="hidden opacity-0 min-w-[330px] min-h-[550px] h-[550px] max-w-[330px] max-h-[630px] overflow-hidden bg-white border-full rounded-md mhc-box-shadow z-[1000] absolute right-0 top-full mt-3 transition-opacity duration-300 ease-in-out" id="cart-popup">
                            <div class="flex flex-col h-full max-h-full">
                                <div class="flex justify-between items-center p-4 pb-2">
                                    <div class="flex items-center gap-4">
                                        <h1 class="text-lg font-semibold font-poppins">Your Cart</h1>
                                        <div class="hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300" id="cart-refresh">
                                            <i class="fa-solid fa-arrows-rotate"></i>
                                        </div>
                                    </div>
                                    <p onClick="goToCart()" class="text-sm font-semibold text-darkYellow underline cursor-pointer">View All</p>
                                </div>

                                <div id="cart-popup-items" class="flex flex-col justify-center items-center h-full"></div>



                            </div>
                        </div>
                    </div>  
                </li>
                <li>
                    <div class="relative inline-block">
                        <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="notification-button" onClick="goToNotification()">
                            <i class="fa-solid fa-bell fa-lg"></i>
                        </div>
                    </div>  
                </li>
                <li>
                    <div class="relative inline-block">
                        <div class="w-20 h-5 border border-gray-200 rounded-full py-4 px-2 flex justify-between items-center hover:mhc-box-shadow text-black hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="user-button">
                            <i class="fa-solid fa-bars fa-lg"></i>
                            <i class="fa-solid fa-user fa-lg"></i>
                        </div>
                        <!-- Popover User Menu -->
                        <div class="hidden absolute right-0 top-full mt-3 min-w-40 w-fit z-[1000] bg-white border border-gray-200 rounded-md mhc-box-shadow opacity-0" id="user-menu">
                            <ul class="flex flex-col gap-2 p-2">
                                <% if (sessionHelper.isAuthenticated()) { %>
                                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="redirectUrl('<%= request.getContextPath() %>/User/account')">
                                        <p class="font-semibold transition-all duration-[500] ease-in-out">Profile</p>
                                    </li>
                                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer " onClick="redirectUrl('<%= request.getContextPath() %>/User/account#transactions')">
                                        <p class="font-semibold transition-all duration-[500] ease-in-out">Purchases</p>
                                    </li>
                                    <form id="logoutForm" action="<%= request.getContextPath()%>/Landing/logout" method="post" enctype="multipart/form-data">
                                        <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="logout()">
                                            <p class="font-semibold transition-all duration-[500] ease-in-out">Logout</p>
                                        </li>
                                    </form>
                                <% } else { %>
                                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="redirectUrl('<%= request.getContextPath() %>/Landing/login')">
                                        <p class="font-semibold transition-all duration-[500] ease-in-out">Login</p>
                                    </li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </li>
            </ul>
        </div>

    </div>

    <!-- Mobile Navigation Full Screen Modal -->
    <div id="mobile-nav-modal" class="hidden fixed inset-0 bg-white z-[9999] flex flex-col p-6">
        <div class="flex justify-between items-center mb-8">
            <h2 class="text-2xl font-bold font-poppins">Menu</h2>
            <button id="close-mobile-nav" class="text-6xl">&times;</button>
        </div>
        <ul class="flex flex-col gap-6 text-xl text-center">
            <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                <a href="<%= request.getContextPath() %>/product/productCatalog" 
                    class="<%= isProductPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                    Products
                </a>
            </li>
            <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                <a href="<%= request.getContextPath() %>/Landing" 
                    class="<%= isHomePage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                    Home
                </a>
            </li>
            <% 
            if(sessionHelper.isAuthenticated() && sessionHelper.getUserSession() != null) {
                
                for(String accessUrl : sessionHelper.getAccessUrls()) {
                    if(!accessUrl.equals("Order/orders")) {
                        continue;
                    }
                    %> 
                    <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                        <a href="<%= request.getContextPath() %>/Order/orders" 
                        class="<%= isOrderPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                            Orders
                        </a>
                    </li>
                    <% break;
                }
            } %>
            <% 
            if(sessionHelper.isAuthenticated() && sessionHelper.getUserSession() != null) {
                boolean hasDashboardAccess = false;
                boolean hasCustomerAccess = false;
                String adminLink = "#";
                
                // Check what dashboard permissions the user has
                for(String accessUrl : sessionHelper.getAccessUrls()) {
                    if(accessUrl.equals("Dashboard")) {
                        hasDashboardAccess = true;
                    }
                    if(accessUrl.equals("Dashboard/customer")) {
                        hasCustomerAccess = true;
                    }
                    if(accessUrl.startsWith("Dashboard")) {
                        // Set default link if we find any dashboard permission
                        if(adminLink.equals("#")) {
                            adminLink = accessUrl;
                        }
                    }
                }
                
                // Determine the link destination based on permissions
                if(hasDashboardAccess) {
                    adminLink = request.getContextPath() + "/Dashboard";
                } else if(hasCustomerAccess) {
                    adminLink = request.getContextPath() + "/Dashboard/customer";
                } else if(!adminLink.equals("#")) {
                    // User has some other Dashboard access
                    adminLink = request.getContextPath() + "/" + adminLink;
                }
                
                // Only show Admin link if user has any Dashboard permissions
                if(!adminLink.equals("#")) {
                %> 
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="<%= adminLink %>" 
                    class="<%= isAdminPage ? "font-normal text-darkYellow" : "font-semibold text-gray-800" %> transition-all duration-[500] ease-in-out">
                        Admin
                    </a>
                </li>
                <% 
                }
            } 
            %>
        </ul>
    </div>


    <!-- Mobile Cart Full Screen Modal -->
    <div id="mobile-cart-modal" class="hidden fixed inset-0 bg-white z-[9999] flex flex-col p-6">
        <div class="grid grid-cols-10 items-center mb-8">
            <div class="col-span-9 grid grid-cols-7 items-center">
                
                <div class="col-span-5 flex items-center gap-4">
                    <h1 class="pl-4 text-2xl font-semibold font-poppins col-span-3">Your Cart</h1>
                    <div class="hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300" id="mobile-cart-refresh">
                        <i class="fa-solid fa-arrows-rotate fa-xl"></i>
                    </div>
                </div>
                
                <p onClick="goToCart()" class="col-span-2 text-2xl text-right font-semibold text-darkYellow underline cursor-pointer">View All</p>
            </div>
            <div class="col-span-1 flex justify-center items-center">
                <button id="close-mobile-cart" class="text-6xl">&times;</button>
            </div>
        </div>

        <div id="mobile-cart-items" class="flex flex-col justify-center items-center h-full">

        </div>
    </div>

    <!-- Mobile User Full Screen Modal -->
    <div id="mobile-user-modal" class="hidden fixed inset-0 bg-white z-[9999] flex flex-col p-6">
        <div class="flex justify-between items-center mb-8">
            <% if (sessionHelper.isAuthenticated()) { %>
                <h2 class="text-2xl font-bold font-poppins">Hi, <%= sessionHelper.getUserSession().getUsername()%></h2>
            <% } else { %>
                <h2 class="text-2xl font-bold font-poppins">Welcome</h2>
            <% } %>
            <button id="close-mobile-user" class="text-6xl">&times;</button>
        </div>
        <ul class="flex flex-col gap-6 text-xl text-center">
            <% if (sessionHelper.isAuthenticated()) { %>
                <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="redirectUrl('<%= request.getContextPath() %>/User/account')">
                    <p class="font-semibold transition-all duration-[500] ease-in-out">Profile</p>
                </li>
                <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer " onClick="redirectUrl('<%= request.getContextPath() %>/User/account#transactions')">
                    <p class="font-semibold transition-all duration-[500] ease-in-out">Purchases</p>
                </li>
                <form id="logoutForm" action="<%= request.getContextPath()%>/Landing/logout" method="post" enctype="multipart/form-data">
                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="logout()">
                        <p class="font-semibold transition-all duration-[500] ease-in-out">Logout</p>
                    </li>
                </form>
            <% } else { %>
                <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="redirectUrl('<%= request.getContextPath() %>/Landing/login')">
                    <p class="font-semibold transition-all duration-[500] ease-in-out">Login</p>
                </li>
            <% } %>
        </ul>
    </div>

    <!-- Content -->
    <script>
        let wasMobile = window.innerWidth < 768;

        function fetchCartItems() {
            const isAuthenticated = <%= sessionHelper.isAuthenticated() %>;

            if (!isAuthenticated) {
                const isMobile = window.innerWidth < 768;
                const cartContainer = isMobile 
                    ? document.getElementById('mobile-cart-items')
                    : document.getElementById('cart-popup-items');
                // User not logged in, show a "please login" message inside cart popup
                cartContainer.className = "flex flex-col justify-center items-center h-full w-full p-4 text-center gap-4";
                cartContainer.innerHTML = `
                    <h2 class="text-lg font-semibold text-gray-700">Please log in to view your cart</h2>
                    <button onclick="window.location.href='<%= request.getContextPath() %>/Landing/login'" class="px-4 py-2 rounded-full bg-darkYellow text-white hover:bg-yellow-600 transition">
                        Log In
                    </button>
                `;
                return; // 🔥 Stop here, don't continue to AJAX
            }

            $.ajax({
                url: '<%= request.getContextPath() %>/Cart/getCartItems',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    userId: <%= sessionHelper.getUserSession().getId() %> // Replace with actual user ID with session data
                }), 
                success: function (response) {
                    const isMobile = window.innerWidth < 768;
                    const cartContainer = isMobile 
                        ? document.getElementById('mobile-cart-items')
                        : document.getElementById('cart-popup-items');
                    let html = '';

                    // If response.data is a string, parse it
                    const innerData = typeof response.data === 'string'
                        ? JSON.parse(response.data)
                        : response.data;

                    if (innerData.cart_items && Array.isArray(innerData.cart_items) && innerData.cart_items.length > 0) {
                        innerData.cart_items.forEach(item => {
                            const variationStr = JSON.stringify(item.selected_variation).replace(/"/g, '&quot;');
                            const variation = JSON.parse(item.selected_variation || '{}');
                            const variationText = Object.entries(variation).map(function(pair) {
                                return pair[0] + ": " + pair[1];
                            }).join(', ');
                            console.log("product name: ", item.product_name);
                            console.log("product img: ", item.product_img);
                            console.log("product category: ", item.product_category);
                            console.log("product price: RM", item.product_price);
                            console.log("product quantity: ", item.quantity);
                            cartContainer.className = "flex flex-col justify-start items-stretch h-full w-full overflow-y-auto";


                            html += 
                            
                                `
                                
                                <div id="cart-item" class="flex gap-4 prod-row p-6">
                                    <div class="w-[60px] h-[60px] md:w-[30px] md:h-[30px]">
                                        <img src="<%= request.getContextPath()%>/File/Content/product/retrieve?id=` + item.product_img_id + `" 
                                            alt="product-img" 
                                            class="w-full h-full rounded-[6px] object-cover border border-grey2 box-border"/>
                                    </div>

                                    <div class="flex flex-col gap-3 w-full">
                                        <div class="flex justify-between gap-3">
                                        <div class="flex flex-col gap-0.5 w-full">
                                            <h1 class="text-lg md:text-sm font-normal text-black" id="cart-product-name">` + item.product_name + `</h1>
                                            <p class="text-sm md:text-xs font-normal text-grey4 italic" id="cart-product-category">` + item.product_category + `</p>
                                            <p class="text-sm md:text-xs font-normal text-grey4 italic" id="cart-product-variation">` + variationText + `</p>
                                        </div>
                                        <div class="hover:text-red2 cursor-pointer transition-colors ease-in-out duration-300" id="cart-item-delete" onClick="deleteCartItem(`+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`)">
                                            <i class="fa-solid fa-trash text-2xl md:text-base"></i>
                                        </div>
                                        </div>

                                        <div class="flex justify-between items-center gap-2">
                                        <p class="text-xl md:text-sm font-semibold italic" id="cart-item-price">RM ` + item.product_price.toFixed(2) + `</p>

                                        <div class="flex items-center h-[40px] md:h-[26px] bg-white">
                                            <!-- Decrease Button -->
                                            <button onClick="updateQty(this, `+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`, -1)"
                                                    id="decrease-btn" type="button"
                                                    class="min-w-[40px] md:min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-l-full hover:bg-gray-200">
                                            <span>-</span>
                                            </button>

                                            <!-- Value Display -->
                                            <div id="quantity-value"
                                                class="min-w-[40px] md:min-w-[33px] h-full flex items-center justify-center border-y-2 border-gray2 text-lg text-center">
                                            <span class="quantity">` + item.quantity + `</span>
                                            </div>

                                            <!-- Increase Button -->
                                            <button onClick="updateQty(this, `+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`, +1)"
                                                    id="increase-btn" type="button"
                                                    class="min-w-[40px] md:min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-r-full hover:bg-gray-200">
                                            <span>+</span>
                                            </button>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                            `;



                        });
                        // Update the cart container with the generated HTML
                        cartContainer.innerHTML = html;
                        // ✅ Trigger event for cart page sync
                        const event = new CustomEvent('cart:changed');
                        window.dispatchEvent(event);
                    } else {
                        html = `
                            <div class="flex flex-col justify-center items-center gap-4 w-full h-full">
                                <img src="<%= request.getContextPath() %>/Content/assets/image/empty-cart.png"
                                    alt="empty-cart"
                                    class="w-[150px] h-[150px] object-cover" />
                                <p class="text-gray-500 font-dmSans">Your cart is empty.</p>
                                <button onclick="window.location.href='<%= request.getContextPath() %>/product/productCatalog'" class="px-4 py-2 rounded-full bg-darkYellow text-white hover:bg-yellow-600 transition">
                                    Shop Now
                                </button>
                            </div>
                        `;

                        cartContainer.className = "flex flex-col justify-start items-stretch h-full w-full overflow-y-auto";
                        cartContainer.innerHTML = html;
                    }
                },
                error: function (error) {
                    console.error('Error fetching cart items:', error);
                }
            });
        }

        function updateQty(btn, cartId, productId, variation, delta) {
            const row = btn.closest('.prod-row');
            const qtyEl = row.querySelector('.quantity');
            const oldQty = parseInt(qtyEl.textContent);

            $.ajax({
                url: '<%= request.getContextPath() %>/Cart/updateQuantity',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    cartId: cartId,
                    productId: productId,
                    selectedVariation: variation,
                    delta: delta
                }),
                success: function(response) {
                    const parsedJson = JSON.parse(response.data);
                    if(parsedJson.update_success){
                        Swal.fire({
                            icon: 'success',
                            title: 'Quantity updated',
                            showConfirmButton: false,
                            timer: 700
                        });
                        qtyEl.textContent = parsedJson.quantity; 
                        if ($('.product-row').length) {
                            const cartRow = $('.product-row[data-cart-id="' + cartId + '"][data-product-id="' + productId + '"]');
                            if (cartRow.length > 0) {
                                cartRow.find('.qty').text(parsedJson.quantity);
                            }
                        }
                        const event = new CustomEvent('cart:changed');
                        window.dispatchEvent(event);
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error updating quantity',
                            text: 'Please try again later.' + parsedJson.error_msg,
                            showConfirmButton: true
                        });
                        qtyEl.textContent = oldQty; // Revert to old quantity on error
                    }
                },
                error: function(xhr, status, error) {
                    qtyEl.textContent = oldQty; // Revert to old quantity on error
                    console.error('Error updating quantity:', error);
                }
            }); 
            

            
        }

        // Function to delete cart item
        function deleteCartItem(cartId, productId, variation) {
            console.log("variation", variation);
            $.ajax({
                url: '<%= request.getContextPath() %>/Cart/removeCartItemById',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    cartId: cartId,
                    productId: productId,
                    selectedVariation: variation
                }),
                success: function (response) {
                    const parsedJson = JSON.parse(response.data);
                    if(parsedJson.remove_success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Item removed from cart',
                            showConfirmButton: false,
                            timer: 700
                        });
                        setTimeout(fetchCartItems, 300);
                        if ($('.product-row').length) {
                            const cartRow = $('.product-row[data-cart-id="' + cartId + '"][data-product-id="' + productId + '"]');
                            if (cartRow.length > 0) {
                                cartRow.remove();
                                const event = new CustomEvent('cart:changed');
                                window.dispatchEvent(event);
                            }
                        }
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error removing item',
                            text: 'Please try again later.' + parsedJson.error_msg,
                            showConfirmButton: true
                        });
                    }
                },
                error: function (error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error removing item',
                        text: 'Please try again later.',
                        showConfirmButton: true
                    });
                }
            });
        }

        function goToCart() {

            const isAuthenticated = <%= sessionHelper.isAuthenticated() %>;
            if (isAuthenticated) {
                window.location.href = '<%= request.getContextPath() %>/Cart/cart';
            } else {
                Swal.fire({
                    icon: 'info',
                    title: 'Please log in to view your cart.',
                    showCancelButton: true,
                    confirmButtonText: 'Log In',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '<%= request.getContextPath() %>/Landing/login'; // Adjust to your actual login URL
                    }
                    // If canceled, do nothing
                });
            }
        }

        function goToNotification() {
            const isAuthenticated = <%= sessionHelper.isAuthenticated() %>;
            console.log("isAuthenticated", isAuthenticated);
            if (isAuthenticated) {
                redirectUrl('<%= request.getContextPath() %>/User/account#notifications');
            } else {
                Swal.fire({
                    icon: 'info',
                    title: 'Please log in to view your notifications.',
                    showCancelButton: true,
                    confirmButtonText: 'Log In',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        redirectUrl('<%= request.getContextPath() %>/Landing/login'); 
                    }
                });
            }
        }

        function logout() {

            
            const logoutForm = document.getElementById('logoutForm');
            Swal.fire({
                title: "Are you sure?",
                text: "You will be signed out of your account.",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6", // Blue button
                cancelButtonColor: "#d33",     // Red button
                confirmButtonText: "Yes, sign me out",
                cancelButtonText: "Cancel"
            }).then((result) => {
                if (result.isConfirmed) {
                    logoutForm.submit();
                }
            });

        }

        function redirectUrl(url) {
            window.location.href = url;
        }

        function hideCartOnCheckout() {
            const currentUrl = window.location.href;
            if (currentUrl.includes("checkout")) {
                const cartButton = document.getElementById('cart-button');
                if (cartButton) {
                    cartButton.style.display = 'none'; // Hides the cart button
                }
                const mobileCartButton = document.getElementById('cart-toggle');
                if (mobileCartButton) {
                    mobileCartButton.style.display = 'none'; // Hides the cart button
                }
            }
        }

        function handleResponsiveModals() {
            const isMobile = window.innerWidth < 768;

            if (wasMobile && !isMobile) {
                // 🔵 MOBILE -> DESKTOP transition

                // Close mobile-cart-modal and trigger desktop cart-button
                if (!$('#mobile-cart-modal').hasClass('hidden')) {
                    $('#mobile-cart-modal').addClass('hidden');
                    gsap.set('#mobile-cart-modal', {opacity: 0});
                    $('#cart-button').trigger('click');
                }

                // Close mobile-user-modal and trigger desktop user-button
                if (!$('#mobile-user-modal').hasClass('hidden')) {
                    $('#mobile-user-modal').addClass('hidden');
                    gsap.set('#mobile-user-modal', {opacity: 0});
                    $('#user-button').trigger('click');
                }

                // Close mobile-nav-modal only
                if (!$('#mobile-nav-modal').hasClass('hidden')) {
                    $('#mobile-nav-modal').addClass('hidden');
                    gsap.set('#mobile-nav-modal', {opacity: 0});
                }
            } 
            else if (!wasMobile && isMobile) {
                // 🔴 DESKTOP -> MOBILE transition

                // Close desktop cart-popup if open
                if (!$('.prod-row').length && !$('#cart-popup').hasClass('hidden')) {
                    $('#cart-popup').addClass('hidden');
                    gsap.set('#cart-popup', {opacity: 0});
                    // Optional: open mobile cart modal if user was interacting

                }

                // Close desktop user-menu if open
                if (!$('#user-menu').hasClass('hidden')) {
                    $('#user-menu').addClass('hidden');
                    gsap.set('#user-menu', {opacity: 0});
                    // Optional: open mobile user modal if user was interacting
                }
            }

            wasMobile = isMobile; // update last known state
        }

        $(window).on('resize', function () {
            handleResponsiveModals();
        });

        $(document).ready(function() {
            hideCartOnCheckout();

            $('#nav-toggle').on('click', function() {
                $('#mobile-nav-modal').removeClass('hidden');
                gsap.fromTo('#mobile-nav-modal', {opacity: 0}, {opacity: 1, duration: 0.3});
            });

            $('#close-mobile-nav').on('click', function() {
                gsap.to('#mobile-nav-modal', {opacity: 0, duration: 0.3, onComplete: function() {
                    $('#mobile-nav-modal').addClass('hidden');
                }});
            });

            $('#user-toggle').on('click', function() {
                $('#mobile-user-modal').removeClass('hidden');
                gsap.fromTo('#mobile-user-modal', {opacity: 0}, {opacity: 1, duration: 0.3});
            });

            $('#close-mobile-user').on('click', function() {
                gsap.to('#mobile-user-modal', {opacity: 0, duration: 0.3, onComplete: function() {
                    $('#mobile-user-modal').addClass('hidden');
                }});
            });

            $('#cart-toggle').on('click', function() {
                $('#mobile-cart-modal').removeClass('hidden');
                gsap.fromTo('#mobile-cart-modal', {opacity: 0}, {opacity: 1, duration: 0.3});
                fetchCartItems(); // Fetch cart items when the modal is opened
            });

            $('#close-mobile-cart').on('click', function() {
                gsap.to('#mobile-cart-modal', {opacity: 0, duration: 0.3, onComplete: function() {
                    $('#mobile-cart-modal').addClass('hidden');
                }});
            });

            const $cartButton = $('#cart-button');
            const $cartPopup = $('#cart-popup');
            const $cartRefresh = $('#cart-refresh');
            const $mobileCartRefresh = $('#mobile-cart-refresh');

            let isCartPopupVisible = false;

            $cartButton.on('click', function (e) {
                e.stopPropagation(); // Prevent the event from bubbling up to the document
                
                // Close user menu if it's open
                if (isUserMenuVisible) {
                    gsap.to($userMenu, {
                        duration: 0.2,
                        y: 10,
                        autoAlpha: 0,
                        ease: 'power2.in',
                        onComplete: function () {
                            $userMenu.addClass('hidden');
                            isUserMenuVisible = false;
                        }
                    });
                }

                if (!isCartPopupVisible) {
                    setTimeout(function() {
                        $cartPopup.removeClass('hidden');
                        gsap.fromTo($cartPopup[0],
                            { y: 10, autoAlpha: 0 },
                            {
                                y: 0,
                                autoAlpha: 1,
                                duration: 0.2,
                                ease: 'power2.out'
                            }
                        );
                        fetchCartItems(); // Fetch cart items when the popup is shown
                    }, 100); // Delay the popup display by 100ms
                    
                    isCartPopupVisible = true;
                } else {
                    gsap.to($cartPopup[0], {
                        y: 10,
                        autoAlpha: 0,
                        duration: 0.2,
                        ease: 'power2.in',
                        onComplete: function () {
                            $cartPopup.addClass('hidden');
                            isCartPopupVisible = false;
                        }
                    });
                    isCartPopupVisible = false;
                }
            });

            $cartRefresh.on('click', function (e) {
                e.stopPropagation(); // Prevent the event from bubbling up to the document
                fetchCartItems();
            });

            $mobileCartRefresh.on('click', function (e) {
                e.stopPropagation(); // Prevent the event from bubbling up to the document
                fetchCartItems();
            });


            const $userButton = $('#user-button');
            const $userMenu = $('#user-menu');
            let isUserMenuVisible = false;

            $userButton.on('click', function (e) {
                e.stopPropagation();

                // Close cart popup if it's open
                if (isCartPopupVisible) {
                    gsap.to($cartPopup, {
                        duration: 0.2,
                        y: 10,
                        autoAlpha: 0,
                        ease: 'power2.in',
                        onComplete: function () {
                            $cartPopup.addClass('hidden');
                            isCartPopupVisible = false;
                        }
                    });
                }

                if (!isUserMenuVisible) {
                    $userMenu.removeClass('hidden');
                    gsap.fromTo($userMenu[0],
                        { y: 10, autoAlpha: 0 },
                        {
                            y: 0,
                            autoAlpha: 1,
                            duration: 0.2,
                            ease: 'power2.out'
                        }
                    );
                    isUserMenuVisible = true;
                } else {
                    gsap.to($userMenu[0], {
                        y: 10,
                        autoAlpha: 0,
                        duration: 0.2,
                        ease: 'power2.in',
                        onComplete: function () {
                            $userMenu.addClass('hidden');
                            isUserMenuVisible = false;
                        }
                    });
                }
            });

            // Hide when clicking outside
            $(document).on('click', function (e) {
                if (isCartPopupVisible && !$cartPopup.is(e.target) && $cartPopup.has(e.target).length === 0 && !$cartButton.is(e.target) && $cartButton.has(e.target).length === 0) {
                    gsap.to($cartPopup, {
                        duration: 0.2,
                        autoAlpha: 0,
                        ease: 'power2.in',
                        onComplete: function () {
                            $cartPopup.addClass('hidden');
                            isCartPopupVisible = false;
                        }
                    });
                }
                if (isUserMenuVisible &&
                    !$userMenu.is(e.target) &&
                    $userMenu.has(e.target).length === 0 &&
                    !$userButton.is(e.target) &&
                    $userButton.has(e.target).length === 0) {
                    
                    gsap.to($userMenu, {
                        duration: 0.2,
                        autoAlpha: 0,
                        ease: 'power2.in',
                        onComplete: function () {
                            $userMenu.addClass('hidden');
                            isUserMenuVisible = false;
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>