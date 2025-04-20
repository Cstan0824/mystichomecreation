<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>Checkout</title>
</head>
<%@ page import="java.util.List" %>
<%@ page import="Models.Users.CartItem" %>
<%@ page import="Models.Accounts.ShippingInformation" %>
<%@ page import="mvc.Helpers.Helpers" %>
<body x-data="{ showAddCardModal: false }" class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
<%@ include file="/Views/Shared/Header.jsp" %>

    <% 
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        ShippingInformation shippingInfo = (ShippingInformation) request.getAttribute("shippingAddress");
        out.println(cartItems);
        out.println(shippingInfo);
    %>

    <div class="content-wrapper">

        <h1 class="font-poppins font-bold text-3xl my-8">Cart</h1>

        <div class="flex gap-8 items-start">


            <!-- Select Voucher -->
            <div class="basis-2/3 flex flex-col gap-6">

                <!-- Select Voucher -->
                <div class="flex flex-col gap-4 p-8 border border-grey3 w-full" x-data="{ showVouchers: true }">
                    <p class="font-bold text-lg font-poppins mb-4">Select Voucher</p>
                
                    <!-- Toggle Button -->
                    <div @click="showVouchers = !showVouchers"
                         class="flex justify-between items-center bg-grey2 rounded-lg p-4 cursor-pointer hover:bg-grey3 transition">
                        <p class="text-sm font-medium text-black">Available Vouchers</p>
                        <i :class="showVouchers ? 'fa-solid fa-chevron-up' : 'fa-solid fa-chevron-down'"
                           class="text-darkYellow transition-all duration-300"></i>
                    </div>
                
                    <!-- Voucher List (toggle display) -->
                    <div x-show="showVouchers" x-transition class="flex flex-col gap-2 mt-2">
                        <!-- Repeat this block per voucher -->
                        <div class="border border-grey3 rounded-md cursor-pointer selectable-voucher hover:text-darkYellow hover:border-darkYellow select-none" data-voucher-id="1">
                            <div class="flex voucher-info">
                                <!-- Left - Voucher Icon -->
                                <div class="basis-1/4 flex flex-col justify-center items-center gap-2 bg-lightMidYellow p-4 overflow-hidden font-poppins">
                                    <div class="aspect-square max-w-[100px] w-full flex flex-col justify-center items-center text-darkYellow bg-white rounded-full border-4 border-darkYellow m-2 p-4 overflow-hidden text-center">
                                        <i class="fa-solid fa-ticket fa-2xl"></i>
                                    </div>
                                    <p class="text-sm font-semibold text-darkYellow text-center break-words leading-tight line-clamp-2">voucher.voucher_name</p>
                                </div>
                
                                <!-- Right - Voucher Details -->
                                <div class="basis-3/4 flex flex-col p-4 justify-between">
                                    <div class="flex flex-col">
                                        <p class="text-base font-semibold text-black">Title</p>
                                        <p class="text-sm text-grey5">Min. spend RM 100.00</p>
                                        <p class="text-sm text-grey4 line-clamp-2">voucher.voucher_desc</p>
                                    </div>
                                    <p class="text-xs text-grey4 mt-2">Remaining: voucher.voucher_usage_left / voucher.voucher_usage_limit</p>
                                </div>
                            </div>
                        </div>
                        <div class="border border-grey3 rounded-md cursor-pointer selectable-voucher hover:text-darkYellow hover:border-darkYellow select-none" data-voucher-id="1">
                            <div class="flex voucher-info">
                                <!-- Left - Voucher Icon -->
                                <div class="basis-1/4 flex flex-col justify-center items-center gap-2 bg-lightMidYellow p-4 overflow-hidden font-poppins">
                                    <div class="aspect-square max-w-[100px] w-full flex flex-col justify-center items-center text-darkYellow bg-white rounded-full border-4 border-darkYellow m-2 p-4 overflow-hidden text-center">
                                        <i class="fa-solid fa-ticket fa-2xl"></i>
                                    </div>
                                    <p class="text-sm font-semibold text-darkYellow text-center break-words leading-tight line-clamp-2">voucher.voucher_name</p>
                                </div>
                
                                <!-- Right - Voucher Details -->
                                <div class="basis-3/4 flex flex-col p-4 justify-between">
                                    <div class="flex flex-col">
                                        <p class="text-base font-semibold text-black">Title</p>
                                        <p class="text-sm text-grey5">Min. spend RM 100.00</p>
                                        <p class="text-sm text-grey4 line-clamp-2">voucher.voucher_desc</p>
                                    </div>
                                    <p class="text-xs text-grey4 mt-2">Remaining: voucher.voucher_usage_left / voucher.voucher_usage_limit</p>
                                </div>
                            </div>
                        </div>
                        <div class="border border-grey3 rounded-md cursor-pointer selectable-voucher hover:text-darkYellow hover:border-darkYellow select-none" data-voucher-id="1">
                            <div class="flex voucher-info ">
                                <!-- Left - Voucher Icon -->
                                <div class="basis-1/4 flex flex-col justify-center items-center gap-2 bg-lightMidYellow p-4 overflow-hidden font-poppins ">
                                    <div class="aspect-square max-w-[100px] w-full flex flex-col justify-center items-center text-darkYellow bg-white rounded-full border-4 border-darkYellow m-2 p-4 overflow-hidden text-center">
                                        <i class="fa-solid fa-ticket fa-2xl"></i>
                                    </div>
                                    <p class="text-sm font-semibold text-darkYellow text-center break-words leading-tight line-clamp-2">voucher.voucher_name</p>
                                </div>
                
                                <!-- Right - Voucher Details -->
                                <div class="basis-3/4 flex flex-col p-4 justify-between ">
                                    <div class="flex flex-col">
                                        <p class="text-base font-semibold text-black">Title</p>
                                        <p class="text-sm text-grey5">Min. spend RM 100.00</p>
                                        <p class="text-sm text-grey4 line-clamp-2">voucher.voucher_desc</p>
                                    </div>
                                    <p class="text-xs text-grey4 mt-2">Remaining: voucher.voucher_usage_left / voucher.voucher_usage_limit</p>
                                </div>
                            </div>
                        </div>
                
                        <!-- Repeat more voucher blocks as needed... -->
                    </div>
                </div>
                

                <!-- Payment Method -->
                <div class="flex flex-col gap-4 p-8 border border-grey3 w-full" x-data="{ showCardOptions: true }">
                    <p class="font-bold text-lg font-poppins mb-4">Payment Method</p>

                    <div class="flex flex-col gap-2">
                        <!-- COD -->
                        <div class="flex items-center bg-grey2 rounded-lg p-4">
                            <p class="text-sm font-normal text-black">Cash On Delivery</p>
                        </div>

                        <!-- Credit / Debit Card (Toggleable) -->
                        <div @click="showCardOptions = !showCardOptions" 
                            class="flex justify-between items-center bg-grey2 rounded-lg p-4 cursor-pointer hover:bg-grey3 transition">
                            <p class="text-sm font-normal text-black">Credit/Debit Card</p>
                            <i :class="showCardOptions ? 'fa-solid fa-chevron-up' : 'fa-solid fa-chevron-down'" class="text-darkYellow transition-all duration-300"></i>
                        </div>

                        <!-- Hidden Card Options (Slide down) -->
                        <div x-show="showCardOptions" x-transition 
                            class="bg-grey1 rounded-md border border-grey3 p-4 space-y-3 overflow-hidden">

                            <!-- Example Card List -->
                            <div class="flex items-center justify-between p-3 bg-white rounded-md shadow-sm hover:bg-grey2 transition cursor-pointer">
                                <div class="flex flex-col">
                                    <p class="text-sm font-medium text-black">**** **** **** 1234</p>
                                    <p class="text-xs text-grey4">Exp: 12/26 - Visa</p>
                                </div>
                                <i class="fa-regular fa-circle-check fa-lg text-green-500"></i>
                            </div>

                            <div class="flex items-center justify-between p-3 bg-white rounded-md shadow-sm hover:bg-grey2 transition cursor-pointer">
                                <div class="flex flex-col">
                                    <p class="text-sm font-medium text-black">**** **** **** 5678</p>
                                    <p class="text-xs text-grey4">Exp: 03/27 - Mastercard</p>
                                </div>
                                <i class="fa-regular fa-circle-check opacity-0"></i>
                            </div>

                            <button @click="showAddCardModal = true" class="w-full py-2 mt-2 text-sm font-medium text-darkYellow border border-darkYellow rounded-lg hover:bg-darkYellow hover:text-white transition">
                                + Add New Card
                            </button>
                        </div>

                        <!-- Bank Transfer -->
                        <div class="flex items-center bg-grey2 rounded-lg p-4">
                            <p class="text-sm font-normal text-black">Bank Transfer / DuitNow</p>
                        </div>
                    </div>
                </div>


            </div>

            <!-- Cart Items and Totals -->
            <div class="basis-1/3 p-8 border border-grey3 flex flex-col w-full sticky top-[30px]">
                <p class="font-bold text-lg font-poppins mb-4">Order Totals</p>

                <div class="flex flex-col gap-3"> 

                    <div id="cart-item" class="flex gap-2">
                        <!-- Image -->
                        
                        <div class="flex items-center flex-shrink-0">
                            <img src="https://placehold.co/50x50/png" alt="product-img" 
                                class="w-[50px] h-[50px] rounded-[6px] object-cover border border-grey2" />
                        </div>
                        
                        
                    
                        <!-- Details -->
                        <div class="flex flex-col justify-between overflow-hidden w-full">
                            <div class="flex justify-between items-start gap-3">
                                <!-- Text Content -->
                                <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                                    <h1 class="text-sm font-normal text-black truncate">Product Name That Might Be Very Long</h1>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">Size: M, Color: Red</p>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">x 7</p>
                                </div>
                                <!-- Price -->
                                <div class="flex flex-col justify-end items-end flex-shrink-0">
                                    <p class="font-semibold text-sm italic py-1 text-nowrap">RM 88.00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="cart-item" class="flex gap-2">
                        <!-- Image -->
                        <div class="flex items-center flex-shrink-0">
                            <img src="https://placehold.co/50x50/png" alt="product-img" 
                                 class="w-[50px] h-[50px] rounded-[6px] object-cover border border-grey2" />
                        </div>
                    
                        <!-- Details -->
                        <div class="flex flex-col justify-between overflow-hidden w-full">
                            <div class="flex justify-between items-start gap-3">
                                <!-- Text Content -->
                                <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                                    <h1 class="text-sm font-normal text-black truncate">Product Name That Might Be Very Long</h1>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">Size: M, Color: Red</p>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">x 7</p>
                                </div>
                                <!-- Price -->
                                <div class="flex flex-col justify-end items-end flex-shrink-0">
                                    <p class="font-semibold text-sm italic py-1 text-nowrap">RM 88.00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="cart-item" class="flex gap-2">
                        <!-- Image -->
                        <div class="flex items-center flex-shrink-0">
                            <img src="https://placehold.co/50x50/png" alt="product-img" 
                                 class="w-[50px] h-[50px] rounded-[6px] object-cover border border-grey2" />
                        </div>
                    
                        <!-- Details -->
                        <div class="flex flex-col justify-between overflow-hidden w-full">
                            <div class="flex justify-between items-start gap-3">
                                <!-- Text Content -->
                                <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                                    <h1 class="text-sm font-normal text-black truncate">Product Name That Might Be Very Long</h1>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">Size: M, Color: Red</p>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">x 7</p>
                                </div>
                                <!-- Price -->
                                <div class="flex flex-col justify-end items-end flex-shrink-0">
                                    <p class="font-semibold text-sm italic py-1 text-nowrap">RM 88.00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="cart-item" class="flex gap-2">
                        <!-- Image -->
                        <div class="flex items-center flex-shrink-0">
                            <img src="https://placehold.co/50x50/png" alt="product-img" 
                                 class="w-[50px] h-[50px] rounded-[6px] object-cover border border-grey2" />
                        </div>
                    
                        <!-- Details -->
                        <div class="flex flex-col justify-between overflow-hidden w-full">
                            <div class="flex justify-between items-start gap-3">
                                <!-- Text Content -->
                                <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                                    <h1 class="text-sm font-normal text-black truncate">Product Name That Might Be Very Long</h1>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">Size: M, Color: Red</p>
                                    <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">x 7</p>
                                </div>
                                <!-- Price -->
                                <div class="flex flex-col justify-end items-end flex-shrink-0">
                                    <p class="font-semibold text-sm italic py-1 text-nowrap">RM 88.00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                
                
                <div class="flex justify-between text-md font-dmSans py-4">
                    <p class="font-medium">Subtotal</p>
                    <p class="font-normal" id="subtotal">0 item, RM 0.00</p>
                </div>
                <hr>
                <div class="py-4 flex flex-col gap-4">
                  
                    <div class="flex justify-between text-md font-dmSans">
                        <p class="font-medium">Shipping Fee</p>
                        <p class="font-normal" id="shipping-total">RM 0.00</p>
                    </div>
  
                    <div class="flex flex-col gap-1 text-md font-dmSans w-[70%]">
                        <p>Shipping to</p>
                        <div class="flex flex-col justify-center pl-2" id="default-shipping-address">
                            <p class="text-sm font-medium" id="label">label</p>
                            <p class="text-sm" id="receiverName">receiverName</p>
                            <p class="text-sm" id="address1">address1</p>
                            <p class="text-sm" id="address2">address2</p>
                            <p class="text-sm" id="postcodeState">postcode State</p>
                            <p class="text-sm" id="phoneNo">phoneNo</p>
                        </div>
                    </div>
                  
                  
                </div>
                <hr>
                <div class="flex justify-between text-md font-dmSans py-4">
                  <p class="font-medium">Total</p>
                  <p class="font-normal" id="final-total">RM 0.00</p>
                </div>
                
                <div class="flex flex-col gap-2">
                  <button class="bg-black text-white font-bold py-2 px-4 rounded hover:bg-darkYellow transition-colors duration-200 ease-in-out mt-auto">Place Order</button>
                </div>
                
  
            </div>

        </div>


    </div>
    <!-- Add New Card Modal -->
    <div x-show="showAddCardModal" x-transition
        class="fixed inset-0 bg-black bg-opacity-40 z-50 flex items-center justify-center px-4"
        @click.self="showAddCardModal = false">

        <div class="bg-white w-full max-w-md p-6 rounded-lg shadow-lg" @click.stop>
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-lg font-semibold text-black">Add New Card</h2>
            <button @click="showAddCardModal = false">
                <i class="fa-solid fa-xmark text-xl text-grey4 hover:text-darkYellow transition"></i>
            </button>
        </div>

        <!-- Form -->
        <form class="space-y-4">
            <!-- Card Number -->
            <div class="flex flex-col">
                <label for="cardNumber" class="text-sm font-medium text-black">Card Number</label>
                <input type="text" id="cardNumber" name="cardNumber"
                        class="border border-grey3 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-darkYellow" 
                        placeholder="XXXX XXXX XXXX XXXX">
            </div>

            <!-- Bank Type -->
            <div class="flex flex-col">
                <label for="bankType" class="text-sm font-medium text-black">Bank Type</label>
                <select id="bankType" name="bankType"
                        class="border border-grey3 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-darkYellow">
                    <option value="">-- Select Bank --</option>
                    <option value="Maybank">Maybank</option>
                    <option value="Public Bank">Public Bank</option>
                    <option value="CIMB">CIMB</option>
                    <option value="RHB">RHB</option>
                    <option value="HSBC">HSBC</option>
                </select>
            </div>

            <!-- Card Name -->
            <div class="flex flex-col">
                <label for="cardName" class="text-sm font-medium text-black">Card Name</label>
                <input type="text" id="cardName" name="cardName"
                        class="border border-grey3 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-darkYellow" 
                        placeholder="Eg: John Doe - Travel">
            </div>

            <!-- Expiry Date -->
            <div class="flex flex-col">
                <label for="expiryDate" class="text-sm font-medium text-black">Expiry Date</label>
                <input type="date" id="expiryDate" name="expiryDate"
                        class="border border-grey3 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-darkYellow">
            </div>

            <!-- Buttons -->
            <div class="flex justify-end gap-2 pt-4">
                <button type="button" @click="showAddCardModal = false"
                        class="px-4 py-2 text-sm border border-grey3 rounded hover:bg-grey2 transition">
                    Cancel
                </button>
                <button type="submit"
                        class="px-4 py-2 text-sm bg-darkYellow text-white rounded hover:bg-yellow-600 transition">
                    Save Card
                </button>
            </div>
        </form>
        </div>
    </div>

 <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>   
</body>
</html>