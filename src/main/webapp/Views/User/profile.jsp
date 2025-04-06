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

<body class="m-2 pb-24 p-2">
  <!-- 
       pb-24 on <body> to ensure 
       the bottom bar doesn’t overlap content 
  -->

  <!-- Profile Header -->
  <div class="flex items-start space-x-6 pb-6">
    <!-- Profile Picture -->
    <div class="relative group">
      <img src="your-profile.jpg" id="profile-pic" class="w-20 h-20 rounded-full object-cover border" />
      <input type="file" id="pic-input" class="hidden" accept="image/*" />
    </div>

    <!-- Username + Email Display -->
    <div>
      <h2 class="text-xl font-semibold text-gray-900">Tan Choon Shen</h2>
      <p class="text-gray-500">cstan@gmail.com</p>
    </div>
  </div>

  <!-- Horizontal line before forms -->
  <hr class="border-gray-200" />

  <!-- Forms -->
  <div class="space-y-12 py-6">
    

    <!-- Username -->
    <div class="grid grid-cols-10 gap-4 items-center">
      <label class="col-span-3 text-sm font-medium text-gray-700">Username</label>
      <input
        type="text"
        value="john_doe"
        class="col-span-7 border rounded-lg px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>

	<!-- Email -->
    <div class="grid grid-cols-10 gap-4 items-center">
      <label class="col-span-3 text-sm font-medium text-gray-700">Email Address</label>
      <div class="col-span-7 flex items-center border rounded-lg px-3 py-2 bg-white">
        <span class="text-gray-500 px-1"><i class="fa-solid fa-envelope"></i></span>
        <input type="email" value="john@example.com" class="ml-1 flex-1 focus:outline-none" />
      </div>
    </div>

    <!-- Birthdate -->
    <div class="grid grid-cols-10 gap-4 items-center">
      <label class="col-span-3 text-sm font-medium text-gray-700">Birthdate</label>
      <input
        type="date"
        value="2025-04-04"
        class="col-span-7 border rounded-lg px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
  </div>

  <!-- Horizontal line after forms -->
  <hr class=" border-gray-200" />

  <!-- Fixed Footer Buttons -->
  <div
    class="fixed bottom-0 left-0 right-0 bg-white flex justify-end items-center p-4 space-x-2">
    <!-- If you prefer them spaced or at different positions, adjust the flex classes -->
    <button class="px-4 py-2 text-sm rounded-md border hover:bg-gray-100">Cancel</button>
    <button class="px-4 py-2 text-sm rounded-md bg-black text-white hover:bg-gray-800">Save changes</button>
  </div>

  <!-- jQuery/GSAP Script -->
  <script>
    $(function() {
      // Let user click the pic to open file chooser
      $('#profile-pic').on('click', function() {
        $('#pic-input').click();
      });

      // When user picks a file, load/preview it
      $('#pic-input').on('change', function(e) {
        const file = e.target.files[0];
        if (file) {
          const reader = new FileReader();
          reader.onload = function(e) {
            $('#profile-pic').attr('src', e.target.result);
            gsap.fromTo('#profile-pic',
              { scale: 0.8, opacity: 0.7 },
              { scale: 1, opacity: 1, duration: 0.4 }
            );
          };
          reader.readAsDataURL(file);
        }
      });
    });
  </script>
</body>
</html>
