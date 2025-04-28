<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Up | Mystichome Creations</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Content/css/output.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* Hide all steps by default */
        .step {
            display: none;
        }

        /* Show only the active step */
        .active-step {
            display: block;
        }
    </style>
</head>

<body class="bg-grey1 font-poppins leading-normal tracking-normal min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-xl shadow-lg overflow-hidden p-8 space-y-6">
        <!-- Add this navigation link at the top -->
        <div class="flex justify-between items-center mb-2">
            <a href="<%= request.getContextPath() %>/Landing/login"
                class="text-grey4 flex items-center hover:text-darkYellow transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Back to Login
            </a>
        </div>

        <div class="text-center">
            <h1 id="formTitle" class="text-3xl font-bold text-grey5">Sign Up</h1>
            <p id="formSubtitle" class="mt-2 text-grey4">Create your account</p>
        </div>

        <!-- Step 1: Enter All User Details -->
        <form id="userDetailsForm" class="step active-step space-y-5">
            <div>
                <label for="usernameInput" class="block text-grey5 font-medium mb-1">Username</label>
                <input type="text" id="usernameInput" name="username" placeholder="Enter username"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="emailInput" class="block text-grey5 font-medium mb-1">Email</label>
                <input type="email" id="emailInput" name="email" placeholder="Enter email"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="birthdateInput" class="block text-grey5 font-medium mb-1">Birthdate</label>
                <input type="date" id="birthdateInput" name="birthdate"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="passwordInput" class="block text-grey5 font-medium mb-1">Password</label>
                <input type="password" id="passwordInput" name="password" placeholder="Enter password"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <label for="confirmPasswordInput" class="block text-grey5 font-medium mb-1">Confirm Password</label>
                <input type="password" id="confirmPasswordInput" name="confirmPassword" placeholder="Confirm password"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <button type="button" id="sendOTPButton"
                    class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Send OTP
                </button>
            </div>
        </form>

        <!-- Step 2: Verify OTP & Complete Sign Up (all details + OTP) -->
        <!-- Note: The submission of this form is handled manually via AJAX -->
        <form id="completeSignUpForm" class="step space-y-5">
            <!-- Hidden fields to carry details from Step 1 -->
            <input type="hidden" id="signupUsername" name="username">
            <input type="hidden" id="signupEmail" name="email">
            <input type="hidden" id="signupBirthdate" name="birthdate">
            <input type="hidden" id="signupPassword" name="password">
            <input type="hidden" id="signupConfirmPassword" name="confirmPassword">
            <div>
                <label for="otpInput" class="block text-grey5 font-medium mb-1">OTP</label>
                <input type="text" id="otpInput" name="otp" placeholder="Enter the OTP sent to your email"
                    class="w-full px-4 py-3 border border-grey3 rounded-md focus:outline-none focus:ring-2 focus:ring-darkYellow"
                    required>
            </div>
            <div>
                <button type="button" id="completeSignUpButton"
                    class="w-full px-4 py-3 bg-darkYellow text-white font-medium rounded-md shadow hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-darkYellow transition-colors">
                    Verify OTP & Complete Sign Up
                </button>
            </div>
            <div>
                <p class="text-sm text-gray-500">Didn't receive the code?
                    <button type="button" id="resendOTPLink"
                        class="text-sm text-blue-600 underline hover:text-blue-800 hidden">
                        Resend OTP
                    </button>
                    <span id="resendTimer" class="text-sm text-red-600 hover:text-red-800 hidden"></span>
                </p>
            </div>
        </form>
    </div>

    <script>
        $(document).ready(function() {
            // Step tracking variable
            var currentStep = <%= request.getAttribute("signUpState") %>;
            console.log(currentStep); // Log the current step for debugging
            var resendCooldown = 600; // seconds (10 minutes)
            var resendTimer; // to hold the timer interval
            // Function to show a specific step
            function showStep(stepNum) {
                currentStep = stepNum;
                // Hide all steps
                $(".step").removeClass("active-step");
                // Show current step
                if (stepNum === 1) {
                    $("#userDetailsForm").addClass("active-step");
                    $("#formTitle").text("Sign Up");
                    $("#formSubtitle").text("Create your account");
                } else if (stepNum === 2) {
                    $("#completeSignUpForm").addClass("active-step");
                    $("#formTitle").text("Verify OTP");
                    $("#formSubtitle").text("Enter the OTP sent to your email and complete your registration.");
                    // After 5 seconds, display the Resend OTP timer
                    setTimeout(function() {
                        // Show the timer first
                        $("#resendOTPLink").removeClass("hidden");
                        $("#resendTimer").removeClass("hidden");
                        startResendCooldown();
                    }, 5000);
                }
                // You can easily add more steps here using additional else if statements
            }

            function startResendCooldown() {
                $("#resendTimer").css("pointer-events", "none");
                // Format the time in minutes and seconds
                function formatTime(seconds) {
                    var m = Math.floor(seconds / 60);
                    var s = seconds % 60;
                    return m + "m " + (s < 10 ? "0" : "") + s + "s";
                }
                $("#resendTimer").text(formatTime(resendCooldown));
                resendTimer = setInterval(function() {
                    resendCooldown--;
                    if (resendCooldown <= 0) {
                        clearInterval(resendTimer);
                        // Hide the timer and show the clickable link
                        $("#resendTimer").addClass("hidden");
                        $("#resendOTPLink").removeClass("hidden");
                        resendCooldown = 600; // reset for future clicks
                    } else {
                        $("#resendTimer").text(formatTime(resendCooldown));
                    }
                }, 1000);
            }
            // Initialize to first step
            showStep(1);
            // Step 1: Send OTP Handler
            $("#sendOTPButton").click(function() {
                // Retrieve all details from Step 1
                var username = $("#usernameInput").val();
                var email = $("#emailInput").val();
                var birthdate = $("#birthdateInput").val();
                var password = $("#passwordInput").val();
                var confirmPassword = $("#confirmPasswordInput").val();
                // Basic validation
                if (username.trim() === "" || email.trim() === "" || birthdate.trim() === "" ||
                    password.trim() === "" || confirmPassword.trim() === "") {
                    Swal.fire({
                        icon: "error",
                        title: "Error",
                        text: "Please fill in all the fields.",
                    });
                    return;
                }
                if (password !== confirmPassword) {
                    Swal.fire({
                        icon: "error",
                        title: "Error",
                        text: "Passwords do not match. Please try again.",
                    });
                    return;
                }
                // Use $.ajax to send only username and email to trigger OTP sending.
                $.ajax({
                    url: "<%= request.getContextPath() %>/User/signUp",
                    type: "POST",
                    dataType: "json",
                    data: JSON.stringify({
                        username: username,
                        email: email
                    }),
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            Swal.fire({
                                icon: "success",
                                title: "OTP Sent",
                                text: "An OTP has been sent to "+ email +".",
                            });
                            // Store all details from Step 1 into hidden fields for Step 2.
                            $("#signupUsername").val(username);
                            $("#signupEmail").val(email);
                            $("#signupBirthdate").val(birthdate);
                            $("#signupPassword").val(password);
                            $("#signupConfirmPassword").val(confirmPassword);
                            // Move to step 2
                            showStep(2);
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Error",
                                text: response.message,
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        Swal.fire({
                            icon: "error",
                            title: "Error",
                            text: response.message,
                        });
                    }
                });
            });
            // Step 2: Handle completeSignUpForm submission manually using AJAX.
            $("#completeSignUpButton").click(function() {
                // Gather details from hidden fields and the OTP input.
                var signupData = {
                    user: {
                        username: $("#signupUsername").val(),
                        email: $("#signupEmail").val(),
                        birthdate: $("#signupBirthdate").val(),
                        password: $("#signupPassword").val()
                    },
                    entryOtp: $("#otpInput").val()
                };
                // Validate OTP field is not empty.
                if (signupData.entryOtp.trim() === "") {
                    Swal.fire({
                        icon: "error",
                        title: "Error",
                        text: "Please enter the OTP.",
                    });
                    return;
                }
                // Send the full signup details including OTP to the server.
                $.ajax({
                    url: "<%= request.getContextPath() %>/User/signUp/otp",
                    type: "POST",
                    data: JSON.stringify(signupData),
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            Swal.fire({
                                icon: "success",
                                title: "Sign Up Successful",
                                text: "You have successfully signed up! Redirecting to home...",
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => {
                                window.location.href = "<%= request.getContextPath() %>/Landing";
                            });
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Error",
                                text: response.message,
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        Swal.fire({
                            icon: "error",
                            title: "Error",
                            text: response.message,
                        });
                    }
                });
            });
            // Resend OTP Handler using a simple URL redirect
            $("#resendOTPLink").on("click", function(e) {
                // This is a POST request, so we need to use AJAX to send the email
                var resendUrl = "<%= request.getContextPath() %>/User/signUp/otp/send";
                $.ajax({
                    type: "POST",
                    url: resendUrl,
                    contentType: "application/json",
                    success: function(response) {
                        if (response.status == 200) {
                            Swal.fire({
                                icon: "success",
                                title: "OTP Resent",
                                text: "A new OTP has been sent to your email.",
                            });
                            // Reset cooldown to full 10 minutes (600 seconds)
                            resendCooldown = 600;
                            // Hide the resend link and show the timer again
                            $("#resendOTPLink").removeClass("hidden");
                            $("#resendTimer").removeClass("hidden");
                            // Clear any existing timer before starting a new one
                            if (resendTimer) {
                                clearInterval(resendTimer);
                            }
                            startResendCooldown();
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Error",
                                text: response.message,
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        let response = xhr.responseJSON;
                        Swal.fire({
                            icon: "error",
                            title: "Error",
                            text: response.message,
                        });
                    }
                });
            });
            // Added functionality to go back to previous step
            $("#backButton").click(function() {
                if (currentStep > 1) {
                    showStep(currentStep - 1);
                }
            });
        });
    </script>
</body>

</html>