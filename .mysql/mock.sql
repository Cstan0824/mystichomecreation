-- Role
INSERT INTO Role (role_description) VALUES ('Admin');
INSERT INTO Role (role_description) VALUES ('Customer');
INSERT INTO Role (role_description) VALUES ('Staff');

-- Users
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'admintroot', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'mohd.rahman@example.com', '1980-03-14', '[{"id": 1, "label": "Home", "receiverName": "Mohd Rahman", "phoneNumber": "0130157166", "state": "Selangor", "postCode": "43000", "addressLine1": "448 Melissa Points Suite 266", "addressLine2": "Apt. 123", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Mohd Rahman", "phoneNumber": "0184256448", "state": "Johor", "postCode": "80000", "addressLine1": "76815 Daniel Cliffs Suite 605", "addressLine2": "Apt. 299", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Mohd Rahman", "phoneNumber": "0146294832", "state": "Malacca", "postCode": "75000", "addressLine1": "45222 John Walk", "addressLine2": "Suite 319", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Assignment_Helper', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'samsam123@example.com', '1996-03-12', '[{"id": 1, "label": "Home", "receiverName": "Haziq Abdullah", "phoneNumber": "0196154862", "state": "Sarawak", "postCode": "93000", "addressLine1": "366 Marshall Hill", "addressLine2": "Apt. 987", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Haziq Abdullah", "phoneNumber": "0166603109", "state": "Perak", "postCode": "30000", "addressLine1": "6950 Gray Harbors Suite 933", "addressLine2": "Apt. 252", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Haziq Abdullah", "phoneNumber": "0188783216", "state": "Sabah", "postCode": "88000", "addressLine1": "2078 Matthew Alley", "addressLine2": "Apt. 466", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Cstan0824', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.tan@example.com', '1984-07-30', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Tan", "phoneNumber": "0165901484", "state": "Sarawak", "postCode": "93000", "addressLine1": "8300 Jesse Tunnel Apt. 477", "addressLine2": "Suite 557", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Tan", "phoneNumber": "0136567564", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "2444 Wilson Roads", "addressLine2": "Suite 423", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Tan", "phoneNumber": "0153456556", "state": "Sabah", "postCode": "88000", "addressLine1": "58951 Choi Wall", "addressLine2": "Apt. 926", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Cstantan', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'mohd.yusof@example.com', '2004-12-27', '[{"id": 1, "label": "Home", "receiverName": "Mohd Yusof", "phoneNumber": "0110821286", "state": "Pahang", "postCode": "25000", "addressLine1": "38729 Lewis Plaza Suite 009", "addressLine2": "Apt. 571", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Mohd Yusof", "phoneNumber": "0178606307", "state": "Sarawak", "postCode": "93000", "addressLine1": "5472 Howard Crest", "addressLine2": "Apt. 513", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Mohd Yusof", "phoneNumber": "0153992177", "state": "Sarawak", "postCode": "93000", "addressLine1": "3473 Young Wall", "addressLine2": "Suite 213", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Mohd Yusof', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'mohd.yusof@example.com', '1985-10-24', '[{"id": 1, "label": "Home", "receiverName": "Mohd Yusof", "phoneNumber": "0183120483", "state": "Penang", "postCode": "10050", "addressLine1": "1981 Hopkins Trace", "addressLine2": "Apt. 817", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Mohd Yusof", "phoneNumber": "0121334403", "state": "Sabah", "postCode": "88000", "addressLine1": "132 Sanders Wells", "addressLine2": "Suite 909", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Mohd Yusof", "phoneNumber": "0141423880", "state": "Perak", "postCode": "30000", "addressLine1": "647 Brian Springs Apt. 885", "addressLine2": "Apt. 042", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Mohd Tan', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'mohd.tan@example.com', '1980-12-29', '[{"id": 1, "label": "Home", "receiverName": "Mohd Tan", "phoneNumber": "0132553861", "state": "Sabah", "postCode": "88000", "addressLine1": "4901 David Groves Suite 877", "addressLine2": "Apt. 198", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Mohd Tan", "phoneNumber": "0181532553", "state": "Perak", "postCode": "30000", "addressLine1": "8236 Hurley Burg", "addressLine2": "Suite 783", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Mohd Tan", "phoneNumber": "0196030230", "state": "Penang", "postCode": "10050", "addressLine1": "8262 Stephanie Avenue Apt. 115", "addressLine2": "Suite 089", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Nur Yusof', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nur.yusof@example.com', '1985-12-26', '[{"id": 1, "label": "Home", "receiverName": "Nur Yusof", "phoneNumber": "0191232360", "state": "Pahang", "postCode": "25000", "addressLine1": "675 Christina Run", "addressLine2": "Apt. 581", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nur Yusof", "phoneNumber": "0183358858", "state": "Perak", "postCode": "30000", "addressLine1": "31542 Bailey Turnpike", "addressLine2": "Suite 183", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nur Yusof", "phoneNumber": "0197219413", "state": "Selangor", "postCode": "43000", "addressLine1": "33925 Villarreal Mews Apt. 583", "addressLine2": "Suite 948", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Haziq Ismail', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'haziq.ismail@example.com', '1983-04-12', '[{"id": 1, "label": "Home", "receiverName": "Haziq Ismail", "phoneNumber": "0199829697", "state": "Negeri Sembilan", "postCode": "70000", "addressLine1": "66451 Madeline Island Suite 973", "addressLine2": "Suite 830", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Haziq Ismail", "phoneNumber": "0158857645", "state": "Malacca", "postCode": "75000", "addressLine1": "83565 Eric Dam Apt. 190", "addressLine2": "Suite 040", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Haziq Ismail", "phoneNumber": "0138751515", "state": "Sarawak", "postCode": "93000", "addressLine1": "212 Lyons Course Apt. 894", "addressLine2": "Suite 420", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Haziq Yusof', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'haziq.yusof@example.com', '1978-11-04', '[{"id": 1, "label": "Home", "receiverName": "Haziq Yusof", "phoneNumber": "0168884287", "state": "Negeri Sembilan", "postCode": "70000", "addressLine1": "0841 Nelson Isle Apt. 753", "addressLine2": "Suite 218", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Haziq Yusof", "phoneNumber": "0149303816", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "1324 Edwin Island", "addressLine2": "Suite 956", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Haziq Yusof", "phoneNumber": "0177339222", "state": "Johor", "postCode": "80000", "addressLine1": "940 Alyssa Creek Suite 052", "addressLine2": "Suite 954", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (1, 'Haziq Rahman', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'haziq.rahman@example.com', '1985-08-05', '[{"id": 1, "label": "Home", "receiverName": "Haziq Rahman", "phoneNumber": "0114421429", "state": "Sarawak", "postCode": "93000", "addressLine1": "42959 Jennifer Dale", "addressLine2": "Apt. 471", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Haziq Rahman", "phoneNumber": "0164504759", "state": "Pahang", "postCode": "25000", "addressLine1": "285 Armstrong Shoal Suite 069", "addressLine2": "Apt. 857", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Haziq Rahman", "phoneNumber": "0110388548", "state": "Sabah", "postCode": "88000", "addressLine1": "0886 Regina Harbors Suite 675", "addressLine2": "Suite 269", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Hafiz Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.kamaruddin@example.com', '1974-11-07', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0122510028", "state": "Penang", "postCode": "10050", "addressLine1": "021 Eileen Ville", "addressLine2": "Suite 222", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0197314036", "state": "Sarawak", "postCode": "93000", "addressLine1": "404 Kevin Squares Apt. 762", "addressLine2": "Suite 113", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0167714725", "state": "Malacca", "postCode": "75000", "addressLine1": "98794 Wolf Mount", "addressLine2": "Apt. 224", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Siti Othman', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'siti.othman@example.com', '2001-09-16', '[{"id": 1, "label": "Home", "receiverName": "Siti Othman", "phoneNumber": "0151600586", "state": "Johor", "postCode": "80000", "addressLine1": "788 Harris Cove", "addressLine2": "Suite 292", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Siti Othman", "phoneNumber": "0138555803", "state": "Sarawak", "postCode": "93000", "addressLine1": "5251 Brown Haven", "addressLine2": "Apt. 459", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Siti Othman", "phoneNumber": "0114907305", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "146 Craig Green", "addressLine2": "Apt. 063", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Ahmad Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'ahmad.kamaruddin@example.com', '1982-07-05', '[{"id": 1, "label": "Home", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0114571869", "state": "Pahang", "postCode": "25000", "addressLine1": "13269 Joyce Dam", "addressLine2": "Suite 857", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0156364324", "state": "Selangor", "postCode": "43000", "addressLine1": "081 Goodman Common Suite 805", "addressLine2": "Apt. 134", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0180984005", "state": "Malacca", "postCode": "75000", "addressLine1": "28649 Jeffrey Stream Apt. 520", "addressLine2": "Apt. 972", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Hafiz Hashim', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.hashim@example.com', '1981-09-17', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Hashim", "phoneNumber": "0182279309", "state": "Pahang", "postCode": "25000", "addressLine1": "0375 Vasquez Orchard", "addressLine2": "Suite 770", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Hashim", "phoneNumber": "0122253386", "state": "Sabah", "postCode": "88000", "addressLine1": "08145 Rice Avenue", "addressLine2": "Suite 922", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Hashim", "phoneNumber": "0145415052", "state": "Penang", "postCode": "10050", "addressLine1": "19350 Kyle Drives", "addressLine2": "Suite 955", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Hafiz Rahman', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.rahman@example.com', '1991-04-24', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Rahman", "phoneNumber": "0178121088", "state": "Penang", "postCode": "10050", "addressLine1": "986 Coffey Squares Apt. 984", "addressLine2": "Suite 629", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Rahman", "phoneNumber": "0179324016", "state": "Perak", "postCode": "30000", "addressLine1": "811 Hood Fork Suite 910", "addressLine2": "Apt. 985", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Rahman", "phoneNumber": "0177101708", "state": "Malacca", "postCode": "75000", "addressLine1": "5611 Danielle Cape", "addressLine2": "Suite 723", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Ahmad Abdullah', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'ahmad.abdullah@example.com', '1979-06-05', '[{"id": 1, "label": "Home", "receiverName": "Ahmad Abdullah", "phoneNumber": "0143089787", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "05336 Ramos Forest Suite 777", "addressLine2": "Suite 880", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Ahmad Abdullah", "phoneNumber": "0122223838", "state": "Malacca", "postCode": "75000", "addressLine1": "51892 Le Fall Apt. 766", "addressLine2": "Suite 003", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Ahmad Abdullah", "phoneNumber": "0165670639", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "3348 Anna Avenue Apt. 445", "addressLine2": "Suite 697", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Nadia Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nadia.kamaruddin@example.com', '1991-08-25', '[{"id": 1, "label": "Home", "receiverName": "Nadia Kamaruddin", "phoneNumber": "0185036934", "state": "Negeri Sembilan", "postCode": "70000", "addressLine1": "166 Miller Causeway Apt. 093", "addressLine2": "Suite 853", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nadia Kamaruddin", "phoneNumber": "0181342962", "state": "Perak", "postCode": "30000", "addressLine1": "1659 Emily Island Apt. 224", "addressLine2": "Suite 209", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nadia Kamaruddin", "phoneNumber": "0164478369", "state": "Johor", "postCode": "80000", "addressLine1": "394 Hannah Wall", "addressLine2": "Suite 818", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Farah Ismail', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'farah.ismail@example.com', '2001-07-24', '[{"id": 1, "label": "Home", "receiverName": "Farah Ismail", "phoneNumber": "0173863224", "state": "Selangor", "postCode": "43000", "addressLine1": "9307 Warner Mission Suite 857", "addressLine2": "Suite 550", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Farah Ismail", "phoneNumber": "0117910265", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "8601 Melody Burgs", "addressLine2": "Suite 732", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Farah Ismail", "phoneNumber": "0150439498", "state": "Sabah", "postCode": "88000", "addressLine1": "021 Brian Glen", "addressLine2": "Apt. 585", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Nadia Hashim', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nadia.hashim@example.com', '2002-10-22', '[{"id": 1, "label": "Home", "receiverName": "Nadia Hashim", "phoneNumber": "0115666289", "state": "Sabah", "postCode": "88000", "addressLine1": "8957 Gregory Motorway Apt. 647", "addressLine2": "Apt. 549", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nadia Hashim", "phoneNumber": "0191414211", "state": "Malacca", "postCode": "75000", "addressLine1": "9405 Jessica Burgs", "addressLine2": "Apt. 607", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nadia Hashim", "phoneNumber": "0141032357", "state": "Sarawak", "postCode": "93000", "addressLine1": "0684 Jackie Heights Apt. 810", "addressLine2": "Apt. 415", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (2, 'Hafiz Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.kamaruddin@example.com', '2004-11-03', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0134803541", "state": "Johor", "postCode": "80000", "addressLine1": "125 Sabrina Pines Suite 149", "addressLine2": "Suite 623", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0114890155", "state": "Perak", "postCode": "30000", "addressLine1": "7599 Michael Via", "addressLine2": "Apt. 082", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Kamaruddin", "phoneNumber": "0194635074", "state": "Sarawak", "postCode": "93000", "addressLine1": "95158 Allen Cove", "addressLine2": "Apt. 426", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Mohd Abdullah', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'mohd.abdullah@example.com', '1980-04-04', '[{"id": 1, "label": "Home", "receiverName": "Mohd Abdullah", "phoneNumber": "0112044368", "state": "Malacca", "postCode": "75000", "addressLine1": "928 Dodson Mission Apt. 237", "addressLine2": "Apt. 982", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Mohd Abdullah", "phoneNumber": "0142218102", "state": "Pahang", "postCode": "25000", "addressLine1": "7211 Tristan Plaza Apt. 045", "addressLine2": "Suite 474", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Mohd Abdullah", "phoneNumber": "0166544870", "state": "Pahang", "postCode": "25000", "addressLine1": "0487 Steven Junctions", "addressLine2": "Apt. 205", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Nadia Abdullah', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nadia.abdullah@example.com', '2001-10-10', '[{"id": 1, "label": "Home", "receiverName": "Nadia Abdullah", "phoneNumber": "0140785253", "state": "Malacca", "postCode": "75000", "addressLine1": "092 Hector Shores", "addressLine2": "Apt. 045", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nadia Abdullah", "phoneNumber": "0170213722", "state": "Pahang", "postCode": "25000", "addressLine1": "218 Lara Locks", "addressLine2": "Suite 742", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nadia Abdullah", "phoneNumber": "0165943188", "state": "Sarawak", "postCode": "93000", "addressLine1": "124 Dana Ford", "addressLine2": "Suite 625", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Ahmad Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'ahmad.kamaruddin@example.com', '1994-12-18', '[{"id": 1, "label": "Home", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0129589210", "state": "Selangor", "postCode": "43000", "addressLine1": "860 Brittney Island", "addressLine2": "Suite 865", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0166461135", "state": "Negeri Sembilan", "postCode": "70000", "addressLine1": "14001 Darrell Overpass", "addressLine2": "Suite 765", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Ahmad Kamaruddin", "phoneNumber": "0118229057", "state": "Perak", "postCode": "30000", "addressLine1": "8620 French Court", "addressLine2": "Suite 177", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Nadia Rahman', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nadia.rahman@example.com', '2004-06-22', '[{"id": 1, "label": "Home", "receiverName": "Nadia Rahman", "phoneNumber": "0153546922", "state": "Pahang", "postCode": "25000", "addressLine1": "1297 Simpson Bypass Suite 780", "addressLine2": "Suite 273", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nadia Rahman", "phoneNumber": "0143637691", "state": "Malacca", "postCode": "75000", "addressLine1": "8840 Hickman Passage Suite 727", "addressLine2": "Suite 795", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nadia Rahman", "phoneNumber": "0139886513", "state": "Malacca", "postCode": "75000", "addressLine1": "4507 Joshua Bypass", "addressLine2": "Apt. 457", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Hafiz Tan', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.tan@example.com', '2002-07-14', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Tan", "phoneNumber": "0185528542", "state": "Selangor", "postCode": "43000", "addressLine1": "549 Ashley Freeway Apt. 155", "addressLine2": "Suite 528", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Tan", "phoneNumber": "0166346010", "state": "Penang", "postCode": "10050", "addressLine1": "235 Campbell Meadow", "addressLine2": "Suite 276", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Tan", "phoneNumber": "0154794259", "state": "Malacca", "postCode": "75000", "addressLine1": "38090 Karen Course Suite 860", "addressLine2": "Apt. 391", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Haziq Kamaruddin', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'haziq.kamaruddin@example.com', '1989-07-06', '[{"id": 1, "label": "Home", "receiverName": "Haziq Kamaruddin", "phoneNumber": "0171690864", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "29805 Murray Courts Apt. 308", "addressLine2": "Suite 315", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Haziq Kamaruddin", "phoneNumber": "0163464232", "state": "Sabah", "postCode": "88000", "addressLine1": "781 Jeremy Plaza", "addressLine2": "Suite 241", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Haziq Kamaruddin", "phoneNumber": "0178556783", "state": "Sarawak", "postCode": "93000", "addressLine1": "099 Christopher Unions Suite 337", "addressLine2": "Suite 292", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Nur Hashim', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'nur.hashim@example.com', '2000-03-11', '[{"id": 1, "label": "Home", "receiverName": "Nur Hashim", "phoneNumber": "0177661695", "state": "Johor", "postCode": "80000", "addressLine1": "509 Mayo Ferry", "addressLine2": "Suite 918", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Nur Hashim", "phoneNumber": "0113063029", "state": "Sabah", "postCode": "88000", "addressLine1": "076 Payne Walks", "addressLine2": "Suite 808", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Nur Hashim", "phoneNumber": "0152391551", "state": "Kuala Lumpur", "postCode": "50450", "addressLine1": "863 Smith Street Suite 226", "addressLine2": "Suite 612", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Hafiz Yusof', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'hafiz.yusof@example.com', '1996-12-31', '[{"id": 1, "label": "Home", "receiverName": "Hafiz Yusof", "phoneNumber": "0139049340", "state": "Malacca", "postCode": "75000", "addressLine1": "127 Lindsey Trail", "addressLine2": "Apt. 838", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Hafiz Yusof", "phoneNumber": "0162960929", "state": "Penang", "postCode": "10050", "addressLine1": "676 Noah Drives", "addressLine2": "Suite 329", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Hafiz Yusof", "phoneNumber": "0136327042", "state": "Malacca", "postCode": "75000", "addressLine1": "22792 Heidi Summit", "addressLine2": "Apt. 020", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Aisyah Abdullah', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'aisyah.abdullah@example.com', '1974-09-02', '[{"id": 1, "label": "Home", "receiverName": "Aisyah Abdullah", "phoneNumber": "0190009549", "state": "Penang", "postCode": "10050", "addressLine1": "631 Morse Centers Apt. 425", "addressLine2": "Apt. 994", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Aisyah Abdullah", "phoneNumber": "0165156902", "state": "Penang", "postCode": "10050", "addressLine1": "3568 Edwin Lake Suite 679", "addressLine2": "Suite 579", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Aisyah Abdullah", "phoneNumber": "0134605594", "state": "Selangor", "postCode": "43000", "addressLine1": "176 Williams Field", "addressLine2": "Suite 756", "isDefault": false}]');
INSERT INTO Users (role_id, user_name, user_password, user_email, user_birthdate, shipping_information) VALUES (3, 'Cstan', 'a+7TSnIP3BgFmrbCf/ZYgQ==:O2TFFmRY7ICLLij0xS5uUSn9pfDu2PoRm4+obMQ0xLg=', 'aisyah.hashim@example.com', '1986-04-29', '[{"id": 1, "label": "Home", "receiverName": "Aisyah Hashim", "phoneNumber": "0127983775", "state": "Negeri Sembilan", "postCode": "70000", "addressLine1": "3992 Davis Crest Apt. 261", "addressLine2": "Apt. 228", "isDefault": true}, {"id": 2, "label": "Office", "receiverName": "Aisyah Hashim", "phoneNumber": "0187868193", "state": "Malacca", "postCode": "75000", "addressLine1": "3323 Black Roads Apt. 561", "addressLine2": "Apt. 329", "isDefault": false}, {"id": 3, "label": "Parent''s House", "receiverName": "Aisyah Hashim", "phoneNumber": "0119560071", "state": "Penang", "postCode": "10050", "addressLine1": "17731 Alan Manors Apt. 268", "addressLine2": "Suite 852", "isDefault": false}]');


-- cart
INSERT INTO cart (cart_id, user_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30);

-- Bank Type
INSERT INTO Bank_Type (bank_type_id, bank_type_description, bank_type_logo_path) VALUES
(1, 'Maybank', '/assets/image/logos/maybank.png'),
(2, 'CIMB Bank', '/assets/image/logos/cimb.png'),
(3, 'RHB Bank', '/assets/image/logos/rhb.png'),
(4, 'Public Bank', '/assets/image/logos/publicbank.png'),
(5, 'Hong Leong Bank', '/assets/image/logos/hongleong.png'),
(6, 'VISA', '/assets/image/logos/visa.png'),
(7, 'Mastercard', '/assets/image/logos/mastercard.png'),
(8, 'Touch ''n Go eWallet', '/assets/image/logos/tng.jpg');


-- User Payment Card
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (11, 3, 'Siti Rahman', '4970622361757070', '01/2029', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (12, 2, 'Siti Ismail', '6575915463746917', '01/2028', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (13, 4, 'Mohd Ismail', '8729095166214766', '01/2030', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (14, 1, 'Ahmad Kamaruddin', '7240263573198474', '04/2029', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (15, 1, 'Nur Ali', '1064467735557346', '05/2029', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (16, 5, 'Amir Ali', '1399189917566341', '03/2026', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (17, 5, 'Farah Ismail', '3180417752803532', '08/2026', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (18, 2, 'Nur Ismail', '1837825004744057', '04/2026', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (19, 1, 'Nur Tan', '5359225005999940', '05/2030', TRUE);
INSERT INTO User_Payment_Card (user_id, bank_type_id, card_name, card_no, expiry, card_isDefault) VALUES (20, 3, 'Haziq Ismail', '9122228680024700', '04/2030', TRUE);


-- Order Status
INSERT INTO `Order_Status` (`status_description`) VALUES ('Pending');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Packing');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Shipping');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Received');
INSERT INTO `Order_Status` (`status_description`) VALUES ('Cancelled');


-- Payment Method
INSERT INTO `Payment_Method` (`method_description`) VALUES ('Credit Card');
INSERT INTO `Payment_Method` (`method_description`) VALUES ('Online Banking');
INSERT INTO `Payment_Method` (`method_description`) VALUES ('Cash on Delivery');

-- Product Type
INSERT INTO Product_Type (product_type) VALUES
('Beds'),
('Mattresses'),
('Sofas & Armchairs'),
('Coffee & Side Tables'),
('Dining Tables & Chairs'),
('Desks'),
('Office Chairs'),
('Storage Units'),
('Wardrobes'),
('Bookcases & Shelving Units'),
('TV & Media Furniture'),
('Dressers & Drawers'),
('Outdoor Furniture'),
('Children''s Furniture'),
('Bathroom Furniture'),
('Kitchen Cabinets & Carts'),
('Hallway Furniture'),
('Lighting'),
('Textiles'),
('Home Décor');

-- Vouchers
-- 1. New User Welcome Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 50.00, 20.00, 10.00, 1, 'WELCOME10', '10% off for new users on orders above RM50', TRUE);

-- 2. Free Shipping Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('flat', 0.00, 10.00, 10.00, 2, 'FREESHIP10', 'Flat RM10 off to cover shipping fees', TRUE);

-- 3. Birthday Special Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 100.00, 30.00, 15.00, 1, 'BDAY15', '15% off birthday month voucher for orders above RM100', TRUE);

-- 4. Festival Promotion Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 200.00, 50.00, 20.00, 3, 'RAYA20', '20% off during Raya sale on orders above RM200', TRUE);

-- 5. Clearance Sale Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('flat', 0.00, 30.00, 30.00, 5, 'CLEAR30', 'RM30 off clearance items', TRUE);

-- 6. First Purchase Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 0.00, 25.00, 5.00, 1, 'FIRST5', '5% off on your first purchase', TRUE);

-- 7. Weekend Special Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 150.00, 40.00, 10.00, 2, 'WEEKEND10', '10% off on weekends for orders above RM150', TRUE);

-- 8. Loyalty Reward Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('flat', 300.00, 50.00, 50.00, 1, 'LOYAL50', 'RM50 off for loyal customers on orders above RM300', TRUE);

-- 9. Flash Sale Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('percentage', 100.00, 25.00, 25.00, 1, 'FLASH25', '25% off during flash sale on orders above RM100', TRUE);

-- 10. App Exclusive Voucher
INSERT INTO Voucher (voucher_type, voucher_min, voucher_max, voucher_amount, voucher_usage_per_month, voucher_name, voucher_description, voucher_status)
VALUES ('flat', 0.00, 15.00, 15.00, 1, 'APP15', 'RM15 off for orders placed via mobile app', TRUE);

-- Products

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(1, 'MALM Bed Frame', 'malm-bed-frame', 'A clean design with a high headboard and ample storage space.', 499.00, 20, 'Available in black-brown and white finishes.', 1, '{"color": ["Black-Brown", "White"], "size": ["Queen", "King"]}', '2024-11-15', NULL),
(1, 'HEMNES Daybed', 'hemnes-daybed', 'A versatile daybed that transforms into a double bed.', 299.00, 15, 'Includes three drawers for storage.', 0, '{"color": ["White"], "size": ["Twin", "Double"]}', '2023-09-10', NULL),
(1, 'BRIMNES Bed Frame', 'brimnes-bed-frame', 'Features four large drawers for under-bed storage.', 399.00, 10, 'Ideal for small spaces.', 0, '{"color": ["White"], "size": ["Full", "Queen"]}', '2022-06-25', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(2, 'EKTORP Sofa', 'ektorp-sofa', 'Classic 3-seat sofa with soft, rounded shapes and removable covers.', 499.00, 12, 'Machine-washable covers for easy cleaning.', 1, '{"color": ["Beige", "Gray", "Blue"]}', CURDATE(), NULL),
(2, 'VIMLE Sofa Bed', 'vimle-sofa-bed', 'Modular sofa with a pull-out bed; customizable to fit your space.', 899.00, 8, 'Includes storage space under the chaise.', 0, '{"color": ["Dark Gray", "Light Beige"]}', CURDATE(), NULL),
(2, 'POÄNG Armchair', 'poang-armchair', 'Comfortable armchair with a bentwood frame; various cushion options.', 129.00, 25, 'Lightweight yet sturdy design.', 0, '{"frame_color": ["Birch", "Black"], "cushion_color": ["Red", "Gray", "Black"]}', CURDATE(), NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(3, 'KLIPPAN Loveseat', 'klippan-loveseat', 'A compact loveseat with a durable cover.', 199.00, 25, 'Cover is removable and washable.', 1, '{"color": ["Red", "Blue", "Gray"]}', '2023-03-18', NULL),
(3, 'POÄNG Armchair', 'poang-armchair', 'A comfortable armchair with a slight bounce.', 129.00, 30, 'Layer-glued bent birch frame.', 0, '{"color": ["Birch", "Black-Brown"], "cushion": ["Beige", "Black"]}', '2024-01-05', NULL),
(3, 'EKTORP Sofa', 'ektorp-sofa', 'A classic 3-seat sofa with soft, rounded shapes.', 499.00, 12, 'Seat cushions have a core of resilient polyurethane foam.', 0, '{"color": ["White", "Gray"], "size": ["3-seat"]}', '2022-08-22', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(4, 'KALLAX Shelf Unit', 'kallax-shelf-unit', 'Versatile shelving unit that can be placed vertically or horizontally.', 69.00, 20, 'Compatible with various inserts and boxes.', 1, '{"color": ["White", "Black-Brown"]}', CURDATE(), NULL),
(4, 'BILLY Bookcase', 'billy-bookcase', 'Classic bookcase with adjustable shelves.', 59.00, 25, 'Available in multiple sizes and colors.', 0, '{"color": ["White", "Birch Veneer"]}', CURDATE(), NULL),
(4, 'IVAR Storage System', 'ivar-storage-system', 'Customizable storage system made of solid pine.', 89.00, 10, 'Can be painted or stained to suit your style.', 0, '{"color": ["Natural"]}', CURDATE(), NULL);


INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(5, 'LISABO Dining Table', 'lisabo-dining-table', 'Lightweight yet durable table with natural wood veneer.', 299.00, 10, 'Seats 4 people comfortably.', 0, '{"color": ["Ash"], "size": ["140x78 cm"]}', '2025-04-19', NULL),
(5, 'INGOLF Chair', 'ingolf-chair', 'Sturdy chair with a classic design.', 89.00, 25, 'High backrest for support.', 0, '{"color": ["White", "Brown"]}', '2025-04-21', NULL),
(5, 'MELLTORP Table and 4 Chairs', 'melltorp-table-and-4-chairs', 'Compact dining set suitable for small spaces.', 199.00, 8, 'Easy to clean surfaces.', 1, '{"color": ["White"], "size": ["125x75 cm"]}', '2025-04-23', NULL);


INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(6, 'MICKE Desk', 'micke-desk', 'A clean and simple desk with a modern look.', 149.00, 20, 'Compact size fits in small spaces.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-20', NULL),
(6, 'LINNMON / ALEX Table', 'linnmon-alex-table', 'Spacious tabletop with drawer units for storage.', 199.00, 15, 'Customizable combinations.', 0, '{"color": ["White"]}', '2025-04-22', NULL),
(6, 'BEKANT Sit/Stand Desk', 'bekant-sit-stand-desk', 'Adjustable height desk for ergonomic working.', 399.00, 10, 'Electric height adjustment.', 1, '{"color": ["Black", "White"]}', '2025-04-24', NULL);


INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(7, 'MARKUS Office Chair', 'markus-office-chair', 'High back office chair with lumbar support.', 229.00, 25, 'Adjustable tilt and height.', 1, '{"color": ["Black", "Gray"]}', '2025-04-19', NULL),
(7, 'FLINTAN Office Chair', 'flintan-office-chair', 'Comfortable chair with built-in lumbar support.', 129.00, 30, 'Tilt and height adjustable.', 0, '{"color": ["Black"]}', '2025-04-21', NULL),
(7, 'LÅNGFJÄLL Office Chair', 'langfjall-office-chair', 'Stylish chair with a sleek design.', 179.00, 20, 'Available in multiple colors.', 1, '{"color": ["Beige", "Blue"]}', '2025-04-23', NULL);


INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(8, 'KALLAX Shelving Unit', 'kallax-shelving-unit', 'Versatile shelving unit with insert options.', 89.00, 40, 'Can be placed vertically or horizontally.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-18', NULL),
(8, 'IVAR Storage System', 'ivar-storage-system', 'Sturdy pine storage system.', 129.00, 15, 'Customizable with shelves and cabinets.', 0, '{"color": ["Pine"]}', '2025-04-20', NULL),
(8, 'BROR Shelving Unit', 'bror-shelving-unit', 'Heavy-duty shelving for garages and workshops.', 149.00, 10, 'Holds up to 130kg per shelf.', 1, '{"color": ["Black"]}', '2025-04-22', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(9, 'PAX Wardrobe System', 'pax-wardrobe-system', 'Customizable wardrobe with sliding doors.', 499.00, 12, 'Interior organizers sold separately.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-17', NULL),
(9, 'BRIMNES Wardrobe', 'brimnes-wardrobe', 'Compact wardrobe with mirror door.', 199.00, 20, 'Includes adjustable shelves.', 0, '{"color": ["White"]}', '2025-04-19', NULL),
(9, 'SONGESAND Wardrobe', 'songesand-wardrobe', 'Classic wardrobe with three doors.', 299.00, 8, 'Spacious interior with hanging rod.', 1, '{"color": ["Brown"]}', '2025-04-21', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(10, 'BILLY Bookcase', 'billy-bookcase', 'Classic bookcase with adjustable shelves.', 69.00, 50, 'Available in various sizes and colors.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-16', NULL),
(10, 'HEMNES Bookcase', 'hemnes-bookcase', 'Solid wood bookcase with a traditional look.', 149.00, 15, 'Made from sustainable materials.', 0, '{"color": ["White", "Gray"]}', '2025-04-18', NULL),
(10, 'LACK Wall Shelf Unit', 'lack-wall-shelf-unit', 'Open wall shelf unit for display.', 59.00, 25, 'Easy to mount on the wall.', 1, '{"color": ["White", "Black"]}', '2025-04-20', NULL);


INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(11, 'BESTÅ TV Unit', 'besta-tv-unit', 'Modular TV unit with storage options.', 299.00, 10, 'Soft-closing drawers.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-15', NULL),
(11, 'LACK TV Unit', 'lack-tv-unit', 'Simple TV unit with open shelves.', 49.00, 30, 'Easy to assemble.', 0, '{"color": ["White", "Black"]}', '2025-04-17', NULL),
(11, 'BRIMNES TV Unit', 'brimnes-tv-unit', 'TV unit with drawers and glass doors.', 179.00, 12, 'Cable management system included.', 1, '{"color": ["White"]}', '2025-04-19', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(12, 'MALM 6-Drawer Dresser', 'malm-6-drawer-dresser', 'Spacious dresser with smooth-running drawers.', 199.00, 20, 'Available in multiple finishes.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-14', NULL),
(12, 'HEMNES 8-Drawer Dresser', 'hemnes-8-drawer-dresser', 'Traditional dresser made of solid wood.', 249.00, 10, 'Sustainable and durable.', 0, '{"color": ["White", "Gray"]}', '2025-04-16', NULL),
(12, 'KOPPANG 3-Drawer Chest', 'koppang-3-drawer-chest', 'Simple chest of drawers with a clean look.', 99.00, 25, 'Easy to coordinate with other furniture.', 1, '{"color": ["White"]}', '2025-04-18', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(13, 'ÄPPLARÖ Outdoor Sofa', 'applaro-outdoor-sofa', 'Modular outdoor sofa with cushions.', 349.00, 5, 'Durable acacia wood.', 1, '{"color": ["Brown"]}', '2025-04-13', NULL),
(13, 'TÄRNÖ Bistro Set', 'tarno-bistro-set', 'Foldable table and chairs for small spaces.', 69.00, 15, 'Easy to store.', 0, '{"color": ["Black", "Brown"]}', '2025-04-15', NULL),
(13, 'SOLLERÖN Lounge Set', 'solleron-lounge-set', 'Comfortable outdoor lounge set with storage.', 799.00, 3, 'Weather-resistant materials.', 1, '{"color": ["Gray"]}', '2025-04-17', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(14, 'KURA Reversible Bed', 'kura-reversible-bed', 'Can be used as a low bed or loft bed.', 199.00, 12, 'Ideal for growing children.', 1, '{"color": ["White", "Pine"]}', '2024-11-18', NULL),
(14, 'FLISAT Children''s Table', 'flisat-childrens-table', 'Adjustable table with storage options.', 59.00, 20, 'Compatible with TROFAST storage boxes.', 0, '{"color": ["Pine"]}', '2024-12-21', NULL),
(14, 'BUSUNGE Wardrobe', 'busunge-wardrobe', 'Spacious wardrobe with adjustable shelves.', 149.00, 8, 'Soft-close doors for safety.', 0, '{"color": ["Pink", "White"]}', '2025-04-23', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(15, 'GODMORGON Sink Cabinet', 'godmorgon-sink-cabinet', 'Modern sink cabinet with two drawers.', 249.00, 10, 'High-gloss finish for easy cleaning.', 1, '{"color": ["White", "Gray"]}', '2025-04-19', NULL),
(15, 'HEMNES Bathroom Shelf', 'hemnes-bathroom-shelf', 'Open shelving unit for towels and accessories.', 99.00, 15, 'Made of solid wood.', 0, '{"color": ["White", "Black-Brown"]}', '2025-04-22', NULL),
(15, 'LILLÅNGEN Mirror Cabinet', 'lillangen-mirror-cabinet', 'Space-saving mirror with storage.', 79.00, 12, 'Adjustable shelves inside.', 0, '{"color": ["White"]}', '2025-04-24', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(16, 'METOD Base Cabinet', 'metod-base-cabinet', 'Modular base cabinet for kitchen customization.', 120.00, 20, 'Soft-close drawers included.', 1, '{"color": ["White", "Oak"]}', '2024-07-20', NULL),
(16, 'STENSTORP Kitchen Cart', 'stenstorp-kitchen-cart', 'Mobile kitchen cart with butcher block top.', 199.00, 10, 'Provides additional counter space.', 0, '{"color": ["White", "Black"]}', '2024-06-23', NULL),
(16, 'KNOXHULT Kitchen Cabinet', 'knoxhult-kitchen-cabinet', 'Pre-assembled kitchen cabinet with sink.', 299.00, 5, 'Ideal for small spaces.', 0, '{"color": ["White"]}', '2025-04-25', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(17, 'HEMNES Shoe Cabinet', 'hemnes-shoe-cabinet', 'Slim shoe cabinet with four compartments.', 129.00, 15, 'Keeps shoes organized and out of sight.', 1, '{"color": ["White", "Black-Brown"]}', '2025-04-19', NULL),
(17, 'TJUSIG Coat Rack', 'tjusig-coat-rack', 'Wall-mounted coat rack with shelf.', 49.00, 20, 'Combines storage and display.', 0, '{"color": ["White", "Black"]}', '2023-04-21', NULL),
(17, 'MACKAPÄR Bench with Shoe Storage', 'mackapar-bench-shoe-storage', 'Bench with two shelves for shoes.', 79.00, 10, 'Perfect for entryways.', 0, '{"color": ["White"]}', '2025-02-24', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(18, 'RANARP Floor Lamp', 'ranarp-floor-lamp', 'Adjustable floor lamp with classic design.', 69.00, 12, 'Provides directed light.', 1, '{"color": ["White", "Black"]}', '2025-01-20', NULL),
(18, 'HEKTAR Pendant Lamp', 'hektar-pendant-lamp', 'Industrial-style pendant lamp.', 49.00, 15, 'Ideal for dining areas.', 0, '{"color": ["Gray"]}', '2024-04-22', NULL),
(18, 'FADO Table Lamp', 'fado-table-lamp', 'Globe-shaped table lamp for soft light.', 29.00, 20, 'Creates a cozy atmosphere.', 0, '{"color": ["White"]}', '2025-04-25', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(19, 'GURLI Cushion Cover', 'gurli-cushion-cover', 'Soft cotton cushion cover.', 5.00, 50, 'Available in various colors.', 1, '{"color": ["Red", "Blue", "Green"]}', '2025-04-18', NULL),
(19, 'VITMOSSA Throw', 'vitmossa-throw', 'Lightweight fleece throw.', 3.00, 40, 'Perfect for chilly evenings.', 0, '{"color": ["Gray", "Black"]}', '2025-04-21', NULL),
(19, 'ALVINE Spets Curtains', 'alvine-spets-curtains', 'Lace curtains for a light and airy feel.', 15.00, 30, 'Adds elegance to any room.', 0, '{"color": ["White"]}', '2025-04-23', NULL);

INSERT INTO Product (product_type_id, product_title, product_slug, product_desc, product_price, product_stock, product_retail_info, product_featured, product_variations, product_created_date, product_image_id)
VALUES
(20, 'FEJKA Artificial Potted Plant', 'fejka-artificial-potted-plant', 'Realistic-looking artificial plant.', 10.00, 25, 'No maintenance required.', 1, '{"color": ["Green"]}', '2024-10-19', NULL),
(20, 'LÖVBACKEN Side Table', 'lovbacken-side-table', 'Vintage-style side table with leaf-shaped top.', 59.00, 10, 'Adds character to your living room.', 0, '{"color": ["Brown"]}', '2023-12-22', NULL),
(20, 'SKURAR Candle Holder', 'skurar-candle-holder', 'Lace-patterned metal candle holder.', 7.00, 30, 'Creates decorative light patterns.', 0, '{"color": ["White"]}', '2025-04-24', NULL);



-- Payment
INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (1, NULL, 1127.32, '{"creditDebit": {"method": true, "cardNumber": "4173192592163759", "bankType": "Maybank", "cardName": "Nur Aisyah", "expiryDate": "01/2029"}, "bankTransfer": {"method": false}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 5, 176.29, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 211.99, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 1108.3, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 9, 631.66, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 1, 1054.6, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 276.85, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 1, 193.75, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (1, NULL, 762.43, '{"creditDebit": {"method": true, "cardNumber": "4683901550032984", "bankType": "Maybank", "cardName": "Nur Aisyah", "expiryDate": "01/2029"}, "bankTransfer": {"method": false}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, NULL, 237.85, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 1439.38, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, NULL, 912.44, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 648.8, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, NULL, 1294.89, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 7, 1241.85, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 4, 170.53, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 1, 482.25, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (1, 10, 1101.78, '{"creditDebit": {"method": true, "cardNumber": "4622204078966005", "bankType": "Maybank", "cardName": "Nur Aisyah", "expiryDate": "01/2029"}, "bankTransfer": {"method": false}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, NULL, 1277.31, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 1082.8, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 10, 973.24, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (1, NULL, 972.44, '{"creditDebit": {"method": true, "cardNumber": "4497552410859388", "bankType": "Maybank", "cardName": "Nur Aisyah", "expiryDate": "01/2029"}, "bankTransfer": {"method": false}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, NULL, 631.39, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 2, 630.96, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 8, 955.48, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 5, 889.21, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (2, 2, 881.53, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": true}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, NULL, 711.49, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (1, NULL, 222.65, '{"creditDebit": {"method": true, "cardNumber": "4624501364066373", "bankType": "Maybank", "cardName": "Nur Aisyah", "expiryDate": "01/2029"}, "bankTransfer": {"method": false}, "cod": {"method": false}}');

INSERT INTO Payment (method_id, voucher_id, total_paid, payment_info) VALUES (3, 7, 1035.74, '{"creditDebit": {"method": false, "cardNumber": "", "bankType": "", "cardName": "", "expiryDate": ""}, "bankTransfer": {"method": false}, "cod": {"method": true}}');


-- Orders
INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (47, 1, 1, 'Shipping info for user 47', '2025-04-09 18:23:44', NULL, NULL, NULL, 'ORD#25040918234447');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (41, 2, 2, 'Shipping info for user 41', '2025-04-05 18:23:44', '2025-04-06 18:23:44', NULL, NULL, 'ORD#25040518234441');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (37, 3, 4, 'Shipping info for user 37', '2025-04-24 18:23:44', '2025-04-25 18:23:44', '2025-04-26 18:23:44', '2025-04-27 18:23:44', 'ORD#25042418234437');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (37, 4, 1, 'Shipping info for user 37', '2025-03-30 18:23:44', NULL, NULL, NULL, 'ORD#25033018234437');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (37, 5, 3, 'Shipping info for user 37', '2025-03-28 18:23:44', '2025-03-29 18:23:44', '2025-03-30 18:23:44', NULL, 'ORD#25032818234437');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (21, 6, 1, 'Shipping info for user 21', '2025-04-11 18:23:44', NULL, NULL, NULL, 'ORD#25041118234421');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (28, 7, 3, 'Shipping info for user 28', '2025-04-09 18:23:44', '2025-04-10 18:23:44', '2025-04-11 18:23:44', NULL, 'ORD#25040918234428');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (35, 8, 1, 'Shipping info for user 35', '2025-04-21 18:23:44', NULL, NULL, NULL, 'ORD#25042118234435');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (21, 9, 2, 'Shipping info for user 21', '2025-04-27 18:23:44', '2025-04-28 18:23:44', NULL, NULL, 'ORD#25042718234421');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (31, 10, 2, 'Shipping info for user 31', '2025-04-04 18:23:44', '2025-04-05 18:23:44', NULL, NULL, 'ORD#25040418234431');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (47, 11, 3, 'Shipping info for user 47', '2025-04-07 18:23:44', '2025-04-08 18:23:44', '2025-04-09 18:23:44', NULL, 'ORD#25040718234447');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (30, 12, 4, 'Shipping info for user 30', '2025-04-23 18:23:44', '2025-04-24 18:23:44', '2025-04-25 18:23:44', '2025-04-26 18:23:44', 'ORD#25042318234430');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (42, 13, 3, 'Shipping info for user 42', '2025-04-10 18:23:44', '2025-04-11 18:23:44', '2025-04-12 18:23:44', NULL, 'ORD#25041018234442');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (27, 14, 1, 'Shipping info for user 27', '2025-04-01 18:23:44', NULL, NULL, NULL, 'ORD#25040118234427');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (32, 15, 2, 'Shipping info for user 32', '2025-04-11 18:23:44', '2025-04-12 18:23:44', NULL, NULL, 'ORD#25041118234432');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (45, 16, 2, 'Shipping info for user 45', '2025-04-04 18:23:44', '2025-04-05 18:23:44', NULL, NULL, 'ORD#25040418234445');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (44, 17, 1, 'Shipping info for user 44', '2025-04-06 18:23:44', NULL, NULL, NULL, 'ORD#25040618234444');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (39, 18, 3, 'Shipping info for user 39', '2025-04-25 18:23:44', '2025-04-26 18:23:44', '2025-04-27 18:23:44', NULL, 'ORD#25042518234439');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (38, 19, 4, 'Shipping info for user 38', '2025-04-27 18:23:44', '2025-04-28 18:23:44', '2025-04-29 18:23:44', '2025-04-30 18:23:44', 'ORD#25042718234438');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (46, 20, 2, 'Shipping info for user 46', '2025-04-14 18:23:44', '2025-04-15 18:23:44', NULL, NULL, 'ORD#25041418234446');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (49, 21, 4, 'Shipping info for user 49', '2025-04-11 18:23:44', '2025-04-12 18:23:44', '2025-04-13 18:23:44', '2025-04-14 18:23:44', 'ORD#25041118234449');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (28, 22, 4, 'Shipping info for user 28', '2025-04-14 18:23:44', '2025-04-15 18:23:44', '2025-04-16 18:23:44', '2025-04-17 18:23:44', 'ORD#25041418234428');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (37, 23, 1, 'Shipping info for user 37', '2025-03-29 18:23:44', NULL, NULL, NULL, 'ORD#25032918234437');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (22, 24, 3, 'Shipping info for user 22', '2025-04-10 18:23:44', '2025-04-11 18:23:44', '2025-04-12 18:23:44', NULL, 'ORD#25041018234422');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (35, 25, 4, 'Shipping info for user 35', '2025-04-04 18:23:44', '2025-04-05 18:23:44', '2025-04-06 18:23:44', '2025-04-07 18:23:44', 'ORD#25040418234435');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (24, 26, 3, 'Shipping info for user 24', '2025-04-12 18:23:44', '2025-04-13 18:23:44', '2025-04-14 18:23:44', NULL, 'ORD#25041218234424');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (25, 27, 4, 'Shipping info for user 25', '2025-04-07 18:23:44', '2025-04-08 18:23:44', '2025-04-09 18:23:44', '2025-04-10 18:23:44', 'ORD#25040718234425');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (38, 28, 2, 'Shipping info for user 38', '2025-04-14 18:23:44', '2025-04-15 18:23:44', NULL, NULL, 'ORD#25041418234438');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (34, 29, 3, 'Shipping info for user 34', '2025-04-13 18:23:44', '2025-04-14 18:23:44', '2025-04-15 18:23:44', NULL, 'ORD#25041318234434');

INSERT INTO Orders (user_id, payment_id, status_id, shipping_information, order_date, pack_date, ship_date, receive_date, order_ref_no) VALUES (43, 30, 3, 'Shipping info for user 43', '2025-04-07 18:23:44', '2025-04-08 18:23:44', '2025-04-09 18:23:44', NULL, 'ORD#25040718234443');


-- Order_Transactions
INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (11, 8, 3, 672.25, '{"color": ["Birch"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (12, 10, 3, 133.71, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (18, 10, 2, 854.11, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (24, 1, 1, 478.49, '{"color": ["Black-Brown"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (17, 3, 1, 669.67, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (3, 4, 4, 879.64, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (22, 8, 4, 350.17, '{"color": ["Birch"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (8, 4, 2, 921.62, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (25, 5, 1, 683.26, '{"color": ["Dark Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (5, 10, 5, 905.76, '{"color": ["White"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (15, 5, 3, 863.98, '{"color": ["Dark Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (19, 7, 4, 982.15, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (11, 9, 4, 612.9, '{"color": ["White"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (5, 2, 3, 863.73, '{"color": ["White"], "size": ["Double"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (15, 1, 3, 259.43, '{"color": ["White"], "size": ["King"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (16, 7, 2, 638.14, '{"color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (4, 2, 1, 727.96, '{"color": ["White"], "size": ["Twin"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (15, 6, 1, 723.36, '{"frame_color": ["Black"], "cushion_color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (2, 3, 1, 893.43, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (23, 4, 5, 925.87, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (16, 8, 1, 807.96, '{"color": ["Birch"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (20, 1, 2, 887.51, '{"color": ["Black-Brown"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (28, 6, 4, 93.38, '{"frame_color": ["Birch"], "cushion_color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (23, 5, 5, 247.48, '{"color": ["Light Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (3, 6, 1, 593.65, '{"frame_color": ["Black"], "cushion_color": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (27, 1, 4, 428.42, '{"color": ["Black-Brown"], "size": ["King"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (10, 4, 1, 775.7, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (20, 3, 3, 674.16, '{"color": ["White"], "size": ["Full"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (26, 5, 1, 256.73, '{"color": ["Dark Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (22, 1, 5, 490.56, '{"color": ["Black-Brown"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (16, 4, 1, 765.92, '{"color": ["Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (30, 10, 1, 847.74, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (1, 7, 2, 368.52, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (16, 10, 5, 193.83, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (23, 7, 2, 192.92, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (1, 6, 1, 478.27, '{"frame_color": ["Birch"], "cushion_color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (24, 3, 1, 217.78, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (29, 7, 4, 559.96, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (22, 6, 3, 67.6, '{"frame_color": ["Black"], "cushion_color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (7, 10, 1, 263.5, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (19, 1, 1, 575.93, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (30, 2, 2, 367.92, '{"color": ["White"], "size": ["Double"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (15, 10, 1, 483.3, '{"color": ["White"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (9, 9, 4, 663.37, '{"color": ["Gray"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (19, 4, 1, 396.92, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (1, 1, 1, 581.05, '{"color": ["White"], "size": ["King"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (27, 5, 4, 527.85, '{"color": ["Light Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (10, 6, 5, 591.0, '{"frame_color": ["Birch"], "cushion_color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (16, 1, 5, 656.89, '{"color": ["Black-Brown"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (20, 5, 5, 237.36, '{"color": ["Light Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (26, 8, 1, 343.88, '{"color": ["Birch"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (2, 4, 2, 93.15, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (14, 8, 4, 325.04, '{"color": ["Black-Brown"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (27, 8, 1, 646.53, '{"color": ["Birch"], "cushion": ["Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (20, 7, 4, 465.97, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (5, 8, 5, 775.53, '{"color": ["Birch"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (19, 6, 1, 626.67, '{"frame_color": ["Black"], "cushion_color": ["Red"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (7, 4, 4, 960.62, '{"color": ["Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (10, 2, 3, 843.67, '{"color": ["White"], "size": ["Double"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (11, 3, 5, 257.62, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (2, 10, 1, 244.4, '{"color": ["White"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (27, 10, 1, 88.84, '{"color": ["White"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (24, 9, 4, 713.0, '{"color": ["Gray"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (14, 1, 2, 983.79, '{"color": ["White"], "size": ["King"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (29, 10, 3, 186.23, '{"color": ["White"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (8, 2, 5, 309.12, '{"color": ["White"], "size": ["Twin"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (18, 3, 5, 92.62, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (7, 3, 5, 55.73, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (23, 8, 5, 117.15, '{"color": ["Black-Brown"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (25, 7, 1, 798.85, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (19, 3, 1, 401.27, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (21, 7, 5, 617.46, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (13, 2, 2, 113.6, '{"color": ["White"], "size": ["Twin"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (12, 9, 3, 275.46, '{"color": ["White"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (24, 2, 4, 608.8, '{"color": ["White"], "size": ["Twin"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (11, 7, 1, 603.95, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (26, 7, 4, 480.31, '{"color": ["Blue"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (11, 1, 1, 239.38, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (1, 5, 5, 552.53, '{"color": ["Light Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (28, 9, 3, 343.95, '{"color": ["White"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (9, 3, 4, 413.12, '{"color": ["White"], "size": ["Full"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (9, 4, 3, 752.19, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (3, 5, 4, 400.7, '{"color": ["Light Beige"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (17, 6, 4, 473.87, '{"frame_color": ["Birch"], "cushion_color": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (15, 3, 4, 925.45, '{"color": ["White"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (23, 1, 4, 532.25, '{"color": ["Black-Brown"], "size": ["Queen"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (22, 4, 4, 197.57, '{"color": ["Gray"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (3, 8, 2, 284.15, '{"color": ["Black-Brown"], "cushion": ["Black"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (29, 1, 3, 804.24, '{"color": ["White"], "size": ["King"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (7, 9, 5, 616.5, '{"color": ["White"], "size": ["3-seat"]}', '2025-04-27 18:23:44');

INSERT INTO Order_Transaction (order_id, product_id, order_quantity, ordered_product_price, selected_variations, created_at) VALUES (25, 10, 4, 156.29, '{"color": ["Black-Brown"]}', '2025-04-27 18:23:44');


-- Product Feedback
INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (3, 4, '2025-04-16 18:28:50', 3, 'Not as expected.', 'Thank you for your feedback!', '2025-04-16', '2025-04-20');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (4, 5, '2025-04-01 18:28:50', 3, 'Great product!', NULL, '2025-04-01', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 5, '2025-04-11 18:28:50', 0, 'Poor quality.', 'Sorry for the inconvenience.', '2025-04-11', '2025-04-19');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (1, 9, '2025-03-29 18:28:50', 3, 'Super comfy.', 'Thank you for your feedback!', '2025-03-29', '2025-03-31');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 6, '2025-03-24 18:28:50', 2, 'Poor quality.', 'Glad you liked it!', '2025-03-24', '2025-03-26');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (7, 7, '2025-03-05 18:28:50', 4, 'Color not accurate.', 'Thank you for your feedback!', '2025-03-05', '2025-03-09');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (10, 3, '2025-03-06 18:28:50', 4, 'Would buy again.', 'Thank you for your feedback!', '2025-03-06', '2025-03-13');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (3, 8, '2025-03-28 18:28:50', 2, 'Packaging was damaged.', 'Glad you liked it!', '2025-03-28', '2025-04-06');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (9, 2, '2025-04-22 18:28:50', 5, 'Very satisfied.', NULL, '2025-04-22', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 8, '2025-04-06 18:28:50', 2, 'Very satisfied.', NULL, '2025-04-06', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 6, '2025-03-22 18:28:50', 2, 'Not Really satisfied.', 'Thank you for your feedback!', '2025-03-22', '2025-03-31');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (2, 1, '2025-04-12 18:28:50', 5, 'Worth the price!', 'Thank you for your feedback!', '2025-04-12', '2025-04-14');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 8, '2025-04-10 18:28:50', 5, 'Great product!', 'Glad you liked it!', '2025-04-10', '2025-04-15');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 4, '2025-04-14 18:28:50', 5, 'Great product!', NULL, '2025-04-14', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (4, 8, '2025-03-30 18:28:50', 1, 'Super comfy.', 'Glad you liked it!', '2025-03-30', '2025-04-08');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (9, 5, '2025-04-21 18:28:50', 2, 'Super comfy.', 'Glad you liked it!', '2025-04-21', '2025-04-24');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (4, 3, '2025-03-20 18:28:50', 5, 'Poor quality.', 'Sorry for the inconvenience.', '2025-03-20', '2025-03-21');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (2, 10, '2025-03-17 18:28:50', 3, 'Not as expected.', 'Sorry for the inconvenience.', '2025-03-17', '2025-03-26');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (4, 5, '2025-04-20 18:28:50', 2, 'Worth the price!', 'Thank you for your feedback!', '2025-04-20', '2025-04-28');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (1, 5, '2025-03-29 18:28:50', 3, 'Super comfy.', 'Sorry for the inconvenience.', '2025-03-29', '2025-04-03');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (7, 8, '2025-03-01 18:28:50', 4, 'Not as expected.', 'Thank you for your feedback!', '2025-03-01', '2025-03-03');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (1, 1, '2025-03-08 18:28:50', 4, 'Packaging was damaged.', 'Thank you for your feedback!', '2025-03-08', '2025-03-14');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 5, '2025-03-13 18:28:50', 3, 'Poor quality.', 'Thank you for your feedback!', '2025-03-13', '2025-03-17');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (4, 9, '2025-04-05 18:28:50', 5, 'Poor quality.', NULL, '2025-04-05', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 5, '2025-04-01 18:28:50', 0, 'Poor quality.', 'Sorry for the inconvenience.', '2025-04-01', '2025-04-07');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (1, 8, '2025-04-21 18:28:50', 3, 'Not as expected.', 'Thank you for your feedback!', '2025-04-21', '2025-04-22');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (6, 5, '2025-04-26 18:28:50', 4, 'Great product!', 'Sorry for the inconvenience.', '2025-04-26', '2025-05-03');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (9, 4, '2025-04-14 18:28:50', 3, 'Worth the price!', 'Glad you liked it!', '2025-04-14', '2025-04-19');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (7, 6, '2025-04-23 18:28:50', 0, 'Very satisfied.', 'Glad you liked it!', '2025-04-23', '2025-04-24');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (6, 7, '2025-03-13 18:28:50', 1, 'Would buy again.', 'Glad you liked it!', '2025-03-13', '2025-03-16');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (6, 6, '2025-03-08 18:28:50', 3, 'Not as expected.', 'Thank you for your feedback!', '2025-03-08', '2025-03-13');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (7, 9, '2025-03-31 18:28:50', 2, 'Worth the price!', 'Glad you liked it!', '2025-03-31', '2025-04-04');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (1, 8, '2025-04-19 18:28:50', 2, 'Fast delivery!', 'Glad you liked it!', '2025-04-19', '2025-04-24');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (2, 1, '2025-03-20 18:28:50', 3, 'Great product!', NULL, '2025-03-20', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 7, '2025-03-04 18:28:50', 5, 'Color not accurate.', 'Sorry for the inconvenience.', '2025-03-04', '2025-03-08');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (2, 10, '2025-03-09 18:28:50', 3, 'Poor quality.', 'Glad you liked it!', '2025-03-09', '2025-03-11');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (3, 6, '2025-03-07 18:28:50', 1, 'Super comfy.', NULL, '2025-03-07', NULL);

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (6, 8, '2025-03-18 18:28:50', 1, 'Poor quality.', 'Glad you liked it!', '2025-03-18', '2025-03-24');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 4, '2025-04-12 18:28:50', 5, 'Packaging was damaged.', 'Thank you for your feedback!', '2025-04-12', '2025-04-16');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (3, 7, '2025-04-01 18:28:50', 1, 'Packaging was damaged.', 'Glad you liked it!', '2025-04-01', '2025-04-06');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 9, '2025-02-27 18:28:50', 0, 'Color not accurate.', 'Glad you liked it!', '2025-02-27', '2025-03-07');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (8, 4, '2025-04-10 18:28:50', 5, 'Super comfy.', 'Thank you for your feedback!', '2025-04-10', '2025-04-11');

INSERT INTO Product_Feedback (product_id, order_id, created_at, rating, comment, reply, feedback_date, reply_date) VALUES (5, 8, '2025-03-25 18:28:50', 1, 'Color not accurate.', NULL, '2025-03-25', NULL);

-- Permissions

-- Cart Permission Data
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/cart', 'Cart Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/checkout', 'Checkout Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/getAvailableVouchers', 'Get Available Vouchers');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/addCart', 'Add Cart for New User');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/getCart', 'Get Cart by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/getCartItems', 'Get Cart Items by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/addToCart', 'Add Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/addToCartById', 'Add Cart Item by Product ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/updateQuantity', 'Update Cart Item Quantity');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/removeCartItem', 'Remove Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/removeCartItemById', 'Remove Cart Item by ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Cart/clearCart', 'Clear All Cart Items');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/cart', 'Cart Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/checkout', 'Checkout Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/getAvailableVouchers', 'Get Available Vouchers');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/addCart', 'Add Cart for New User');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/getCart', 'Get Cart by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/getCartItems', 'Get Cart Items by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/addToCart', 'Add Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/addToCartById', 'Add Cart Item by Product ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/updateQuantity', 'Update Cart Item Quantity');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/removeCartItem', 'Remove Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/removeCartItemById', 'Remove Cart Item by ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Cart/clearCart', 'Clear All Cart Items');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/cart', 'Cart Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/checkout', 'Checkout Page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/getAvailableVouchers', 'Get Available Vouchers');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/addCart', 'Add Cart for New User');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/getCart', 'Get Cart by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/getCartItems', 'Get Cart Items by User ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/addToCart', 'Add Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/addToCartById', 'Add Cart Item by Product ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/updateQuantity', 'Update Cart Item Quantity');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/removeCartItem', 'Remove Cart Item (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/removeCartItemById', 'Remove Cart Item by ID');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Cart/clearCart', 'Clear All Cart Items');

-- Order Permission Data
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/orderInfo', 'View Single Order Info');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/generateReceipt', 'Generate Order Receipt PDF');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/orders', 'View Orders Page (Staff)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getOrderByCategories', 'Filter Orders by Status (Staff/Admin)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/updateOrderStatus', 'Update Order Status (Staff/Admin)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/cancelOrder', 'Cancel Order');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/processPayment', 'Process Payment (Checkout)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/addPayment', 'Add Payment Info (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getPaymentByOrder', 'Get Payment Info by Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getPaymentById', 'Get Payment by ID (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/addOrder', 'Add Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getOrderById', 'Get Order by ID (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getAllOrderInfo', 'Get Full Order Info (Admin/Staff) (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getOrdersByUser', 'Get Orders List by User (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/addOrderTransaction', 'Add Order Transaction (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getOrderTransactionByOrderAndProduct', 'Get Order Transaction by Order and Product (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/getAllOrderTransactionByOrder', 'Get All Transactions for an Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'Order/addOrderFeedback', 'Add Order Feedback');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Order/orderInfo', 'View Single Order Info');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Order/generateReceipt', 'Generate Order Receipt PDF');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Order/cancelOrder', 'Cancel Order');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'Order/processPayment', 'Process Payment (Checkout)');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/orderInfo', 'View Single Order Info');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/generateReceipt', 'Generate Order Receipt PDF');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/orders', 'View Orders Page (Staff)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getOrderByCategories', 'Filter Orders by Status (Staff/Admin)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/updateOrderStatus', 'Update Order Status (Staff/Admin)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/cancelOrder', 'Cancel Order');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/processPayment', 'Process Payment (Checkout)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/addPayment', 'Add Payment Info (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getPaymentByOrder', 'Get Payment Info by Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getPaymentById', 'Get Payment by ID (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/addOrder', 'Add Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getOrderById', 'Get Order by ID (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getAllOrderInfo', 'Get Full Order Info (Admin/Staff) (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getOrdersByUser', 'Get Orders List by User (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/addOrderTransaction', 'Add Order Transaction (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getOrderTransactionByOrderAndProduct', 'Get Order Transaction by Order and Product (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/getAllOrderTransactionByOrder', 'Get All Transactions for an Order (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'Order/addOrderFeedback', 'Add Order Feedback');



-- Product Permission Data
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'product/productPage', 'Get Full Order Info (Admin/Staff) (Postman)');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'product/productCatalog', 'Add Order Transaction (Postman)');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'product/productCatalog', 'View Single Order Info');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (2, 'product/productPage', 'Generate Order Receipt PDF');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'product/productCatalog', 'View Single Order Info');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'product/productPage', 'Generate Order Receipt PDF');

INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'product/addProduct', 'Get to access update and edit product page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'deleteProduct', 'Have access to add product');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (1, 'updateProduct', 'Get to access update and edit product page');


INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'product/addProduct', 'Get to access update and edit product page');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'deleteProduct', 'Have access to add product');
INSERT INTO Permission (role_id, permission_url, permission_description) VALUES (3, 'updateProduct', 'Get to access update and edit product page');

-- Permissions for Admin (full access)
INSERT INTO `Permission` (`role_id`, `permission_url`, `permission_description`) VALUES
(1, 'User/account', 'Access account dashboard'),
(1, 'User/account/profile', 'View profile'),
(1, 'User/account/profile/edit', 'Edit profile'),
(1, 'User/account/password', 'Access password page'),
(1, 'User/account/password/verify', 'Verify current password'),
(1, 'User/account/password/otp', 'OTP verification'),
(1, 'User/account/password/new', 'Change password'),
(1, 'User/account/addresses', 'Manage addresses'),
(1, 'User/account/addresses/add', 'Add address'),
(1, 'User/account/addresses/edit', 'Edit address'),
(1, 'User/account/addresses/delete', 'Delete address'),
(1, 'User/account/payments', 'View payment cards'),
(1, 'User/account/payment/add', 'Add payment card'),
(1, 'User/account/payment/edit', 'Edit payment card'),
(1, 'User/account/payment/delete', 'Delete payment card'),
(1, 'User/account/vouchers', 'View vouchers'),
(1, 'User/account/notifications', 'View notifications'),
(1, 'User/account/notification/redirect', 'Redirect via notification');

-- Permissions for Customer (access)
INSERT INTO `Permission` (`role_id`, `permission_url`, `permission_description`) VALUES
(2, 'User/account', 'Access account dashboard'),
(2, 'User/account/profile', 'View profile'),
(2, 'User/account/profile/edit', 'Edit profile'),
(2, 'User/account/password', 'Access password page'),
(2, 'User/account/password/verify', 'Verify current password'),
(2, 'User/account/password/otp', 'OTP verification'),
(2, 'User/account/password/new', 'Change password'),
(2, 'User/account/addresses', 'Manage addresses'),
(2, 'User/account/addresses/add', 'Add address'),
(2, 'User/account/addresses/edit', 'Edit address'),
(2, 'User/account/addresses/delete', 'Delete address'),
(2, 'User/account/payments', 'View payment cards'),
(2, 'User/account/payment/add', 'Add payment card'),
(2, 'User/account/payment/edit', 'Edit payment card'),
(2, 'User/account/payment/delete', 'Delete payment card'),
(2, 'User/account/vouchers', 'View vouchers'),
(2, 'User/account/notifications', 'View notifications'),
(2, 'User/account/notification/redirect', 'Redirect via notification');

-- Permissions for Staff (access)
INSERT INTO `Permission` (`role_id`, `permission_url`, `permission_description`) VALUES
(3, 'User/account', 'Access account dashboard'),
(3, 'User/account/profile', 'View profile'),
(3, 'User/account/profile/edit', 'Edit profile'),
(3, 'User/account/password', 'Access password page'),
(3, 'User/account/password/verify', 'Verify current password'),
(3, 'User/account/password/otp', 'OTP verification'),
(3, 'User/account/password/new', 'Change password'),
(3, 'User/account/addresses', 'Manage addresses'),
(3, 'User/account/addresses/add', 'Add address'),
(3, 'User/account/addresses/edit', 'Edit address'),
(3, 'User/account/addresses/delete', 'Delete address'),
(3, 'User/account/payments', 'View payment cards'),
(3, 'User/account/payment/add', 'Add payment card'),
(3, 'User/account/payment/edit', 'Edit payment card'),
(3, 'User/account/payment/delete', 'Delete payment card'),
(3, 'User/account/vouchers', 'View vouchers'),
(3, 'User/account/notifications', 'View notifications'),
(3, 'User/account/notification/redirect', 'Redirect via notification');

-- Dashbord
-- Admin
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard", "Management Portal");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/staff", "View Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/customer", "View Customer");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/staff/add", "Add Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/staff/edit", "Edit Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/staff/delete", "Delete Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/vouchers", "Delete Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/voucher/add", "Delete Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(1, "Dashboard/voucher/status", "Delete Staff");

-- Staff
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(3, "Dashboard/customer", "View Customer");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(3, "Dashboard/vouchers", "Delete Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(3, "Dashboard/voucher/add", "Delete Staff");
INSERT INTO Permission(role_id, permission_url, permission_description) VALUES(3, "Dashboard/voucher/status", "Delete Staff");