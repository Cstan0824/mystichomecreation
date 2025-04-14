<%@ page import="java.util.List" %>
<%@ page import="Models.PaymentMethod" %> <%-- Adjust this import to your actual PaymentMethod model --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Assume 'paymentMethods' is passed from the controller
    List<PaymentMethod> paymentMethods = (List<PaymentMethod>) request.getAttribute("paymentMethods");
    // Assume 'defaultPaymentMethodId' is passed or determined
    int defaultPaymentMethodId = (Integer) request.getAttribute("defaultPaymentMethodId"); // Example
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mystichome Creations - Banks & Cards</title>
    <!-- Tailwind & other resources -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>
<body class="m-0 p-2 bg-gray-100">
    <!-- Page Header -->
    <div class="bg-white px-4 py-3 shadow-sm">
        <h1 class="text-lg font-bold text-gray-800">Banks & Cards</h1>
    </div>

    <!-- Outer container -->
    <div class="bg-white w-full p-4 mt-2">
        <hr class="border-gray-200 mb-4" />

        <% if (paymentMethods != null && !paymentMethods.isEmpty()) { %>
            <% for (PaymentMethod pm : paymentMethods) { %>
                <% boolean isDefault = pm.getId() == defaultPaymentMethodId; %>
                <!-- Payment Method Card -->
                <div class="bg-gray-50 p-4 rounded shadow mb-4 flex flex-col space-y-3 relative border <%= isDefault ? "border-green-300" : "border-gray-200" %>">
                    <div class="flex items-start justify-between">
                        <!-- Card Logo + Info -->
                        <div class="flex space-x-3 items-start">
                            <%-- Determine logo based on card type --%>
                            <% String logoUrl = "https://via.placeholder.com/48"; // Default placeholder
                               if ("Visa".equalsIgnoreCase(pm.getCardType())) {
                                   logoUrl = "https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_2021.svg";
                               } else if ("Mastercard".equalsIgnoreCase(pm.getCardType())) {
                                   logoUrl = "https://upload.wikimedia.org/wikipedia/commons/a/a4/Mastercard_2019_logo.svg";
                               } // Add more card types as needed
                            %>
                            <img
                                src="<%= logoUrl %>"
                                alt="<%= pm.getCardType() %> Logo"
                                class="w-12 h-12 object-contain"
                            />
                            <div>
                                <p class="font-semibold text-gray-700 text-sm"><%= pm.getCardHolderName() %></p>
                                <p class="text-gray-500 text-xs">**** **** **** <%= pm.getLastFourDigits() %></p>
                                <p class="text-gray-400 text-xs mt-1">Expires: <%= pm.getExpiryMonth() %>/<%= pm.getExpiryYear() %></p>
                            </div>
                        </div>
                        <!-- Label: Default -->
                        <% if (isDefault) { %>
                            <span class="border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md">
                                Default
                            </span>
                        <% } %>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex justify-end space-x-2 pt-2 border-t border-gray-200 mt-2">
                        <% if (!isDefault) { %>
                            <!-- Set as Default Form -->
                            <form action="<%= request.getContextPath() %>/User/payments/default" method="POST" class="inline">
                                <input type="hidden" name="paymentMethodId" value="<%= pm.getId() %>">
                                <button type="submit" class="text-xs text-blue-600 hover:text-blue-800">Set as Default</button>
                            </form>
                        <% } %>

                        <!-- Delete Form -->
                        <form action="<%= request.getContextPath() %>/User/payments/delete" method="POST" class="inline" onsubmit="return confirm('Are you sure you want to delete this payment method?');">
                            <input type="hidden" name="paymentMethodId" value="<%= pm.getId() %>">
                            <button type="submit" class="text-xs text-red-600 hover:text-red-800">Delete</button>
                        </form>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <p class="text-center text-gray-500">You have no saved payment methods.</p>
        <% } %>

        <!-- Add New Payment Method Button -->
        <div class="mt-6 text-center">
            <a href="<%= request.getContextPath() %>/User/payments/add"
               class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                <i class="fas fa-plus mr-1"></i> Add New Card/Bank
            </a>
        </div>
    </div>

    <%-- Include any necessary JS for modals or dynamic behavior if needed --%>
    <script>
	
    </script>
</body>
</html>
