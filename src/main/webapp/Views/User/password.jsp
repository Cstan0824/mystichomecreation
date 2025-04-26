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
    <hr class="border-gray-200 mx-1 my-7" />
  </header>

  <!-- Main Content Area -->
  <main class="grid place-items-center px-4">
    <div id="step-container" class="max-w-md w-full h-96 bg-white p-2 rounded-lg space-y-6 flex flex-col">
      
      <!-- Step Indicator -->
      <p class="text-sm text-gray-400 text-right" id="step-indicator">Step 1 of 3</p>
      
      <!-- Step 1 -->
      <div id="step-1" class="step">
        <label class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
        <input type="password" placeholder="Enter current password"
          class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
      </div>

      <!-- Step 2 -->
      <div id="step-2" class="step hidden space-y-2">
        <label class="block text-sm font-medium text-gray-700 mb-1">OTP Code</label>
        <p class="text-sm text-gray-500">
          We've sent a 6-digit code to <span class="font-medium text-gray-700"><%= request.getAttribute("email") %></span>
        </p>
        <p id="otp-timer" class="text-sm text-red-500 font-medium hidden">
          This code will expire in <span id="countdown">10:00</span>
        </p>
        <input type="text" placeholder="Enter 6-digit code"
          class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />

		 
		<p class="text-sm text-gray-500">Didn't receive the code?
			<button id="resend-otp-btn" class="text-sm text-blue-600 underline hover:text-blue-800 hidden">
			Resend OTP
			</button>
		</p>

      </div>

      <!-- Step 3 -->
      <div id="step-3" class="step hidden space-y-6">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
          <input type="password" placeholder="Enter new password"
            class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" id="new-password" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
          <input type="password" placeholder="Confirm new password"
            class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" id="confirm-password" />
          <p id="match-msg" class="text-xs text-red-500 mt-1 hidden">Passwords do not match.</p>
        </div>
      </div>

      <!-- Buttons -->
      <div class="flex justify-between pt-8">
        <button id="cancel-btn" class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Back</button>
        <button id="next-btn" class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Next</button>
      </div>
    </div>
  </main>

  <!-- jQuery Flow Logic -->
  <script>
  $(function () {
    let currentStep = parseInt('<%= request.getAttribute("passwordChangeState") %>');
    let countdownInterval;

    function updateCountdownDisplay(seconds) {
      const minutes = Math.floor(seconds / 60);
      const secs = seconds % 60;
      let formatted = (minutes < 10 ? '0' + minutes : minutes) + ':' + (secs < 10 ? '0' + secs : secs);
      $('#countdown').text(formatted);
    }

    function startOtpTimer(durationSeconds) {
      let timeLeft = durationSeconds;
      $('#otp-timer').removeClass('hidden');
      updateCountdownDisplay(timeLeft);

      countdownInterval = setInterval(function () {
        timeLeft--;
        updateCountdownDisplay(timeLeft);
        if (timeLeft <= 0) {
          clearInterval(countdownInterval);
          alert("OTP expired. Please request a new one.");
          currentStep = 1;
          showStep(currentStep);
        }
      }, 1000);
    }

    function showStep(step) {
		$('.step').addClass('hidden');
		$('#step-' + step).removeClass('hidden');
		$('#step-indicator').text('Step ' + step + ' of 3');
		$('#next-btn').text(step === 3 ? 'Submit' : 'Next');

		if (step === 2) {
			clearInterval(countdownInterval);
			$('#resend-otp-btn').addClass('hidden'); // Hide initially
			startOtpTimer(600); // Start 10-minute OTP timer

			// Show resend button after 10 seconds
			setTimeout(function () {
			$('#resend-otp-btn').removeClass('hidden');
			}, 6000);

		} else {
			$('#resend-otp-btn').addClass('hidden');
			$('#otp-timer').addClass('hidden');
			clearInterval(countdownInterval);
		}
	}


    $('#next-btn').click(function () {
      if (currentStep == 1) {
        const currentPassword = $('#step-1 input').val();
        $.ajax({
          url: '<%= request.getContextPath() %>/User/account/password/verify',
          method: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({ password: currentPassword }),
          success: function (response) {
            if (response.status == 200) {
              currentStep++;
              showStep(currentStep);
            }
            alert(response.message);
          },
          error: function () {
            alert('Incorrect current password.');
          }
        });

      } else if (currentStep == 2) {
        const otp = $('#step-2 input').val();
        $.ajax({
          url: '<%= request.getContextPath() %>/User/account/password/otp',
          method: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({ otp: otp }),
          success: function (response) {
            if (response.status == 200) {
              currentStep++;
              showStep(currentStep);
            }
            alert(response.message);
          },
          error: function () {
            alert('Invalid OTP code.');
          }
        });

      } else if (currentStep == 3) {
        const newPass = $('#new-password').val();
        const confirmPass = $('#confirm-password').val();

        if (newPass !== confirmPass) {
          $('#match-msg').removeClass('hidden');
          return;
        }

        $('#match-msg').addClass('hidden');

        $.ajax({
          url: '<%= request.getContextPath() %>/User/account/password/new',
          method: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({ newPassword: newPass }),
          success: function (response) {
            if (response.status == 200) {
              currentStep = 1;
              showStep(currentStep);

              // Clear fields
              $('#step-1 input').val('');
              $('#step-2 input').val('');
              $('#new-password').val('');
              $('#confirm-password').val('');

              alert('Password changed successfully!');
            } else {
              alert(response.message);
            }
          },
          error: function () {
            alert('Failed to change password.');
          }
        });
      }
    });

    $('#cancel-btn').click(function () {
      currentStep = 1;
      showStep(currentStep);
    });

	$("#resend-otp-btn").on("click", function () {
		$.ajax({
			url: '<%= request.getContextPath() %>/User/account/password/otp/send',
			method: 'POST',
			contentType: 'application/json',
			success: function (response) {
				if (response.status == 200) {
					alert('OTP resent successfully!');
          			clearInterval(countdownInterval);
					startOtpTimer(600); // Restart the timer
				} else {
					alert(response.message);
				}
			},
			error: function () {
				alert('Failed to resend OTP.');
			}
		});
	});

    showStep(1);
  });
</script>


</body>
</html>
