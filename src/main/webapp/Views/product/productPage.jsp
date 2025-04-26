<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Products.productVariationOptions" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productFeedback" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="java.util.Map, java.util.List" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Page</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<%@ include file="/Views/Shared/Header.jsp" %>


<body>

    <%
        product product = (product) request.getAttribute("product");

    %>
    <div class="content-wrapper">
            <div class="flex justify-end space-x-4 mb-4">
                <!-- Update Button -->

                <!-- for the update and delete button, we need to pass the product-->


                <button  onclick="openeditModal()" class="bg-black rounded-full text-white py-2 px-6 font-bold hover:bg-yellow-400">
                    Update
                </button>
                
                <!-- Delete Button -->
                <form action="<%= request.getContextPath() %>/product/deleteProduct" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <button type="submit" class="bg-black rounded-full text-white py-2 px-6 font-bold hover:bg-yellow-400">
                        Delete
                    </button>
                </form>
            </div>


        <div class="grid grid-cols-1 md:grid-cols-6 gap-8 bg-white">

            <!-- Image Gallery -->
            <div class="order-1 md:col-span-3">
                <div class="relative overflow-hidden rounded-lg">
                   
                    <img loading="lazy" src="<%=request.getContextPath()%>/File/Content/product/retrieve?id=<%=product.getImage().getId()%>"
                        alt="<%=product.getTitle()%>" class="w-full h-auto object-cover rounded-lg"/>
                </div>

               
            </div>

            <!-- Product Details -->
            <%
                productVariationOptions options = (productVariationOptions) request.getAttribute("variationOptions");
            %>
            <div class="order-2 md:col-span-3 md:sticky md:top-[30px] h-fit ">
                <div class="p-4 lg:p-6 rounded-lg mhc-box-shadow">
                    <h1 class="text-2xl font-bold text-left mb-4"><%= product.getTitle() %></h1>

                    <% if (options != null && options.getOptions() != null) { %>
                        <% for (Map.Entry<String, List<String>> entry : options.getOptions().entrySet()) { %>
                            <div class="mb-4">
                                <h2 class="text-xl font-semibold capitalize"><%= entry.getKey() %></h2>
                                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 mt-2">
                                    <% for (String value : entry.getValue()) { %>
                                        <button class="py-2 px-4 bg-gray-200 rounded variation-btn hover:bg-gray-300 transition duration-200" 
                                            data-option="<%= entry.getKey() %>" data-value="<%= value %>">
                                            <%= value %>
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>No variation options available.</p>
                    <% } %>

                    <!-- Price and Stock -->
                    <div class="mt-6">
                        <p class="text-2xl font-bold">RM <%= String.format("%.2f", product.getPrice()) %></p>
                        <p class="text-sm text-gray-600">(unit: RM <%= String.format("%.2f", product.getPrice()) %>)</p>
                    </div>

                    <div class="flex items-center justify-between my-4">
                        <div class="flex items-center justify-between w-28 border border-black rounded select-none">
                            <button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(-1)">−</button>
                            <span class="text-lg font-medium qty">1</span>
                            <button class="px-4 py-1 text-lg font-light hover:bg-darkYellow hover:text-white" onclick="changeQty(+1)">+</button>
                        </div>

                        <div class="text-sm text-gray-600 italic font-bold">
                            <span>Stock: <%= product.getStock() %></span>
                        </div>
                    </div>

                    <!-- Add to Cart Button -->
                    <div class="text-center my-4">
                        <button class="bg-yellow-400 text-white py-3 px-12 rounded-full font-bold w-full md:w-1/2" onClick="addToCart()">Add to Cart</button>
                    </div>
                </div>
            </div>

            <!-- Description & Reviews -->
            <div class="order-3 md:col-span-3 pt-6">
                
                <h1 class="text-3xl font-bold mb-4">Description</h1>
                <p class="mb-4 text-lg lineClamp-3"><%= product.getDescription() %></p>
                <hr class="mb-4 border border-gray-150 border-b-0" />
                

                <!-- Reviews -->
                <div class="pt-6">
                    <%
                        List<productFeedback> feedbackList = (List<productFeedback>) request.getAttribute("feedbackList");
                        if (feedbackList != null && !feedbackList.isEmpty()) {
                            int totalRating = 0;
                            for (productFeedback fb : feedbackList) {
                                totalRating += fb.getRating();
                            }
                            // total rating / how many feedback form
                            float averageRating = (float) totalRating / feedbackList.size();

                    %>
                        <h1 class="text-2xl font-bold">Reviews</h1>

                        <h2 class="text-xl font-semibold mb-6">
                            Overall Rating:
                            <span class="text-yellow-400">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <%= (i <= Math.floor(averageRating)) ? "<i class='fa-solid fa-star'></i>" : "<i class='fa-regular fa-star'></i>" %>
                                <% } %>
                            </span>
                            <%= String.format("%.1f", averageRating) %> (<%= feedbackList.size() %>)
                        </h2>

                      <div class="bg-white rounded-lg space-y-6">
                        <% for (productFeedback feedback : feedbackList) { %>
                            <!-- Entire comment + reply lives inside one bordered box -->
                            <div class="border-b pb-4">
                            <!-- 1) Original user feedback -->
                            <h3 class="font-bold">
                                <%= feedback.getOrder().getUser().getUsername() %>
                            </h3>                            
                            <p class="text-yellow-400">
                                <% for (int i = 1; i <= 5; i++) { %>
                                <%= (i <= feedback.getRating()) ? "<i class='fa-solid fa-star'></i>" : "<i class='fa-regular fa-star'></i>" %>
                                <% } %>
                            </p>
                            <p><%= feedback.getComment() %></p>
                            <p class="text-sm text-gray-600"><%= feedback.getFeedbackDate() %></p>

                            
                            <% if (feedback.getReply() != null && !feedback.getReply().isEmpty()) { %>
                                <!-- Already replied: show reply + date -->
                                <div class="mt-2">
                                    Reply : 
                                    <div class="reply-text mb-1"><%= feedback.getReply() %></div>
                                    <div class="reply-date text-xs text-gray-500"><%= feedback.getReplyDate() %></div>
                                </div>
                            <% } else { %>
                                <!-- No reply yet: show reply icon + inline form -->
                                <div class="mt-2">
                                <i
                                    class="fa-solid fa-reply cursor-pointer text-black-300"
                                    onclick="toggleReplyForm(this)"
                                    title="Reply to this comment"
                                ></i>

                                <form
                                    action="<%=request.getContextPath()%>/product/feedback/reply"
                                    method="post"
                                    class="inline-reply-form hidden mt-2 space-y-2"
                                >
                                    <input type="hidden" name="productId" value="<%= feedback.getProductId() %>"/>
                                    <input type="hidden" name="orderId"   value="<%= feedback.getOrderId()   %>"/>
                                    <input type="hidden" name="createdAt"   value="<%= feedback.getCreatedAt()   %>"/>

                                    <label class="block text-sm font-semibold">Your reply:</label>
                                    <textarea
                                    name="reply"
                                    rows="2"
                                    placeholder="Type your reply…"
                                    class="w-full border border-gray-300 rounded px-3 py-1 focus:outline-none focus:ring-2 focus:ring-blue-400"
                                    required
                                    ></textarea>

                                    <button
                                    type="submit"
                                    class="bg-yellow-400 hover:bg-green-600 text-white px-4 py-1 rounded text-sm transition-colors"
                                    >
                                    Send
                                    </button>
                                </form>
                                </div>
                            <% } %>
                            </div>
                        <% } %>
                        </div>

                        
                        




                    <% }  %>
                        
                </div>
            </div>
        </div>


        <% List<product> productFeatured = (List<product>) request.getAttribute("featuredProducts"); %>
        <!-- Feature Products -->
        <div class="pt-3">
            <h2 class="text-2xl font-bold mb-6">Featured Products</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <% if (productFeatured != null && !productFeatured.isEmpty()) {
                for (product p : productFeatured) {
            %>
            <div class="bg-white rounded-lg overflow-hidden cursor-pointer relative" onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= p.getId() %>')">
                <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">Featured</div>
                <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= p.getImage().getId() %>" alt="<%= p.getTitle() %>" class="w-[350px] h-[260px] object-cover cursor-pointer">
                <div class="p-3 cursor-pointer hover:bg-grey1">
                    <h3 class="font-medium"><%= p.getTitle() %></h3>
                    <p class="text-xs text-gray-500"><%= p.getTypeId().gettype() %></p>
                    <div class="flex justify-between items-center mt-2">
                    <span class="font-bold">RM <%= String.format("%.2f", p.getPrice()) %></span>
                    <div class="flex items-center text-xs text-gray-500">
                        <i class="fas fa-box mr-1"></i>
                        <span><%= p.getStock() %> left</span>
                    </div>
                    </div>
                </div>
            </div>
            <% } } %>
            </div>
        </div>
    </div>

    <%@ include file="/Views/Shared/Footer.jsp" %>
    <%@ include file="/Views/product/updateProduct.jsp" %>


    


    <script>

        const maxQuantity = <%= product.getStock() %>;
        const selectedVariations = {};

        const qtySpan = document.querySelector('.qty');
        let currentQty = parseInt(qtySpan.textContent) || 1;

        document.querySelectorAll('.variation-btn').forEach(button => {
            button.addEventListener('click', () => {
                const option = button.dataset.option;
                const value = button.dataset.value;

                // Save selected value
                selectedVariations[option] = value;

                // Clear previous selections for this option
                document.querySelectorAll(`.variation-btn[data-option="`+ option +`"]`).forEach(btn => {
                    btn.classList.remove('bg-darkYellow', 'text-white');
                    btn.classList.add('bg-gray-200');
                });

                // Highlight selected button
                button.classList.remove('bg-gray-200');
                button.classList.add('bg-darkYellow', 'text-white');

                console.log("Selected variations:", selectedVariations);
            });
        });

        function getAvailableVariations() {
            const availableVariations = {};

            // Collect variation data
            document.querySelectorAll('.variation-btn').forEach(button => {
                const option = button.dataset.option;
                const value = button.dataset.value;

                // Populate the available variations
                if (!availableVariations[option]) {
                    availableVariations[option] = [];
                }
                availableVariations[option].push(value);
            });

            return availableVariations;
        }

        function checkVariationsSelected() {
            const availableVariations = getAvailableVariations();
            let allKeysSelected = true;

            // Check if each variation type has at least one selected option
            for (const option in availableVariations) {
                if (!selectedVariations[option]) {
                    allKeysSelected = false;
                    break; // Stop if any option is not selected
                }
            }

            if (!allKeysSelected) {
                alert("Please select a value for all variations.");
                return false;
            }
            return true;
        }



        function changeQty(delta) {
            
            currentQty += delta;
            
            // Enforce bounds
            if (currentQty < 1) currentQty = 1;
            if (currentQty >= maxQuantity) currentQty = maxQuantity;

            // Update the display
            qtySpan.textContent = currentQty;
        }

        function addToCart() {
            // First, check if all variation keys are selected
            if (!checkVariationsSelected()) {
                return; // Stop if any variation is not selected
            }

            const selectedVariationsJson = JSON.stringify(selectedVariations);

            $.ajax({
                url: '<%= request.getContextPath() %>/Cart/addToCartById',
                type: 'POST',
                data: JSON.stringify({
                    productId: <%= product.getId() %>,
                    quantity: currentQty,
                    selectedVariation: selectedVariationsJson
                }),
                contentType: 'application/json',
                success: function(response) {
                    const parsedJson = JSON.parse(response.data);
                    if (parsedJson.addToCart_success) {
                        alert('✅ Product added to cart successfully!');
                        window.location.href = "<%= request.getContextPath() %>/Cart/cart";
                    } else {
                        alert('❌ Failed to add product to cart: ' + parsedJson.error_msg);
                    }

                },
                error: function(xhr, status, error) {
                    console.error('Error adding to cart:', error);
                    alert('❌ An error occurred while adding the product to the cart.');
                }
            });

            
        }

        var swiper = new Swiper(".mySwiper", {
            loop: true,
            spaceBetween: 10,
            slidesPerView: 4,
            freeMode: true,
            watchSlidesProgress: true,
        });

        function openeditModal() {
            const m = document.getElementById("editProductModal");
            m.classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }
        function closeeditModal() {
            const m = document.getElementById("editProductModal");
            m.classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

    

        function toggleReplyForm(icon) {
            // Assumes the <form> is the very next sibling
            const form = icon.nextElementSibling;
            form.classList.toggle('hidden');
            if (!form.classList.contains('hidden')) {
            form.querySelector('textarea').focus();
            }
        }
        
       

    



    </script>
</body>

</html>