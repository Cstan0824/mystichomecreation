#!/bin/sh

echo "Starting GlassFish setup..."

echo "start-domain
add-library --type common /opt/glassfish7/custom/mysql-connector-j-9.2.0.jar
create-jdbc-connection-pool \
--restype javax.sql.DataSource \
--datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
--property user=root:password=$MYSQL_ROOT_PASSWORD:serverName=$MYSQL_CONTAINER_NAME:portNumber=$MYSQL_PORT:databaseName=$MYSQL_DATABASE:useSSL=$POOL_ENABLESSL:allowPublicKeyRetrieval=$POOL_ALLOW_PUBLICKEY_RETRIEVAL:serverTimezone=$POOL_SERVER_TIMEZONE \
MainPool
create-jdbc-resource --connectionpoolid MainPool $JTA_DATA_SOURCE
stop-domain" | asadmin --interactive=false multimode

echo "GlassFish setup completed and domain stopped."

