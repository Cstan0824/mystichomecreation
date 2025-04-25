<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Mystichome Creations</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <style>
        /* Additional custom styles if required */
    </style>
</head>
<body class="bg-grey1 font-poppins leading-normal tracking-normal min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-xl shadow-lg overflow-hidden p-8 space-y-8">
        <!-- Add Back to Home button -->
        <div class="flex justify-between items-center mb-2">
            <a href="<%= request.getContextPath() %>/Landing" class="text-grey4 flex items-center hover:text-darkYellow transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Back to Home
            </a>
        </div>
        
        <div class="text-center">
            <h1 class="text-3xl font-bold text-grey5">Login</h1>
        </div>

        <!-- Display error message if login fails -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            <span class="block sm:inline"><%= request.getAttribute("error") %></span>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/Landing/login" method="POST" class="space-y-6" enctype="multipart/form-data">
            <div class="mb-4">
                <label for="username" class="block text-grey5 font-medium mb-1">Username</label>
                <input id="username" name="username" type="text" placeholder="Enter your username" 
                       class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow" required>
            </div>
            <div class="mb-4">
                <label for="password" class="block text-grey5 font-medium mb-1">Password</label>
                <input id="password" name="password" type="password" placeholder="Enter your password" 
                       class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow" required>
            </div>
            <div class="flex items-center justify-between mb-4">
                <div>
                    <a href="<%= request.getContextPath() %>/User/account/forgetPassword" class="text-sm text-darkYellow hover:text-brown3 transition-colors">
                        Forgot Password?
                    </a>
                </div>
            </div>
            <div class="mb-4">
                <button type="submit" 
                        class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Sign In
                </button>
            </div>
        </form>
        <div class="text-center">
            <p class="text-grey4 text-sm">
                Don't have an account? 
                <a href="<%= request.getContextPath() %>/User/signUp" class="text-darkYellow hover:text-brown3 transition-colors">
                    Sign Up Here
                </a>
            </p>
        </div>
    </div>
</body>
</html>