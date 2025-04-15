INSERT INTO `Role` (`role_description`) VALUES ('Admin');
INSERT INTO `Role` (`role_description`) VALUES ('Customer');
INSERT INTO `Role` (`role_description`) VALUES ('Staff');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('3', 'johnsonjoshua', 'cs&2#4Xd$a', 'blakeerik@yahoo.com', 'https://dummyimage.com/696x569', '1978-12-05', '{"address": "USNV Garcia\nFPO AA 13177", "city": "Melanieview", "postcode": "06196"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'yherrera', 'Xp@e8J9u5*', 'jason41@hotmail.com', 'https://dummyimage.com/350x501', '1995-09-25', '{"address": "503 Linda Locks\nCarlshire, VT 41746", "city": "Lake Victor", "postcode": "84760"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'ithomas', 'hi8Ez_Rhp$', 'dcarlson@hotmail.com', 'https://www.lorempixel.com/514/23', '2000-10-25', '{"address": "46270 Stanton Track Apt. 814\nEast Nathaniel, ND 70015", "city": "New Mariotown", "postcode": "15163"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('3', 'natasha43', '&N^3S)cS!q', 'samuel87@gmail.com', 'https://www.lorempixel.com/507/460', '1987-04-14', '{"address": "301 Jeremy Bypass\nChadbury, TN 64125", "city": "New David", "postcode": "75348"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('2', 'esanchez', 'a3ID%aZd&l', 'dwhite@baxter.info', 'https://www.lorempixel.com/200/103', '1970-08-16', '{"address": "PSC 3267, Box 7360\nAPO AE 50173", "city": "South Josephmouth", "postcode": "37889"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'uhorton', '97ESh%VP(g', 'richarddavid@sanchez.biz', 'https://dummyimage.com/647x534', '1985-08-28', '{"address": "47510 Howell Port Apt. 183\nDavidstad, CA 32519", "city": "Justinmouth", "postcode": "71701"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'cheryl80', '8q7rJ+8v_c', 'ccalderon@cook.com', 'https://placeimg.com/330/904/any', '2002-06-12', '{"address": "280 Aguilar Drive\nAndersonport, WY 05730", "city": "Jasonbury", "postcode": "87917"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'gomezanita', 'u&9XeI1ujI', 'garrisonjeffrey@yahoo.com', 'https://dummyimage.com/716x625', '1979-06-12', '{"address": "5414 May Locks\nSheilaville, KS 23906", "city": "Benjaminchester", "postcode": "45810"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('3', 'samuel81', '$iQl9Gg2J&', 'snguyen@yahoo.com', 'https://placeimg.com/260/392/any', '1990-01-28', '{"address": "946 Kevin Fords\nFloydmouth, NV 58455", "city": "New Thomas", "postcode": "96964"}');
INSERT INTO `Users` (`role_id`, `user_name`, `user_password`, `user_email`, `user_image_url`, `user_birthdate`, `shipping_information`) VALUES ('1', 'donnacampbell', 'mhb92@Kco_', 'dylanwatts@gmail.com', 'https://dummyimage.com/870x448', '1999-07-10', '{"address": "72788 Dodson Mills\nRivasside, GA 97973", "city": "Colebury", "postcode": "84080"}');
INSERT INTO `Product_Type` (`product_type`) VALUES ('Canvas');
INSERT INTO `Product_Type` (`product_type`) VALUES ('Digital');
INSERT INTO `Product_Type` (`product_type`) VALUES ('Sculpture');
INSERT INTO `Product_Type` (`product_type`) VALUES ('Print');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('1', 'Factor', 'space-star-near', 'Dream key require doctor from throw ball character.', '185.34', '9', 'Wall Group', '0', '{"color": "Red", "size": "M"}', '2025-01-04', 'https://www.lorempixel.com/779/976');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'Yes', 'he-fire-some-in', 'Mrs same son today major event.', '161.5', '8', 'Ferguson, Meadows and Vargas', '0', '{"color": "Yellow", "size": "M"}', '2025-01-06', 'https://dummyimage.com/171x877');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('4', 'Trial', 'main-court-apply', 'Force lawyer front they everything week.', '184.99', '5', 'Jones, Bernard and Williams', '0', '{"color": "Yellow", "size": "L"}', '2025-01-07', 'https://www.lorempixel.com/506/408');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('3', 'Pretty', 'claim-edge-card', 'Nor design record short. Paper white responsibility sing.', '63.53', '48', 'Odonnell, Brooks and David', '0', '{"color": "Red", "size": "XL"}', '2025-02-08', 'https://www.lorempixel.com/155/497');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('1', 'Same', 'spring-fish-to', 'Support state black.', '120.51', '49', 'Gilbert-Gillespie', '1', '{"color": "Red", "size": "XL"}', '2025-04-04', 'https://placekitten.com/952/892');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('1', 'Future', 'together-else-then', 'Everything late seek now.', '292.47', '53', 'Beard-Haynes', '0', '{"color": "Green", "size": "L"}', '2025-02-23', 'https://www.lorempixel.com/20/391');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'Effort', 'service-investment', 'Serve real position make society behavior develop.', '217.28', '10', 'Pierce, Bell and Chavez', '0', '{"color": "Green", "size": "S"}', '2025-03-01', 'https://www.lorempixel.com/514/472');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'Set', 'data-four-call', 'Week real course school everybody operation set.', '262.62', '53', 'Tran Ltd', '1', '{"color": "Yellow", "size": "L"}', '2025-01-25', 'https://www.lorempixel.com/1005/210');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'Painting', 'feel-manager', 'Future whole education technology box assume.', '123.65', '31', 'Grant Group', '1', '{"color": "Red", "size": "M"}', '2025-02-13', 'https://placeimg.com/779/922/any');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'Finish', 'trade-per-laugh', 'Perform participant science way debate decision produce.', '65.75', '53', 'Wheeler, Carter and Hall', '1', '{"color": "Blue", "size": "L"}', '2025-02-24', 'https://dummyimage.com/929x145');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('1', 'Window', 'everything-store', 'Operation sound cup boy different chance enter central.', '84.13', '9', 'Gonzales-Harrison', '1', '{"color": "Yellow", "size": "L"}', '2025-03-01', 'https://placeimg.com/824/557/any');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('1', 'Left', 'be-piece-among', 'Same page ago director purpose team.', '79.08', '77', 'White-Richards', '1', '{"color": "Blue", "size": "XL"}', '2025-04-06', 'https://placekitten.com/186/962');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('4', 'Issue', 'goal-full-religious', 'Form really explain war.', '267.71', '87', 'Sandoval PLC', '1', '{"color": "Blue", "size": "L"}', '2025-03-31', 'https://dummyimage.com/846x111');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('2', 'National', 'high-prevent', 'Personal service data near until just recognize.', '89.06', '76', 'Pierce-Tran', '1', '{"color": "Yellow", "size": "XL"}', '2025-01-19', 'https://placeimg.com/460/232/any');
INSERT INTO `Product` (`product_type_id`, `product_title`, `product_slug`, `product_desc`, `product_price`, `product_stock`, `product_retail_info`, `product_featured`, `product_variations`, `product_created_date`, `product_image_url`) VALUES ('3', 'Your', 'buy-raise-there', 'Usually factor relate indeed lot line lead.', '81.41', '22', 'Hill Group', '1', '{"color": "Red", "size": "S"}', '2025-03-07', 'https://placekitten.com/547/5');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Pending');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Packing');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Shipping');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Received');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Cancelled');
INSERT INTO `Payment_Method` (`method_description`) VALUES ('Credit Card');
INSERT INTO `Payment_Method` (`method_description`) VALUES ('Online Banking');

INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`, `voucher_status`) VALUES ('Percent', '65.28', '247.99', '35.62', '5', 'She', 'Study oil process tend land.', '1');
INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`, `voucher_status`) VALUES ('Percent', '88.48', '378.77', '26.06', '3', 'Member', 'Forward several help usually thank wonder.', '1');
INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`, `voucher_status`) VALUES ('Percent', '118.03', '234.37', '44.82', '3', 'Edge', 'Him task improve fish list tree high.', '1');
INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`, `voucher_status`) VALUES ('Fixed', '61.16', '330.43', '25.42', '3', 'Record', 'Manager already maybe opportunity.', '1');
INSERT INTO `Voucher` (`voucher_type`, `vouchar_min`, `voucher_max`, `voucher_amount`, `voucher_usage_per_month`, `voucher_name`, `voucher_description`, `voucher_status`) VALUES ('Percent', '100.77', '231.92', '33.14', '5', '1', 'Them key moment lead.', '1');

-- INSERT INTO `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('10', '4', '2', '217 Morgan Square Suite 158
-- Finleyfort, ND 05206', '2025-01-14', 'ebc2026f-af34-4f65-a193-c4b23c19e71d');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('6', '3', '1', '161 Scott Square
-- Rebeccaton, WY 07856', '2025-02-26', '25440fe0-6e41-4d47-9ff5-95ea5bc440f1');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('10', '6', '4', '222 Chelsea Light Apt. 792
-- South Dana, KS 87905', '2025-01-02', 'e6b5a92c-771a-4655-8dfc-6ee0e61ede90');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('1', '2', '3', '75946 Bryant Hollow
-- South Melissa, IA 50487', '2025-03-11', 'b303f438-fe21-40d0-8bbe-4aff9326dffd');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('5', '4', '1', '0909 Wall Heights Apt. 953
-- New John, VA 86901', '2025-01-27', 'a0a11839-e745-4704-98df-bc3ca0d4de3d');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('4', '10', '1', '0952 Renee Islands Suite 232
-- Alyssaview, GA 34182', '2025-04-04', 'bf1e8366-4b8e-43d4-8e76-07adf7a67b94');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('2', '8', '1', '1236 Davis Locks
-- West Amandamouth, TX 98675', '2025-02-20', 'a377f6f1-d289-40ab-a18a-e30595a5bafa');
-- INSERT INTO  `Order` (`user_id`, `payment_id`, `status_id`, `shipping_information`, `order_date`, `order_ref_no`) VALUES ('9', '3', '2', 'USS Leonard
-- FPO AA 03781', '2025-03-05', 'a5cc8bf7-38ab-454c-9c2e-58deea4e3617');

INSERT INTO User_Payment_Info (user_id, card_name, card_no, expiry, card_isDefault) VALUES
(1, 'John Doe', '4111111111111111', '2026-08-31', TRUE),
(1, 'John Doe - Travel', '5500000000000004', '2025-12-31', FALSE),
(2, 'Jane Smith', '4007000000027', '2027-03-31', TRUE),
(3, 'Alex Johnson', '6011000990139424', '2026-01-31', TRUE),
(3, 'Alex Johnson - Business', '3530111333300000', '2028-07-31', FALSE);

INSERT INTO Bank_Type (bank_type_description, bank_type_logo_path) VALUES
('Maybank', '/assets/images/logos/maybank.png'),
('CIMB Bank', '/assets/images/logos/cimb.png'),
('RHB Bank', '/assets/images/logos/rhb.png'),
('Public Bank', '/assets/images/logos/publicbank.png'),
('Hong Leong Bank', '/assets/images/logos/hongleong.png'),
('VISA', '/assets/images/logos/visa.png'),
('Mastercard', '/assets/image/logos/mastercard.png'),
('Touch ''n Go eWallet', '/assets/image/logos/tng.jpg');
