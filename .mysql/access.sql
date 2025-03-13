USE MysticHome_Creation;

-- grant access to users
-- check access for users [SHOW GRANTS FOR 'user'@'%';]
GRANT SELECT, INSERT, UPDATE, DELETE ON `MysticHome_Creation`.* TO 'user'@'%';
FLUSH PRIVILEGES;

-- change authentication plugins
-- check plugins[SELECT user, host, plugin FROM mysql.user WHERE user = 'user';]
ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'myuser1234';
FLUSH PRIVILEGES;