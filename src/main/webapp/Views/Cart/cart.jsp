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
<%@ page import="Models.Accounts.ShippingInformation" %>
<%@ page import="mvc.Helpers.Helpers" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<body class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
<%@ include file="/Views/Shared/Header.jsp" %>

    <div class="content-wrapper">

        <h1 class="font-poppins font-bold text-3xl my-8">Cart</h1>

        <div class="flex gap-8 items-start">
            <!-- LEFT: Cart Items -->
            <div class="basis-2/3" id="cart-items-container">
            
                <% 
                    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    List<ShippingInformation> shippingAddresses = (List<ShippingInformation>) request.getAttribute("shippingAddresses");
                

                    if(cartItems != null && !cartItems.isEmpty()){ %>
                <!-- Header Row -->
                <div class="grid grid-cols-10 border-b border-grey3 text-lg font-dmSans font-semibold py-6">
                    <div class="col-span-5">Product</div>
                    <div class="col-span-2 text-center">Quantity</div>
                    <div class="col-span-2 text-center">Subtotal</div>
                    <div class="col-span-1 text-center"></div>
                </div>
                 <!-- Product List -->
                <%
                    for(CartItem item : cartItems){  %>
                    

              <div class="grid grid-cols-10 border-b border-grey2 text-lg font-dmSans py-4 items-center product-row" data-price="<%= item.getProduct().getPrice() %>" data-product-id="<%= item.getProduct().getId() %>" data-cart-id="<%= item.getCart().getId() %>" data-variation="<%= StringEscapeUtils.escapeHtml4(item.getSelectedVariation()) %>">
                <div class="col-span-5">
                    <div class="flex gap-4">
                        <img src="<%= item.getProduct().getImageUrl() %>" alt="<%= item.getProduct().getTitle() %>" class="w-[100px] h-[100px] object-cover rounded-lg">
                        <div class="flex flex-col justify-between">
                            <div class="flex flex-col">
                                <p class="font-medium text-md lineClamp-2"><%= item.getProduct().getTitle() %></p>
                                <p class="font-normal text-sm"><%= item.getProduct().getTypeId().gettype() %></p>
                                
                                <p class="text-sm font-normal">
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
              
                <div class="flex flex-col gap-2 text-md font-dmSans py-4">
                  <p class="font-medium">Subtotal</p>
                  <div class="flex justify-between text-md font-dmSans">
                    <p class="font-normal" id="total-items">0 item</p>
                    <p class="font-normal" id="cart-total">RM 0.00</p>
                  </div>
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
                        <% if(shippingAddresses != null && !shippingAddresses.isEmpty()){ 
                            for(ShippingInformation address : shippingAddresses){
                                if(address.isDefault()){ %>
                                <div class="flex flex-col justify-center pl-2" id="default-shipping-address">
                                    <p class="text-sm font-medium" id="label"><%= Helpers.escapeString(address.getLabel()) %></p>
                                    <p class="text-sm" id="receiverName"><%= Helpers.escapeString(address.getReceiverName()) %></p>
                                    <p class="text-sm" id="address1"><%= Helpers.escapeString(address.getAddressLine1()) %></p>
                                    <p class="text-sm" id="address2"><%= address.getAddressLine2() != null ? Helpers.escapeString(address.getAddressLine2()) : "" %></p>
                                    <p class="text-sm" id="postcodeState"><%= address.getPostCode() %> <%= address.getState() %></p>
                                    <p class="text-sm" id="phoneNo"><%= address.getPhoneNumber() %></p>
                                </div>
                                <% } 
                            }%>
                            <div class="flex flex-col justify-center hidden pl-2" id="selected-shipping-address">
                                
                            </div>
                        <% } else { %>
                            <p class="text-sm">No saved addresses yet.</p>
                        <% } %>
                    </div>

                    <% if(shippingAddresses != null && !shippingAddresses.isEmpty()){ %>
                        <button class="w-fit text-sm hover:text-darkYellow transition-colors duration-200 ease-in-out cursor-pointer" onClick="showAddressModal()">
                            Change Address
                        </button>
                    <% } else { %>
                        <button class="w-fit text-sm hover:text-darkYellow transition-colors duration-200 ease-in-out cursor-pointer" onClick="redirectToAccount()">
                            Add New Address
                        </button>
                    <% } %>
                    
                    
                </div>

                <hr>

                <div class="flex justify-between text-md font-dmSans py-4">
                    <p class="font-medium">Total</p>
                    <p class="font-normal" id="final-total">RM 0.00</p>
                </div>
                
                <div class="flex flex-col gap-2">
                    <button class="bg-white text-black border border-black font-bold py-2 px-4 rounded hover:border-darkYellow hover:text-darkYellow transition-colors duration-200 ease-in-out mt-auto" onClick="redirectShopping()">Continue Shopping</button>
                    <button class="bg-black text-white font-bold py-2 px-4 rounded hover:bg-darkYellow transition-colors duration-200 ease-in-out mt-auto" onClick="submitCheckout()">Proceed to Checkout</button>
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

            <% if(shippingAddresses != null && !shippingAddresses.isEmpty()){ %>
            <div class="grid-cols-3 grid gap-4 max-h-[280px] overflow-y-auto">
                <% for(ShippingInformation address : shippingAddresses){ %>
                <div class="p-4 border border-grey3 rounded-md cursor-pointer selectable-address hover:text-darkYellow hover:border-darkYellow select-none">
                    <div class="flex flex-col justify-center address-info">
                        <p class="font-medium text-md" id="label"><%= Helpers.escapeString(address.getLabel()) %></p>
                        <p class="text-sm" id="receiverName"><%= Helpers.escapeString(address.getReceiverName()) %></p>
                        <p class="text-sm" id="address1"><%= Helpers.escapeString(address.getAddressLine1()) %></p>
                        <p class="text-sm" id="address2"><%= address.getAddressLine2() != null ? Helpers.escapeString(address.getAddressLine2()) : "" %></p>
                        <p class="text-sm" id="postcodeState"><%= address.getPostCode() %> <%= address.getState() %></p>
                        <p class="text-sm" id="phoneNo"><%= address.getPhoneNumber() %></p>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
                <div class="text-center py-6 text-gray-500">
                    <p>No saved addresses yet.</p>
                </div>
            <% } %>

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

    <!-- Hidden Form for Checkout -->
    <form id="checkout-form" method="POST" action="<%= request.getContextPath() %>/Cart/checkout" enctype="multipart/form-data">
        <input type="hidden" name="label" />
        <input type="hidden" name="receiverName" />
        <input type="hidden" name="phoneNumber" />
        <input type="hidden" name="state" />
        <input type="hidden" name="postCode" />
        <input type="hidden" name="addressLine1" />
        <input type="hidden" name="addressLine2" />
        <input type="hidden" name="isDefault" />
    </form>


    <script>
        const userId = 1; // change to session userId

        function refreshCartItems() {
            console.log("Refreshing cart items...");
            $.ajax({
                url: '<%= request.getContextPath() %>/Cart/getCartItems',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ userId: userId }),
                success: function(response) {
                    try {
                        const parsed = typeof response.data === 'string'
                            ? JSON.parse(response.data)
                            : response.data;

                        // Check for valid data before modifying DOM
                        if (!parsed || !Array.isArray(parsed.cart_items)) {
                            console.warn("Unexpected cart data:", parsed);
                            return; // ❌ Do nothing to UI if invalid
                        }

                        const container = document.querySelector('#cart-items-container');
                        container.innerHTML = ''; // Clear old items

                        if (parsed.cart_items.length > 0) {
                            container.insertAdjacentHTML('beforeend', getCartHeaderRow());

                            parsed.cart_items.forEach(item => {
                                container.insertAdjacentHTML('beforeend', renderCartRow(item));
                            });

                            watchQtyChanges();
                            updateCartSummary();
                        } else {
                            container.innerHTML = `
                                <div class="text-center py-6 text-gray-500">
                                    <p>No item in cart.</p>
                                </div>`;
                            updateCartSummary();
                        }
                    } catch (err) {
                        console.error("Error parsing cart response:", err);
                        // ❌ Don't touch DOM if something fails here
                    }
                },
                error: function(error) {
                    console.error("Error refreshing cart:", error);
                    // ❌ Also don't touch the DOM on HTTP error
                }
            });
        }


        document.addEventListener('DOMContentLoaded', function () {
            updateCartSummary();
            watchQtyChanges();
        });

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
                closeDeleteModal();
            }
        });

        function watchQtyChanges() {
            const qtyElements = document.querySelectorAll('.product-row .qty');

            qtyElements.forEach(qtyEl => {
                const observer = new MutationObserver(() => {
                    updateCartSummary(); // Automatically update when qty text is changed
                });

                observer.observe(qtyEl, {
                    childList: true,
                    characterData: true,
                    subtree: true
                });
            });
        }

        function removeProduct(icon) {
            const row = icon.closest('.product-row');
            const cartId = parseInt(row.dataset.cartId);
            const productId = parseInt(row.dataset.productId);
            const variation = row.dataset.variation;

            if (row) {
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
                        console.log('Item deleted successfully:', response);
                        // Optionally, refresh the cart items after deletion
                        row.remove();
                        updateCartSummary();
                    },
                    error: function (error) {
                        console.error('Error deleting item:', error);
                    }
                });
            }
        }

        //Update product quantity, cart subtotals/total
        function changeQty(btn, delta) {
            const row = btn.closest('.product-row');
            const qtyEl = row.querySelector('.qty');
            const oldQty = parseInt(qtyEl.textContent);
            const cartId = parseInt(row.dataset.cartId);
            const productId = parseInt(row.dataset.productId);
            const variation = row.dataset.variation;

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
                    console.log('Quantity updated successfully:', response);
                    console.log("qtyEl found?", qtyEl);
                    const parsedJson = JSON.parse(response.data);
                    console.log("New quantity:", parsedJson.quantity);
                    qtyEl.textContent = parsedJson.quantity; // Update displayed quantity

                    updateCartSummary();

                },
                error: function(xhr, status, error) {
                    qtyEl.textContent = oldQty; // Revert to old quantity on error
                    console.error('Error updating quantity:', error);
                }
            }); 
            

            
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

            const defaultShipping = 25;
            let shippingTotal = defaultShipping;
            if (subtotal > 1000){
                shippingTotal = 0;
            }
            const finalTotal = subtotal + shippingTotal;

            // Update right side display
            document.getElementById('cart-total').textContent = "RM " + subtotal.toFixed(2);
            document.getElementById('total-items').textContent = totalItems + ' item' + (totalItems === 1 ? '' : 's');
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
        let selectedAddressHTML = null;

        function showAddressModal() {
            const defaultBlock = document.getElementById('default-shipping-address');
            const selectedBlock = document.getElementById('selected-shipping-address');

            // Determine active visible block
            let activeAddressBlock = !defaultBlock.classList.contains('hidden') 
                ? defaultBlock 
                : selectedBlock;

            // Safeguard in case nothing exists yet
            if (!activeAddressBlock) return;

            // Extract full address text for matching
            const currentAddress = Array.from(activeAddressBlock.querySelectorAll('p'))
                .map(p => p.textContent.trim())
                .join(' ')
                .replace(/\s+/g, ' ')
                .toLowerCase();

            // Show modal
            document.getElementById('addressModal').classList.remove('hidden');
            document.getElementById('addressModal').classList.add('flex');

            // Match against selectable-address blocks
            document.querySelectorAll('.selectable-address').forEach(item => {
                const addressText = Array.from(item.querySelectorAll('p'))
                    .map(p => p.textContent.trim())
                    .join(' ')
                    .replace(/\s+/g, ' ')
                    .toLowerCase();

                if (addressText === currentAddress) {
                    item.classList.add('!border-darkYellow', 'text-darkYellow');
                } else {
                    item.classList.remove('!border-darkYellow', 'text-darkYellow');
                }
            });
        }



        function closeAddressModal() {
            document.getElementById('addressModal').classList.add('hidden');
            document.getElementById('addressModal').classList.remove('flex');
            selectedAddressHTML = null;
        }

        document.querySelectorAll('.selectable-address').forEach(item => {
            item.addEventListener('click', () => {
                // Clear previous highlights
                document.querySelectorAll('.selectable-address').forEach(div => {
                    div.classList.remove('!border-darkYellow', 'text-darkYellow');
                });

                // Highlight selected card
                item.classList.add('!border-darkYellow', 'text-darkYellow');

                // Clone the address-info block
                const cloned = item.querySelector('.address-info').cloneNode(true);

                // Change the class of the first <p> from text-md to text-sm
                const firstP = cloned.querySelector('p');
                if (firstP) {
                    firstP.classList.remove('text-md');
                    firstP.classList.add('text-sm');
                }

                // Convert updated DOM back to string
                selectedAddressHTML = cloned.innerHTML;
            });
        });

        document.getElementById('confirmAddress').addEventListener('click', () => {
            if (selectedAddressHTML) {
                const defaultBlock = document.getElementById('default-shipping-address');
                const selectedBlock = document.getElementById('selected-shipping-address');

                defaultBlock.classList.add('hidden');
                selectedBlock.classList.remove('hidden');

                // Insert with same structure
                selectedBlock.innerHTML = selectedAddressHTML;
            }

            closeAddressModal();
        });


        function redirectToAccount() {
            window.location.href = '<%= request.getContextPath() %>/User/account#addresses'; // change this to your target URL
        }

        // continue shopping
        function redirectShopping(){
            window.location.href = '<%= request.getContextPath() %>/product/productCatalog'; // change this to your target URL
        }

        function getCartHeaderRow() {
            return `
                <div class="grid grid-cols-10 border-b border-grey3 text-lg font-dmSans font-semibold py-6">
                    <div class="col-span-5">Product</div>
                    <div class="col-span-2 text-center">Quantity</div>
                    <div class="col-span-2 text-center">Subtotal</div>
                    <div class="col-span-1 text-center"></div>
                </div>`;
        }

        function renderCartRow(item) {
            const variationStr = JSON.stringify(item.selected_variation).replace(/"/g, '&quot;');
            const variation = JSON.parse(item.selected_variation || '{}');
            const variationText = Object.entries(variation).map(function(pair) {
                return pair[0] + ": " + pair[1];
            }).join(', ');

            return (
                '<div class="grid grid-cols-10 border-b border-grey2 text-lg font-dmSans py-4 items-center product-row"' +
                    ' data-price="' + item.product_price + '" data-product-id="' + item.product_id + '" data-cart-id="' + item.cart_id + '" data-variation="' + item.selected_variation + '">' +
                    '<div class="col-span-5">' +
                        '<div class="flex gap-4">' +
                            '<img src="' + item.product_img + '" alt="Product" class="w-[100px] h-[100px] object-cover rounded-lg">' +
                            '<div class="flex flex-col justify-between">' +
                                '<div class="flex flex-col">' +
                                    '<p class="font-medium text-md lineClamp-2">' + item.product_name + '</p>' +
                                    '<p class="text-sm font-normal">' + variationText + '</p>' +
                                '</div>' +
                                '<p class="text-sm font-normal">RM' + item.product_price.toFixed(2) + '</p>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-span-2 text-center flex justify-center">' +
                        '<div class="flex items-center justify-between w-28 border border-black rounded select-none">' +
                            '<button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(this, -1)">−</button>' +
                            '<span class="text-lg font-medium qty">' + item.quantity + '</span>' +
                            '<button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(this, +1)">+</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-span-2 text-center subtotal">RM0.00</div>' +
                    '<div class="col-span-1 flex justify-center">' +
                        '<div class="w-fit hover:text-red-500 cursor-pointer transition-all duration-200 ease-in-out">' +
                            '<i class="fa-solid fa-trash" onclick="showDeleteModal(this)"></i>' +
                        '</div>' +
                    '</div>' +
                '</div>'
            );
        }

        function submitCheckout() {
            const selectedBlock = document.getElementById('selected-shipping-address');
            const defaultBlock = document.getElementById('default-shipping-address');
            const activeBlock = !selectedBlock.classList.contains('hidden') ? selectedBlock : defaultBlock;

            if (!activeBlock) {
                alert("No address selected.");
                return;
            }

            // Extract values
            const form = document.getElementById('checkout-form');
            form.label.value = activeBlock.querySelector('#label')?.textContent.trim() || '';
            form.receiverName.value = activeBlock.querySelector('#receiverName')?.textContent.trim() || '';
            form.phoneNumber.value = activeBlock.querySelector('#phoneNo')?.textContent.trim() || '';
            const stateText = activeBlock.querySelector('#postcodeState')?.textContent.trim() || '';
            form.state.value = stateText.split(' ').slice(1).join(' ');
            form.postCode.value = stateText.split(' ')[0];
            form.addressLine1.value = activeBlock.querySelector('#address1')?.textContent.trim() || '';
            form.addressLine2.value = activeBlock.querySelector('#address2')?.textContent.trim() || '';
            form.isDefault.value = selectedBlock.classList.contains('hidden') ? true : false;

            form.submit(); // 🔄 Submits like a normal POST that your controller maps
        }






        window.addEventListener('cart:changed', function () {
            refreshCartItems();
        });
    </script>
</body>

  
</html>