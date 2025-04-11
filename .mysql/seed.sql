
START TRANSACTION;
    -- Insert sample data for TEST-ONLY
    INSERT INTO `dev`(`id`, `username`, `password`, `created_date`, `email`) VALUES
    
    (1, 'Tan Choon Shen', 'admin123', CURDATE(), 'cstan@gmail.com'),
    (2, 'Jeremy Chin Jun Chen', 'admin123', CURDATE(), 'jeremy@gmail.com'),
    (3, 'Gan Chin Chung', 'admin123', CURDATE(), 'ccgan@gmail.com');


    -- Insert dummy data into `Role`
    INSERT INTO `Role` (`role_description`) VALUES
    ('Admin'), ('Customer'), ('Seller');

    -- Insert dummy data into `Users`
    INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_birthdate`, `shipping_information`)
    VALUES
    (1, 'admin', 'admin', 'admin@example.com', '1990-01-01', '{"address": "123 Admin Street"}'),
    (2, 'cstan', 'cstan', 'johndoe@example.com', '1995-05-15', '{"address": "456 Customer Lane"}'),
    (3, 'JaneSeller', 'sellerpass', 'jane@example.com', '1992-07-20', '{"address": "789 Seller Ave"}');

    -- Insert dummy data into `Order_Status`
    INSERT INTO `Order_Status` (`status_description`) VALUES
    ('Pending'), ('Shipped'), ('Delivered'), ('Cancelled');

    -- Insert dummy data into `Payment_Method`
    INSERT INTO `Payment_Method` (`method_description`) VALUES
    ('Credit Card'), ('PayPal'), ('Bank Transfer');

    -- Insert dummy data into `Voucher`
    INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`)
    VALUES
    ('float', 50.00, 500.00, 10.00, 1, 'Birthday Discount', 'This is a birthday discount'),
    ('int', 100.00, 1000.00, 20.00, 3, 'Chinese New Year Carnival Cashback', 'This is a Chinese New Year Carnival Cashback');

    -- Insert dummy data into `Payment`
    INSERT INTO `Payment` (`method_id`, `voucher_id`, `total_paid`)
    VALUES
    (1, 1, 200.00),
    (2, NULL, 500.00),
    (3, 2, 150.00);

    -- Insert dummy data into `Order`
    INSERT INTO `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`)
    VALUES
    (2, 1, 1, '456 Customer Lane', '2024-03-01'),
    (2, 2, 2, '456 Customer Lane', '2024-03-02'),
    (3, 3, 3, '789 Seller Ave', '2024-03-03');

    -- Insert dummy data into `Product_Type`
    INSERT INTO `Product_Type` (`product_type`)
    VALUES
    ('Electronics'), ('Clothing'), ('Home & Kitchen');

    -- Insert dummy data into `Product`
    INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`)
    VALUES
    (1, 'Smartphone', 'smartphone-001', 'Latest smartphone with advanced features', 699.99, 50, 'Retailer XYZ', 1, '{"color": ["black", "white"], "storage": ["64GB", "128GB"]}', '2024-03-01'),
    (2, 'T-Shirt', 'tshirt-001', 'Cotton t-shirt with multiple colors', 19.99, 200, 'Retailer ABC', 0, '{"size": ["S", "M", "L"], "color": ["red", "blue", "green"]}', '2024-03-02');

    -- Insert dummy data into `Permission`
    INSERT INTO `Permission` (`role_id`, `role_description`)
    VALUES
    (1, 'Full Access'),
    (2, 'Limited Access'),
    (3, 'Seller Access');

    -- Insert dummy data into `Cart`
    INSERT INTO `Cart` (`user_id`)
    VALUES
    (2), (3);

    -- Insert dummy data into `Cart_Item`
    INSERT INTO `Cart_Item` (`cart_id`, `product_id`, `quantity`, `selected_variations`)
    VALUES
    (1, 1, 1, '{"color": "black", "storage": "64GB"}'),
    (2, 2, 2, '{"size": "M", "color": "blue"}');

    -- Insert dummy data into `Order_Transaction`
    INSERT INTO `Order_Transaction` (`order_id`, `product_id`, `order_quantity`, `ordered_product_price`, `selected_variations`)
    VALUES
    (1, 1, 1, 699.99, '{"color": "black", "storage": "64GB"}'),
    (2, 2, 2, 19.99, '{"size": "M", "color": "blue"}');

    -- Insert dummy data into `Product_Feedback`
    INSERT INTO `Product_Feedback` (`product_id`, `order_id`, `rating`, `comment`, `reply`, `feedback_date`, `reply_date`)
    VALUES
    (1, 1, 5.0, 'Great smartphone!', 'Thank you for your review!', '2024-03-05', '2024-03-06'),
    (2, 2, 4.0, 'Nice T-Shirt, but delivery was slow', 'We apologize for the delay!', '2024-03-06', '2024-03-07');

    -- Insert dummy data into `User_Payment_Info`
    INSERT INTO `User_Payment_Info` (`user_id`, `card_name`, `card_no`, `cvv`, `expiry`)
    VALUES
    (2, 'John Doe', '1234567890123456', '123', '2025-12-31'),
    (3, 'Jane Seller', '9876543210987654', '456', '2026-06-30');

-- Commit all insert queries if everything succeeds
COMMIT;
