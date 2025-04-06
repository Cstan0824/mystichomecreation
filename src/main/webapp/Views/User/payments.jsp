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
<body class="m-0 p-2">
<!-- Page Header -->
<div class="bg-white px-4 py-3">
  <h1 class="text-lg font-bold text-gray-800">Banks & Cards</h1>
</div>

  <!-- Outer container -->
  <div class="bg-white w-full p-4">
      <hr class="border-gray-200 p-2" />

    <!-- Card 1: Default card (no button) -->
    <div class="bg-gray-50 p-4 rounded shadow mb-4 flex flex-col space-y-2 relative">
      <div class="flex items-start justify-between">
        <!-- Card Logo + Info -->
        <div class="flex space-x-3 items-start">
          <img 
            src="https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_2021.svg" 
            alt="Visa Logo" 
            class="w-12 h-12 object-contain" 
          />
          <div>
            <p class="font-semibold text-gray-700 text-sm">TAN CHOON SHEN</p>
            <p class="text-gray-500 text-xs">**** **** **** 1234</p>
          </div>
        </div>
        <!-- Label: Default -->
        <span class="border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md">
          Default
        </span>
      </div>
      <div>
        <p class="text-gray-400 text-xs uppercase">Expires</p>
        <p class="text-gray-700 text-sm">05/2025</p>
      </div>
    </div>

    <!-- Card 2: Set as default button -->
    <div class="bg-gray-50 p-4 rounded shadow mb-4 flex flex-col space-y-2 relative">
      <div class="flex items-start justify-between">
        <!-- Card Logo + Info -->
        <div class="flex space-x-3 items-start">
          <img 
            src="https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_2021.svg" 
            alt="Visa Logo" 
            class="w-12 h-12 object-contain" 
          />
          <div>
            <p class="font-semibold text-gray-700 text-sm">TAN CHOON SHEN</p>
            <p class="text-gray-500 text-xs">**** **** **** 5678</p>
          </div>
        </div>
        <!-- "Set as Default" Button -->
        <button 
          class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">
          Set as default
        </button>
      </div>
      <div>
        <p class="text-gray-400 text-xs uppercase">Expires</p>
        <p class="text-gray-700 text-sm">07/2027</p>
      </div>
    </div>

    <!-- "Add New Card" Tile -->
    <div
      class="bg-white rounded-xl border-2 border-dashed border-gray-300 
             flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50">
      <div class="flex flex-col items-center space-y-2">
        <span class="text-2xl text-gray-400">+</span>
        <p class="text-gray-600 text-sm">Add New Card</p>
      </div>
    </div>

  </div>
  <script>
   $(function () {
    $('.cursor-pointer').on('click', function () {
      const $modal = $(window.parent.document).find('#cardModal');
      $modal.removeClass('hidden').addClass('flex');
    });
  });
  </script>
</body>
</html>
