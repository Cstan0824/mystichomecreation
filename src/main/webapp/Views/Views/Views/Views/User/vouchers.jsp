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

<body class="p-2 m-0">
    <div class="bg-white px-4 py-3">
        <h1 class="text-lg font-bold text-gray-800">My Vouchers</h1>
    </div>

    <div class="bg-white w-full p-4">
        <hr class="border-gray-200 p-2" />

        <!-- Voucher 1 (example) -->
        <div class="bg-gray-50 p-4 rounded shadow mb-4">
            <div class="flex justify-between">
                <div class="text-sm">
                    <p class="font-semibold text-gray-700">VOUCHER NAME &middot; VOURCHER AMOUNT[VOUCHER
                        TYPE{integer/decimal}]</p>
                    <p class="text-xs text-gray-500">VOUCHER DESCRIPTION</p>
                    <p class="text-xs text-gray-400">MIN: RMXX &middot; MAX: RMXXX</p>
                    <p class="text-xs text-gray-400">USED FOR CURRENT MONTH/TOTAL AVAILABLE FOR CURRENT MONTH</p>
                </div>
                <!-- Replace this block -->
                <div class="flex space-x-2 items-start">
                    <button
                        class="status-btn border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md hover:bg-green-50"
                        data-status="active">
                        Active
                    </button><button
                        class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">Edit</button>

                    <button
                        class="border border-red-500 text-red-500 text-xs px-3 py-1 rounded-md hover:bg-red-50">Remove</button>

                </div>
            </div>
        </div>
        <!-- Voucher 1 (example) -->
        <div class="bg-gray-50 p-4 rounded shadow mb-4">
            <div class="flex justify-between">
                <div class="text-sm">
                    <p class="font-semibold text-gray-700">Huge Discount For this Month only &middot; RM300</p>
                    <p class="text-xs text-gray-500">Huge discount for current month</p>
                    <p class="text-xs text-gray-400">MIN: RM50 &middot; MAX: RM350</p>
                    <p class="text-xs text-gray-400">Usage: 2/3</p>
                </div>
                <div class="flex space-x-2 items-start">
                    <button
                        class="status-btn border border-green-500 text-green-500 text-xs px-3 py-1 rounded-md hover:bg-green-50"
                        data-status="active">
                        Active
                    </button><button
                        class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">Edit</button>

                    <button
                        class="border border-red-500 text-red-500 text-xs px-3 py-1 rounded-md hover:bg-red-50">Remove</button>

                </div>
            </div>
        </div>
        <!-- Voucher 1 (example) -->
        <div class="bg-gray-50 p-4 rounded shadow mb-4">
            <div class="flex justify-between">
                <div class="text-sm">
                    <p class="font-semibold text-gray-700">Huge Discount For this Month only &middot; 30%</p>
                    <p class="text-xs text-gray-500">Huge discount for current month</p>
                    <p class="text-xs text-gray-400">MIN: RM50 &middot; MAX: RM350</p>
                    <p class="text-xs text-gray-400">Usage: 2/3</p>
                </div>
                <div class="flex space-x-2 items-start">
                    <button
                        class="status-btn border text-gray-500 border-gray-400 text-xs px-3 py-1 rounded-md  hover:bg-gray-100"
                        data-status="inactive">
                        Inactive
                    </button><button
                        class="border border-blue-500 text-blue-500 text-xs px-3 py-1 rounded-md hover:bg-blue-50">Edit</button>
                    <button
                        class="border border-red-500 text-red-500 text-xs px-3 py-1 rounded-md hover:bg-red-50">Remove</button>
                    <!-- Toggleable Status -->
                </div>
            </div>
        </div>

        <!-- Add New Voucher -->
        <div class="bg-white rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center py-8 cursor-pointer hover:bg-gray-50"
            id="addVoucherTile">
            <div class="flex flex-col items-center space-y-2">
                <span class="text-2xl text-gray-400">+</span>
                <p class="text-gray-600 text-sm">Add New Voucher</p>
            </div>
        </div>
    </div>

    <script>
        $(function() {
            $('#addVoucherTile, .edit-voucher').on('click', function() {
                const parentDoc = $(window.parent.document);
                parentDoc.find('#voucherModal').removeClass('hidden').addClass('flex');
                // Optional: prefill for editing
                const id = $(this).data('id');
                if (id) {
                    // simulate AJAX or populate values
                    const form = parentDoc.find('#voucherForm');
                    form.find('#voucherId').val(id);
                    form.find('#voucherName').val('WELCOME10');
                    form.find('#voucherType').val('Percentage');
                    form.find('#voucherMin').val(50);
                    form.find('#voucherMax').val(200);
                    form.find('#voucherAmount').val(10);
                    form.find('#voucherUsage').val(3);
                    form.find('#voucherDesc').val('10% off for new users');
                    parentDoc.find('#modalTitle').text('Edit Voucher');
                } else {
                    parentDoc.find('#voucherForm')[0].reset();
                    parentDoc.find('#modalTitle').text('Add Voucher');
                    parentDoc.find('#voucherId').val('');
                }
            });
            $(document).on('click', '.status-btn', function() {
                const isActive = $(this).data('status') === 'active';
                $(this).data('status', isActive ? 'inactive' : 'active');
                $(this)
                    .text(isActive ? 'Inactive' : 'Active')
                    .toggleClass('text-green-500 border-green-500 hover:bg-green-50', !isActive)
                    .toggleClass('text-gray-500 border-gray-400 hover:bg-gray-100', isActive);
            });
            $('.cursor-pointer').on('click', function() {
                const $modal = $(window.parent.document).find('#voucherModal');
                $modal.removeClass('hidden').addClass('flex');
            });
        });
    </script>

</body>

</html>