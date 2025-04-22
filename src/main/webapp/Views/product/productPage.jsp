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


        <div class="grid grid-cols-1 md:grid-cols-7 gap-4 bg-white">

            <!-- Image Gallery -->
            <div class="order-1 md:col-span-4">
                <div class="swiper mySwiper2 w-full h-[300px] sm:h-[600px] md:h-[1000px] rounded-lg" style="--swiper-navigation-color: #fff; --swiper-pagination-color: #fff">
                    <div class="swiper-wrapper">
                        <% for (int i = 1; i <= 10; i++) { %>
                            <div class="swiper-slide">
                                <img src="/src/cupboard.avif" alt="Nature <%= i %>" class="w-full h-full object-cover" />
                            </div>
                        <% } %>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>

                <div class="swiper mySwiper w-full h-[80px] sm:h-[100px] md:h-[150px] mt-4" thumbsSlider="">
                    <div class="swiper-wrapper">
                        <% for (int i = 1; i <= 10; i++) { %>
                            <div class="swiper-slide">
                                <img src="/src/cupboard.avif" alt="Thumbnail <%= i %>" class="w-full h-full object-cover rounded-lg" />
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Product Details -->
            <%
                productVariationOptions options = (productVariationOptions) request.getAttribute("variationOptions");
            %>
            <div class="order-2 md:col-span-3 md:sticky md:top-[30px] h-fit ">
                <div class="p-4 lg:p-6 rounded-lg shadow-md">
                    <h1 class="text-2xl font-bold text-left mb-4"><%= product.getTitle() %></h1>

                    <% if (options != null && options.getOptions() != null) { %>
                        <% for (Map.Entry<String, List<String>> entry : options.getOptions().entrySet()) { %>
                            <div class="mb-4">
                                <h2 class="text-xl font-semibold capitalize"><%= entry.getKey() %></h2>
                                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 mt-2">
                                    <% for (String value : entry.getValue()) { %>
                                        <button class="py-2 px-4 bg-gray-200 rounded"><%= value %></button>
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
                        <div class="flex items-center border rounded overflow-hidden">
                            <div class="text-md px-4 bg-gray-200"><i class="fa-solid fa-minus"></i></div>
                            <span class="px-4">1</span>
                            <div class="text-md px-4 bg-gray-200"><i class="fa-solid fa-plus"></i></div>
                        </div>
                        <div class="text-sm text-gray-600 italic font-bold">
                            <span>Stock: <%= product.getStock() %></span>
                        </div>
                    </div>

                    <!-- Add to Cart Button -->
                    <div class="text-center my-4">
                        <button class="bg-yellow-400 text-white py-3 px-12 rounded-full font-bold w-full md:w-1/2">Add</button>
                    </div>
                </div>
            </div>

            <!-- Description & Reviews -->
            <div class="order-3 md:col-span-4 pt-6">
                <div>
                    <h1 class="text-3xl font-bold mb-4">Description</h1>
                    <p class="mb-4 text-lg"><%= product.getDescription() %></p>
                    <hr class="mb-4">
                </div>
                

                <!-- Reviews -->
                <div class="pt-6">
                    <h1 class="text-2xl font-bold">Reviews</h1>
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

        <!-- Feature Products -->
        <div class="pt-3">
            <h2 class="text-2xl font-bold mb-6">Popular accessories</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <div class="shadow rounded-lg">
                    <div class="relative">
                        <img src="/src/cupboard.avif" alt="Accessory" class="w-full h-full object-cover rounded-md">
                        <span class="absolute top-0 right-0 bg-red-500 text-white text-sm font-semibold m-2 px-2 py-1 rounded">Top seller</span>
                    </div>
                    <div class="p-4">
                        <h3 class="text-md font-semibold">Accessory Name</h3>
                        <p class="text-lg font-bold text-yellow-600">RM6</p>
                        <div class="flex justify-between items-center mt-2">
                            <span>★★★★☆ (272)</span>
                            <i class="fa-solid fa-cart-shopping text-blue-500"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/Views/Shared/Footer.jsp" %>
    <%@ include file="/Views/product/updateProduct.jsp" %>


    <script>
        var swiper = new Swiper(".mySwiper", {
            loop: true,
            spaceBetween: 10,
            slidesPerView: 4,
            freeMode: true,
            watchSlidesProgress: true,
        });

        var swiper2 = new Swiper(".mySwiper2", {
            loop: true,
            spaceBetween: 10,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
            thumbs: {
                swiper: swiper,
            },
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
        
        document.addEventListener('DOMContentLoaded', function() {
            const params = new URLSearchParams(window.location.search);
            if (params.get('updated') === '1') {
                alert('✅ Product updated successfully!');
                params.delete('updated');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
            if (params.get('deleted') === '1') {
                alert('❌ Product deleted successfully!');
                params.delete('deleted');
                history.replaceState(null, '', window.location.pathname + (params.toString() ? '?' + params : ''));
            }
        });


    



    </script>
</body>

</html>