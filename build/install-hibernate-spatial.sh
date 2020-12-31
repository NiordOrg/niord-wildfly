#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

HIBERNATE_MODULE=$WILDFLY_PATH/modules/system/layers/base/org/hibernate/main
INFINISPAN_MODULE=$WILDFLY_PATH/modules/system/layers/base/org/infinispan/main

HIBERNATE_VERSION=5.4.23.Final
HIBERNATE_CORE=hibernate-core-$HIBERNATE_VERSION.jar
HIBERNATE_ENVERS=hibernate-envers-$HIBERNATE_VERSION.jar
HIBERNATE_SPATIAL=hibernate-spatial-$HIBERNATE_VERSION.jar
GEOLATTE_VERSION=1.6.0
GEOLATTE=geolatte-geom-$GEOLATTE_VERSION.jar
JTS_VERSION=1.16.1
JTS=jts-core-$JTS_VERSION.jar
JSON_SIMPLE_VERSION=1.1.1
JSON_SIMPLE=json-simple-$JSON_SIMPLE_VERSION.jar



echo "Updating Hibernate module. Make sure this is up-to-date with the current WILDFLY version!"
cat > $HIBERNATE_MODULE/module.xml << EOL
<?xml version="1.0" encoding="UTF-8"?>
<module xmlns="urn:jboss:module:1.3" name="org.hibernate">
    <resources>
        <resource-root path="hibernate-core-$HIBERNATE_VERSION.jar"/>
        <resource-root path="hibernate-envers-$HIBERNATE_VERSION.jar"/>
        <resource-root path="$HIBERNATE_SPATIAL"/>
        <resource-root path="$GEOLATTE"/>
        <resource-root path="$JTS"/>
        <resource-root path="$JSON_SIMPLE"/>
    </resources>

    <dependencies>
        <module name="asm.asm"/>
        <module name="com.fasterxml.classmate"/>
        <module name="javax.api"/>
        <module name="javax.annotation.api"/>
        <module name="javax.enterprise.api"/>
        <module name="javax.persistence.api"/>
        <module name="javax.transaction.api"/>
        <module name="javax.validation.api"/>
        <module name="javax.xml.bind.api"/>
        <module name="org.antlr"/>
        <module name="org.dom4j"/>
        <module name="org.javassist"/>
        <module name="org.jboss.as.jpa.spi"/>
        <module name="org.jboss.jandex"/>
        <module name="org.jboss.logging"/>
        <module name="org.jboss.threads"/>
        <module name="org.jboss.vfs"/>
        <module name="org.hibernate.commons-annotations"/>
        <module name="org.hibernate.infinispan" services="import" optional="true"/>
        <module name="org.hibernate.jipijapa-hibernate5" services="import"/>
        <module name="org.slf4j"/>
        <module name="net.bytebuddy"/>
        <module name="org.infinispan.hibernate-cache"/>
    </dependencies>
</module>
EOL

echo "Installing Hibernate Spatial module resources."
curl -o $HIBERNATE_MODULE/$HIBERNATE_CORE \
       https://repo1.maven.org/maven2/org/hibernate/hibernate-core/$HIBERNATE_VERSION/$HIBERNATE_CORE
curl -o $HIBERNATE_MODULE/$HIBERNATE_ENVERS \
       https://repo1.maven.org/maven2/org/hibernate/hibernate-envers/$HIBERNATE_VERSION/$HIBERNATE_ENVERS
curl -o $HIBERNATE_MODULE/$HIBERNATE_SPATIAL \
       https://repo1.maven.org/maven2/org/hibernate/hibernate-spatial/$HIBERNATE_VERSION/$HIBERNATE_SPATIAL
curl -o $HIBERNATE_MODULE/$GEOLATTE \
       https://repo1.maven.org/maven2/org/geolatte/geolatte-geom/$GEOLATTE_VERSION/$GEOLATTE
curl -o $HIBERNATE_MODULE/$JTS \
       https://repo1.maven.org/maven2/org/locationtech/jts/jts-core/$JTS_VERSION/$JTS
curl -o $HIBERNATE_MODULE/$JSON_SIMPLE \
       https://repo1.maven.org/maven2/com/googlecode/json-simple/json-simple/$JSON_SIMPLE_VERSION/$JSON_SIMPLE


echo "Adding thread support to infinispan-core"
cat > $INFINISPAN_MODULE/module.xml << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ JBoss, Home of Professional Open Source.
  ~ Copyright 2010, Red Hat, Inc., and individual contributors
  ~ as indicated by the @author tags. See the copyright.txt file in the
  ~ distribution for a full listing of individual contributors.
  ~
  ~ This is free software; you can redistribute it and/or modify it
  ~ under the terms of the GNU Lesser General Public License as
  ~ published by the Free Software Foundation; either version 2.1 of
  ~ the License, or (at your option) any later version.
  ~
  ~ This software is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ Lesser General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Lesser General Public
  ~ License along with this software; if not, write to the Free
  ~ Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  ~ 02110-1301 USA, or see the FSF site: http://www.fsf.org.
  -->
<module name="org.infinispan" xmlns="urn:jboss:module:1.9">
    <properties>
        <property name="jboss.api" value="private"/>
    </properties>

    <resources>
        <resource-root path="infinispan-core-11.0.4.Final.jar"/>
    </resources>

    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
        <module name="com.github.ben-manes.caffeine"/>
        <module name="io.reactivex.rxjava3.rxjava"/>
        <module name="org.infinispan.persistence.jdbc" optional="true"/>
        <module name="org.infinispan.persistence.remote" optional="true"/>
        <module name="org.infinispan.client.hotrod" optional="true"/>
        <module name="org.infinispan.commons"/>
        <module name="org.infinispan.component.annotations"/>
        <module name="org.infinispan.protostream"/>
        <module name="org.jboss.jandex"/>
        <module name="org.jboss.logging"/>
        <module name="org.jboss.threads"/>
        <module name="org.jgroups" optional="true"/>
        <module name="org.reactivestreams"/>
        <module name="sun.jdk" optional="true"/>
    </dependencies>
</module>
EOL
