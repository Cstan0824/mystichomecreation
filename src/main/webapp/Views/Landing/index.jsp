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

    <%-- Set bean properties from web.xml context parameters --%>
    <jsp:useBean id="companyInfo" class="Beans.CompanyInfoBean" scope="application" />
    <jsp:setProperty name="companyInfo" property="companyName" value='<%= application.getInitParameter("companyName") %>' />
    <jsp:setProperty name="companyInfo" property="companyEmail" value='<%= application.getInitParameter("companyEmail") %>' />
    <jsp:setProperty name="companyInfo" property="copyright" value='<%= application.getInitParameter("copyright") %>' />
    <jsp:setProperty name="companyInfo" property="companyAddress" value='<%= application.getInitParameter("companyAddress") %>' />
    <jsp:setProperty name="companyInfo" property="companyPhone" value='<%= application.getInitParameter("companyPhone") %>' />


    <%

        List<product> bestSellers = (List<product>) request.getAttribute("bestSellers");
        List<product> newProducts = (List<product>) request.getAttribute("newProducts");
        List<product> randomProducts = (List<product>) request.getAttribute("randomProducts");
        List<productType> productTypes = (List<productType>) request.getAttribute("productTypes");
        List<productFeedback> feedbacks = (List<productFeedback>) request.getAttribute("feedbacks");

    %>
    <!-- Carousel -->
    <div class="w-full flex flex-col">
        <!-- Video Container -->
        <div class="relative w-full overflow-hidden aspect-video">
            <video class="w-full h-full object-cover" autoplay loop muted playsinline>
                <source src="<%= request.getContextPath() %>/Content/assets/video/carousel-video.mp4">
                <img src="<%= request.getContextPath() %>/Content/assets/image/carousel-banner.avif" alt="carousel-image">
            </video>

            <!-- Overlay -->
            <div
                class="absolute inset-0 font-poppins bg-black bg-opacity-20 flex justify-center items-center px-10 md:px-20 lg:px-36">
                <div class="text-white text-center">
                    <h1 class="text-2xl md:text-5xl lg:text-6xl font-bold drop-shadow-lg">MysticHome Creations</h1>
                    <p class="text-md md:text-lg font-bold drop-shadow-lg">Timeless Designs, Crafted for the Way You Live.</p>
                    <button
                        onClick="getStartNavigation()"
                        class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out text-sm md:text-lg px-4 py-2 rounded-full mt-4">
                        Get Started
                    </button>
                </div>
            </div>
        </div>


        <!-- Highlights Section -->
        <div class="bg-lightMidYellow">
            <div
                class="content-wrapper !my-0 flex flex-col md:flex-row justify-center items-center md:items-start gap-6 md:gap-10 !p-6 text-center md:text-left">
                <div class="flex flex-row justify-center md:justify-start items-center gap-2">
                    <i class="fa-solid fa-truck"></i>
                    <p class="font-dmSans text-md">Fast delivery</p>
                </div>
                <div class="flex flex-row justify-center md:justify-start items-center gap-2">
                    <i class="fa-solid fa-calendar-days"></i>
                    <p class="font-dmSans text-md">14-days free return</p>
                </div>
                <div class="flex flex-row justify-center md:justify-start items-center gap-2">
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
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center category-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center item-center category-next">
                        <span class="text-lg">></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper category-swiper content-wrapper !px-0 !my-0">
            <div class="swiper-wrapper pb-10">
                <%  for (productType pType : productTypes) {
                        for (product product : randomProducts) {
                            if(product.getTypeId().getId() == pType.getId()) { %>
                
                                <div class="swiper-slide w-full cursor-pointer mhc-box-shadow bg-white hover:bg-grey1 transition-colors ease-in-out duration-200 rounded-lg overflow-hidden" onClick="redirectURL('<%= request.getContextPath() %>/product/productCatalog?productTypeId=<%= pType.getId() %>')">
                                    <div class="w-full flex flex-col rounded-lg overflow-hidden">
                                        <div class="border border-white bg-grey1 rounded-lg">
                                            <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= product.getImage().getId() %>" class="w-full aspect-[7/5] object-cover" alt="<%= pType.gettype()%>">
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
        <div class="flex flex-wrap gap-8 justify-center">
            <% for(product prod : bestSellers) { %>
                <div class="w-full sm:w-[calc(100%-0.75rem)] md:w-[calc(50%-1rem)] lg:w-[calc(25%-2rem)] hover:mhc-box-shadow">
                    <div class="bg-white rounded-lg overflow-hidden shadow cursor-pointer relative"
                            onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= prod.getId() %>')">
                        <% if (prod.getFeatured() == 1) { %>
                            <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">FEATURED</div>
                        <% } %>
                        <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= prod.getImage().getId() %>" alt="<%= prod.getTitle() %>" class="w-full aspect-[7/5] object-cover cursor-pointer">
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
    </div>  
    
    <!-- Banner -->
    <div class="content-wrapper">
        <div
            class="p-6 md:p-8 flex flex-col md:flex-row justify-between items-center gap-4 bg-lightMidYellow rounded-lg">
            <h1 class="text-2xl lg:text-3xl font-poppins font-semibold text-center md:text-left">
                Enjoy 25% on your first order with us.
            </h1>
            <button
                onClick="redirectURL('<%= request.getContextPath()%>/product/productCatalog')"
                class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out px-6 py-3 rounded-full text-poppins font-bold text-lg">
                SHOP NOW
            </button>
        </div>
    </div>

    <!-- New Arrivals -->
    <div class="content-wrapper flex flex-col">
        <div class="pb-8 flex justify-between items-center">
            <h1 class="text-3xl font-bold text-poppins">New Arrivals</h1>
             <div class="flex justify-end items-center gap-2 select-none">
                <div class="flex justify-between items-center border-2 border-gray-100 rounded-lg">
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center newArrivals-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center item-center newArrivals-next">
                        <span class="text-lg">></span>
                    </div>
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center">
                        <a href="<%= request.getContextPath() %>/product/productCatalog"><i class="fa-solid fa-ellipsis fa-lg"></i></a>
                    </div>
                </div>
            </div>
            
        </div>
        <div class="swiper newArrivals-swiper content-wrapper !px-0 !my-0">
            <div class="swiper-wrapper pb-10">
                <% for(product p : newProducts) { %>
                    <div class="swiper-slide w-full mhc-box-shadow hover:mhc-box-shadow">
                        <div class="bg-white rounded-lg overflow-hidden cursor-pointer relative" onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= p.getId() %>')">
                            <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
                            </div>
                            <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= p.getImage().getId() %>" alt="L-shape Sofa" class="w-full aspect-[7/5] object-cover cursor-pointer">
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

        <div class="flex flex-col md:flex-row justify-between gap-6 pb-10">
            <!-- Left side (Testimonial Title) -->
            <div class="flex flex-col items-start" id="testimonial-title">
                <p class="text-4xl">★★★★★</p>
                <p class="text-4xl font-bold">Over <span class="font-dmSans text-grey4">500,000</span> happy customers
                </p>
                <p class="text-4xl font-bold">and more than <span class="font-dmSans text-grey4">100,000</span>
                    five-star reviews</p>
            </div>

            <!-- Right side (Navigation buttons) -->
            <div class="flex justify-end items-end gap-2 select-none">
                <div class="flex justify-between items-center border-2 border-gray-100 rounded-lg">
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center review-prev">
                        <span class="text-lg">&lt;</span>
                    </div>
                    <div
                        class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center review-next">
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
                                <div class="w-full aspect-[4/3] rounded-lg overflow-hidden">
                                    <img src="<%= request.getContextPath() %>/File/Content/product/retrieve?id=<%= feedback.getProduct().getImage().getId() %>" alt="<%= feedback.getProduct().getTitle() %>" class="w-full h-full object-cover rounded-lg cursor-pointer" onClick="redirectURL('<%= request.getContextPath() %>/product/productPage?id=<%= feedback.getProduct().getId() %>')">
                                </div>
                                <div class="w-full rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between h-auto min-h-[350px]">
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
                                        <div class="max-h-[150px] overflow-hidden">
                                            <p class="line-clamp-5 text-justify text-lg"><%= feedback.getComment() %></p>
                                        </div>
                                        
                                    </div>

                                    <div class="flex flex-col justify-between gap-2 mt-4">
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
            <p class="text-4xl font-semibold font-poppins text-darkYellow text-center">We're in the business of making things good</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 justify-center gap-6">
            <div class="flex flex-col gap-2">
                <div class="w-full aspect-[5/3] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/craft.jpeg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Crafted with Sustainability</h1>
                    <p class="text-lg">We thoughtfully source materials that protect our forests and environment. Every piece of furniture you buy helps promote sustainability for a greener future.</p>
                </div>
            </div>
            <div class="flex flex-col gap-2">
                <div class="w-full aspect-[5/3] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/realLife.jpg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Designed for Real Life</h1>
                    <p class="text-lg">Our furniture is built to last, combining comfort, durability, and timeless style. Experience easy-to-assemble, practical designs that make your home beautiful without the hassle.</p>
                </div>
            </div>
            <div class="flex flex-col gap-2">
                <div class="w-full aspect-[5/3] rounded-lg overflow-hidden">
                    <img src="<%= request.getContextPath()%>/Content/assets/image/home/customer.jpg" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Customer-First Commitment</h1>
                    <p class="text-lg">Your satisfaction is our top priority. Enjoy worry-free shopping with our dedicated customer support, fast shipping, and hassle-free returns.</p>
                </div>
            </div>

        </div>
    </div>
    

    <!-- About us -->
    <div id="about-us" class="content-wrapper flex flex-col gap-6">
        <!-- Title -->
        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
            <h1 class="text-4xl font-bold font-poppins">A little about us</h1>
            <a href="#contact-us"><div
                class="p-4 text-xl font-poppins font-semibold border hover:bg-lightMidYellow hover:text-white text-center rounded-full cursor-pointer duration-300 transition-colors ease-in-out">
                LEARN MORE
            </div></a>
        </div>
        <div class="flex flex-col gap-2">
            <div class="flex flex-col md:flex-row items-start md:items-center bg-grey2 border p-6 rounded-lg gap-6 md:gap-20">
                <h2 class="text-2xl md:text-3xl font-semibold font-poppins">Craft Your Comfort, Define Your Home</h2>
                <p class="text-md md:text-lg font-dmSans text-justify">At MysticHome Creations, we believe that your home should be a reflection of your personality – warm, welcoming, and uniquely you. That's why we craft and curate high-quality furniture pieces that combine timeless design with everyday comfort. From modern minimalism to rustic charm, every item in our collection is thoughtfully chosen to help you create spaces that feel like home.</p>
            </div>

            <div class="flex flex-wrap gap-4">
                <div
                    class="w-full md:w-[calc(50%-0.5rem)] lg:w-[calc(25%-0.75rem)] h-auto flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full aspect-[19/7] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/qualityCraft.jpeg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Stylish & Versatile Designs</h2>
                        <p class="text-md font-dmSans">From modern to classic styles, our pieces are designed to suit a wide range of tastes and seamlessly fit into any home.</p>
                    </div>
                </div>
                <div
                    class="w-full md:w-[calc(50%-0.5rem)] lg:w-[calc(25%-0.75rem)] h-auto flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full aspect-[19/7] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/stylish.jpg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Reliable Delivery & Support</h2>
                        <p class="text-md font-dmSans">Enjoy a smooth shopping experience with fast delivery, secure packaging, and responsive customer service that truly cares.</p>
                    </div>
                </div>
                <div
                    class="w-full md:w-[calc(50%-0.5rem)] lg:w-[calc(25%-0.75rem)] h-auto flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full aspect-[19/7] rounded-lg overflow-hidden">
                        <img src="<%= request.getContextPath()%>/Content/assets/image/home/delivery.jpg" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Sustainable Commitment</h2>
                        <p class="text-md font-dmSans">We believe in creating beautiful homes without compromising the planet – many of our products are eco-conscious and responsibly made.</p>
                    </div>
                </div>
                <div
                    class="w-full md:w-[calc(50%-0.5rem)] lg:w-[calc(25%-0.75rem)] h-auto flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full aspect-[19/7] rounded-lg overflow-hidden">
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
        <!-- Title -->
        <div class="flex items-center justify-center gap-3 py-4">
            <p class="text-4xl font-semibold font-poppins text-darkYellow text-center">Need more? We gotcha.</p>
        </div>

        <!-- 2 Cards -->
        <div class="flex flex-wrap gap-6 justify-center">
            <!-- Contact Us Card -->
            <div class="w-full md:w-[calc(50%-0.75rem)] flex flex-col p-10 bg-lightMidYellow rounded-lg h-auto gap-6">
                <div class="flex flex-col justify-center items-center gap-4 text-center">
                    <h1 class="text-3xl font-semibold font-poppins">Contact Us</h1>
                    <p class="text-md font-dmSans">We’d love to hear from you! Reach out to us through any of the
                        following ways:</p>
                </div>
                <div class="flex flex-col text-md font-dmSans gap-2 text-center">
                    <a href="tel:<jsp:getProperty name="companyInfo" property="companyPhone" />"><p class="cursor-pointer hover:underline"><strong>📞 Phone:</strong> <jsp:getProperty name="companyInfo" property="companyPhone" /></p></a>
                    <a href="mailto:<jsp:getProperty name="companyInfo" property="companyEmail" />"><p class="cursor-pointer hover:underline"><strong>✉️ Email:</strong> <jsp:getProperty name="companyInfo" property="companyEmail" /></p></a>
                    <p><strong>🕒 Business Hours:</strong> Mon – Fri, 9:00 AM – 6:00 PM</p>
                    <p><strong>📍 Address:</strong> <jsp:getProperty name="companyInfo" property="companyAddress" /></p>
                </div>
            </div>

            <!-- Visit Us Card -->
            <div class="w-full md:w-[calc(50%-0.75rem)] flex flex-col p-10 bg-lightMidYellow rounded-lg h-auto gap-6">
                <div class="flex flex-col justify-center items-center gap-4 text-center w-full">
                    <h1 class="text-3xl font-semibold font-poppins">Visit our stores</h1>
                    <p class="text-md font-dmSans">Visit our physical stores to experience our products in person. Our
                        friendly staff is ready to assist you with any questions.</p>
                    <p class="text-md font-dmSans">📍 <jsp:getProperty name="companyInfo" property="companyName" /> – 123 Serenity Lane, Kuala Lumpur</p>

                    <!-- Embedded Google Map -->
                    <div class="w-full h-[120px] overflow-hidden rounded-md">
                        <iframe
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3984.027290251409!2d101.6932!3d3.139!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31cc49f100000001%3A0x3c0e9e2d84a4c8e!2sKuala%20Lumpur%20City%20Centre!5e0!3m2!1sen!2smy!4v1614072818734!5m2!1sen!2smy"
                            width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>
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
    try {
        var newArrivalsSwiper = new Swiper(".newArrivals-swiper", {
            slidesPerView: 1, // default for mobile (smaller screens)
            spaceBetween: 20,
            scrollbar: {
                el: ".newArrivals-scrollbar",
                draggable: true,
                hide: false,
            },
            mousewheel: {
                enabled: true,
                forceToAxis: true,
            },
            navigation: {
                nextEl: ".newArrivals-next",
                prevEl: ".newArrivals-prev",
            },
            autoplay: {
                delay: 3000,
                disableOnInteraction: true,
                waitForTransition: true,
                pauseOnMouseEnter: true,
            },
            grabCursor: true,

            // ✨ Add this part to control based on screen size
            breakpoints: {
                375: {
                    slidesPerView: 1,
                    spaceBetween: 20,
                },
                768: {
                    slidesPerView: 2,
                    spaceBetween: 24,
                },
                1024: {
                    slidesPerView: 4,
                    spaceBetween: 28,
                },
            }
        });
        console.log("newArrivalsSwiper initialized:", newArrivalsSwiper);
    } catch (error) {
        console.error("Error initializing newArrivalsSwiper:", error);
    }

    try {
        var categorySwiper = new Swiper(".category-swiper", {
            slidesPerView: 2, // default mobile first
            spaceBetween: 20,
            scrollbar: {
                el: ".category-scrollbar",
                draggable: true,
                hide: false,
            },
            mousewheel: {
                enabled: true,
                forceToAxis: true,
            },
            navigation: {
                nextEl: ".category-next",
                prevEl: ".category-prev",
            },
            grabCursor: true,
            breakpoints: {
                375: {
                    slidesPerView: 1,
                    spaceBetween: 20,
                },
                768: {
                    slidesPerView: 2,
                    spaceBetween: 24,
                },
                1024: {
                    slidesPerView: 4,
                    spaceBetween: 28,
                },
            },
        });
        console.log("categorySwiper initialized:", categorySwiper);
    } catch (error) {
        console.error("Error initializing categorySwiper:", error);
    }

    try {
        var reviewSwiper = new Swiper(".review-swiper", {
            slidesPerView: 4, // default desktop
            spaceBetween: 15,
            scrollbar: {
                el: ".review-scrollbar",
                draggable: true,
                hide: false,
            },
            mousewheel: {
                enabled: true,
                forceToAxis: true,
            },
            navigation: {
                nextEl: ".review-next",
                prevEl: ".review-prev",
            },
            grabCursor: true,
            breakpoints: {
                0: {
                    slidesPerView: 1,
                },
                768: {
                    slidesPerView: 2,
                },
                1024: {
                    slidesPerView: 4,
                },
            },
        });
        console.log("reviewSwiper initialized:", reviewSwiper);
    } catch (error) {
        console.error("Error initializing reviewSwiper:", error);
    }

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