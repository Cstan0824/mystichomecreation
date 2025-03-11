<!-- Navigation Bar -->
<nav class="bg-gray-900 text-white">
    <div class="container mx-auto px-4 flex items-center justify-between py-4">
        <a href="#" class="text-xl font-bold">MyBrand</a>

        <!-- Mobile menu button -->
        <button id="nav-toggle" class="lg:hidden focus:outline-none">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
        </button>

        <!-- Navigation Links -->
        <div id="nav-menu" class="hidden lg:flex space-x-6">
            <a href="#features" class="hover:text-gray-300">Features</a>
            <a href="#testimonials" class="hover:text-gray-300">Testimonials</a>
            <a href="#contact" class="hover:text-gray-300">Contact</a>
        </div>
    </div>

    <!-- Mobile Menu -->
    <div id="mobile-menu" class="hidden bg-gray-800 lg:hidden">
        <a href="#features" class="block px-4 py-2 hover:bg-gray-700">Features</a>
        <a href="#testimonials" class="block px-4 py-2 hover:bg-gray-700">Testimonials</a>
        <a href="#contact" class="block px-4 py-2 hover:bg-gray-700">Contact</a>
    </div>
</nav>

<script>
    const navToggle = document.getElementById("nav-toggle");
    const navMenu = document.getElementById("mobile-menu");

    navToggle.addEventListener("click", () => {
        navMenu.classList.toggle("hidden");
    });
</script>
