<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title>Checkout</title>
</head>

<%@ page import="java.util.List" %>
<%@ page import="Models.Users.CartItem" %>
<%@ page import="Models.Accounts.ShippingInformation" %>
<%@ page import="DTO.VoucherInfoDTO" %>
<%@ page import="Models.Accounts.PaymentCard" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page import="mvc.Helpers.Helpers" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<body x-data="{ showAddCardModal: false }" class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">

<%@ include file="/Views/Shared/Header.jsp" %>

    <% 
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        ShippingInformation shippingInfo = (ShippingInformation) request.getAttribute("shippingAddress");
        List<VoucherInfoDTO> voucherInfoList = (List<VoucherInfoDTO>) request.getAttribute("voucherArray");
        List<PaymentCard> paymentCards = (List<PaymentCard>)request.getAttribute("paymentCards");
        double subtotal = (double) request.getAttribute("subtotal");
        double shippingFee = (double) request.getAttribute("shippingFee");
        int totalItems = (int) request.getAttribute("totalItems");

        double total = subtotal + shippingFee;
    %>

    <div class="content-wrapper">

        <h1 class="font-poppins font-bold text-5xl text-center md:text-left md:text-3xl my-8">Checkout</h1>

        <div class="flex flex-col lg:flex-row gap-8 items-start">


            <!-- Select Voucher & Payment Method -->
            <div class="w-full lg:basis-2/3 flex flex-col gap-6">

                <!-- Select Voucher -->
                <% if (voucherInfoList != null && !voucherInfoList.isEmpty()) { %>
                    
                    <div class="flex flex-col gap-4 p-8 border border-grey3 w-full" x-data="{ showVouchers: true }">
                        <p class="font-bold text-base md:text-lg font-poppins mb-2 md:mb-4">Select Voucher</p>
                    
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

                            <% 
                                for (VoucherInfoDTO voucher : voucherInfoList) {
                            %>
                            <div class="border border-grey3 rounded-md cursor-pointer selectable-voucher hover:text-darkYellow hover:border-darkYellow select-none" data-voucher-id="<%= voucher.getVoucher().getId() %>" data-after-deduction="<%= voucher.getTotalAfterDeduction() %>">

                            
                                <div class="flex voucher-info select-none">
                                    <!-- Left - Voucher Icon -->
                                    <div class="basis-1/4 flex flex-col justify-center items-center gap-2 bg-lightMidYellow p-4 overflow-hidden font-poppins">
                                        <div class="aspect-square max-w-[60px] md:max-w-[100px] w-full flex flex-col justify-center items-center text-darkYellow bg-white rounded-full border-2 md:border-4 border-darkYellow m-1 md:m-2 p-2 md:p-4 overflow-hidden text-center">
                                            <i class="fa-solid fa-ticket text-xl md:text-4xl"></i>
                                        </div>
                                        <p class="text-xs md:text-sm font-semibold text-darkYellow text-center break-words leading-tight line-clamp-2"><%= voucher.getVoucher().getName() %></p>
                                    </div>
                    
                                    <!-- Right - Voucher Details -->
                                    <div class="basis-3/4 flex p-4 justify-between font-dmSans">
                                        <div class="w-[90%] flex flex-col justify-between">
                                            <div class="flex flex-col">
                                                <p class="text-sm md:text-base font-semibold text-black">
                                                
                                                <% if (voucher.getVoucher().getType().equals("percentage")) { %>
                                                    <%= String.format("%.2f", voucher.getVoucher().getAmount()) %>% off
                                                <% } else if (voucher.getVoucher().getType().equals("flat")) { %>
                                                        RM <%= String.format("%.2f", voucher.getVoucher().getAmount()) %> off
                                                <% } %>

                                                Capped at RM 
                                                <%= String.format("%.2f", voucher.getVoucher().getMaxCoverage()) %>
                                                </p>

                                                <p class="text-xs md:text-sm text-grey5">
                                                    Min. spend RM <%= String.format("%.2f", voucher.getVoucher().getMinSpent()) %>
                                                </p>

                                                <p class="text-xs md:text-sm text-grey4 line-clamp-2">
                                                    <%= voucher.getVoucher().getDescription() %>
                                                </p>
                                            </div>
                                            <div class="flex flex-col">
                                                <p class="text-xs md:text-sm text-green-500">
                                                    -RM <%= String.format("%.2f", voucher.getDeduction()) %>
                                                </P>
                                                <p class="text-[10px] md:text-xs text-grey4 mt-2">
                                                    Remaining: 
                                                    <%= voucher.getUsageLeft() %>/<%= voucher.getVoucher().getUsagePerMonth() %>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="w-[10%] flex justify-center items-center voucher-check-icon">
                                            
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                            <% } %>
                    
                            <!-- Repeat more voucher blocks as needed... -->
                        </div>
                    </div>
                
                <% } %>
                

                <!-- Payment Method -->
                <div class="flex flex-col gap-4 p-8 border border-grey3 w-full" x-data="{ showCardOptions: true }">
                    <p class="font-bold text-base md:text-lg font-poppins mb-2 md:mb-4">Payment Method</p>

                    <div class="flex flex-col gap-2">
                        <!-- COD -->
                        <div class="flex items-center bg-grey2 hover:bg-grey3 transition rounded-lg p-4 justify-between cursor-pointer select-none" data-payment-method="3">
                            <p class="text-sm font-normal text-black">Cash On Delivery</p>
                            <div class="cod-check-icon check-icon-container">

                            </div>
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
                            <% if(paymentCards != null && !paymentCards.isEmpty()) {
                                    for(PaymentCard payment : paymentCards) { 
                                        LocalDate today = LocalDate.now();
                                        String expiryStr = payment.getExpiryDate();
                                        LocalDate expiryDate = null;
                                        try {
                                            expiryDate = LocalDate.parse(expiryStr); // assumes yyyy-MM-dd
                                        } catch (DateTimeParseException e) {
                                            
                                        }

                                        if (expiryDate != null && expiryDate.isAfter(today)) { %>
                                    

                                        <div class="card-option flex items-center justify-between p-3 bg-white rounded-md shadow-sm hover:bg-grey2 transition cursor-pointer select-none" data-payment-method="1">
                                            <div class="flex items-center gap-3">
                                                <img src="<%= request.getContextPath() + "/Content" + payment.getBankType().getLogoPath() %>" alt="Bank Logo" class="w-12 h-12 object-contain rounded-full"/>
                                                <div class="flex flex-col">
                                                    <p class="text-sm font-medium text-black cardName"><%= payment.getName() %></p>
                                                    <p class="text-xs text-grey4 cardNumber">
                                                        **** **** **** <%= payment.getCardNumber().substring(12) %>
                                                    </p>
                                                    <p class="text-xs text-grey4 cardExp">Exp: <%= payment.getExpiryDate() %></p>
                                                </div>
                                            </div>
                                            <div class="card-check-icon check-icon-container">

                                            </div>
                                        </div>

                                        <% } %>
                                    <% } %>
                            <% } %>

                            <button class="w-full py-2 mt-2 text-sm font-medium text-darkYellow border border-darkYellow rounded-lg hover:bg-darkYellow hover:text-white transition" onClick=redirectToAddCard()>
                                + Add New Card
                            </button>
                        </div>

                        <!-- Bank Transfer -->
                        <div class="flex items-center bg-grey2 rounded-lg p-4 justify-between cursor-pointer hover:bg-grey3 select-none" data-payment-method="2">
                            <p class="text-sm font-normal text-black">Bank Transfer / DuitNow</p>
                            <div class="bankTransfer-check-icon check-icon-container">

                            </div>
                        </div>
                    </div>
                </div>


            </div>

            <!-- Cart Items and Totals -->
            <div class="w-full lg:basis-1/3 p-8 border border-grey3 flex flex-col sticky md:top-[60px] static">
                <p class="font-bold text-base md:text-lg font-poppins mb-2 md:mb-4">Order Totals</p>

                <!-- Cart Items List -->
                <div class="flex flex-col gap-3 max-h-[260px] overflow-y-auto"> 
                    <% for(CartItem item : cartItems) { %>
                        <div id="cart-item" class="flex gap-2">
                            <!-- Image -->
                            
                            <div class="flex items-center flex-shrink-0">
                                <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= item.getProduct().getImage().getId() %>" alt="product-img" 
                                    class="w-[50px] h-[50px] rounded-[6px] object-cover border border-grey2" />
                            </div>
                            
                            
                        
                            <!-- Details -->
                            <div class="flex flex-col justify-between overflow-hidden w-full">
                                <div class="flex justify-between items-start gap-3">
                                    <!-- Text Content -->
                                    <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                                        <h1 class="text-sm font-normal text-black truncate"><%= item.getProduct().getTitle() %></h1>
                                        <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">
                                            <% String jsonString = item.getSelectedVariation();
                                                if (jsonString != null && !jsonString.isEmpty() && !jsonString.equals("null")) {
                                                %>
                                                    <script>
                                                        try {
                                                            const variation = JSON.parse('<%= StringEscapeUtils.escapeEcmaScript(jsonString) %>');
                                                            const formatted = Object.entries(variation)
                                                                .map(([key, value]) => key + ': ' + value)
                                                                .join(', ');
                                                            document.write(formatted);
                                                        } catch (e) {
                                                            document.write('<%= StringEscapeUtils.escapeHtml4(jsonString) %>');
                                                        }
                                                    </script>
                                            <% } %>
                                        </p>
                                        <p class="text-xs font-normal text-grey4 italic line-clamp-1 truncate">x <%= item.getQuantity() %></p>
                                    </div>
                                    <!-- Price -->
                                    <div class="flex flex-col justify-end items-end flex-shrink-0">
                                        <p class="font-semibold text-sm py-1 text-nowrap">RM <%= String.format("%.2f", item.getProduct().getPrice()) %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>

                </div>
                
                
                <div class="flex justify-between text-md font-dmSans py-4">
                    <p class="font-medium">Subtotal</p>
                    <p class="font-normal" id="subtotal"><%= totalItems %> item<%= totalItems > 1 ? "s" : "" %>, RM <%= String.format("%.2f", subtotal) %></p>
                </div>
                <hr>
                <div class="py-4 flex flex-col gap-4">
                  
                    <div class="flex flex-col text-md font-dmSans">
                        <p class="font-medium">Shipping Fee</p>
                        <div class="flex items-center justify-between text-md font-dmSans">
                            <p class="font-normal text-sm">Free Shipping if exceed RM1000</p>
                            <p class="font-normal" id="shipping-total">RM 0.00</p>
                        </div>
                    </div>
  
                    <div class="flex flex-col gap-1 text-md font-dmSans w-[70%]">
                        <p>Shipping to</p>
                        <div class="flex flex-col justify-center pl-2" id="default-shipping-address">
                            <p class="text-sm font-medium" id="label"><%= shippingInfo.getLabel() %></p>
                            <p class="text-sm" id="receiverName"><%= shippingInfo.getReceiverName() %></p>
                            <p class="text-sm" id="address1"><%= shippingInfo.getAddressLine1() %></p>
                            <p class="text-sm" id="address2"><%= shippingInfo.getAddressLine2() != null ?  shippingInfo.getAddressLine2() : "" %></p>
                            <p class="text-sm" id="postcodeState"><%= shippingInfo.getPostCode() %> <%= shippingInfo.getState() %></p>
                            <p class="text-sm" id="phoneNo"><%= shippingInfo.getPhoneNumber() %></p>
                        </div>
                    </div>
                  
                  
                </div>
                <hr>
                <div class="flex justify-between text-md font-dmSans py-4">
                  <p class="font-medium">Total</p>
                  <p class="font-normal" id="final-total">RM <%= String.format("%.2f", total) %></p>
                </div>
                
                <div class="flex flex-col gap-2">
                  <button class="w-full bg-black text-white text-sm md:text-base font-bold py-2 px-4 rounded hover:bg-darkYellow transition-colors duration-200 ease-in-out mt-auto" onClick="proceedToPayment()">Place Order</button>
                </div>
                
  
            </div>

        </div>


    </div>


    <!-- Proceed Payment Hidden Form -->
    <form id="proceedPaymentForm" action="<%= request.getContextPath() %>/Order/processPayment" method="post" enctype="multipart/form-data">
        <input type="hidden" name="methodId" id="methodId">
        <input type="hidden" name="voucherId" id="voucherId">
        <input type="hidden" name="paymentInfo" id="paymentInfo">
        <input type="hidden" name="shippingInfo" id="shippingInfo">
    </form>

<%@ include file="/Views/Shared/Footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const oldTotal = <%= total %>;
            const voucherElements = document.querySelectorAll('.selectable-voucher');
            const totalDisplay = document.getElementById('final-total');
            let selectedVoucherId = null;

            voucherElements.forEach(voucherEl => {
                voucherEl.addEventListener('click', () => {
                    const isAlreadySelected = voucherEl.classList.contains('selected');

                    // Clear all check icons & remove selected class from all
                    document.querySelectorAll('.voucher-check-icon').forEach(iconContainer => {
                        iconContainer.innerHTML = '';
                    });
                    voucherElements.forEach(el => el.classList.remove('selected'));

                    if (isAlreadySelected) {
                        // Deselect and reset total
                        totalDisplay.textContent = 'RM ' + oldTotal.toFixed(2);
                        selectedVoucherId = null; // Reset selected voucher ID
                    } else {
                        // Select this one
                        voucherEl.classList.add('selected');
                        const iconContainer = voucherEl.querySelector('.voucher-check-icon');
                        selectedVoucherId = parseInt(voucherEl.dataset.voucherId); // Get the ID of the selected voucher
                        iconContainer.innerHTML = '<i class="fa-regular fa-circle-check fa-lg text-green-500"></i>';

                        const newTotal = parseFloat(voucherEl.dataset.afterDeduction);
                        totalDisplay.textContent = 'RM ' + newTotal.toFixed(2);
                    }
                });
            });

            const paymentOptions = document.querySelectorAll('[data-payment-method]');
            const cardOptions = document.querySelectorAll('.card-option');

            paymentOptions.forEach(option => {
                option.addEventListener('click', () => {
                    // Clear all selected icons
                    document.querySelectorAll('.cod-check-icon, .bankTransfer-check-icon, .card-check-icon').forEach(el => {
                        el.innerHTML = '';
                    });

                    // Remove all selected class
                    paymentOptions.forEach(el => el.classList.remove('selected'));
                    cardOptions.forEach(el => el.classList.remove('selected'));

                    // Add check icon to selected method
                    const checkContainer = option.querySelector('.check-icon-container');
                    if (checkContainer) {
                        checkContainer.innerHTML = '<i class="fa-regular fa-circle-check fa-lg text-green-500"></i>';
                    }

                    // Mark as selected
                    option.classList.add('selected');
                });
            });

            cardOptions.forEach(card => {
                card.addEventListener('click', () => {
                    // Clear other icons and selections
                    document.querySelectorAll('.cod-check-icon, .bankTransfer-check-icon, .card-check-icon').forEach(el => {
                        el.innerHTML = '';
                    });
                    paymentOptions.forEach(el => el.classList.remove('selected'));
                    cardOptions.forEach(el => el.classList.remove('selected'));

                    // Add icon and mark selected card
                    const cardIconContainer = card.querySelector('.card-check-icon');
                    if (cardIconContainer) {
                        cardIconContainer.innerHTML = '<i class="fa-regular fa-circle-check fa-lg text-green-500"></i>';
                    }
                    card.classList.add('selected');
                });
            });
        });

        function redirectToAddCard() {
            window.location.href = "<%= request.getContextPath() %>/User/account#payments";
        }

        function proceedToPayment() {
            const methodInput = document.getElementById('methodId');
            const voucherInput = document.getElementById('voucherId');
            const paymentInfoInput = document.getElementById('paymentInfo');
            const shippingInfoInput = document.getElementById('shippingInfo');

            const selectedPaymentMethod = document.querySelector('[data-payment-method].selected');
            const selectedCard = document.querySelector('.card-option.selected');
            let methodId = 0;

            if (!selectedPaymentMethod && !selectedCard) {
                Swal.fire({
                    icon: 'error',
                    title: 'Payment Method Required',
                    text: 'Please select a payment method before proceeding.',
                    confirmButtonText: 'OK'
                });
                return;
            }

            let paymentInfo = {
                creditDebit: { method: false, cardNumber: "", bankType: "", cardName: "", expiryDate: "" },
                bankTransfer: { method: false },
                cod: { method: false }
            };

            if (selectedPaymentMethod) {
                methodId = parseInt(selectedPaymentMethod.dataset.paymentMethod);
                if (methodId === 2) {
                    paymentInfo.bankTransfer.method = true;
                } else if (methodId === 3) {
                    paymentInfo.cod.method = true;
                }
            }

            if (selectedCard) {
                methodId = parseInt(selectedCard.dataset.paymentMethod);
                paymentInfo.creditDebit.method = true;
                paymentInfo.creditDebit.cardNumber = selectedCard.querySelector('.cardNumber')?.textContent.trim();
                paymentInfo.creditDebit.cardName = selectedCard.querySelector('.cardName')?.textContent.trim();
                paymentInfo.creditDebit.expiryDate = selectedCard.querySelector('.cardExp')?.textContent.replace("Exp:", "").trim();
                paymentInfo.creditDebit.bankType = "";
            }

            const selectedVoucher = document.querySelector('.selectable-voucher.selected');
            const voucherId = selectedVoucher ? parseInt(selectedVoucher.dataset.voucherId) : 0;

            const shippingInfo = {
                label: "<%= shippingInfo.getLabel() %>",
                receiverName: "<%= shippingInfo.getReceiverName() %>",
                addressLine1: "<%= shippingInfo.getAddressLine1() %>",
                addressLine2: "<%= shippingInfo.getAddressLine2() != null ? shippingInfo.getAddressLine2() : "" %>",
                postCode: "<%= shippingInfo.getPostCode() %>",
                state: "<%= shippingInfo.getState() %>",
                phoneNumber: "<%= shippingInfo.getPhoneNumber() %>"
            };

            methodInput.value = methodId;
            voucherInput.value = voucherId;
            paymentInfoInput.value = JSON.stringify(paymentInfo);
            shippingInfoInput.value = JSON.stringify(shippingInfo);

            const formData = new FormData(document.getElementById("proceedPaymentForm"));

            // ✅ Show Loading Swal
            Swal.fire({
                title: 'Processing Payment',
                text: 'Please wait while we process your order...',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: "<%= request.getContextPath() %>/Order/processPayment",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    Swal.close(); // ✅ Close loading when success

                    const parsedResponse = JSON.parse(response.data);
                    if (parsedResponse.process_success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Payment Successful',
                            text: 'Your payment has been processed successfully.',
                            confirmButtonText: 'Proceed to Order Details',
                            cancelButtonText: 'Back to Home',
                            showCancelButton: true,
                            showConfirmButton: true,
                        })
                        .then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = "<%= request.getContextPath() %>/User/account#transactions/details?id=" + parsedResponse.processDone_orderId;
                            } else {
                                window.location.href = "<%= request.getContextPath() %>/Landing/";
                            }
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Payment Failed',
                            text: parsedResponse.error_msg,
                            confirmButtonText: 'OK'
                        })
                        .then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = "<%= request.getContextPath() %>/Landing/";
                            }
                        });
                    }
                },
                error: function (error) {
                    Swal.close(); // ✅ Close loading on error too

                    console.error("Error submitting form:", error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Submission Failed',
                        text: 'There was an error processing your payment. Please try again.',
                        confirmButtonText: 'OK'
                    })
                    .then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = "<%= request.getContextPath() %>/Landing/";
                        }
                    });
                }
            });
        }

        function closePaymentWarningModal() {
            const modal = document.getElementById("paymentWarningModal");
            modal.classList.add("hidden");
            modal.classList.remove("flex");
        }

    </script>

</body>
</html>