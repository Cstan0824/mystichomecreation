CREATE DATABASE IF NOT EXISTS MysticHome_Creation;

USE MysticHome_Creation;

CREATE TABLE IF NOT EXISTS `Role` (
  `role_id` INT AUTO_INCREMENT,
  `role_description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`role_id`)
);

CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` INT AUTO_INCREMENT,
  `role_id` INT NOT NULL,
  `user_name` VARCHAR(255) NOT NULL,
  `user_password` VARCHAR(255) NOT NULL,
  `user_email` VARCHAR(50) NOT NULL,
  `user_image_id` INT,
  `user_birthdate` DATE,
  `shipping_information` JSON,
  INDEX (`role_id`),
  PRIMARY KEY (`user_id`),
  FOREIGN KEY (`role_id`) REFERENCES `Role`(`role_id`),
  FOREIGN KEY (`user_image_id`) REFERENCES `User_Image`(`image_id`)
);

CREATE TABLE IF NOT EXISTS `User_Image` (
  `image_id` INT AUTO_INCREMENT,
  `image_data` BLOB NOT NULL,
  PRIMARY KEY (`image_id`)
);

CREATE TABLE IF NOT EXISTS `Order_Status` (
  `status_id` INT AUTO_INCREMENT,
  `status_description` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`status_id`)
);
CREATE TABLE IF NOT EXISTS `Payment_Method` (
  `method_id` INT AUTO_INCREMENT,
  `method_description` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`method_id`)
);

CREATE TABLE IF NOT EXISTS `Voucher` (
  `voucher_id` INT AUTO_INCREMENT,
  `voucher_type` VARCHAR(20) NOT NULL,
  `vouchar_min` DECIMAL,
  `voucher_max` DECIMAL,
  `voucher_amount` DECIMAL,
  `voucher_usage_per_month` INT,
  `voucher_name` VARCHAR(50) NOT NULL,
  `voucher_description` VARCHAR(255),
  `voucher_status` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`voucher_id`)
);

CREATE TABLE IF NOT EXISTS `Payment` (
  `payment_id` INT AUTO_INCREMENT,
  `method_id` INT NOT NULL,
  `voucher_info` JSON,
  `total_paid` DECIMAL NOT NULL,
  INDEX (`method_id`),
  PRIMARY KEY (`payment_id`),
  FOREIGN KEY (`method_id`) REFERENCES `Payment_Method`(`method_id`)
);

CREATE TABLE IF NOT EXISTS `Order` (
  `order_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `payment_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  `shipping_information` VARCHAR(255),
  `order_date` DATE NOT NULL,
  `order_ref_no` VARCHAR(255) NOT NULL,
  INDEX (`user_id`),
  INDEX (`status_id`),
  INDEX (`payment_id`),
  PRIMARY KEY (`order_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ,
  FOREIGN KEY (`status_id`) REFERENCES `Order_Status`(`status_id`),
  FOREIGN KEY (`payment_id`) REFERENCES `Payment`(`payment_id`)
);

CREATE TABLE IF NOT EXISTS `Product_Type` (
  `product_type_id` INT AUTO_INCREMENT,
  `product_type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`product_type_id`)
);

CREATE TABLE IF NOT EXISTS `Product` (
  `product_id` INT AUTO_INCREMENT,
  `product_type_id` INT NOT NULL,
  `product_title` VARCHAR(50) NOT NULL,
  `product_slug` VARCHAR(50),
  `product_desc` VARCHAR(255),
  `product_price` DECIMAL NOT NULL,
  `product_stock` INT NOT NULL DEFAULT 0,
  `product_retail_info` VARCHAR(255),
  `product_featured` INT,
  `product_variations` JSON,
  `product_created_date` DATE NOT NULL,
  `product_image_id` INT,
  INDEX (`product_type_id`),
  PRIMARY KEY (`product_id`),
  FOREIGN KEY (`product_type_id`) REFERENCES `Product_Type`(`product_type_id`),
  FOREIGN KEY (`product_image_id`) REFERENCES `Product_Image`(`image_id`)
);

-- CREATE TABLE IF NOT EXISTS `Product_Image` (
--   `image_id` INT AUTO_INCREMENT,
--   `image_data` BLOB NOT NULL,
--   PRIMARY KEY (`image_id`)
-- );

CREATE TABLE IF NOT EXISTS `Permission` (
  `permission_id` INT AUTO_INCREMENT,
  `role_id` INT NOT NULL,
  `permission_url` VARCHAR(255) NOT NULL,
  `permission_description` VARCHAR(50) NOT NULL,
   INDEX (`role_id`),
  PRIMARY KEY (`permission_id`),
  FOREIGN KEY (`role_id`) REFERENCES `Role`(`role_id`)
);

CREATE TABLE IF NOT EXISTS `Product_Feedback` (
  `product_id` INT ,
  `order_id` INT,
  `rating` DECIMAL NOT NULL,
  `comment` TEXT,
  `reply` TEXT,
  `feedback_date` DATE NOT NULL,
  `reply_date` DATE,
  PRIMARY KEY (`product_id`, `order_id`) ,
  FOREIGN KEY (`order_id`) REFERENCES `Order`(`order_id`),
  FOREIGN KEY (`product_id`) REFERENCES `Product`(`product_id`) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS `Cart` (
  `cart_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  INDEX (`user_id`),
  PRIMARY KEY (`cart_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`)
);



CREATE TABLE IF NOT EXISTS `Cart_Item` (
  `cart_id` INT,
  `product_id` INT,
  `quantity` INT NOT NULL,
  `selected_variations` JSON,
  PRIMARY KEY (`cart_id`, `product_id`),
  FOREIGN KEY (`product_id`) REFERENCES `Product`(`product_id`),
  FOREIGN KEY (`cart_id`) REFERENCES `Cart`(`cart_id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `User_Payment_Info` (
  `card_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `bank_type_id` INT NOT NULL,
  `card_name` VARCHAR(50),
  `card_no` VARCHAR(50) NOT NULL,
  `expiry` DATE NOT NULL,
  `card_isDefault` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`card_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`),
  FOREIGN KEY (`bank_type_id`) REFERENCES `Bank_Type`(`bank_type_id`)
);

CREATE TABLE IF NOT EXISTS `Order_Transaction` (
  `order_id` INT,
  `product_id` INT,
  `order_quantity` INT NOT NULL,
  `ordered_product_price` DECIMAL NOT NULL,
  `selected_variations` JSON,
  PRIMARY KEY(`order_id`, `product_id`),
  FOREIGN KEY (`order_id`) REFERENCES `Order`(`order_id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `Product`(`product_id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Audit_Trail` (
  `id` INT AUTO_INCREMENT,
  `user_id` INT NULL, -- could be NULL for system actions
  `source` VARCHAR(50) NOT NULL,
  `description` TEXT NULL,
  `type` VARCHAR(20) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`)
);



-- create tables -- FOR TEST ONLY
CREATE TABLE IF NOT EXISTS `dev` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_date` DATE NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Bank_Type` (
  `bank_type_id` INT AUTO_INCREMENT PRIMARY KEY,
  `bank_type_description` VARCHAR(100) NOT NULL,
  `bank_type_logo_path` VARCHAR(255) -- stores path or URL to logo image
);



