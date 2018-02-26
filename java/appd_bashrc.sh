#TODO
#Clean /etc/bashrc

APPDYNAMICS_CONTROLLER_HOST_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_HOST_NAME 2>&1)
APPDYNAMICS_CONTROLLER_PORT=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_PORT 2>&1)
APPDYNAMICS_CONTROLLER_SSL_ENABLED=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_SSL_ENABLED 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_NAME <2>&1)
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY 2>&1)
APPDYNAMICS_AGENT_APPLICATION_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_APPLICATION_NAME 2>&1)
APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_TIER_NAME 2>&1)
JAVA_OPTS=$(/opt/elasticbeanstalk/bin/get-config environment -k JAVA_OPTS 2>&1)

if [[ -v APPDYNAMICS_CONTROLLER_HOST_NAME ]]
then
    echo "APPDYNAMICS_CONTROLLER_HOST_NAME=$APPDYNAMICS_CONTROLLER_HOST_NAME" >> /etc/bashrc
else
    echo "APPDYNAMICS_CONTROLLER_HOST_NAME not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_CONTROLLER_PORT ]]
then
    echo "APPDYNAMICS_CONTROLLER_PORT=$APPDYNAMICS_CONTROLLER_PORT" >> /etc/bashrc
else
    echo "APPDYNAMICS_CONTROLLER_PORT not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_CONTROLLER_SSL_ENABLED ]]
then
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=$APPDYNAMICS_CONTROLLER_SSL_ENABLED" >> /etc/bashrc
else
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED not set. It will default to false."
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=false" >> /etc/bashrc
fi

if [[ -v APPDYNAMICS_AGENT_ACCOUNT_NAME ]]
then
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME" >> /etc/bashrc
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME not set. It will default to customer1."
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1" >> /etc/bashrc
fi

if [[ -v APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY ]]
then
    echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY" >> /etc/bashrc
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_AGENT_APPLICATION_NAME ]]
then
    echo "APPDYNAMICS_AGENT_APPLICATION_NAME=$APPDYNAMICS_AGENT_APPLICATION_NAME" >> /etc/bashrc
else
    echo "APPDYNAMICS_AGENT_APPLICATION_NAME not set. Exiting."
    exit 1
fi

if [[ -v APPDYNAMICS_AGENT_TIER_NAME ]]
then
    echo "APPDYNAMICS_AGENT_TIER_NAME=$APPDYNAMICS_AGENT_TIER_NAME" >> /etc/bashrc
else
    echo "APPDYNAMICS_AGENT_TIER_NAME not set. Using Environment Name."
    echo "APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config container -k environment_name 2>&1)" >> /etc/bashrc
fi

if [[ -v JAVA_OPTS ]]
then
    echo "JAVA_OPTS=$JAVA_OPTS -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_TIER_NAME" >> /etc/bashrc
else
    echo "JAVA_OPTS not set. Exiting."
    exit 1
fi

exit 0