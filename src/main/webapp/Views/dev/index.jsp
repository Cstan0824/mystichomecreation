<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Landing Page</title>
    <link href="<%= request.getContextPath() %>/Content/css/output.css" rel="stylesheet"> <%-- Use local Tailwind --%>
</head>
<body class="bg-gray-100 text-gray-900">

    <%@ include file="/Views/Shared/_Navigation.jsp" %>

    <!-- Hero Section -->
    <header class="bg-blue-600 text-white text-center py-16">
        <div class="container mx-auto px-4">
            <h1 class="text-4xl font-bold">Welcome <%= request.getAttribute("userName") %>!</h1>
            <p class="text-lg mt-2">The best solution for your business</p>
            <a href="#features" class="mt-4 inline-block bg-white text-blue-600 px-6 py-2 rounded-lg font-semibold">Explore Features</a>
        </div>
    </header>

    <!-- Features Section -->
    <section id="features" class="py-16">
        <div class="container mx-auto px-4">
            <h2 class="text-center text-3xl font-bold mb-8">Why Choose Us?</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <%
                    java.util.List<String> features = (java.util.List<String>) request.getAttribute("features");
                    if (features != null) {
                        for (String feature : features) {
                %>
                    <div class="bg-white p-6 rounded-lg shadow-md text-center">
                        <h5 class="text-xl font-semibold"><%= feature %></h5>
                    </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section id="testimonials" class="bg-gray-200 py-16">
        <div class="container mx-auto px-4">
            <h2 class="text-center text-3xl font-bold mb-8">What Our Clients Say</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <%
                    java.util.List<String> testimonials = (java.util.List<String>) request.getAttribute("testimonials");
                    if (testimonials != null) {
                        for (String testimonial : testimonials) {
                %>
                    <div class="bg-white p-6 rounded-lg shadow-md">
                        <p class="text-gray-700"><%= testimonial %></p>
                    </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </section>

    <!-- Users Section -->
    <section id="users" class="bg-gray-200 py-16">
        <div class="container mx-auto px-4">
            <h2 class="text-center text-3xl font-bold mb-8">Our Dev Contacts</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <%
                    java.util.List<com.yourpackage.User> users = (java.util.List<com.yourpackage.User>) request.getAttribute("users");
                    if (users != null) {
                        for (com.yourpackage.User user : users) {
                %>
                    <div class="bg-white p-6 rounded-lg shadow-md">
                        <p class="text-gray-700"><%= user.getEmail() %></p>
                    </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-16 text-center">
        <div class="container mx-auto px-4">
            <h2 class="text-3xl font-bold">Contact Us</h2>
            <p class="mt-4">Email us at <a href="mailto:support@mybrand.com" class="text-blue-600 font-semibold">support@mybrand.com</a></p>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white text-center py-6">
        <p>&copy; 2025 MyBrand. All rights reserved.</p>
    </footer>

</body>
</html>
