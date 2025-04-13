<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>


<body>
    <div class="content-wrapper">
        <div class="grid grid-cols-1 md:grid-cols-7 gap-4 bg-white">
            <!-- Image Gallery (Mobile: order 1; Desktop: left columns) -->
            <div class="order-1 md:col-span-4">

                <div style="--swiper-navigation-color: #fff; --swiper-pagination-color: #fff"
                    class="swiper mySwiper2 w-full h-[300px] sm:h-[600px] md:h-[1000px] rounded-lg ">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 1"
                                class="w-full h-full object-cover " />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 2"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 3"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 4"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 5"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 6"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 7"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 8"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 9"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Nature 10"
                                class="w-full h-full object-cover" />
                        </div>
                    </div>
                    <!-- Navigation Arrows -->
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>

                <!-- Thumbnail Swiper (Thumbs slider) -->
                <div thumbsSlider="" class="swiper mySwiper w-full h-[80px] sm:h-[100px] md:h-[150px] mt-4 ">
                    <div class="swiper-wrapper ">
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 1"
                                class="w-full h-full object-cover rounded-lg" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 2"
                                class="w-full h-full object-cover rounded-lg" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 3"
                                class="w-full h-full object-cover rounded-lg" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 4"
                                class="w-full h-full object-cover rounded-lg" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 5"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 6"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 7"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 8"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 9"
                                class="w-full h-full object-cover" />
                        </div>
                        <div class="swiper-slide">
                            <img src="/src/cupboard.avif" alt="Thumbnail 10"
                                class="w-full h-full object-cover" />
                        </div>
                    </div>
                </div>
            </div>


            <!-- Product Details (Mobile: order 2; Desktop: right column) -->
            <div class="order-2 md:col-span-3 md:sticky md:top-[30px] h-fit md:z-10">
                <div class="p-4 lg:p-6 rounded-lg shadow-md">
                    <h1 class="text-2xl font-bold text-left mb-4">
                        SUPIMA Cotton Crew Neck T-shirt | Short Sleeve
                    </h1>

                    <div class="mb-4">
                        <h2 class="text-xl font-semibold">Color</h2>
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 mt-2">
                            <button class="py-2 px-4 bg-gray-200 rounded ">
                                White Stained Oak
                            </button>
                            <button class="py-2 px-4 bg-black text-white rounded">
                                Black
                            </button>
                            <button class="py-2 px-4 bg-gray-200 rounded">
                                White
                            </button>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h2 class="text-xl font-semibold mt-4">Specification</h2>
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 mt-2">
                            <button class="py-2 px-4 bg-gray-200 rounded ">
                                Fibreboard
                            </button>
                            <button class="py-2 px-4 bg-gray-200 rounded ">
                                Particleboard
                            </button>
                        </div>
                    </div>

                    <div class="mt-6">
                        <p class="text-2xl font-bold">RM 88.00</p>
                        <p class="text-sm text-gray-600">(unit: RM 88.00)</p>
                    </div>

                    <div class="flex items-center justify-between my-4">
                        <div class="flex items-center border rounded overflow-hidden ">
                            <div class="text-md px-4 bg-gray-200">
                                <i class="fa-solid fa-minus"></i>
                            </div>
                            <span class="px-4">1</span>
                            <div class="text-md px-4 bg-gray-200">
                                <i class="fa-solid fa-plus"></i>
                            </div>
                        </div>
                        <div class="text-sm text-gray-600 italic font-bold">
                            <span>1 in stock</span>
                        </div>
                    </div>

                    <div class="text-center my-4">
                        <button class="bg-yellow-400 text-white py-3 px-12 rounded-full font-bold w-full md:w-1/2 ">
                          Add
                        </button>
                    </div>
                      
                </div>
            </div>

            <!-- Description & Reviews (Mobile: order 3; Desktop: below the image gallery) -->
            <div class="order-3 md:col-span-4 pt-6">
                <!-- Product Description -->
                <div>
                    <h1 class="text-3xl font-bold mb-4">Description</h1>
                    <p class="mb-4 text-lg">Product ID: 468503</p>
                    <hr class="mb-4">
                    <!-- Accordion for Features -->
                    <div class="mb-4">
                        <div onclick="toggleAccordion('features')"
                            class="flex justify-between items-center cursor-pointer">
                            <h2 class="text-lg font-semibold">Features</h2>
                            <i class="fa-solid fa-plus"></i>
                        </div>
                        <div id="features" class="hidden">
                            <ul class="list-disc pl-5 mt-2">
                                <li>Feature 1</li>
                                <li>Feature 2</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Reviews -->
                <div class="pt-6">
                    <h1 class="text-2xl font-bold">Reviews</h1>
                    <h2 class="text-xl font-semibold mb-6">
                        Overall Rating: <span class="text-yellow-400">★★★★☆</span> 4.8 (450)
                    </h2>
                    <div class="bg-white rounded-lg space-y-6">
                        <!-- Review 1 -->
                        <div class="border-b pb-4">
                            <h3 class="font-bold">Tshirt</h3>
                            <p class="text-yellow-400">★★★★★</p>
                            <p>Purchased size: XL</p>
                            <p>How it fits: True to size</p>
                            <p>I love the quality of the Tshirt. It's really good when you fit it. Thank you.</p>
                        </div>
                        <!-- Review 2 -->
                        <div class="border-b pb-4">
                            <h3 class="font-bold">Comfortable</h3>
                            <p class="text-yellow-400">★★★★☆</p>
                            <p>Purchased size: 3XL</p>
                            <p>How it fits: True to size</p>
                            <p class="text-sm text-gray-600">28/02/2025</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!--Feature Product-->

        <div class="pt-3 ">
            <h2 class="text-2xl font-bold mb-6">Popular accessories</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <!-- Product Card 1 -->
                <div class="shadow rounded-lg">
                    <div class="relative">
                        <img src="/src/cupboard.avif" alt="FNiSS Waste bin"
                            class="w-full h-full object-cover rounded-md">
                        <span
                            class="absolute top-0 right-0 bg-red-500 text-white text-sm font-semibold m-2 px-2 py-1 rounded">Top
                            seller</span>
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

                <!-- Add additional product cards similarly -->

            </div>
        </div>







    </div><jsp:useBean id="products" scope="request" class="Modals.product" ></jsp:useBean>
    <!-- Example of Processing List of Product via Java Statement in .jsp -->
     <% for(product product : (java.util.List<product>)request.getAttribute("products")) { %>
        <div>Product ID: <%= product.getId() %></div>
     <%}  %>

</body>

<script>

    function toggleAccordion(id) {
        const accordion = document.getElementById(id);
        const icon = accordion.previousElementSibling.querySelector("i");

        if (accordion.classList.contains("hidden")) {
            accordion.classList.remove("hidden");
            icon.classList.remove("fa-plus");
            icon.classList.add("fa-minus");
        } else {
            accordion.classList.add("hidden");
            icon.classList.remove("fa-minus");
            icon.classList.add("fa-plus");
        }
    }
    function getProducts(){
        $.ajax({
            url: '/product/getProducts',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                //response.status - Http Status
                //response.message - Comments
                //response.timestamp - Time of Server start process Http Request
                //response.data - Data from the server

                // Handle the response data here
                console.log(data);
            },
            error: function(xhr, status, error) {
                // Handle any errors here
                console.error(error);
            }
        });
    }
</script>


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
</script>

</html>