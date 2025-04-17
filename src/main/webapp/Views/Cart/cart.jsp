<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>Cart</title>
</head>
<%@ page import="java.util.List" %>
<%@ page import="Models.Users.CartItem" %>
<%@ page import="mvc.Helpers.Helpers" %>
<body class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
<%@ include file="/Views/Shared/Header.jsp" %>
    <div class="content-wrapper">

        <h1 class="font-poppins font-bold text-3xl my-8">Cart</h1>

        <div class="flex gap-8 items-start">
            <!-- LEFT: Cart Items -->
            <div class="basis-2/3">
              <!-- Header Row -->
              

              <!-- Product List -->
            
                <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                
                if(cartItems != null){ %>

                <div class="grid grid-cols-10 border-b border-grey3 text-lg font-dmSans font-semibold py-6">
                    <div class="col-span-5">Product</div>
                    <div class="col-span-2 text-center">Quantity</div>
                    <div class="col-span-2 text-center">Subtotal</div>
                    <div class="col-span-1 text-center"></div>
                </div>

                <%
                    for(CartItem item : cartItems){  %>
                    

              <div class="grid grid-cols-10 border-b border-grey2 text-lg font-dmSans py-4 items-center product-row" data-price="<%= item.getProduct().getPrice() %>" data-product-id="<%= item.getProduct().getId() %>" data-cart-id="<%= item.getCart().getId() %>">
                <div class="col-span-5">
                    <div class="flex gap-4">
                        <img src="<%= item.getProduct().getImageUrl() %>" alt="Product 1" class="w-[100px] h-[100px] object-cover rounded-lg">
                        <div class="flex flex-col justify-between">
                            <div class="flex flex-col">
                                <p class="font-medium text-md lineClamp-2"><%= item.getProduct().getTitle() %></p>
                                <p class="text-sm font-normal"><%= item.getSelectedVariation() %></p>
                            </div>
                            
                            <p class="text-sm font-normal">RM<%= item.getProduct().getPrice() %></p>
                        </div>
                    </div>
                </div>
                <div class="col-span-2 text-center flex justify-center">
                    <div class="flex items-center justify-between w-28 border border-black rounded select-none">
                        <button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(this, -1)">−</button>
                        <span class="text-lg font-medium qty"><%= item.getQuantity() %></span>
                        <button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(this, +1)">+</button>
                    </div>
                </div>
                <div class="col-span-2 text-center subtotal">
                    RM0.00
                </div>                
                <div class="col-span-1 flex justify-center">
                    <div class="w-fit hover:text-red-500 cursor-pointer transition-all duration-200 ease-in-out">
                        <i class="fa-solid fa-trash" onclick="showDeleteModal(this)"></i>
                    </div>
                </div>
              </div>
                <% 
                    } // end for loop
                } else {
                    
                %>
                    <div class="text-center py-6 text-gray-500">
                        <p>No item in cart.</p>
                    </div>
                <% 
                }
                %>
              
            </div>
          
            <!-- RIGHT: Cart Totals -->
            <div class="basis-1/3 p-8 border border-grey3 flex flex-col w-full sticky top-[30px]">
              <p class="font-bold text-lg font-poppins mb-4">Cart Totals</p>
              <div class="flex justify-between text-md font-dmSans py-4">
                <p class="font-medium">Subtotal</p>
                <p class="font-normal" id="cart-total">RM 0.00</p>
              </div>
              <hr>
              <div class="py-4 flex flex-col gap-4">
                
                <div class="flex flex-col gap-2 text-md font-dmSans">
                  <p class="font-medium">Shipping</p>
                  <div class="flex justify-between text-md font-dmSans">
                    <p class="font-normal" id="total-items">7 items * RM 5</p>
                    <p class="font-normal" id="shipping-total">RM 0.00</p>
                  </div>
                </div>

                <div class="flex flex-col gap-1 text-md font-dmSans w-[70%]">
                    <p>Shipping to</p>
                    <p class="lineClamp-3 text-sm" id="shipping-address">
                        No 62, Jalan Nagasari 36/1B, Desa Latania Seksyen 36, 40470 Shah Alam, Selangor.
                    </p>
                </div>

                
                <button class="w-fit text-sm hover:text-darkYellow transition-colors duration-200 ease-in-out cursor-pointer" onClick="showAddressModal()">
                    Change Address
                </button>
                
                
              </div>
              <hr>
              <div class="flex justify-between text-md font-dmSans py-4">
                <p class="font-medium">Total</p>
                <p class="font-normal" id="final-total">RM 0.00</p>
              </div>
              
              <div class="flex flex-col gap-2">
                <button class="bg-white text-black border border-black font-bold py-2 px-4 rounded hover:border-darkYellow hover:text-darkYellow transition-colors duration-200 ease-in-out mt-auto" onClick="redirectShopping()">Continue Shopping</button>
                <button class="bg-black text-white font-bold py-2 px-4 rounded hover:bg-darkYellow transition-colors duration-200 ease-in-out mt-auto">Proceed to Checkout</button>
              </div>
              

            </div>
        </div>

        <!-- You may also like -->
        <div class="flex flex-col mt-10">
            <div class="pb-8 flex justify-between items-center">
                <h1 class="text-3xl font-bold text-poppins">You May Also Like</h1>
            </div>
            <!-- Best sellers catalog -->
            <div class="flex gap-8">
                <div class="w-full pb-10 basis-1/4">
                    <div class="bg-white rounded-lg overflow-hidden shadow hover:mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED
                        </div>
                        <img src="https://placehold.co/350x260/png" alt="L-shape Sofa" class="w-[350px] h-[260px] object-cover">
                        <div class="p-3">
                            <h3 class="font-medium">MARCO L-shape Sofa</h3>
                            <p class="text-xs text-gray-500">Hoi Kong Furniture...</p>
                            <div class="flex justify-between items-center mt-2">
                                <span class="font-bold">RM 2,499.00</span>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fas fa-box mr-1"></i>
                                    <span>3 left</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="w-full pb-10 basis-1/4">
                    <div class="bg-white rounded-lg overflow-hidden shadow hover:mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED
                        </div>
                        <img src="https://placehold.co/350x260/png" alt="L-shape Sofa" class="w-[350px] h-[260px] object-cover">
                        <div class="p-3">
                            <h3 class="font-medium">MARCO L-shape Sofa</h3>
                            <p class="text-xs text-gray-500">Hoi Kong Furniture...</p>
                            <div class="flex justify-between items-center mt-2">
                                <span class="font-bold">RM 2,499.00</span>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fas fa-box mr-1"></i>
                                    <span>3 left</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="w-full pb-10 basis-1/4">
                    <div class="bg-white rounded-lg overflow-hidden shadow hover:mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED
                        </div>
                        <img src="https://placehold.co/350x260/png" alt="L-shape Sofa" class="w-[350px] h-[260px] object-cover">
                        <div class="p-3">
                            <h3 class="font-medium">MARCO L-shape Sofa</h3>
                            <p class="text-xs text-gray-500">Hoi Kong Furniture...</p>
                            <div class="flex justify-between items-center mt-2">
                                <span class="font-bold">RM 2,499.00</span>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fas fa-box mr-1"></i>
                                    <span>3 left</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="w-full pb-10 basis-1/4">
                    <div class="bg-white rounded-lg overflow-hidden shadow hover:mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED
                        </div>
                        <img src="https://placehold.co/350x260/png" alt="L-shape Sofa" class="w-[350px] h-[260px] object-cover">
                        <div class="p-3">
                            <h3 class="font-medium">MARCO L-shape Sofa</h3>
                            <p class="text-xs text-gray-500">Hoi Kong Furniture...</p>
                            <div class="flex justify-between items-center mt-2">
                                <span class="font-bold">RM 2,499.00</span>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fas fa-box mr-1"></i>
                                    <span>3 left</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    
        </div>  

    </div>
    
    <!-- Delete Product -->
    <div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div id="modalContent" class="bg-white p-6 rounded-lg shadow-lg w-[90%] max-w-md text-center">
          <p class="text-lg font-semibold mb-4">Are you sure you want to remove this item?</p>
          <div class="flex justify-center gap-4">
            <button id="confirmDelete" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Yes</button>
            <button onclick="closeDeleteModal()" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">Cancel</button>
          </div>
        </div>
    </div>

    <!-- Change Address Modal -->
    <div id="addressModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50 select-none">
        <div id="modalContent" class="bg-white p-6 rounded-lg shadow-lg w-[90%] max-w-3xl flex flex-col gap-4">
            <p class="text-lg font-semibold mb-4">Shipping Addresses</p>
        
            <div class="grid-cols-3 grid gap-4 max-h-[280px] overflow-y-auto">
                <div class="p-4 flex flex-col justify-center border border-grey3 rounded-md cursor-pointer selectable-address hover:text-darkYellow hover:border-darkYellow select-none">
                    <p class="font-medium text-md">Address 1</p>
                    <p class="text-sm">No 62, Jalan Nagasari 36/1B, Desa Latania Seksyen 36, 40470 Shah Alam, Selangor.</p>
                </div>
                <div class="p-4 flex flex-col justify-center border border-grey3 rounded-md cursor-pointer selectable-address hover:text-darkYellow hover:border-darkYellow select-none">
                    <p class="font-medium text-md">Address 2</p>
                    <p class="text-sm">No 63, Jalan Nagasari 36/1B, Desa Latania Seksyen 36, 40470 Shah Alam, Selangor.</p>
                </div>
                <div class="p-4 flex flex-col justify-center border border-grey3 rounded-md cursor-pointer selectable-address hover:text-darkYellow hover:border-darkYellow select-none">
                    <p class="font-medium text-md">Address 3</p>
                    <p class="text-sm">No 64, Jalan Nagasari 36/1B, Desa Latania Seksyen 36, 40470 Shah Alam, Selangor.</p>
                </div>
                <div class="p-4 flex flex-col justify-center border border-grey3 rounded-md cursor-pointer selectable-address hover:text-darkYellow hover:border-darkYellow select-none">
                    <p class="font-medium text-md">Address 4</p>
                    <p class="text-sm">No 65, Jalan Nagasari 36/1B, Desa Latania Seksyen 36, 40470 Shah Alam, Selangor.</p>
                </div>
            </div>

            <button class="place-self-center w-fit border-black border px-4 py-2 rounded hover:text-darkYellow hover:border-darkYellow"
                    onClick="redirectToAccount()"
                >Add New Address
            </button>
            <div class="flex justify-center gap-4">
                <button id="confirmAddress" class="bg-lightMidYellow text-white px-4 py-2 rounded hover:bg-darkYellow">Update</button>
                <button onclick="closeAddressModal()" class="bg-gray-300 px-4 py-2 rounded hover:bg-red-400">Cancel</button>
            </div>
        </div>
    </div>
