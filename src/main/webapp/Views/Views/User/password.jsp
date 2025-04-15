<!DOCTYPE html>
<html lang="en">
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
<body class="m-0 p-2 min-h-screen grid grid-rows-[auto,1fr]">

  <!-- Header -->
  <header class="bg-white px-4 py-3">
    <h1 class="text-lg font-bold text-gray-800">Reset your Password</h1>
     <hr class="border-gray-200 mx-1 my-7 " />
  </header>
  

  <!-- Main Content Area (Centered using grid) -->
<main class="grid place-items-center px-4">
  <!-- Fixed grid space for the change password card -->
  <div id="step-container" class="max-w-md w-full h-96 bg-white p-2 rounded-lg space-y-6 flex flex-col">
    
    <!-- Step Indicator -->
    <p class="text-sm text-gray-400 text-right" id="step-indicator">Step 1 of 3</p>
    
    <!-- Step 1 -->
    <div id="step-1" class="step">
      <label class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
      <input
        type="password"
        placeholder="Enter current password"
        class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>

    <!-- Step 2 -->
<div id="step-2" class="step hidden space-y-2">
  <label class="block text-sm font-medium text-gray-700 mb-1">OTP Code</label>
  <p class="text-sm text-gray-500">
    We've sent a 6-digit code to <span class="font-medium text-gray-700">you@example.com</span>
  </p>
  <input
    type="text"
    placeholder="Enter 6-digit code"
    class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
  />
</div>


    <!-- Step 3 -->
    <div id="step-3" class="step hidden space-y-6">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
        <input
          type="password"
          placeholder="Enter new password"
          class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          id="new-password"
        />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
        <input
          type="password"
          placeholder="Confirm new password"
          class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          id="confirm-password"
        />
        <p id="match-msg" class="text-xs text-red-500 mt-1 hidden">Passwords do not match.</p>
      </div>
    </div>

    <!-- Buttons (now inside the same container) -->
    <div class="flex justify-between pt-8">
      <button id="cancel-btn" class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">
        Back
      </button>
      <button id="next-btn" class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">
        Next
      </button>
    </div>
  </div>
</main>




  <!-- jQuery Flow Logic -->
  <script>
    $(function () {
      let currentStep = 1;

      function showStep(step) {
        $('.step').addClass('hidden');
        $('#step-' + step).removeClass('hidden');
        $('#step-indicator').text("Step " + step + " of 3");
        $('#next-btn').text(step === 3 ? 'Submit' : 'Next');
      }

      $('#next-btn').click(function () {
        if (currentStep === 3) {
          const newPass = $('#new-password').val();
          const confirmPass = $('#confirm-password').val();
          if (newPass !== confirmPass) {
            $('#match-msg').removeClass('hidden');
            return;
          }
          $('#match-msg').addClass('hidden');
          alert('✅ Password changed successfully!');
          currentStep = 1;
        } else {
          currentStep++;
        }
        showStep(currentStep);
      });

      $('#cancel-btn').click(function () {
        currentStep = 1;
        showStep(currentStep);
      });

      // Initialize
      showStep(currentStep);
    });
  </script>
</body>
</html>
