#TODO
#Clean /etc/environment

APPDYNAMICS_CONTROLLER_HOST_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_HOST_NAME 2>&1)
APPDYNAMICS_CONTROLLER_PORT=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_PORT 2>&1)
APPDYNAMICS_CONTROLLER_SSL_ENABLED=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_SSL_ENABLED 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_NAME 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY 2>&1)
APPDYNAMICS_AGENT_APPLICATION_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_APPLICATION_NAME 2>&1)
APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_TIER_NAME 2>&1)

if [ -n "${APPDYNAMICS_CONTROLLER_HOST_NAME:+1}" ]
then
    echo "APPDYNAMICS_CONTROLLER_HOST_NAME=$APPDYNAMICS_CONTROLLER_HOST_NAME" >> /etc/environment
    echo "export APPDYNAMICS_CONTROLLER_HOST_NAME=$APPDYNAMICS_CONTROLLER_HOST_NAME" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_CONTROLLER_HOST_NAME not set. Exiting."
    exit 1
fi

if [ -n "${APPDYNAMICS_CONTROLLER_PORT:+1}" ]
then
    echo "APPDYNAMICS_CONTROLLER_PORT=$APPDYNAMICS_CONTROLLER_PORT" >> /etc/environment
    echo "export APPDYNAMICS_CONTROLLER_PORT=$APPDYNAMICS_CONTROLLER_PORT" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_CONTROLLER_PORT not set. Exiting."
    exit 1
fi

if [ -n "${APPDYNAMICS_CONTROLLER_SSL_ENABLED:+1}" ]
then
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=$APPDYNAMICS_CONTROLLER_SSL_ENABLED" >> /etc/environment
    echo "export APPDYNAMICS_CONTROLLER_SSL_ENABLED=$APPDYNAMICS_CONTROLLER_SSL_ENABLED" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED not set. It will default to false."
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=false" >> /etc/environment
    echo "export APPDYNAMICS_CONTROLLER_SSL_ENABLED=false" >> /etc/profile.d/appd_profile.sh
fi

if [ -n "${APPDYNAMICS_AGENT_ACCOUNT_NAME:+1}" ]
then
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME not set. It will default to customer1."
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1" >> /etc/profile.d/appd_profile.sh
fi

if [ -n "${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY:+1}" ]
then
    echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY not set. Exiting."
    exit 1
fi

if [ -n "${APPDYNAMICS_AGENT_APPLICATION_NAME:+1}" ]
then
    echo "APPDYNAMICS_AGENT_APPLICATION_NAME=$APPDYNAMICS_AGENT_APPLICATION_NAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_APPLICATION_NAME=$APPDYNAMICS_AGENT_APPLICATION_NAME" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_AGENT_APPLICATION_NAME not set. Exiting."
    exit 1
fi

if [ -n "${APPDYNAMICS_AGENT_TIER_NAME:+1}" ]
then
    echo "APPDYNAMICS_AGENT_TIER_NAME=$APPDYNAMICS_AGENT_TIER_NAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_APPLICATION_NAME=$APPDYNAMICS_AGENT_APPLICATION_NAME" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_AGENT_TIER_NAME not set. Using Environment Name."
    APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config container -k environment_name 2>&1)
    echo "APPDYNAMICS_AGENT_TIER_NAME=$APPDYNAMICS_AGENT_TIER_NAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_TIER_NAME=$APPDYNAMICS_AGENT_TIER_NAME" >> /etc/profile.d/appd_profile.sh
fi

sed -i "s@\(.*java \)\(.*\)@\1-javaagent:/opt/appdynamics/appagent/javaagent.jar -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_TIER_NAME -Dappdynamics.agent.tierName=$APPDYNAMICS_AGENT_TIER_NAME \2@" /var/elasticbeanstalk/staging/supervisor/application.conf

exit 0
