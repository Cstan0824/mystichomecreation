<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="Models.Orders.Order" %>
<%@ page import="Models.Orders.OrderStatus" %>
<%@ page import="mvc.Helpers.Helpers" %>


<body class="bg-gray-50">

<%@ include file="/Views/Shared/Header.jsp" %>

    <%  
    
        List<OrderStatus> statuses = (List<OrderStatus>) request.getAttribute("statuses");
        List<Order> orders = (List<Order>) request.getAttribute("orders");
    
    %>


    <div class="content-wrapper">
        <h1 class="font-poppins font-bold text-3xl my-8">Orders</h1>
        <!-- Header with search and cart -->
        <div class="flex flex-row justify-between items-center mb-6 gap-4">
            <!-- Search Container -->
            <div class="relative flex-1 md:flex-none md:w-96">
                <input type="text" placeholder="Search Customer" name="keywords" id="searchInput" oninput="filterByCategory()"
                    class="w-full border border-gray-300 rounded-md py-2 pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-yellow-400">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-4">
            <!-- Sidebar filters for desktop -->
            <div class="w-full md:w-64 mr-6 bg-white rounded-lg shadow-lg p-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-bold text-lg">Filter</h2>
                    <button onclick="clearAllFilters()" class="text-yellow-500 text-sm">Clear All</button>
                </div>

                <form id="filterForm" oninput="filterByCategory()" enctype="multipart/form-data">
                    <!-- 🔽 Sort By -->
                    <div class="border-b pb-3 mb-3">
                        <h3 class="text-gray-600 font-semibold mb-2">Sort By</h3>
                        <select name="sortBy" class="w-full border border-gray-300 rounded-md px-2 py-1 focus:outline-none">
                            <option value="">Select...</option>
                            <option value="latest">Latest orders</option>
                            <option value="oldest">Oldest orders</option>
                        </select>
                    </div>

                    <!-- 🔽 Category -->
                    <div class="border-b pb-3 mb-3">
                        <h3 class="text-gray-600 font-semibold mb-2">Category</h3>
                        <div class="space-y-1">
                            <% if (statuses != null && !statuses.isEmpty()) {
                                    for (OrderStatus status : statuses) {  %>
                                        <label class="flex items-center">
                                            <input type="checkbox" name="selectedStatuses" value="<%= status.getId() %>" class="form-checkbox text-yellow-500">
                                            <span class="ml-2 text-sm text-gray-600"><%= status.getStatusDesc() %></span>
                                        </label>
                                <%  } %>
                            <% } %>
                            
                        </div>
                    </div>

                </form>

            </div>

            <!-- Main content -->
            <div class="flex-1 rounded-lg bg-white p-6 shadow-lg">
                <div class="mb-6">
                    <!-- Search Results header with tabs on same line -->
                    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
                        <h2 class="text-xl font-bold">Filtered Result</h2>
                    </div>
                    <!-- Order Container: List View -->
                    <div class="mb-6" id="orders-container">
    
                        <% if(orders != null && !orders.isEmpty()) { %>
                            <!-- Header Row -->
                            <div class="grid grid-cols-10 items-center bg-gray-200 text-gray-700 text-sm font-poppins font-semibold rounded-t-md">
                                <div class="col-span-2 px-4 py-2">Order Ref.</div>
                                <div class="col-span-2 px-4 py-2">Customer</div>
                                <div class="col-span-1 px-4 py-2">Status</div>
                                <div class="col-span-2 px-4 py-2">Total</div>
                                <div class="col-span-2 px-4 py-2">Order Date</div>
                                <div class="col-span-1 px-4 py-2">Actions</div>
                            </div>

                            <!-- Order Rows -->
                            <% for (Order order : orders) { %>
                                <div class="grid grid-cols-10 text-sm font-dmSans bg-white justify-center items-center border-b" data-order-id="<%= order.getId() %>">
                                    <div class="col-span-2 px-4 py-2 text-black "><%= order.getOrderRefNo() %></div>
                                    <div class="col-span-2 px-4 py-2 text-black "><%= order.getUser().getUsername() %></div>
                                    <div class="col-span-1 px-4 py-2 text-yellow-500 "><%= order.getStatus().getStatusDesc() %></div>
                                    
                                    <div class="col-span-2 px-4 py-2 text-black ">RM <%= String.format("%.2f", order.getPayment().getTotalPaid()) %></div>
                                    <div class="col-span-2 px-4 py-2 text-black "><%= order.getOrderDate() %></div>
                                
                                    <div class="col-span-1 px-4 py-2 flex gap-4 justify-start items-center">
                                        <div class="hover:text-darkYellow cursor-pointer transition-color duration-200 ease-in-out"
                                             onClick="openUpdateModal('<%= order.getId() %>')">
                                            <i class="fa-solid fa-pen-to-square fa-lg"></i>
                                        </div>
                                        <div class="hover:text-darkYellow cursor-pointer transition-color duration-200 ease-in-out"
                                            onClick="redirectToPage('<%= order.getId() %>')">
                                            <i class="fa-solid fa-arrow-up-right-from-square fa-lg" ></i>
                                        </div>
                                    </div>
                                </div>
                            <% } %>

                        <% } else { %>
                            <!-- No orders found message -->
                            <div class="grid grid-cols-10 text-sm font-dmSans bg-white justify-center items-center border-b">
                                <div class="col-span-10 px-4 py-2 text-black text-center">No orders found.</div>
                            </div>

                        <% } %>

                    </div>
                </div>
            </div>
        </div>

        <!-- ✅ Modal Overlay -->
        <div id="updateOrderModal" class="fixed inset-0 z-[1000] flex items-center justify-center bg-black bg-opacity-50 hidden">
            <div class="bg-white rounded-xl p-6 w-full max-w-3xl shadow-lg relative">

                <!-- Modal Content (Update Order Status for orderRefNo) --> 
                <h2 class="text-xl font-semibold mb-4 font-poppins" id="updateOrderTitle">Update Order Status for </h2>


                <!-- Order Details -->
                <div class="max-h-[200px] overflow-y-auto my-4 p-4 pl-0" id="modal-order-container">
                    <!-- Inject order details here dynamically -->
                </div>

                <!-- Current Status -->
                <div class="my-4 text-center" id="current-status-container">
                    
                </div>

                <form id="updateOrderForm">
                    <input type="hidden" name="orderId" id="updateOrderId">

                    <div class="flex justify-end gap-2">
                        <button type="button" onclick="closeUpdateModal()" class="font-poppins bg-gray-200 hover:text-red-500 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-md">Cancel</button>
                        <button type="submit" class="bg-yellow-400 font-poppins text-white px-4 py-2 rounded-md hover:bg-darkYellow transition-color duration-200 ease-in-out" id="updateStatusBtn">Update Status</button>
                        <button type="button" onclick="cancelOrder()" class="bg-red-500 font-poppins text-black px-4 py-2 rounded-md hover:bg-black hover:text-white transition-color duration-200 ease-in-out" id="cancelOrderBtn">Cancel Order</button>
                    </div>
                </form>
            </div>
        </div>
    
    </div>
