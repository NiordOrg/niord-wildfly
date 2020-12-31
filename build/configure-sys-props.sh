#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

echo "Introducing System Properties."
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo
batch

/system-property=resteasy.jackson.deserialization.whitelist.allowIfBaseType.prefix:add(\
value=org.niord.core.promulgation.vo.BaseMessagePromulgationVo\
)

run-batch
stop-embedded-server
EOF


