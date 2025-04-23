<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Password Reset | Mystichome Creations</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <style>
        /* Hide steps by default */
        .step {
            display: none;
        }

        .active-step {
            display: block;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-grey1 font-poppins leading-normal tracking-normal min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-xl shadow-lg overflow-hidden p-8 space-y-6">
        <div class="text-center">
            <h1 id="formTitle" class="text-3xl font-bold text-grey5">Verify Your Email</h1>
        </div>

        <!-- Step 1: Email Verification -->
        <form id="emailForm" action="<%= request.getContextPath() %>/User/account/password/verify" method="POST"
            class="step active-step space-y-5">
            <div>
                <label for="username" class="block text-grey5 font-medium mb-1">Username</label>
                <input id="username" name="username" type="text" placeholder="Enter your username"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="email" class="block text-grey5 font-medium mb-1">Email</label>
                <input id="email" name="email" type="email" placeholder="Enter your email"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>

            <div>
                <button type="submit"
                    class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Verify Email
                </button>
            </div>
        </form>

        <!-- Step 2: OTP Verification -->
        <form id="otpForm" action="<%= request.getContextPath() %>/Landing/account/password/otp" method="POST"
            class="step space-y-5">
            <div>
                <label for="otp" class="block text-grey5 font-medium mb-1">OTP</label>

            </div>
            <input id="otp" name="otp" type="text" placeholder="Enter the OTP"
                class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                required>
            <div>
                <button type="submit"
                    class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Verify OTP
                </button>
               
            </div>
            <p class="text-sm text-gray-500">Didn't receive the code?
            <button type="button" id="resendOTPLink" class="text-sm text-blue-600 underline hover:text-blue-800 hidden">
                Resend OTP
            </button>
        </p>
        </form>
         

        <!-- Step 3: Change Password -->
        <form id="changePassForm" action="<%= request.getContextPath() %>/Landing/account/password/new" method="POST"
            class="step space-y-5">
            <div>
                <label for="newPassword" class="block text-grey5 font-medium mb-1">New Password</label>
                <input id="newPassword" name="newPassword" type="password" placeholder="Enter new password"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="confirmPassword" class="block text-grey5 font-medium mb-1">Confirm Password</label>
                <input id="confirmPassword" name="confirmPassword" type="password" placeholder="Confirm your password"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <button type="submit"
                    class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Change Password
                </button>
            </div>
        </form>

        <div class="text-center">
            <p class="text-grey4 text-sm">
                Remembered your password?
                <a href="<%= request.getContextPath() %>/Landing/login"
                    class="text-darkYellow hover:text-brown3 transition-colors">
                    Sign In
                </a>
            </p>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            var verifiedEmail = "";
            var resendCooldown = 600; // seconds (10 minutes)
            var resendTimer; // to hold the timer interval

            // Format seconds into mm:ss
            function formatTime(seconds) {
                var m = Math.floor(seconds / 60);
                var s = seconds % 60;
                return m + "m " + (s < 10 ? "0" : "") + s + "s";
            }

            // Start the cooldown and countdown display
            function startResendCooldown() {
                $("#resendOTPLink").css("pointer-events", "none");
                $("#resendOTPLink").text("Resend OTP (" + formatTime(resendCooldown) + ")");
                resendTimer = setInterval(function() {
                    resendCooldown--;
                    if (resendCooldown <= 0) {
                        clearInterval(resendTimer);
                        $("#resendOTPLink").css("pointer-events", "auto").text("Resend OTP");
                        resendCooldown = 600; // reset for future clicks
                    } else {
                        $("#resendOTPLink").text("Resend OTP (" + formatTime(resendCooldown) + ")");
                    }
                }, 1000);
            }

            // Handle Email Verification (Step 1) with AJAX.
            $("#emailForm").submit(function(e) {
                e.preventDefault();
                var username = $("#username").val();
                var email = $("#email").val();
                $.ajax({
                    type: "POST",
                    url: "<%= request.getContextPath() %>/User/account/password/verify",
                    data: JSON.stringify({ username: username, email: email }),
                    contentType: "application/json",
                    success: function(response) {
                        // Proceed only if status is 200.
                        if (response.status == 200) {
                            verifiedEmail = email;
                            // Switch to OTP step.
                            $("#emailForm").removeClass("active-step");
                            $("#otpForm").addClass("active-step");
                            $("#formTitle").text("Enter OTP");
                            // After 5 seconds, display the Resend OTP button and start its countdown.
                            setTimeout(function() {
                                $("#resendOTPLink").show();
                                startResendCooldown();
                            }, 5000);
                        } else {
                            alert("Email verification failed. Please try again.");
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("Email verification failed. Please try again.");
                    }
                });
            });

            // Handle OTP Verification (Step 2) with AJAX.
            $("#otpForm").submit(function(e) {
                e.preventDefault();
                var otp = $("#otp").val();
                if (otp.trim() === "") {
                    alert("Please enter the OTP.");
                    return;
                }
                $.ajax({
                    type: "POST",
                    url: "<%= request.getContextPath() %>/Landing/account/password/otp",
                    data: JSON.stringify({ otp: otp }),
                    contentType: "application/json",
                    success: function(response) {
                        // Proceed only if status is 200.
                        if (response.status == 200) {
                            $("#otpForm").removeClass("active-step");
                            $("#changePassForm").addClass("active-step");
                            $("#formTitle").text("Change Password");
                        } else {
                            alert("OTP verification failed. Please check your OTP and try again.");
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("OTP verification failed. Please check your OTP and try again.");
                    }
                });
            });

            // Resend OTP button handler (Step 2) with AJAX.
            $("#resendOTPLink").on("click", function(e) {
                e.preventDefault();
                if (verifiedEmail === "") {
                    alert("Email address not found.");
                    return;
                }
                if ($(this).css("pointer-events") === "none") {
                    return;
                }
                var resendUrl = "<%= request.getContextPath() %>/user/account/password/otp";
                $.ajax({
                    type: "POST",
                    url: resendUrl,
                    data: JSON.stringify({ email: verifiedEmail }),
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            alert("OTP resent successfully!");
                            startResendCooldown();
                        } else {
                            alert("Failed to resend OTP. Please try again.");
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("Failed to resend OTP. Please try again.");
                    }
                });
            });
        });
    </script>
</body>

</html>