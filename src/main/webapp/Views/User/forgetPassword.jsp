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
        <!-- Change from a static link to a dynamic element with ID -->
        <div class="flex justify-between items-center mb-2">
            <a id="backLink" href="<%= request.getContextPath() %>/Landing/login" 
               class="text-grey4 flex items-center hover:text-darkYellow transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                <span id="backLinkText">Back to Login</span>
            </a>
        </div>

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
            <div>
  <p class="text-sm text-gray-500 flex items-center gap-2 flex-wrap">
    <span>Didn't receive the code?</span>
    
    <button type="button" id="resendOTPLink"
      class="text-sm text-blue-600 underline hover:text-blue-800 hidden">
      Resend OTP
    </button>

    <span id="resendTimer" class="text-sm text-red-600 hover:text-red-800 hidden"></span>
  </p>
</div>

        </form>

        <!-- Step 3: Change Password -->
        <form id="changePassForm" action="<%= request.getContextPath() %>/User/account/password/new" method="POST"
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
            var currentStep = <%= request.getAttribute("forgotPasswordState") %>; // Track which step we're on
            var resendCooldown = 600; // seconds (10 minutes)
            var resendTimer; // to hold the timer interval
            // Function to show a specific step
            function showStep(stepNum) {
                currentStep = stepNum;
                
                // Hide all steps
                $(".step").removeClass("active-step");
                
                // Update the back link based on current step
                if (stepNum === 2) {
                    // When on step 2, change to "Back to previous step"
                    $("#backLinkText").text("Back to previous step");
                    $("#backLink").attr("href", "#").off("click").on("click", function(e) {
                        e.preventDefault();
                        showStep(1); // Go back to step 1
                    });
                } else {
                    // For step 1 and 3, keep as "Back to Login"
                    $("#backLinkText").text("Back to Login");
                    $("#backLink").attr("href", "<%= request.getContextPath() %>/Landing/login")
                        .off("click"); // Remove any click handlers
                }
                
                // Show current step
                if (stepNum === 1) {
                    $("#emailForm").addClass("active-step");
                    $("#formTitle").text("Verify Your Email");
                } else if (stepNum === 2) {
                    $("#otpForm").addClass("active-step");
                    $("#formTitle").text("Enter OTP");
                    // After 5 seconds, display the Resend OTP timer
                    setTimeout(function() {
                        $("#resendOTPLink").removeClass("hidden");
                        $("#resendTimer").removeClass("hidden");
                        startResendCooldown();
                    }, 5000);
                } else if (stepNum === 3) {
                    $("#changePassForm").addClass("active-step");
                    $("#formTitle").text("Change Password");
                }
            }
            // Initialize to first step
            showStep(1);
            // Format seconds into mm:ss
            function formatTime(seconds) {
                var m = Math.floor(seconds / 60);
                var s = seconds % 60;
                return m + "m " + (s < 10 ? "0" : "") + s + "s";
            }
            // Start the cooldown and countdown display
            function startResendCooldown() {
                // Hide the clickable link and show the timer
                $("#resendOTPLink").addClass("hidden");
                $("#resendTimer").removeClass("hidden");
                
                $("#resendTimer").css("pointer-events", "none");
                $("#resendTimer").text(formatTime(resendCooldown));
                
                // Clear any existing timer to prevent multiple intervals running
                if (resendTimer) {
                    clearInterval(resendTimer);
                }
                
                resendTimer = setInterval(function() {
                    resendCooldown--;
                    if (resendCooldown <= 0) {
                        clearInterval(resendTimer);
                        // Hide timer and show clickable link
                        $("#resendTimer").addClass("hidden");
                        $("#resendOTPLink").removeClass("hidden");
                        resendCooldown = 600; // reset for future clicks
                    } else {
                        $("#resendTimer").text(formatTime(resendCooldown));
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
                    url: "<%= request.getContextPath() %>/User/account/forgetPassword/verify",
                    data: JSON.stringify({
                        username: username,
                        email: email
                    }),
                    contentType: "application/json",
                    success: function(response) {
                        // Proceed only if status is 200.
                        if (response.status == 200) {
                            // Move to step 2 using our central function
                            showStep(2);
                            // After 5 seconds, display the Resend OTP button and start its countdown.
                            setTimeout(function() {
                                $("#resendOTPLink").show();
                                startResendCooldown();
                            }, 5000);
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        alert(response.message);
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
                    url: "<%= request.getContextPath() %>/User/account/password/otp",
                    data: JSON.stringify({
                        otp: otp
                    }),
                    contentType: "application/json",
                    success: function(response) {
                        // Proceed only if status is 200.
                        if (response.status == 200) {
                            // Move to step 3 using our central function
                            showStep(3);
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        alert(response.message);                    
                        }
                });
            });
            // Resend OTP button handler (Step 2) with AJAX.
            $("#resendOTPLink").on("click", function(e) {
                e.preventDefault();
                if ($(this).css("pointer-events") === "none") {
                    return;
                }
                var resendUrl = "<%= request.getContextPath() %>/User/account/password/otp/send";
                $.ajax({
                    type: "POST",
                    url: resendUrl,
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            alert("OTP resent successfully!");
                            // Reset the cooldown timer to 10 minutes (600 seconds)
                            resendCooldown = 600;
                            // Clear any existing timer to prevent multiple timers running
                            if (resendTimer) {
                                clearInterval(resendTimer);
                            }
                            // Start a fresh countdown
                            startResendCooldown();
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        alert(response.message);
                    }
                });
            });
            // Handle Password Change Form submission (Step 3) with AJAX
            $("#changePassForm").submit(function(e) {
                e.preventDefault(); // Prevent the default form submission
                
                // Get the password values
                var newPassword = $("#newPassword").val();
                var confirmPassword = $("#confirmPassword").val();
                
                // Validate passwords
                if (newPassword.trim() === "") {
                    alert("Please enter a new password.");
                    return;
                }
                
                // Check if passwords match
                if (newPassword !== confirmPassword) {
                    alert("Passwords do not match. Please try again.");
                    return;
                }
                
                // Send only the new password as JSON
                $.ajax({
                    type: "POST",
                    url: "<%= request.getContextPath() %>/User/account/forgetPassword/new",
                    data: JSON.stringify({
                        newPassword: newPassword
                    }),
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            // Redirect to login page
                            window.location.href = "<%= request.getContextPath() %>/Landing/login";
                        } else {
                            alert(response.message || "Failed to reset password. Please try again.");
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON || {};
                        alert(response.message || "Failed to reset password. Please try again.");
                    }
                });
            });
            // Add this if you want to support going back to previous steps
            $("#backButton").click(function() {
                if (currentStep > 1) {
                    showStep(currentStep - 1);
                }
            });
        });
    </script>
</body>

</html>