<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
</head>
<body>
    <jsp:useBean id="companyInfo2" class="Beans.CompanyInfoBean" scope="application" />
    <jsp:setProperty name="companyInfo2" property="copyright" value='<%= application.getInitParameter("copyright") %>' />

    <footer id="footer" class="bg-gray-100 text-gray-700 p-10">
        <div class="max-w-7xl mx-auto text-center sm:text-left grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-10 border-b-2 border-gray-300 pb-10 ">
            <!-- About US -->
            <div>
                <h5 class="font-bold text-lg mb-4">About MYC</h5>
                <ul class="space-y-2">
                    <li><a href="#choose-us" class="hover:underline">Why Choose Us</a></li>
                    <li><a href="#about-us" class="hover:underline">About Us</a></li>
                </ul>
            </div>

            <!-- Help -->
            <div>
                <h5 class="font-bold text-lg mb-4">Help</h5>
                <ul class="space-y-2">
                    <li><a href="#contact-us" class="hover:underline">Customer Support</a></li>
                </ul>
            </div>

            <!-- Account -->
            <div>
                <h5 class="font-bold text-lg mb-4">Account</h5>
                <ul class="space-y-2">
                    <li><a href="<%= request.getContextPath() %>/User/account#profile" class="hover:underline">Profile</a></li>
                    <li><a href="<%= request.getContextPath() %>/User/account#vouchers" class="hover:underline">Vouchers</a></li>

                </ul>
            </div>
            

            <!-- MYC Social Account -->
            <div>
                <h5 class="font-bold text-lg mb-4">MYC Social Account</h5>
                <div class="flex space-x-4 justify-center sm:justify-start">
                    <a href="#" class="hover:opacity-75 transition-all duration-200">
                        <img src="<%= request.getContextPath() %>/Content/assets/image/facebook-icon.webp" 
                             alt="Facebook" 
                             class="w-8 h-8 object-contain rounded hover:shadow-md hover:scale-110">
                    </a>
                    <a href="#" class="hover:opacity-75 transition-all duration-200">
                        <img src="<%= request.getContextPath() %>/Content/assets/image/instagram-icon.avif" 
                             alt="Instagram" 
                             class="w-8 h-8 object-contain rounded hover:shadow-md hover:scale-110">
                    </a>
                    <a href="#" class="hover:opacity-75 transition-all duration-200">
                        <img src="<%= request.getContextPath() %>/Content/assets/image/youtube-icon.webp" 
                             alt="YouTube" 
                             class="w-8 h-8 object-contain rounded hover:shadow-md hover:scale-110">
                    </a>
                </div>
            </div>
        </div>
        <div class="text-center text-sm mt-10">
            <jsp:getProperty name="companyInfo" property="copyright" />
        </div>
    </footer>

    <!-- Add smooth scrolling script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Find all links in the footer
            const footerLinks = document.querySelectorAll('footer a[href^="#"]');
            
            // Add click event listeners to each link
            footerLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    // Only prevent default for hash links (not full URLs)
                    if (this.getAttribute('href').startsWith('#')) {
                        e.preventDefault();
                        
                        // Get the target element
                        const targetId = this.getAttribute('href');
                        const targetElement = document.querySelector(targetId);
                        
                        // If target exists, scroll to it smoothly
                        if (targetElement) {
                            // Scroll to the element smoothly
                            targetElement.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                            
                            // Update URL hash for bookmarking
                            history.pushState(null, null, targetId);
                        }
                    }
                });
            });
        });
        
        // Function to be called from outside (like the LEARN MORE button)
        function scrollToFooter() {
            document.getElementById('footer').scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    </script>
</body>
</html>