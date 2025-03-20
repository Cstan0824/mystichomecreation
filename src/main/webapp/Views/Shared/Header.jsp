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
</head>
<body class="font-poppins overflow-x-hidden">
    <!-- Header -->
    <div class="flex max-w-vw w-full p-4 items-center sticky top-0 z-[1000] bg-white" id="nav-bar">

        <!--logo-->
        <div class="basis-1/5 flex justify-center w-full">
            <img src="https://placehold.co/50x50/png" class="object-cover rounded-full" alt="logo">
        </div>

        <!--nav-->
        <div class="basis-3/5">
            <ul class="flex justify-center gap-2 text-xl">
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Home</a>
                </li>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="index.html" class="    -semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Home</a>
                </li>
                <li class="hover:bg-gray-50 rounded-full px-2 transition-all duration-[500] ease-in-out">
                    <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Home</a>
                </li>
            </ul>
        </div>

        <!--user and cart-->
        <div class="basis-1/5">
            <ul class="flex justify-center items-center gap-4">
                <li>
                    <div class="w-fit h-5 py-4 px-2 flex justify-between items-center hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="cart-button">
                        <i class="fa-solid fa-cart-shopping fa-lg"></i>
                    </div>
                    <!--Popover Cart-->
                    <div class="hidden absolute opacity-0 min-w-[330px] min-h-[550px] max-w-[330px] max-h-[630px] bg-white border-full rounded-md mhc-box-shadow z-[1000]" id="cart-popup">
                        <div class="flex flex-col">
                            <div class="flex justify-between items-center p-4 pb-2">
                                <h1 class="text-lg font-semibold font-poppins">Your Cart</h1>
                                <a href="#" class="text-sm font-semibold text-darkYellow underline">View All</a>
                            </div>
    
                            <div id="cart-item" class="px-6 py-4 flex gap-2">
                                <div class="w-full h-full max-w-[26px] max-h-[26px] lg:max-w-[30px] lg:max-h-[30px]">
                                    <img src=https://placehold.co/26x26/png alt="product-img" class="w-[26px] h-[26px] lg:w-[30px] lg:h-[30px] rounded-[6px] object-cover border border-grey2 box-border"/>
                                </div>
                                <div class="w-full flex flex-col gap-3">
                                    <div class="w-full flex justify-between gap-3">
                                        <div class="w-full flex flex-col gap-0.5">
                                            <h1 class="text-sm font-normal text-black">Product Name</h1>
                                            <p class="text-xs font-normal text-grey4 italic">Category</p>
                                        </div>
                                        <div class="flex justify-between items-start hover:text-red2 cursor-pointer transition-colors ease-in-out duration-300"> 
                                            <i class="fa-solid fa-trash"></i>
                                        </div>
                                    </div>
                                    <div class="w-full flex gap-1.5 items-center flex-wrap text-xs font-semibold">
                                        <select id="variants" name="variants" class="text-xs font-poppins border bg-grey2 border-grey1 rounded p-1">
                                            <option value="variant1">Variant 1</option>
                                            <option value="variant2">Variant 2</option>
                                            <option value="variant3">Variant 3</option>
                                        </select>
                                        <select id="variants" name="variants" class="text-xs font-poppins border bg-grey2 border-grey1 rounded p-1">
                                            <option value="variant1">Variant 1</option>
                                            <option value="variant2">Variant 2</option>
                                            <option value="variant3">Variant 3</option>
                                        </select>
                                    </div>
                                    <div class="flex justify-between items-center gap-2">
    
                                        <p class="font-semibold text-sm italic py-1">RM 88.00</p>
    
                                        <div class="flex items-center h-[26px] bg-white">
                                            <!-- Decrease Button -->
                                            <button id="decrease-btn" type="button" 
                                                class="min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-l-full hover:bg-gray-200 px-2">
                                                <span>-</span>
                                            </button>
                                    
                                            <!-- Value Display -->
                                            <div id="quantity-value" 
                                                class="min-w-[33px] h-full flex items-center justify-center border-y-2 border-gray2 border-gray2 text-lg text-center px-2">
                                                <span>1</span>
                                            </div>
                                    
                                            <!-- Increase Button -->
                                            <button id="decrease-btn" type="button" 
                                                class="min-w-[26px] h-full flex items-center justify-center border-2 border-gray2 text-black text-lg rounded-r-full hover:bg-gray-200 px-2">
                                                <span>+</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="w-20 h-5 border border-gray-200 rounded-full py-4 px-2 flex justify-between items-center hover:mhc-box-shadow text-black hover:text-darkYellow cursor-pointer transition-colors ease-in-out duration-300 relative" id="user-button">
                        <i class="fa-solid fa-bars fa-lg"></i>
                        <i class="fa-solid fa-user fa-lg"></i>
                    </div>
                    <!-- Popover User Menu -->
                    <div class="hidden absolute min-w-40 w-fit z-[1000] bg-white border border-gray-200 rounded-md mhc-box-shadow opacity-0" id="user-menu">
                        <ul class="flex flex-col gap-2 p-2">
                            <li class="hover:bg-gray-50 rounded-full px-2 py-1 transition-all duration-[500] ease-in-out">
                                <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Profile</a>
                            </li>
                            <li class="hover:bg-gray-50 rounded-full px-2 py-1 transition-all duration-[500] ease-in-out">
                                <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Settings</a>
                            </li>
                            <li class="hover:bg-gray-50 rounded-full px-2 py-1 transition-all duration-[500] ease-in-out">
                                <a href="#" class="font-semibold hover:font-normal hover:text-darkYellow transition-all duration-[500] ease-in-out">Logout</a>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>

    </div>

    <!-- Content -->
    
    <script>
        $(document).ready(function() {
          $('#user-button').click(function() {
            var buttonOffset = $(this).offset(); // Get button position
            var buttonWidth = $(this).outerWidth(); // Get button width
            var buttonHeight = $(this).outerHeight(); // Get button height
            var menu = $('#user-menu'); // Popover menu
  
            // If menu is hidden, show it
            if (menu.hasClass('hidden')) {
              menu.removeClass('hidden');
              
              // Position the menu (Align end with button end)
              var menuWidth = menu.outerWidth();
              var leftPosition = buttonOffset.left + buttonWidth - menuWidth;
  
              menu.css({
                top: buttonOffset.top + buttonHeight + 10, // Position below the button
                left: leftPosition + 'px' // Align right side of menu with button
              });
  
              // Animate with GSAP (fade and slide-in effect)
              gsap.fromTo(menu, 
                { opacity: 0, y: -10 }, 
                { opacity: 1, y: 0, duration: 0.15, ease: "power2.out" }
              );
            } else {
              // Animate close
              gsap.to(menu, { opacity: 0, y: -10, duration: 0.15, ease: "power2.in", onComplete: () => menu.addClass('hidden') });
            }
          });

          $('#cart-button').click(function() {
            var buttonOffset = $(this).offset(); // Get button position
            var buttonWidth = $(this).outerWidth(); // Get button width
            var buttonHeight = $(this).outerHeight(); // Get button height
            var menu = $('#cart-popup'); // Popover menu
  
            // If menu is hidden, show it
            if (menu.hasClass('hidden')) {
              menu.removeClass('hidden');
              
              // Position the menu (Align end with button end)
              var menuWidth = menu.outerWidth();
              var leftPosition = buttonOffset.left + buttonWidth - menuWidth;
  
              menu.css({
                top: buttonOffset.top + buttonHeight + 10, // Position below the button
                left: leftPosition + 'px' // Align right side of menu with button
              });
  
              // Animate with GSAP (fade and slide-in effect)
              gsap.fromTo(menu, 
                { opacity: 0, y: -10 }, 
                { opacity: 1, y: 0, duration: 0.15, ease: "power2.out" }
              );
            } else {
              // Animate close
              gsap.to(menu, { opacity: 0, y: -10, duration: 0.15, ease: "power2.in", onComplete: () => menu.addClass('hidden') });
            }
          });
  
          // Close the popover when clicking anywhere outside
          $(document).click(function(event) {
            if (!$(event.target).closest('#user-button, #user-menu').length) {
              var menu = $('#user-menu');
              if (!menu.hasClass('hidden')) {
                gsap.to(menu, { opacity: 0, y: -10, duration: 0.3, ease: "power2.in", onComplete: () => menu.addClass('hidden') });
              }
            }
            if (!$(event.target).closest('#cart-button, #cart-popup').length) {
              var menu = $('#cart-popup');
              if (!menu.hasClass('hidden')) {
                gsap.to(menu, { opacity: 0, y: -10, duration: 0.3, ease: "power2.in", onComplete: () => menu.addClass('hidden') });
              }
            }
          });
        });
    </script>
</body>
</html>