</body>
<script>
    // Remove product from list
    let itemToDelete = null;

    function showDeleteModal(icon) {
        itemToDelete = icon;
        document.getElementById('deleteModal').classList.remove('hidden');
        document.getElementById('deleteModal').classList.add('flex');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.remove('flex');
        document.getElementById('deleteModal').classList.add('hidden');
        itemToDelete = null;
    }

    document.getElementById('deleteModal').addEventListener('click', function (e) {
        const modalBox = document.getElementById('modalContent');
        if (!modalBox.contains(e.target)) {
            closeDeleteModal();
        }
    });

    document.getElementById('confirmDelete').addEventListener('click', () => {
        if (itemToDelete) {
            removeProduct(itemToDelete);
            closeModal();
        }
    });

    function removeProduct(icon) {
        const row = icon.closest('.product-row');
        if (row) {
            row.remove();
            updateCartSummary();
        }
    }

    //Update product quantity, cart subtotals/total
    function changeQty(btn, delta) {
        const row = btn.closest('.product-row');
        const qtyEl = row.querySelector('.qty');
        const cartId = parseInt(row.dataset.cartId);
        const productId = parseInt(row.dataset.productId);
        console.log("cartId", cartId);
        console.log("productId", productId);

        $.ajax({
            url: '<%= request.getContextPath() %>/Cart/updateQuantity',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                cartId: cartId,
                productId: productId,
                delta: delta
            }),
            success: function(response) {
                console.log('Quantity updated successfully:', response);
                console.log("qtyEl found?", qtyEl);
                const parsedJson = JSON.parse(response.data);
                console.log("New quantity:", parsedJson.quantity);
                qtyEl.textContent = parsedJson.quantity; // Update displayed quantity

            },
            error: function(xhr, status, error) {
                qtyEl.textContent = oldQty; // Revert to old quantity on error
                console.error('Error updating quantity:', error);
            }
        }); 
        

        updateCartSummary();
    }
  
    function updateCartSummary() {
        let totalItems = 0;
        let subtotal = 0;
        const rows = document.querySelectorAll('.product-row');

        rows.forEach(row => {
            const unitPrice = parseFloat(row.dataset.price);
            const qty = parseInt(row.querySelector('.qty').textContent);
            const lineTotal = unitPrice * qty;

            row.querySelector('.subtotal').textContent = "RM " + lineTotal.toFixed(2);

            subtotal += lineTotal;
            totalItems++;
        });

        const shippingRate = 30;
        const shippingTotal = totalItems * shippingRate;
        const finalTotal = subtotal + shippingTotal;

        // Update right side display
        document.getElementById('cart-total').textContent = "RM " + subtotal.toFixed(2);
        document.getElementById('total-items').textContent = totalItems + ' item' + (totalItems === 1 ? '' : 's') + ' * RM 30';
        document.getElementById('shipping-total').textContent = "RM " + shippingTotal.toFixed(2);
        document.getElementById('final-total').textContent = "RM " + finalTotal.toFixed(2);

        // Hide checkout button if cart is empty
        const checkoutBtn = document.querySelector('.bg-black.text-white');
        if (rows.length === 0) {
            checkoutBtn.classList.add('hidden');
        } else {
            checkoutBtn.classList.remove('hidden');
        }
    }

    
    //Change shipping address
    let selectedAddress = null;

    function showAddressModal() {
        const current = document.getElementById('shipping-address').textContent.trim();
        selectedAddress = current;

        document.getElementById('addressModal').classList.remove('hidden');
        document.getElementById('addressModal').classList.add('flex');
        
        // Pre-highlight the current address
        document.querySelectorAll('.selectable-address').forEach(item => {
            const addressText = item.querySelector('p.text-sm').textContent.trim();

            if (addressText === current) {
                item.classList.add('!border-darkYellow', 'text-darkYellow');
            } else {
                item.classList.remove('!border-darkYellow', 'text-darkYellow');
            }
        });
    }

    function closeAddressModal() {
        document.getElementById('addressModal').classList.add('hidden');
        document.getElementById('addressModal').classList.remove('flex');

        // Remove visual highlights
        document.querySelectorAll('.selectable-address').forEach(item => {
            item.classList.remove('!border-darkYellow', 'text-darkYellow');
        });

        selectedAddress = null;
    }

    document.querySelectorAll('.selectable-address').forEach(item => {
        item.addEventListener('click', () => {
            // Clear previous selection
            document.querySelectorAll('.selectable-address').forEach(div => {
            div.classList.remove('!border-darkYellow', 'text-darkYellow');
            });

            // Highlight selected one
            item.classList.add('!border-darkYellow', 'text-darkYellow');
            selectedAddress = item.querySelector('p.text-sm').textContent.trim();
        });
    });

    document.getElementById('confirmAddress').addEventListener('click', () => {
        if (selectedAddress) {
            document.getElementById('shipping-address').textContent = selectedAddress;
        }
        closeAddressModal();
    });

    function redirectToAccount() {
        window.location.href = './index.html'; // change this to your target URL
    }

    // continue shopping
    function redirectShopping(){
        window.location.href = './index.html';
    }


    // Init on page load
    document.addEventListener('DOMContentLoaded', updateCartSummary);
</script>
  
</html>