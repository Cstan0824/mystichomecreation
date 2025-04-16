<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">

</head>
<body>
    <footer class="bg-gray-100 text-gray-700 p-10">
        <div class="max-w-7xl mx-auto text-center sm:text-left grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-10 border-b-2 border-gray-300 pb-10 ">
            <!-- About UNIQLO -->
            <div>
                <h5 class="font-bold text-lg mb-4">About UNIQLO</h5>
                <ul class="space-y-2">
                    <li><a href="#" class="hover:underline">Information</a></li>
                    <li><a href="#" class="hover:underline">Store Locator</a></li>
                    <li><a href="#" class="hover:underline">Careers</a></li>
                </ul>
            </div>

            <!-- Help -->
            <div>
                <h5 class="font-bold text-lg mb-4">Help</h5>
                <ul class="space-y-2">
                    <li><a href="#" class="hover:underline">FAQ</a></li>
                    <li><a href="#" class="hover:underline">Bulk Purchase</a></li>
                </ul>
            </div>

            <!-- Account -->
            <div>
                <h5 class="font-bold text-lg mb-4">Account</h5>
                <ul class="space-y-2">
                    <li><a href="#" class="hover:underline">Membership</a></li>
                    <li><a href="#" class="hover:underline">Profile</a></li>
                    <li><a href="#" class="hover:underline">Coupons</a></li>

                </ul>
            </div>
            

            <!-- UNIQLO Social Account -->
            <div>
                <h5 class="font-bold text-lg mb-4">UNIQLO Social Account</h5>
                <div class="flex space-x-4">
                    <a href="#" class="hover:opacity-75"><img src="path_to_facebook_icon" alt="Facebook"></a>
                    <a href="#" class="hover:opacity-75"><img src="path_to_instagram_icon" alt="Instagram"></a>
                    <a href="#" class="hover:opacity-75"><img src="path_to_youtube_icon" alt="YouTube"></a>
                </div>
            </div>
        </div>
        <div class="text-center text-sm mt-10">
            COPYRIGHT © UNIQLO CO., LTD. ALL RIGHTS RESERVED.
        </div>
    </footer>
</body>
</html>