</body>
        
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
            formData.append("keywords", keywords || "");
        }

        // Step 4: Send AJAX request
        
        $.ajax({
            url: "<%= request.getContextPath() %>/Order/orders/Categories",
            type: "POST",
            data: formData, // ✅ send as multipart/form-data
            processData: false, // ✅ prevent jQuery from transforming it into a query string
            contentType: false, // ✅ let browser set multipart boundaries
            success: function (response) {
                try {
                    const parsedOrders = JSON.parse(response.data);
                    renderOrders(parsedOrders);
                } catch (e) {
                    console.error("❌ JSON parse error:", e);
                }
            },
            error: function (err) {
                console.error("🔥 AJAX error:", err);
            }
        });
    }    
        
        
    function renderOrders(orders) {
        const container = document.getElementById("orders-container");
        container.innerHTML = ""; 

        if (!orders || orders.length === 0) {
            container.innerHTML = 
            `
            
                <div class="grid grid-cols-10 text-sm font-dmSans bg-white justify-center items-center border-b">
                    <div class="col-span-10 px-4 py-2 text-black text-center">No orders found.</div>
                </div>
            
            `;
            return;
        }
        
        let html = getOrderHeaderRow();
        for (let i = 0; i < orders.length; i++) {
            let order = orders[i];

            html += 
            
            `
            <div class="grid grid-cols-10 text-sm font-dmSans bg-white justify-center items-center border-b" data-order-id="`+ order.id +`">
                <div class="col-span-2 px-4 py-2 text-black ">`+ order.orderRefNo +`</div>
                <div class="col-span-2 px-4 py-2 text-black ">`+ order.username +`</div>
                <div class="col-span-1 px-4 py-2 text-yellow-500 ">`+ order.status +`</div>
                        
                <div class="col-span-2 px-4 py-2 text-black ">RM `+ order.totalPaid.toFixed(2) +`</div>
                <div class="col-span-2 px-4 py-2 text-black ">`+ order.orderDate +`</div>
                    
                <div class="col-span-1 px-4 py-2 flex gap-4 justify-start items-center">
                    <div class="hover:text-darkYellow cursor-pointer transition-color duration-200 ease-in-out"
                            onClick="openUpdateModal('`+ order.id +`')">
                        <i class="fa-solid fa-pen-to-square fa-lg"></i>
                    </div>
                    <div class="hover:text-darkYellow cursor-pointer transition-color duration-200 ease-in-out"
                        onClick="redirectToPage('`+ order.id +`')">
                        <i class="fa-solid fa-arrow-up-right-from-square fa-lg" ></i>
                    </div>
                </div>
            </div>
            `;
        }
        container.innerHTML = html;
    }

    function getOrderHeaderRow() {
        return `
            <div class="grid grid-cols-10 items-center bg-gray-200 text-gray-700 text-sm font-poppins font-semibold rounded-t-md">
                <div class="col-span-2 px-4 py-2">Order Ref.</div>
                <div class="col-span-2 px-4 py-2">Customer</div>
                <div class="col-span-1 px-4 py-2">Status</div>
                <div class="col-span-2 px-4 py-2">Total</div>
                <div class="col-span-2 px-4 py-2">Order Date</div>
                <div class="col-span-1 px-4 py-2">Actions</div>
            </div>`;
    }

    function openUpdateModal(orderId) {
        document.getElementById("updateOrderId").value = orderId;
        document.body.classList.add("overflow-hidden");

        $.ajax({
            url: "<%= request.getContextPath() %>/Order/getAllOrderInfo",
            type: "POST",
            data: JSON.stringify({ orderId: orderId }),
            contentType: "application/json",
            success: function (response) {
                const orderData = JSON.parse(response.data);
                if (orderData.getOrder_success){

                    // Set modal title with order reference number
                    document.getElementById("updateOrderTitle").textContent = "Update Order Status for " + orderData.orderRefNo;

                    const parsedStatus = JSON.parse(orderData.statusJson);
                    const currentStatusId = parsedStatus.id;
                    const currentStatus = parsedStatus.statusDesc;
                    let statusSpan = "";

                    switch (currentStatusId) {
                        case 1:
                            statusSpan = `<span class="text-black">`+ currentStatus+ `</span>`;
                            break;
                        case 2:
                            statusSpan = `<span class="text-blue-500">`+ currentStatus+ `</span>`;
                            break;
                        case 3:
                            statusSpan = `<span class="text-darkYellow">`+ currentStatus+ `</span>`;
                            break;
                        case 4:
                            statusSpan = `<span class="text-green-500">`+ currentStatus+ `</span>`;
                            break;
                        case 5:
                            statusSpan = `<span class="text-red-500">`+ currentStatus+ `</span>`;
                            break;
                        default:
                            statusSpan = `<span class="text-gray-500">Unknown Status</span>`;
                            break;
                    }

                    document.getElementById("current-status-container").innerHTML = 
                        `<p class="text-gray-600 font-medium font-poppins">Current Status: ` + statusSpan + `</p>`;

                    const updateBtn = document.getElementById("updateStatusBtn");
                    const cancelBtn = document.getElementById("cancelOrderBtn");
                    if (currentStatusId === 4 || currentStatusId === 5) {
                        updateBtn.classList.add("hidden");
                        cancelBtn.classList.add("hidden");
                    } else {
                        updateBtn.classList.remove("hidden");
                        cancelBtn.classList.remove("hidden");
                    }

                    // Parse each product
                    const products = orderData.orderTransactions.map(function (t) {
                        const product = JSON.parse(t.productJson); // Parse the product JSON string into an object
                        const productImg = product.image ? product.image : {}; // Ensure image exists
                        return {
                            imageUrl: productImg.id ? "<%= request.getContextPath() %>/File/Content/product/retrieve?id=" + productImg.id : "https://placehold.co/100x100/png",
                            title: product.title,
                            price: t.orderedProductPrice,
                            quantity: t.quantity,
                            selectedVariations: JSON.parse(t.selectedVariations) // Parse the selectedVariations JSON string
                        };
                    });
                    let html = "";
                    products.forEach(function (p) {
                        const variations = variationsToString(p.selectedVariations);
                        html += renderProduct(p.imageUrl, p.title, p.price, p.quantity, variations);
                    });

                    document.getElementById("modal-order-container").innerHTML = html;
                    document.getElementById("updateOrderModal").classList.remove("hidden");

                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Failed to fetch order details.',
                        text: orderData.error_msg || 'Please try again later.',
                        showConfirmButton: true
                    });
                }
            },
            error: function () {
                Swal.fire({
                    icon: 'error',
                    title: 'Failed to fetch order details.',
                    text: 'Please try again later.',
                    showConfirmButton: true
                });
            }
        });
    }

    function cancelOrder() {
        Swal.fire({
            title: 'Are you sure you want cancel this order?',
            text: "This action cannot be undone!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, cancel it!'
        }).then((result) => {
            if (result.isConfirmed) {
                const orderId = document.getElementById("updateOrderId").value;
                $.ajax({
                    url: "<%= request.getContextPath() %>/Order/orders/cancelOrder",
                    type: "POST",
                    data: JSON.stringify({ orderId: orderId }),
                    contentType: "application/json",
                    success: function (response) {
                        const parsedResponse = JSON.parse(response.data);
                        if (!parsedResponse.cancelOrder_success) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Failed to cancel order.',
                                text: parsedResponse.error_msg || 'Please try again later.',
                                showConfirmButton: true
                            });
                            return;
                        }else{
                            Swal.fire({
                                icon: 'success',
                                title: 'Order cancelled successfully!',
                                showConfirmButton: false,
                                timer: 1500
                            });
                            closeUpdateModal();
                            filterByCategory(); // refresh the filtered orders
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: 'error',
                            title: 'Failed to cancel order.',
                            text: 'Please try again later.',
                            showConfirmButton: true
                        });
                    }
                });
            }
        });
    }


    function closeUpdateModal() {
        document.getElementById("updateOrderModal").classList.add("hidden");
        document.body.classList.remove("overflow-hidden");
    }

    // 🚀 Form Submit Handler (adjust URL accordingly)
    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("updateOrderForm").addEventListener("submit", function (e) {
            e.preventDefault();
            
            const orderId = document.getElementById("updateOrderId").value;

            // ✅ Show loading Swal before sending
            Swal.fire({
                title: 'Updating Order Status',
                text: 'Please wait...',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: "<%= request.getContextPath() %>/Order/orders/updateStatus", // 🔧 adjust controller endpoint
                type: "POST",
                data: JSON.stringify({ orderId: orderId }),
                contentType: "application/json",
                success: function (response) {
                    Swal.close(); // ✅ Close loading Swal when success

                    const parsedResponse = JSON.parse(response.data);
                    if (!parsedResponse.updateStatus_success) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Failed to update order status.',
                            text: parsedResponse.error_msg || 'Please try again later.',
                            showConfirmButton: true
                        });
                        return;
                    } else {
                        closeUpdateModal();
                        Swal.fire({
                            icon: 'success',
                            title: 'Order status updated successfully!',
                            showConfirmButton: false,
                            timer: 1500
                        });
                        filterByCategory(); // refresh the filtered orders
                    }
                },
                error: function () {
                    Swal.close(); // ✅ Close loading Swal on error too

                    Swal.fire({
                        icon: 'error',
                        title: 'Failed to update order status.',
                        text: 'Please try again later.',
                        showConfirmButton: true
                    });
                }
            });
        });
    });


    function renderProduct(productImgUrl, productName, productPrice, quantity, selectedVariation) {
        return (
            '<div class="flex gap-2 mb-3">' +
                // Image
                '<div class="flex items-center flex-shrink-0">' +
                    '<img src="' + productImgUrl + '" alt="product-img" class="w-[100px] h-[100px] rounded-[6px] object-cover border border-grey2" />' +
                '</div>' +

                // Details
                '<div class="flex flex-col justify-between w-full h-[100px]">' +
                    // Top left: title + variation
                    '<div class="flex flex-col gap-0.5 overflow-hidden">' +
                        '<h1 class="text-lg font-normal text-black truncate font-dmSans">' + productName + '</h1>' +
                        '<p class="text-sm font-normal text-black truncate font-dmSans">' + selectedVariation + '</p>' +
                    '</div>' +

                    // Bottom row: quantity left, price right
                    '<div class="flex justify-between items-end">' +
                        '<p class="text-sm font-normal text-black font-dmSans">Qty: ' + quantity + '</p>' +
                        '<p class="font-semibold text-md text-black font-dmSans">RM ' + productPrice.toFixed(2) + '</p>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }

    function variationsToString(obj) {
        return Object.entries(obj)
            .map(function(entry) {
                return entry[0] + ": " + entry[1];
            })
            .join(", ");
    }



</script>

</html>