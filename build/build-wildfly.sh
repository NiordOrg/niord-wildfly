#!/bin/bash

#
# Installs a Wildfly instance and adds a MySQL driver
#

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh


# NB: We could download from JBoss, but using maven makes it faster because it is fetched from local maven repo...
echo "Installing $WILDFLY to $WILDFLY_ROOT"
rm -rf $WILDFLY_PATH
mvn package -f $DIR/install-wildfly-pom.xml -P install-wildfly -DskipTests
rm -rf  $DIR/target

chmod +x $WILDFLY_PATH/bin/*.sh

# Configure the System properties
$WILDFLY_CONF_DIR/configure-sys-props.sh

# Configure SSL proxying via e.g. Nginx or Apache
$WILDFLY_CONF_DIR/configure-ssl.sh

# Configure an SMTP session
$WILDFLY_CONF_DIR/configure-smtp.sh

# Install the MySQL driver
$WILDFLY_CONF_DIR/install-mysql-ds.sh

# Configure messaging support
$WILDFLY_CONF_DIR/configure-wildfly-jms.sh

# Configure JDBC-backed Batch support
$WILDFLY_CONF_DIR/configure-wildfly-batch.sh

# Install the Hibernate Spatial module
$WILDFLY_CONF_DIR/install-hibernate-spatial.sh

# Install the Keycloak adapter
$WILDFLY_CONF_DIR/install-keycloak-adapter.sh

rm -rf $WILDFLY_PATH/standalone/configuration/standalone_xml_history