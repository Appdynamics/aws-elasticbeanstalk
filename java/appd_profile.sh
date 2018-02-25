APPDYNAMICS_CONTROLLER_HOST_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_HOST_NAME 2>&1)
APPDYNAMICS_CONTROLLER_PORT=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_PORT 2>&1)
APPDYNAMICS_CONTROLLER_SSL_ENABLED=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_SSL_ENABLED 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_NAME 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY 2>&1)
APPDYNAMICS_AGENT_APPLICATION_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_APPLICATION_NAME 2>&1)
APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_TIER_NAME 2>&1)
JAVA_OPTS=$(/opt/elasticbeanstalk/bin/get-config environment -k JAVA_OPTS 2>&1)

if [[ -v APPDYNAMICS_CONTROLLER_HOST_NAME ]]
then
    export APPDYNAMICS_CONTROLLER_HOST_NAME=$APPDYNAMICS_CONTROLLER_HOST_NAME
else
    echo "APPDYNAMICS_CONTROLLER_HOST_NAME not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_CONTROLLER_PORT ]]
then
    export APPDYNAMICS_CONTROLLER_PORT=$APPDYNAMICS_CONTROLLER_PORT
else
    echo "APPDYNAMICS_CONTROLLER_PORT not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_CONTROLLER_SSL_ENABLED ]]
then
    export APPDYNAMICS_CONTROLLER_SSL_ENABLED=$APPDYNAMICS_CONTROLLER_SSL_ENABLED
else
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED not set. It will default to false."
    export APPDYNAMICS_CONTROLLER_SSL_ENABLED=false
fi

if [[ -v APPDYNAMICS_AGENT_ACCOUNT_NAME ]]
then
    export APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME not set. It will default to customer1."
    export APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1
fi

if [[ -v APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY ]]
then
    export APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_AGENT_APPLICATION_NAME ]]
then
    export APPDYNAMICS_AGENT_APPLICATION_NAME=$APPDYNAMICS_AGENT_APPLICATION_NAME
else
    echo "APPDYNAMICS_AGENT_APPLICATION_NAME not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_AGENT_TIER_NAME ]]
then
    export APPDYNAMICS_AGENT_TIER_NAME=$APPDYNAMICS_AGENT_TIER_NAME
else
    echo "APPDYNAMICS_AGENT_TIER_NAME not set. Using Environment Name."
    export APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config container -k environment_name 2>&1)
fi

if [[ -v JAVA_OPTS ]]
then
    export JAVA_OPTS=$JAVA_OPTS -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_TIER_NAME
else
    echo "JAVA_OPTS not set. Exiting."
    exit 1
fi

exit 0
