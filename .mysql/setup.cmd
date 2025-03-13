docker exec -u root -it mystichome /bin/bash

#install mysql client
apt-get update
apt-get install mysql-client -y

#login as root
mysql -h mysql_db -u root -p
