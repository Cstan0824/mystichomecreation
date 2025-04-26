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
        <div class="basis-1/5 flex justify-center w-full">
            <img src="<%= request.getContextPath()%>/Content/assets/image/MystichomeCreationLogo.jpg" onClick="redirectUrl('<%= request.getContextPath()%>/Landing')" class="w-[50px] h-[50px] object-cover rounded-full" alt="logo">
        </div>

        <!--nav-->
        <div class="basis-3/5">
            <ul class="flex justify-center gap-2 text-xl">
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="<%= request.getContextPath() %>/product/productCatalog" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Products</a>
                </li>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="<%= request.getContextPath() %>/Landing" class="hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Home</a>
                </li>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Home</a>
                </li>
            </ul>
        </div>

        <!--user and cart-->
        <div class="basis-1/5">
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

                                <div id="cart-items" class="flex flex-col justify-center items-center h-full"></div>



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
                                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer " onClick="redirectUrl('<%= request.getContextPath() %>/User/account#notifications')">
                                        <p class="font-semibold transition-all duration-[500] ease-in-out">Purchases</p>
                                    </li>
                                    <li class="hover:bg-gray-50 rounded-full hover:font-normal hover:text-darkYellow px-2 py-1 transition-all duration-[500] ease-in-out cursor-pointer" onClick="redirectUrl('<%= request.getContextPath() %>/User/account#notifications')">
                                        <a href="#" class="font-semibold transition-all duration-[500] ease-in-out">Logout</a>
                                    </li>
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

    <!-- Content -->
    <script>
        function fetchCartItems() {
            const isAuthenticated = <%= sessionHelper.isAuthenticated() %>;

            if (!isAuthenticated) {
                const cartContainer = document.getElementById('cart-items');
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
                    const cartContainer = document.getElementById('cart-items');
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
                                
                                <div id="cart-item" class="px-6 py-4 flex gap-2 prod-row">
                                        <div class="w-full h-full max-w-[26px] max-h-[26px] lg:max-w-[30px] lg:max-h-[30px]">
                                            <img src="<%= request.getContextPath()%>/File/Content/product/retrieve?id=` + item.product_img_id + `" alt="product-img" class="w-[26px] h-[26px] lg:w-[30px] lg:h-[30px] rounded-[6px] object-cover border border-grey2 box-border"/>
                                        </div>
                                        <div class="w-full flex flex-col gap-3">
                                            <div class="w-full flex justify-between gap-3">
                                                <div class="w-full flex flex-col gap-0.5">
                                                    <h1 class="text-sm font-normal text-black" id="cart-product-name">`+ item.product_name +`</h1>
                                                    <p class="text-xs font-normal text-grey4 italic" id="cart-product-category">`+ item.product_category +`</p>
                                                    <p class="text-xs font-normal text-grey4 italic" id="cart-product-variation">`+ variationText +`</p>
                                                </div>
                                                <div class="flex justify-between items-start hover:text-red2 cursor-pointer transition-colors ease-in-out duration-300" id="cart-item-delete" onClick="deleteCartItem(`+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`)"> 
                                                    <i class="fa-solid fa-trash"></i>
                                                </div>
                                            </div>
                                            
                                            <div class="flex justify-between items-center gap-2">
            
                                                <p class="font-semibold text-sm italic py-1" id="cart-item-price">RM `+ item.product_price.toFixed(2) +`</p>
            
                                                <div class="flex items-center h-[26px] bg-white">
                                                    <!-- Decrease Button -->
                                                    <button 
                                                        onClick="updateQty(this, `+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`, -1)"
                                                        id="decrease-btn" type="button" 
                                                        class="min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-l-full hover:bg-gray-200 px-2">
                                                        <span>-</span>
                                                    </button>
                                            
                                                    <!-- Value Display -->
                                                    <div id="quantity-value" 
                                                        class="min-w-[33px] h-full flex items-center justify-center border-y-2 border-gray2 border-gray2 text-lg text-center px-2">
                                                        <span class="quantity">`+ item.quantity +`</span>
                                                    </div>
                                            
                                                    <!-- Increase Button -->
                                                    <button 
                                                        onClick="updateQty(this, `+ item.cart_id +`, `+ item.product_id +`, `+ variationStr +`, +1)"
                                                        id="increase-btn" type="button" 
                                                        class="min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-r-full hover:bg-gray-200 px-2">
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
                            const event = new CustomEvent('cart:changed');
                            window.dispatchEvent(event);
                        }
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

        function redirectUrl(url) {
            window.location.href = url;
        }

        $(document).ready(function() {
          

            const $cartButton = $('#cart-button');
            const $cartPopup = $('#cart-popup');
            const $cartRefresh = $('#cart-refresh');

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