<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>test</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
</head>
<body class="selection:bg-gray-500 selection:bg-opacity-50 selection:text-white">
<%@ include file="/Views/Shared/Header.jsp" %>
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
                    <button class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out text-lg px-4 py-2 rounded-full mt-4">Get Started</button>
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
    <div class="content-wrapper flex flex-col">
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
                    <div class="hover:text-darkYellow border border-white rounded-lg hover:bg-gray-50 px-2 cursor-pointer flex justify-center items-center">
                        <a href="#"><i class="fa-solid fa-ellipsis fa-lg"></i></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper category-swiper content-wrapper !my-0">
            <div class="swiper-wrapper pb-10">
                <div class="swiper-slide w-full">
                    <div class="w-full flex flex-col">
                        <div class="border border-white bg-grey1 rounded-lg">
                            <img src="<%= request.getContextPath() %>/Content/assets/image/category-img.avif" class="w-full h-full object-cover" alt="category-1">
                        </div>
                        <h2 class="text-lg font-semibold text-poppins p-2">Category 1</h2>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="w-full flex flex-col">
                        <div class="border border-white bg-grey1 rounded-lg">
                            <img src="<%= request.getContextPath() %>/Content/assets/image/category-img.avif" class="w-full h-full object-cover" alt="category-1">
                        </div>
                        <h2 class="text-lg font-semibold text-poppins p-2">Category 1</h2>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="w-full flex flex-col">
                        <div class="border border-white bg-grey1 rounded-lg">
                            <img src="<%= request.getContextPath() %>/Content/assets/image/category-img.avif" class="w-full h-full object-cover" alt="category-1">
                        </div>
                        <h2 class="text-lg font-semibold text-poppins p-2">Category 1</h2>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="w-full flex flex-col">
                        <div class="border border-white bg-grey1 rounded-lg">
                            <img src="<%= request.getContextPath() %>/Content/assets/image/category-img.avif" class="w-full h-full object-cover" alt="category-1">
                        </div>
                        <h2 class="text-lg font-semibold text-poppins p-2">Category 1</h2>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="w-full flex flex-col">
                        <div class="border border-white bg-grey1 rounded-lg">
                            <img src="<%= request.getContextPath() %>/Content/assets/image/category-img.avif" class="w-full h-full object-cover" alt="category-1">
                        </div>
                        <h2 class="text-lg font-semibold text-poppins p-2">Category 1</h2>
                    </div>
                </div>
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
        
        <div>
            
        </div>

    </div>  
    
    <!-- Banner -->
    <div class="content-wrapper">
        <div class="p-8 flex justify-between items-center bg-lightMidYellow rounded-lg">
            <h1 class="text-3xl font-poppins font-semibold">Enjoy 25% on your first order with us.</h1>
            <button class="bg-white text-black hover:bg-darkYellow hover:text-white transition-colors duration-300 ease-in-out px-6 py-4 rounded-full text-poppins font-bold text-lg">SHOP NOW</button>
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
                        <a href="#"><i class="fa-solid fa-ellipsis fa-lg"></i></a>
                    </div>
                </div>
            </div>
            
        </div>
        <div class="swiper newArrivals-swiper content-wrapper !my-0">
            <div class="swiper-wrapper pb-10">
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden mhc-box-shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="bg-white rounded-lg overflow-hidden shadow relative">
                        <div class="absolute top-0 left-0 bg-yellow-400 text-white px-2 py-1 text-sm">NEW
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
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-sm"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-sm"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-sm"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-sm"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-sm"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="swiper-slide w-full">
                    <div class="flex flex-col gap-2">
                        <div class="w-full max-h-[260px] rounded-lg">
                            <img src="https://placehold.co/380x260/png" alt="review-1" class="w-full h-full object-cover rounded-lg">
                        </div>
                        <div class="max-w-[360px] h-[400px] rounded-lg p-5 bg-white mhc-box-shadow hover:border-lightMidYellow border flex flex-col justify-between">
                            <div class="flex flex-col gap-1 font-dmSans">
                                <p class="text-xl">★★★★★</p>
                                <h2 class="text-2xl font-bold">Review Title</h2>
                                <div class="max-h-[70%]">
                                    <p class="line-clamp-5 text-justify text-lg">Review Description Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cum, dolorem aut. Commodi, voluptatem dolores! Dolor quia dicta libero quisquam rem aut? Natus maiores mollitia excepturi ut quam, ducimus voluptates beatae.</p>
                                </div>
                                
                            </div>

                            <div class="flex flex-col justify-between gap-2">
                                <div class="flex flex-col gap-1">
                                    <h2 class="text-lg font-sembold">User Name</h2>
                                    <div class="flex gap-2 items-center">
                                        <i class="fa-solid fa-circle-check fa-md"></i>
                                        <span class="font-semibold font-poppins text-darkYellow text-md">Verified Buyer</span>
                                    </div>
                                </div>
                                <a href="#" class="underline text-lg font-dmSans">Product Page</a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="review-scrollbar w-full h-2 cursor-pointer"></div>
        </div>

    </div>

    <!-- Why us -->
    <div class="content-wrapper flex flex-col gap-4">
        <!-- title -->
        <div class="flex flex-col items-center justify-center gap-3 py-4">
            <p class="text-lg font-light font-dmSans">Why choose us?</p>
            <p class="text-4xl font-semibold font-poppins text-darkYellow">We're in the business of making things good</p>
        </div>

        <div class="flex gap-4">

            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="https://placehold.co/500x300/png" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Crafted with Sustainability</h1>
                    <p class="text-lg">We thoughtfully source materials that protect our forests and environment. Every piece of furniture you buy helps promote sustainability for a greener future.</p>
                </div>
            </div>
            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="https://placehold.co/500x300/png" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Designed for Real Life</h1>
                    <p class="text-lg">Our furniture is built to last, combining comfort, durability, and timeless style. Experience easy-to-assemble, practical designs that make your home beautiful without the hassle.</p>
                </div>
            </div>
            <div class="w-[calc(33.33%-1rem)] flex flex-col gap-2">
                <div class="w-full h-[300px] rounded-lg overflow-hidden">
                    <img src="https://placehold.co/500x300/png" class="w-full h-full object-cover" alt="pic"/>
                </div>
                <div class="w-full h-[250px] flex flex-col">
                    <h1 class="text-xl font-semibold font-poppins py-2">Customer-First Commitment</h1>
                    <p class="text-lg">Your satisfaction is our top priority. Enjoy worry-free shopping with our dedicated customer support, fast shipping, and hassle-free returns.</p>
                </div>
            </div>
            

        </div>
    </div>
    

    <!-- About us -->
    <div class="content-wrapper flex flex-col gap-6">
        <!-- Title -->
        <div class="flex justify-between items-center">
            <h1 class="text-4xl font-bold font-poppins">A little about us</h1>
            <div class="p-4 text-xl font-poppins font-semibold border hover:bg-lightMidYellow hover:text-white text-center rounded-full cursor-pointer duration-300 transition-colors ease-in-out">
                LEARN MORE
            </div>
        </div>
        <div class="flex flex-col gap-2">
            <div class="flex items-center rounded-lg bg-grey2 border p-6 gap-52">
                <h2 class="text-3xl font-semibold font-poppins">Our Mission: Crafting Homes, Protecting Nature</h2>
                <p class="text-lg font-dmSans text-justify">We' re on a mission to create homes that are as sustainable as they are stylish. Every piece of furniture you purchase helps us support reforestation projects and eco-friendly practices that reduce our environmental impact.</p>
            </div>

            <div class="flex gap-4">
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="https://placehold.co/380x150/png" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Thoughtful Design for Every Home</h2>
                        <p class="text-md font-dmSans">We believe furniture should be beautiful and functional. Our designs combine elegance, comfort, and practicality to elevate your living space without compromise.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="https://placehold.co/380x150/png" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Affordability Without Sacrificing Quality</h2>
                        <p class="text-md font-dmSans">By cutting out the middleman, we pass the savings directly to you, offering quality furniture at prices you can feel good about.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="https://placehold.co/380x150/png" class="w-full h-full object-cover" alt="pic"/>
                    </div>
                    <div class="flex flex-col">
                        <h2 class="text-lg font-semibold font-poppins py-2">Seamless Shopping Experience</h2>
                        <p class="text-md font-dmSans">Enjoy easy shopping with our fast delivery, simple assembly, and a satisfaction guarantee—120 nights to love your purchase or return it for a full refund.</p>
                    </div>
                </div>
                <div class="w-[calc(25%-1rem)] h-[400px] flex flex-col gap-2 p-6 rounded-lg bg-lightYellow">
                    <div class="w-full h-[150px] rounded-lg overflow-hidden">
                        <img src="https://placehold.co/380x150/png" class="w-full h-full object-cover" alt="pic"/>
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
    <div class="content-wrapper flex flex-col gap-6">

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

</script>
</html>