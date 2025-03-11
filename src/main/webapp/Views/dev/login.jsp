<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link href="<%= request.getContextPath() %>/Content/css/output.css" rel="stylesheet"> <%-- Use local Tailwind --%>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">

    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold text-center mb-4">Login</h2>
        
        <div id="error-message" class="hidden p-2 mb-4 text-red-700 bg-red-100 border border-red-400 rounded"></div>

        <form id="loginForm">
            <div class="mb-4">
                <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                <input type="text" id="username" name="username" required
                    class="mt-1 block w-full px-4 py-2 border rounded-md focus:ring-blue-500 focus:border-blue-500">
            </div>
            <div class="mb-4">
                <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                <input type="password" id="password" name="password" required
                    class="mt-1 block w-full px-4 py-2 border rounded-md focus:ring-blue-500 focus:border-blue-500">
            </div>
            <button type="submit"
                class="w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition">
                Login
            </button>
        </form>
    </div>

    <script>
        document.getElementById("loginForm").addEventListener("submit", async function(event) {
            event.preventDefault(); // Prevent default form submission
            
            let username = document.getElementById("username").value;
            let password = document.getElementById("password").value;
            
            const response = await fetch("<%= request.getContextPath() %>/landing/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ username, password })
            });

            const result = await response.json();
            
            if (result.success) {
                window.location.href = "<%= request.getContextPath() %>/landing"; // Redirect on success
            } else {
                const errorMessage = document.getElementById("error-message");
                errorMessage.innerText = result.message;
                errorMessage.classList.remove("hidden");
            }
        });
    </script>

</body>
</html>
