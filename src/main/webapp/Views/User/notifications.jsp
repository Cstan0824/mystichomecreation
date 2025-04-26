<!DOCTYPE html>
<html lang="en">
<%@ page import="java.util.List" %>
<%@ page import="mvc.Helpers.Notify.Notification" %>
<%@ page import="mvc.Helpers.Helpers" %>

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Mystichome Creations</title>
	<!-- Tailwind & other resources -->
	<link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
	<link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/swiper.css" />
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>

<body class="m-0 p-2">
	<!-- Page Header -->
	<div class="bg-white px-4 py-3">
		<h1 class="text-lg font-bold text-gray-800">Notifications</h1>
	</div>
	<div class="bg-white w-full p-4">
		<hr class="border-gray-200 p-2" />

		<%
		// Get the ShippingAddresses list from request attributes
		List<Notification> notifications = 
			(List<Notification>)request.getAttribute("notifications");
		
		// Check if there are any addresses to display
		if(notifications != null && !notifications.isEmpty()) {
			// Loop through each shipping address
			for(Notification notification : notifications) {

                // Determine background color based on read status
                String cardClasses = "p-4 rounded shadow mb-4";
                if (!notification.isRead()) {
                    cardClasses += " bg-blue-50 border-l-4 border-blue-300"; // Highlight unread
                } else {
                    cardClasses += " bg-gray-50"; // Default for read
                }
		%>
		<!-- Notification Card -->
        <div class="<%= cardClasses %> notification" data-id="<%= notification.getId() %>">
                <div class="flex justify-between">
                    <div class="text-sm">
                        <p class="font-semibold text-gray-700"><%= notification.getTitle() %></p>
                        <p class="text-xs text-gray-500"><%= notification.getContent() %></p>
                        <p class="text-xs text-gray-400"><%= notification.getCreatedAt() %></p>
                    </div>
                    <%-- Optional: Add a visual indicator like a dot for unread --%>
                    <% if (!notification.isRead()) { %>
                        <span class="w-2 h-2 bg-blue-500 rounded-full ml-3 mt-1 flex-shrink-0" title="Unread"></span>
                    <% } %>
                </div>
            </div>
		<%
			}
		} else {
		%>
		<div class="text-center py-6 text-gray-500">
			<p>No Notification yet.</p>
		</div>
		<%
		}
		%>
	</div>
    <script>
        $(document).ready(function() {
            let contextRoot = '<%= request.getContextPath() %>';
            // Mark notification as read on click
            $('.notification').on('click', function() {
                var notificationId = $(this).data('id');
                $.ajax({
                    url: '<%= request.getContextPath() %>/User/account/notification/redirect',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({ id: notificationId }),
                    success: function(response) {
                        if(response.status == 200){
                            let result = JSON.parse(response.data);
                            if("" == result || null == result || "#" == result) {
                                return;
                            }
                            window.parent.location.href = contextRoot + result;
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error marking notification as read:", error);
                    }
                });
            });
        });
    </script>
</body>

</html>