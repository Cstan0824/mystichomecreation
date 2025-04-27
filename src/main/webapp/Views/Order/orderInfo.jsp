<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title>Order Information</title>
</head>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="Models.Orders.Order" %>
<%@ page import="Models.Orders.OrderTransaction" %>
<%@ page import="Models.Payment" %>
<%@ page import="Models.PaymentMethod" %>
<%@ page import="Models.Accounts.ShippingInformation" %>
<%@ page import="mvc.Helpers.Helpers" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>
<body class="content-wrapper flex flex-col selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
    
    <% 
        Order order = (Order) request.getAttribute("order");
        ShippingInformation shippingInfo = (ShippingInformation) request.getAttribute("shippingInfo");
        List<OrderTransaction> orderTransactions = (List<OrderTransaction>) request.getAttribute("orderTransactions");
        Map<String, Boolean> feedbackMap = (Map<String, Boolean>) request.getAttribute("feedbackMap");
    %>

    <!-- #region ORDER STATUS -->
    <div class="content-wrapper flex flex-col bg-white" style="padding: 0 0 0 0; margin: 0 0 0 0;">
        <div class="p-8 pb-0">
            <div class="flex justify-between">
                <div class="text-2xl font-bold font-poppins hover:text-darkYellow cursor-pointer">
                    <p class="flex gap-2 items-center" onClick="redirect('<%= request.getContextPath() %>/User/account#transactions')"><i class="fa-solid fa-left-long fa-lg"></i>Back</p>
                </div>

                <div class="flex gap-4 items-center text-xl">
                    <p class="font-semibold">Order Information for <%= order.getOrderRefNo() %></p>
                    <p>|</p>
                    <%
                        String statusClass = "";
                        int status = order.getStatus().getId();

                        switch(status) {
                            case 1:
                                statusClass = "text-DarkYellow";
                                break;
                            case 2:
                                statusClass = "text-[#599cff]";
                                break;
                            case 3:
                                statusClass = "text-[#f9a207]";
                                break;
                            case 4:
                                statusClass = "text-green-500";
                                break;
                            case 5:
                                statusClass = "text-red-500";
                                break;
                            default:
                                statusClass = "text-gray-500";
                        }
                    %>
                    <p class="font-semibold">Order Status: <span class="<%= statusClass %>"><%= order.getStatus().getStatusDesc() %></span></p>
                </div>

            </div>
        </div>

        <div class="flex flex-col w-full bg-white p-10 px-24">
            <!-- Order Status Flow -->
            <div class="flex items-center justify-between mb-10">
                <div class="flex flex-col gap-2 items-center text-center" id="pending_status">
                    <div class="w-[76px] h-[76px] rounded-full border-4 border-darkYellow flex items-center justify-center text-xl text-darkYellow">
                        <i class="fa-solid fa-receipt fa-lg"></i>
                    </div>
                    <p class="text-sm text-gray-500">Pending</p>
                </div>
                
                <!-- Line -->
                <div class="flex-1 h-1 bg-darkYellow mx-2"></div>
            
                <!-- Repeat for other steps -->
                <div class="flex flex-col gap-2 items-center text-center" id="packing_status">
                    <div class="w-[76px] h-[76px] rounded-full border-4 border-darkYellow flex items-center justify-center text-xl text-darkYellow">
                        <i class="fa-solid fa-boxes-packing fa-lg"></i>
                    </div>
                    <p class="text-sm text-gray-500">Packing</p>
                </div>
            
                <div class="flex-1 h-1 bg-darkYellow mx-2"></div>
            
                <div class="flex flex-col gap-2 items-center text-center" id="shipping_status">
                    <div class="w-[76px] h-[76px] rounded-full border-4 border-darkYellow flex items-center justify-center text-xl text-darkYellow">
                        <i class="fa-solid fa-truck fa-lg"></i>
                    </div>
                    <p class="text-sm text-gray-500">Shipping</p>
                </div>
            
                <div class="flex-1 h-1 bg-darkYellow mx-2"></div>
            
                <div class="flex flex-col gap-2 items-center text-center" id="received_status">
                    <div class="w-[76px] h-[76px] rounded-full border-4 border-darkYellow flex items-center justify-center text-xl text-darkYellow">
                        <i class="fa-solid fa-check fa-lg"></i>
                    </div>
                    <p class="text-sm text-gray-500">Received</p>
                </div>
            </div>
            

            <!-- Delivery & Logs -->
            <div class="flex gap-8 items-start mb-10">
                <!-- Delivery Address -->
                <div class="flex basis-1/3 flex-col w-full items-start justify-between">
                    <p class="font-poppins font-semibold text-lg mb-3">Delivery Address</p>
                    <div class="flex flex-col font-dmSans text-md">
                        <p class="text-md font-medium" id="label"><%= Helpers.escapeString(shippingInfo.getLabel()) %></p>
                        <p class="text-sm" id="receiverName"><%= Helpers.escapeString(shippingInfo.getReceiverName()) %></p>
                        <p class="text-sm" id="address1"><%= Helpers.escapeString(shippingInfo.getAddressLine1()) %></p>
                        <p class="text-sm" id="address2"><%= shippingInfo.getAddressLine2() != null ? Helpers.escapeString(shippingInfo.getAddressLine2()) : "" %></p>
                        <p class="text-sm" id="postcodeState"><%= shippingInfo.getPostCode() %> <%= shippingInfo.getState() %></p>
                        <p class="text-sm" id="phoneNo"><%= shippingInfo.getPhoneNumber() %></p>
                    </div>  
                </div>

                <!-- Order Status Log -->
                <div class="flex basis-2/3 flex-col w-full items-start justify-between">
                    <p class="font-poppins font-semibold text-lg mb-4"><%= order.getOrderRefNo() %></p>
                    
                    <% if (order.getReceiveDate() != null && !order.getReceiveDate().isEmpty()) { 
                        String input = order.getReceiveDate();
                        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime dateTime = LocalDateTime.parse(input, inputFormatter);

                        String receiveDate = dateTime.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
                        String receiveTime = dateTime.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
                    %>
                    <div class="flex justify-between w-full font-dmSans text-md">
                        <p>Order Delivered</p>
                        <div class="flex gap-2 items-center">
                            <p><%= receiveDate %></p>
                            <p><%= receiveTime %></p>
                        </div>
                    </div>
                    <% } %>
                    <% if (order.getShipDate() != null && !order.getShipDate().isEmpty()) { 
                        String input = order.getShipDate();
                        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime dateTime = LocalDateTime.parse(input, inputFormatter);

                        String shipDate = dateTime.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
                        String shipTime = dateTime.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
                    %>
                    <div class="flex justify-between w-full font-dmSans text-md">
                        <p>Order Shipped</p>
                        <div class="flex gap-2 items-center">
                            <p><%= shipDate %></p>
                            <p><%= shipTime %></p>
                        </div>
                    </div>
                    <% } %>
                    <% if (order.getPackDate() != null && !order.getPackDate().isEmpty()) { 
                        String input = order.getPackDate();
                        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime dateTime = LocalDateTime.parse(input, inputFormatter);

                        String packDate = dateTime.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
                        String packTime = dateTime.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
                    %>
                    <div class="flex justify-between w-full font-dmSans text-md">
                        <p>Order Packed</p>
                        <div class="flex gap-2 items-center">
                            <p><%= packDate %></p>
                            <p><%= packTime %></p>
                        </div>
                    </div>
                    <% } %>
                    <% if (order.getOrderDate() != null && !order.getOrderDate().isEmpty()) { 
                        
                        String input = order.getOrderDate();
                        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime dateTime = LocalDateTime.parse(input, inputFormatter);

                        String orderDate = dateTime.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
                        String orderTime = dateTime.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
                        
                    %>
                    <div class="flex justify-between w-full font-dmSans text-md">
                        <p>Order Placed</p>
                        <div class="flex gap-2 items-center">
                            <p><%= orderDate %></p>
                            <p><%= orderTime %></p>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            
        
            <!-- Buy again or View Receipt -->
            <div class="flex justify-end gap-4 items-center">
                <button onClick="generatePDF()" class="border-darkYellow border text-darkYellow font-poppins font-semibold px-4 py-2 rounded-lg hover:text-white hover:bg-yellow-500 transition-colors duration-300">View Receipt</button>
            </div>
        </div>
    </div>  

    <!-- #endregion -->

    <!-- #region Order Section -->
    <div class="flex flex-col bg-primary-50 p-8 pb-4">
        
        <p class="font-poppins font-semibold text-2xl mb-4">Order List</p>

        <div class="flex flex-col">
            <!-- Product List -->
            <% for(OrderTransaction item : orderTransactions) { %>
            <div class="flex flex-col border-t border-gray-300 py-4" id="product">
                <div class="flex gap-4">
                    <img src="<%= request.getContextPath()%>/File/Content/product/retrieve?id=<%= item.getProduct().getImage().getId() %>" alt="<%= item.getProduct().getTitle() %>" class="basis-[150px] w-[150px] h-[150px] object-cover rounded-lg shrink-0">
                    <div class="flex flex-col w-full justify-between">
                        <div>
                            <p class="font-poppins font-medium text-lg lineClamp-2"><%= item.getProduct().getTitle() %></p>
                            <p class="font-dmSans text-md"><%= item.getProduct().getTypeId().gettype() %></p>
                            <p class="font-dmSans text-md">
                                <% String jsonString = item.getSelectedVariations();
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
                        </div>
                        
                        <div class="flex justify-between items-center mt-2">
                            <p class="font-dmSans text-md" id="quantity">x<%= item.getOrderQuantity() %></p>
                            <div class="flex gap-4 items-center">

                            <%
                                boolean isOrderReceived = order.getStatus().getId() == 4;
                                int productId = item.getProduct().getId();
                                String createdAt = item.getCreatedAt(); // already a String in ISO format
                                String feedbackKey = productId + "|" + createdAt;

                                boolean hasFeedback = feedbackMap != null && feedbackMap.getOrDefault(feedbackKey, false);
                            %>


                            <% if (isOrderReceived) { %>
                                <% if (hasFeedback) { %>
                                    <button class="border-darkYellow border text-md text-darkYellow font-poppins font-semibold px-4 py-2 rounded-lg hover:text-white hover:bg-yellow-500 transition-colors duration-300" 
                                        onclick="window.top.location.href='<%= request.getContextPath() %>/product/productPage?id=<%= item.getProduct().getId() %>'">
                                        View Review
                                    </button>
                                <% } else { %>
                                <% out.println("<script>console.log('"+ Helpers.escapeJS(item.getSelectedVariations()) +"')</script>");%>
                                    <button 
                                        class="review-button border-darkYellow border text-md text-darkYellow font-poppins font-semibold px-4 py-2 rounded-lg hover:text-white hover:bg-yellow-500 transition-colors duration-300"
                                        data-order-id="<%= item.getOrder().getId() %>"
                                        data-product-id="<%= item.getProduct().getId() %>"
                                        data-title="<%= Helpers.escapeJS(item.getProduct().getTitle()) %>"
                                        data-variation="<%= StringEscapeUtils.escapeHtml4(item.getSelectedVariations()) %>"
                                        data-image-url="<%= request.getContextPath()%>/File/Content/product/retrieve?id=<%= item.getProduct().getImage().getId() %>"
                                        data-price="<%= item.getOrderedProductPrice() %>">
                                        Review Here
                                    </button>

                                <% } %>
                            <% } %>

                                <button class="border-darkYellow border text-md text-darkYellow font-poppins font-semibold px-4 py-2 rounded-lg hover:text-white hover:bg-yellow-500 transition-colors duration-300" onClick="redirect('<%= request.getContextPath() %>/product/productPage?id=<%= item.getProduct().getId() %>')">
                                    Buy Again
                                </button>

                                <p class="font-dmSans text-md" id="pricePerUnit">RM <%= String.format("%.2f", (double) item.getOrderedProductPrice()) %></p>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
            
        </div>
        
        
        
    </div>
    <!-- #endregion -->

    <!-- #region Order Summary -->
    <div class="flex font-dmSans bg-white">
        <div class="basis-3/4 grid grid-rows-5 w-full text-md">
            <div class="border-t-4 border-r-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-4 py-2">
                <p>Merchandise Subtotal</p>
            </div>
            <div class="border-t-2 border-r-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-4 py-2">
                <p>Shipping Fee</p>
            </div>
            <div class="border-t-2 border-r-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-4 py-2">
                <p>Voucher Applied</p>
            </div>
            <div class="border-t-2 border-r-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-4 py-2">
                <p>Order Total</p>
            </div>
            <div class="border-t-2 border-r-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-4 py-2">
                <p>Payment Method</p>
            </div>
        </div>
        <div class="basis-1/4 grid grid-rows-5 w-full text-md">
            <% 
                double merchandiseSubtotal = 0.0;
                double shippingFee = 25.00; // Default shipping fee
                double voucherDeduction = 0.0;
                double total = 0.0;

                for(OrderTransaction item : orderTransactions) {
                    merchandiseSubtotal += item.getOrderedProductPrice() * item.getOrderQuantity();
                }

                if (merchandiseSubtotal >= 1000) {
                    shippingFee = 0.00; // Free shipping for orders above RM1000
                }

                if (order.getPayment().getVoucher() != null) {
                    String voucherType = order.getPayment().getVoucher().getType();
                    double voucherValue = order.getPayment().getVoucher().getAmount();
                    double maximumDiscount = order.getPayment().getVoucher().getMaxCoverage();

                    if ("Percent".equals(voucherType)) {
                        voucherDeduction = (merchandiseSubtotal * voucherValue) / 100;
                        if (voucherDeduction > maximumDiscount) {
                            voucherDeduction = maximumDiscount;
                        }
                    } else if ("Fixed".equals(voucherType)) {
                        voucherDeduction = Math.min(voucherValue, maximumDiscount);
                    }
                }

                total = merchandiseSubtotal + shippingFee - voucherDeduction;
            %>

            <div class="border-t-4 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-8 py-2">
                <p id="subtotal">RM <%= String.format("%.2f", merchandiseSubtotal) %></p>
            </div>
            <div class="border-t-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-8 py-2">
                <p id="shipping">RM <%= String.format("%.2f", shippingFee) %></p>
            </div>
            <div class="border-t-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-8 py-2">
                <p id="voucher">-RM <%= String.format("%.2f", voucherDeduction) %></p>
            </div>
            <div class="border-t-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-8 py-2">
                <p class="text-2xl text-darkYellow font-semibold" id="total">RM <%= String.format("%.2f", total) %></p>
            </div>
            <%

                String desc = "";
                if (order.getPayment() != null && order.getPayment().getMethod() != null) {
                    desc = order.getPayment().getMethod().getMethodDesc();
                }

            %>
            <div class="border-t-2 last:border-b-2 w-full border-gray-300 flex justify-end items-center px-8 py-2">
                <p><%= desc %></p>
            </div>
        </div>
        
    </div>
    <!-- #endregion -->

    <!-- #region Feedback Modal -->
    <div id="feedbackModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-[1000] flex">
        <div class="bg-white rounded-2xl p-6 w-full max-w-3xl shadow-xl flex flex-col gap-4">
            <h2 class="text-xl font-semibold text-gray-800 mb-4 font-poppins">Leave Your Review</h2>
 
            <div id="order-item" class="flex gap-2">
                <!-- Image -->
                <div class="flex items-center flex-shrink-0">
                    <img src="https://placehold.co/100x100/png" alt="product-img" 
                        class="w-[100px] h-[100px] rounded-[6px] object-cover border border-grey2" />
                </div>
                
                <!-- Details -->
                <div class="flex flex-col justify-between w-full h-[100px]">
                    <!-- Top (Product Name) -->
                    <div class="flex flex-col gap-0.5 overflow-hidden max-w-[70%]">
                        <h1 class="text-lg font-normal text-black truncate font-dmSans" id="modalProductName">Product Name That Might Be Very Long</h1>
                    </div>

                    <!-- Bottom Right (Price) -->
                    <div class="flex justify-end">
                        <p class="font-semibold text-lg py-1 text-nowrap" id="product-price">RM 88.00</p>
                    </div>
                </div>

            </div>
            <!-- Rating Stars -->
            <div class="flex flex-col items-center justify-center gap-1">
                <p id="rating-description" class="text-center text-md text-gray-600 font-medium h-5"></p>
                <div id="rating-stars" class="flex justify-center space-x-2 my-4 mb-6 cursor-pointer text-3xl text-gray-300">
                    <i class="fa-solid fa-star" data-index="1"></i>
                    <i class="fa-solid fa-star" data-index="2"></i>
                    <i class="fa-solid fa-star" data-index="3"></i>
                    <i class="fa-solid fa-star" data-index="4"></i>
                    <i class="fa-solid fa-star" data-index="5"></i>
                </div>
            </div>

            <!-- Comment box -->
            <textarea id="feedback-comment" rows="6" placeholder="Write your review here..." 
                class="w-full border rounded-lg px-4 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-darkYellow resize-none mb-4"></textarea>

            <!-- Buttons -->
            <div class="flex justify-end gap-4">
                <button onclick="closeFeedbackModal()" class="px-4 py-2 border rounded-lg text-gray-600 hover:bg-gray-100">Cancel</button>
                <button onclick="submitFeedback()" class="px-4 py-2 bg-darkYellow text-white font-semibold rounded-lg hover:bg-yellow-600">Submit</button>
            </div>
        </div>
    </div>

<!-- #endregion -->

</body>
<script>
    const thisOrderId = '<%= order.getId() %>';
    const thisOrderRefNo = '<%= order.getOrderRefNo() %>';
    const safeOrderRefNo = thisOrderRefNo.replace(/#/g, ''); // remove all #
    var status = '<%= order.getStatus().getStatusDesc() %>';

    document.addEventListener('DOMContentLoaded', () => {

        // Order Status Highlight Logic
        const statuses = ["pending", "packing", "shipping", "received"];
        const reachedStatus = status.toLowerCase();

        statuses.forEach(stat => {
            const el = document.getElementById("" + stat + "_status");
            if (!el) return;

            const circle = el.querySelector('div');

            // Reset all status circles first
            circle.classList.remove("bg-darkYellow", "text-white");
            circle.classList.add("border-darkYellow", "text-darkYellow");

            // If it's the current status, apply highlight
            if (stat === reachedStatus) {
                circle.classList.add("bg-darkYellow", "text-white");
                circle.classList.remove("text-darkYellow");
            }
        });
    });

    function redirect(url) {
        const targetWindow = (window.top === window.self) ? window : window.top;
        const currentHref = targetWindow.location.href;

        // Extract substring after "/web"
        const currentPath = currentHref.substring(currentHref.indexOf("/web"));

        if (currentPath === url) {
            targetWindow.location.reload();
        } else {
            targetWindow.location.replace(url);
        }
    }





    let selectedRating = 0;

    const ratingDescriptions = {
        1: "Very Bad",
        2: "Bad",
        3: "Okay",
        4: "Good",
        5: "Excellent"
    };

    function openFeedbackModal(orderId, productId, productTitle, selectedVariation, productImage, productPrice) {
        const modal = document.getElementById('feedbackModal');
        modal.classList.remove('hidden');
        modal.dataset.orderId = orderId;
        modal.dataset.productId = productId;
        modal.dataset.selectedVariation = selectedVariation;

        selectedRating = 0;
        document.getElementById('feedback-comment').value = "";
        document.getElementById('modalProductName').innerText = productTitle;

        // Inject image and price
        document.querySelector('#order-item img').src = productImage;
        document.querySelector('#order-item #product-price').innerText = `RM ` + parseFloat(productPrice).toFixed(2);

        highlightStars(0);
    }

    function generatePDF() {

        $.ajax({
            url: '<%= request.getContextPath() %>/Order/generateReceipt',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                orderId: parseInt(thisOrderId)
            }),
            xhrFields: {
                responseType: 'blob'   // 🚀 Important! Expect a blob, not text
            },
            success: function(blob) {
                // Create a temporary URL for the blob
                const blobUrl = URL.createObjectURL(blob);
                
                // Create an anchor element to trigger download
                const a = document.createElement('a');
                a.href = blobUrl;
                a.download = 'Order_Receipt_' + safeOrderRefNo + '.pdf'; // ✅ set filename here
                document.body.appendChild(a);
                a.click();
                
                // Cleanup
                document.body.removeChild(a);
                URL.revokeObjectURL(blobUrl);

                // Optionally, show a success popup
                Swal.fire({
                    icon: 'success',
                    title: 'Receipt Generated',
                    text: 'Your receipt has been downloaded.'
                });
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to generate receipt.'
                });
            }
        });

    }

    function closeFeedbackModal() {
        document.getElementById('feedbackModal').classList.add('hidden');
    }

    function highlightStars(count) {
        document.querySelectorAll('#rating-stars i').forEach((star, i) => {
            star.classList.toggle('text-yellow-400', i < count);
            star.classList.toggle('text-gray-300', i >= count);
        });
    }

    document.querySelectorAll(".review-button").forEach(button => {
        button.addEventListener("click", function () {
            openFeedbackModal(
                this.dataset.orderId,
                this.dataset.productId,
                this.dataset.title,
                this.dataset.variation,
                this.dataset.imageUrl,
                this.dataset.price
            );
        });
    });

    document.querySelectorAll('#rating-stars i').forEach(star => {
        const index = parseInt(star.dataset.index);

        star.addEventListener('mouseenter', () => {
            highlightStars(index);
            document.getElementById('rating-description').innerText = ratingDescriptions[index] || "";
        });

        star.addEventListener('click', () => {
            selectedRating = index;
        });
    });


    document.getElementById('rating-stars').addEventListener('mouseleave', () => {
        highlightStars(selectedRating);
        document.getElementById('rating-description').innerText = selectedRating ? ratingDescriptions[selectedRating] : "";
    });


    function submitFeedback() {
        const modal = document.getElementById('feedbackModal');
        const orderId = modal.dataset.orderId;
        const productId = modal.dataset.productId;
        const variation = modal.dataset.selectedVariation;
        let comment = document.getElementById('feedback-comment').value.trim();

        if (comment.length == 0) {
            comment = null;
        }

        if (selectedRating === 0) return alert("Please select a star rating.");


        $.ajax({
            url: '<%= request.getContextPath() %>/Order/addOrderFeedback',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                orderId: parseInt(orderId),
                productId: parseInt(productId),
                selectedVariation: variation,
                rating: selectedRating,
                comment: comment
            }),
            success: function(response) {
                const parsedResponse = JSON.parse(response.data);
                if (parsedResponse.success) {
                    closeFeedbackModal();
                    Swal.fire({
                        icon: 'success',
                        title: 'Feedback Submitted!',
                        text: 'Your feedback was submitted successfully.',
                        confirmButtonText: 'Close'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload(true);
                        }
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Failed to Submit Feedback',
                        text: parsedResponse.error_msg
                    });
                }
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Failed to Submit Feedback',
                    text: parsedResponse.error_msg
                });
            }
        });
    }

</script>
    
</html>