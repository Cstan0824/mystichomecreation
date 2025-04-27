<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mystichome Creations</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    
</head>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="Models.Products.productFeedback" %>
<%@ page import="Models.Orders.OrderStatus" %>
<%@ page import="mvc.Helpers.Helpers" %>

<body class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
<%@ include file="/Views/Shared/Header.jsp" %>

    <%

        List<product> bestSellers = (List<product>) request.getAttribute("bestSellers");
        List<product> newProducts = (List<product>) request.getAttribute("newProducts");
        List<product> randomProducts = (List<product>) request.getAttribute("randomProducts");
        List<productType> productTypes = (List<productType>) request.getAttribute("productTypes");
        List<productFeedback> feedbacks = (List<productFeedback>) request.getAttribute("feedbacks");

    %>
    <!-- Carousel -->
    <div class="w-full flex flex-col">
        <!-- Video -->
        <div class="relative h-full max-h-[640px]">
            <video class="w-full h-full" autoplay loop muted playsinline>
                <source src="<%= request.getContextPath() %>/Content/assets/video/carousel-video.mp4" type="video/mp4">
                <img src="<%= request.getContextPath() %>/Content/assets/image/carousel-banner.avif" alt="carousel-image">
            </video>
    
            <!-- Overlay (Matches Video Height) -->
            <div class="absolute inset-0 font-poppins max-h-full bg-black bg-opacity-20 flex justify-center items-center px-36 lg:px-20">
                <div class="text-white text-center">
                    <h1 class="text-6xl font-bold drop-shadow-lg">MysticHome Creations</h1>
                    <p class="text-lg font-bold drop-shadow-lg">Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.</p>
                    <button class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out text-lg px-4 py-2 rounded-full mt-4" onCLick="getStartNavigation()">Get Started</button>
                </div>
            </div>
        </div>
        <div class="bg-lightMidYellow">
            <div class="content-wrapper !my-0 flex justify-center gap-3 !p-6">
                <div class="flex justify-between items-center gap-2">
                    <i class="fa-solid fa-truck"></i>
                    <p class="font-dmSans text-md">Fast delivery</p>
                </div>
                <div class="flex justify-between items-center gap-2">
                    <i class="fa-solid fa-calendar-days"></i>
                    <p class="font-dmSans text-md">14-days free return</p>
                </div>
                <div class="flex justify-between items-center gap-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <p class="font-dmSans text-md">World-class warranty</p>
                </div>
            </div>
        </div>
    </div>
        

    <!-- Category -->
    <div id="categories" class="content-wrapper flex flex-col">
        <div class="pb-8 flex justify-between items-center">
            <div class="flex gap-2 items-center">
                <h1 class="text-4xl font-bold text-poppins">Categories</h1>
            </div>
            
            <div class="flex justify-end items-center gap-2 select-none">
                <div class="flex justify-between items-center border-2 border-gray-100 rounded-lg">
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center category-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center item-center category-next">
                        <span class="text-lg">></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper category-swiper content-wrapper !my-0">
            <div class="swiper-wrapper pb-10">
                <%  for (productType pType : productTypes) {
                        for (product product : randomProducts) {
                            if(product.getTypeId().getId() == pType.getId()) { %>
                
                                <div class="swiper-slide w-full cursor-pointer bg-white hover:bg-grey1 transition-colors ease-in-out duration-200 rounded-lg overflow-hidden" onClick="redirectURL('<%= request.getContextPath() %>/product/productCatalog?productTypeId=<%= pType.getId() %>')">
                                    <div class="w-full flex flex-col rounded-lg overflow-hidden">
                                        <div class="border border-white bg-grey1 rounded-lg">
                                            <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= product.getImage().getId() %>" class="w-full h-full object-cover" alt="<%= pType.gettype()%>">
                                        </div>
                                        <h2 class="text-lg font-semibold text-poppins p-2"><%= pType.gettype() %></h2>
                                    </div>
                                </div>
                        <% } 
                        }
                    } %>
            </div>
            <div class="category-scrollbar w-full h-2 cursor-pointer"></div>
        </div>  
    </div>


    <!-- Best Sellers -->
    <div class="content-wrapper flex flex-col">
        <div class="pb-8 flex justify-between items-center">
            <h1 class="text-3xl font-bold text-poppins">Best Sellers</h1>
        </div>
        <!-- Best sellers catalog -->
        <div class="flex gap-8">
            <% for(product prod : bestSellers) { %>
                <div class="w-full pb-10 basis-1/4 hover:mhc-box-shadow">
                    <div class="bg-white rounded-lg overflow-hidden shadow cursor-pointer relative"
                            onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= prod.getId() %>')">
                        <% if (prod.getFeatured() == 1) { %>
                            <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED</div>
                        <% } %>
                        <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= prod.getImage().getId() %>" alt="<%= prod.getTitle() %>" class="w-[350px] h-[260px] object-cover cursor-pointer">
                        <div class="p-3 cursor-pointer hover:bg-grey1">
                            <h3 class="font-medium"><%= prod.getTitle() %></h3>
                            <p class="text-xs text-gray-500"><%= prod.getTypeId().gettype() %></p>
                            <div class="flex justify-between items-center mt-2">
                                <span class="font-bold">RM <%= String.format("%.2f", prod.getPrice()) %></span>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fas fa-box mr-1"></i>
                                    <span><%= prod.getStock() %> left</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
        
        <div>
            
        </div>

    </div>  
    
    <!-- Banner -->
    <div class="content-wrapper">
        <div class="p-8 flex justify-between items-center bg-lightMidYellow rounded-lg">
            <h1 class="text-3xl font-poppins font-semibold">Enjoy 25% on your first order with us.</h1>
            <button class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out px-6 py-4 rounded-full text-poppins font-bold text-lg" onClick="redirectURL('<%= request.getContextPath()%>/product/productCatalog')">SHOP NOW</button>
        </div>
    </div>

    <!-- New Arrivals -->
    <div class="content-wrapper flex flex-col">
        <div class="pb-8 flex justify-between items-center">
            <h1 class="text-3xl font-bold text-poppins">New Arrivals</h1>
            <div class="flex justify-end items-center gap-2 select-none">
                <div class="flex justify-between items-center border-2 border-gray-100 rounded-lg">
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center newArrivals-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center item-center newArrivals-next">
                        <span class="text-lg">></span>
                    </div>
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center">
                        <a href="<%= request.getContextPath() %>/product/productCatalog"><i class="fa-solid fa-ellipsis fa-lg"></i></a>
                    </div>
                </div>
            </div>
            
        </div>
        <div class="swiper newArrivals-swiper content-wrapper !my-0">
            <div class="swiper-wrapper pb-10">
                <% for(product p : newProducts) { %>
                    <div class="swiper-slide w-full hover:mhc-box-shadow">
                        <div class="bg-white rounded-lg overflow-hidden cursor-pointer relative" onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= p.getId() %>')">
                            <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
                            </div>
                            <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= p.getImage().getId() %>" alt="L-shape Sofa" class="w-[350px] h-[260px] object-cover cursor-pointer">
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
                    </div>
                <% } %>
            </div>
            <div class="newArrivals-scrollbar w-full h-2 cursor-pointer"></div>
        </div>
    </div>     


    <!-- Testimonial / Review -->
    <div class="content-wrapper flex flex-col">

        <div class="flex justify-between pb-10">
            <div class="flex flex-col items-start" id="testimonial-title">
                <p class="text-4xl">★★★★★</p>
                <p class="text-4xl font-bold">Over <span class="font-dmSans text-grey4">500,000</span> happy customer</p>
                <p class="text-4xl font-bold">and more than <span class="font-dmSans text-grey4">100,000</span> five-star reviews</p>
            </div>
            <div class="flex justify-end items-end gap-2 select-none">
                <div class="flex justify-between items-center border-2 border-gray-100 rounded-lg">
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center review-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center item-center review-next">
                        <span class="text-lg">></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="swiper review-swiper content-wrapper !my-0 font-poppins">
            <div class="swiper-wrapper pb-10">
                <% for(productFeedback feedback : feedbacks) { %>
                    <% if (feedback.getComment() != null) { %>
                        <div class="swiper-slide w-full">
                            <div class="flex flex-col gap-2">
                                <div class="w-full max-h-[260px] rounded-lg">
                                    <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= feedback.getProduct().getImage().getId() %>" alt="<%= feedback.getProduct().getTitle() %>" class="w-full h-full object-cover rounded-lg cursor-pointer" onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= feedback.getProduct().getId() %>')">
                                </div>
                                <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                                    <div class="flex flex-col gap-1 font-dmSans">
                                        <p class="text-xl">
                                            <% 
                                                int rating = (int) Math.round(feedback.getRating());
                                                for (int i = 0; i < rating; i++) { 
                                            %>
                                                ★
                                            <% 
                                                } 
                                            %>
                                        </p>
                                        <h2 class="text-2xl font-bold"><%= feedback.getProduct().getTitle() %></h2>
                                        <div class="max-h-[70%]">
                                            <p class="line-clamp-5 text-justify text-lg"><%= feedback.getComment() %></p>
                                        </div>
                                        
                                    </div>

                                    <div class="flex flex-col justify-between gap-2">
                                        <div class="flex flex-col gap-1">
                                            <h2 class="text-lg font-sembold"><%= feedback.getOrder().getUser().getUsername() %></h2>
                                            <div class="flex gap-2 items-center">
                                                <i class="fa-solid fa-circle-check fa-sm"></i>
                                                <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                            </div>
                                        </div>
                                        <a href="<%= request.getContextPath() %>/product/productPage?id=<%= feedback.getProduct().getId() %>" class="underline text-lg font-dmSans">Product Page</a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
            <div class="review-scrollbar w-full h-2 cursor-pointer"></div>
        </div>

    </div>

    <!-- Why us -->
    <div id="choose-us" class="content-wrapper flex flex-col gap-4">
        <!-- title -->
        <div class="flex flex-col items-center justify-center gap-3 py-4">
            <p class="text-lg font-light font-dmSans">Why choose us?</p>
            <p class="text-4xl font-semibold font-poppins text-darkYellow">We're in the business of making things good</p>
        </div>

        <div class="flex gap-4">

            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/craft.jpeg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Crafted with Sustainability</h1>
                    <p class="text-lg">We thoughtfully source materials that protect our forests and environment. Every piece of furniture you buy helps promote sustainability for a greener future.</p>
                </div>
            </div>
            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/realLife.jpg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Designed for Real Life</h1>
                    <p class="text-lg">Our furniture is built to last, combining comfort, durability, and timeless style. Experience easy-to-assemble, practical designs that make your home beautiful without the hassle.</p>
                </div>
            </div>
            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/customer.jpg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Customer-First Commitment</h1>
                    <p class="text-lg">Your satisfaction is our top priority. Enjoy worry-free shopping with our dedicated customer support, fast shipping, and hassle-free returns.</p>
                </div>
            </div>
            

        </div>
    </div>
    

    <!-- About us -->
    <div id="about-us" class="content-wrapper flex flex-col gap-6">
        <!-- Title -->
        <div class="flex justify-between items-center">
            <h1 class="text-4xl font-bold font-poppins">A little about us</h1>
            <div class="p-4 text-xl font-poppins font-semibold border hover:bg-lightMidYellow hover:text-white text-center rounded-full cursor-pointer duration-300 transition-colors ease-in-out" onClick="scrollToFooter()">
                LEARN MORE
            </div>
        </div>
        <div class="flex flex-col gap-2">
            <div class="flex items-center rounded-lg bg-grey2 border p-6 gap-52">
                <h2 class="text-3xl font-semibold font-poppins">Craft Your Comfort, Define Your Home</h2>
                <p class="text-lg font-dmSans text-justify">At MysticHome Creations, we believe that your home should be a reflection of your personality – warm, welcoming, and uniquely you. That's why we craft and curate high-quality furniture pieces that combine timeless design with everyday comfort. From modern minimalism to rustic charm, every item in our collection is thoughtfully chosen to help you create spaces that feel like home.</p>
            </div>

            <div class="flex gap-4">
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/qualityCraft.jpeg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Stylish & Versatile Designs</h2>
                        <p class="text-md font-dmSans">From modern to classic styles, our pieces are designed to suit a wide range of tastes and seamlessly fit into any home.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/stylish.jpg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Reliable Delivery & Support</h2>
                        <p class="text-md font-dmSans">Enjoy a smooth shopping experience with fast delivery, secure packaging, and responsive customer service that truly cares.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/delivery.jpg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Sustainable Commitment</h2>
                        <p class="text-md font-dmSans">We believe in creating beautiful homes without compromising the planet – many of our products are eco-conscious and responsibly made.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/sustainable.jpg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Commitment to Sustainability</h2>
                        <p class="text-md font-dmSans">Our commitment goes beyond the product. From sustainable sourcing to eco-friendly production methods, we’re designing for the future of our planet—one piece at a time.</p>
                    </div>
                </div>
            </div>

        </div>
        

    </div>


    <!-- CTA -->
    <div id="contact-us" class="content-wrapper flex flex-col gap-6">

        <!-- title -->
        <div class="flex items-center justify-center gap-3 py-4">
            <p class="text-4xl font-semibold font-poppins text-darkYellow">Need more? We gotcha.</p>
        </div>

        <div class="flex gap-6 items-center">
            <div class="p-10 flex flex-col items-center gap-4 w-[calc(50%-1.5rem)] h-[342px] bg-lightMidYellow rounded-lg">
                <div class="flex flex-col justify-center items-center gap-4">
                    <h1 class="text-3xl font-semibold font-poppins">Subscribe to our emails</h1>
                    <p class="text-md font-dmSans">Be the first to know about new collections and exclusive offers.</p>
                </div>
                <div class="flex gap-4 text-lg">
                    <form action="#">
                        <input type="text" class="p-2 border focus:border-darkYellow border-grey4 rounded-md font-dmSans" placeholder="First name">
                        <input type="email" class="p-2 border focus:border-darkYellow border-grey4 rounded-md font-dmSans" placeholder="Enter your email">
                        <button type="submit" class="py-2 px-4 border rounded-full font-dmSans border-grey4 hover:border-darkYellow bg-white hover:bg-darkYellow hover:text-white duration-300 transition-colors ease-in-out">SIGN UP</button>
                    </form>
                </div>
                
                <p class="text-md font-dmSans">By clicking 'Sign up' you agree that you have read and understood MysticHome Creations' <span><a href="#">Privacy Policy</a></span>.</p>
    
                <div class="flex gap-2 items-center">
                    <input type="checkbox" id="newsletter" name="newsletter" value="newsletter" class="w-[20px] h-[20px]">
                    <label for="newsletter" class="text-md font-dmSans">I agree to receive marketing communications and product updates from MysticHome Creations.</label>
                </div>
                
                
            </div>
            <div class="p-10 flex flex-col items-center justify-between gap-4 w-[calc(50%-1.5rem)] h-[342px] bg-lightMidYellow rounded-lg">
                <div class="flex flex-col justify-center items-center gap-4">
                    <h1 class="text-3xl font-semibold font-poppins">Visit our stores</h1>
                    <p class="text-md font-dmSans">Visit our physical stores to experience our products in person. Our friendly staff is ready to assist you with any questions, offering personalized recommendations and expert guidance.</p>
                </div>
                
                <div class="flex justify-end w-full">
                    <div class="rounded-full py-4 px-6 border bg-white border-grey4 hover:border-darkYellow hover:bg-darkYellow hover:text-white font-dmSans text-lg cursor-pointer duration-300 transition-colors ease-in-out">FIND A STORE</div>
                </div>
                
            </div>
        </div>
        
    </div>

<%@ include file="/Views/Shared/Footer.jsp" %>

</body>
<script src="<%= request.getContextPath() %>/Content/scripts/swiper.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init();
    var newArrivalsSwiper = new Swiper(".newArrivals-swiper", {
      slidesPerView: 4,
      spaceBetween: 30,
      scrollbar: {
        el: ".newArrivals-scrollbar",
        draggable: true,
        hide: false,
      },
      mousewheel:{
        enabled: true,
        forceToAxis: true,
      },
      navigation:{
        nextEl: ".newArrivals-next",
        prevEl: ".newArrivals-prev",
      },
      autoplay:{
        delay: 3000,
        disableOnInteraction: true,
        waitForTransition: true,
        pauseOnMouseEnter: true,
      },
      grabCursor: true,
    });

    var categorySwiper = new Swiper(".category-swiper", {
      slidesPerView: 4,
      spaceBetween: 30,
      scrollbar: {
        el: ".category-scrollbar",
        draggable: true,
        hide: false,
      },
      mousewheel:{
        enabled: true,
        forceToAxis: true,
      },
      navigation:{
        nextEl: ".category-next",
        prevEl: ".category-prev",
      },
      grabCursor: true,
    });

    var reviewSwiper = new Swiper(".review-swiper", {
      slidesPerView: 4,
      spaceBetween: 15,
      scrollbar: {
        el: ".review-scrollbar",
        draggable: true,
        hide: false,
      },
      mousewheel:{
        enabled: true,
        forceToAxis: true,
      },
      navigation:{
        nextEl: ".review-next",
        prevEl: ".review-prev",
      },
      grabCursor: true,
    });

    function redirectURL(url) {
        window.location.href = url;
    }

    function scrollToFooter() {
        // Smooth scroll to footer
        document.querySelector('footer').scrollIntoView({ 
            behavior: 'smooth' 
        });
    }

    function getStartNavigation() {
        // Smooth scroll to the first section of the page
        document.querySelector('#categories').scrollIntoView({ 
            behavior: 'smooth' 
        });
    }
</script>
</html>