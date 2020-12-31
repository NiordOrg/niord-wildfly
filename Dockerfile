# Use latest jboss/base-jdk:11 image as the base
FROM jboss/base-jdk:11

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 21.0.0.Final
ENV WILDFLY_SHA1 949ab4e1b608f5dbdd2d63c7443cdaba0bc5c07b
ENV JBOSS_HOME /opt/jboss/wildfly
ENV NIORD_HOME /opt/niord

USER root

# set locals for image to support UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD ../wildfly-$WILDFLY_VERSION /opt/jboss/wildfly

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

RUN yum install -y epel-release && yum install -y jq && yum clean all

#RUN apt-get -q update && apt-get -qy install netcat

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /opt/jboss/wildfly/bin/wait-for-it.sh
RUN chmod +x /opt/jboss/wildfly/bin/wait-for-it.sh

# Expose the ports we're interested in
EXPOSE 8080

# wait for database docker image before starting Keycloak
CMD /opt/jboss/wildfly/bin/wait-for-it.sh niord-mysql:3306 --timeout=40 --strict \
    -- /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -Dfile.encoding=UTF-8 -Dniord.home=${NIORD_HOME}
    
#CMD /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -Dfile.encoding=UTF-8 -Dniord.home=${NIORD_HOME}