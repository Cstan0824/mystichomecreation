USE MysticHome_Creation;

-- grant access to users
GRANT SELECT, INSERT, UPDATE, DELETE ON `MysticHome_Creation`.* TO 'user'@'%';
FLUSH PRIVILEGES;
--check access for users
SHOW GRANTS FOR 'user'@'%';

-- change authentication plugins
ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'myuser1234';
FLUSH PRIVILEGES;
--check plugins
SELECT user, host, plugin FROM mysql.user WHERE user = 'user';

-- create tables
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

