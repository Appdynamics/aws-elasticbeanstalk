#!/bin/bash

# Default Options will be gathered from Elastic Beanstalk
APPDYNAMICS_CONTROLLER_HOST_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_HOST_NAME 2>&1)
APPDYNAMICS_CONTROLLER_PORT=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_PORT 2>&1)
APPDYNAMICS_CONTROLLER_SSL_ENABLED=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_SSL_ENABLED 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_NAME 2>&1)
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY 2>&1)
APPDYNAMICS_AGENT_APPLICATION_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_APPLICATION_NAME 2>&1)
APPDYNAMICS_AGENT_TIER_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_TIER_NAME 2>&1)
APPDYNAMICS_SIM_ENABLED=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_SIM_ENABLED 2>&1)
APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME 2>&1)
APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT 2>&1)
APPDYNAMICS_DEBUG=$(/opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_DEBUG 2>&1)

# Default Error and Success Messages for the Machine Agent
MACHINE_ERROR="WARN ExtensionManager - Failed to start extension ServerMonitoring."
MACHINE_SUCCESS="Started AppDynamics Machine Agent Successfully"

# Deleting any old files
rm -rf /opt/appdynamics > /dev/null 2>&1

# Check and extraction of the Java Agent
if [ -f /tmp/appagent.zip ]
then
    mkdir -p /opt/appdynamics/appagent
    unzip /tmp/appagent.zip -d /opt/appdynamics/appagent/
    chown -R webapp:webapp /opt/appdynamics/appagent
    cp /tmp/appd.sh /opt/appdynamics/appd.sh
    rm -rf /tmp/appagent.zip > /dev/null 2>&1
else
    "AppDynamics App Agent does not exist. Exiting."
    exit 1
fi

# Environment Variable Checks and persistence
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
    if [ "$APPDYNAMICS_CONTROLLER_SSL_ENABLED" == "false" ]
    then
        APPDYNAMICS_CONTROLLER_PROTOCOL="http"
    elif [ "$APPDYNAMICS_CONTROLLER_SSL_ENABLED" == "true" ]
    then
        APPDYNAMICS_CONTROLLER_PROTOCOL="https"
    fi
else
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED not set. It will default to false."
    echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=false" >> /etc/environment
    echo "export APPDYNAMICS_CONTROLLER_SSL_ENABLED=false" >> /etc/profile.d/appd_profile.sh
    APPDYNAMICS_CONTROLLER_PROTOCOL="http"
fi

if [ -n "${APPDYNAMICS_AGENT_ACCOUNT_NAME:+1}" ]
then
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_ACCOUNT_NAME=$APPDYNAMICS_AGENT_ACCOUNT_NAME" >> /etc/profile.d/appd_profile.sh
else
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME not set. It will default to customer1."
    echo "APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1" >> /etc/profile.d/appd_profile.sh
    APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1
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

# App Agent Debug Setting
if [ "$APPDYNAMICS_DEBUG" == "true" ]
then
    find /opt/appdynamics/appagent/ -iname log4j.xml -exec sed -i "s@\"info\"@\"debug\"@" {} \;
fi

# Adding the Java Agent to the Application
sed -i "s@\(.*java \)\(.*\)@\1-javaagent:/opt/appdynamics/appagent/javaagent.jar -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_TIER_NAME -Dappdynamics.agent.tierName=$APPDYNAMICS_AGENT_TIER_NAME \2@" /var/elasticbeanstalk/staging/supervisor/application.conf

if [ -f /tmp/machineagent.zip ]
then
    mkdir -p /opt/appdynamics/machineagent
    unzip /tmp/machineagent.zip -d /opt/appdynamics/machineagent/
    rm -rf /tmp/machineagent.zip > /dev/null 2>&1
    echo "APPDYNAMICS_AGENT_UNIQUE_HOST_ID=$HOSTNAME" >> /etc/environment
    echo "export APPDYNAMICS_AGENT_UNIQUE_HOST_ID=$HOSTNAME" >> /etc/profile.d/appd_profile.sh
    echo "APPDYNAMICS_MACHINE_HIERARCHY_PATH=\"$APPDYNAMICS_AGENT_TIER_NAME|\""
    echo "export APPDYNAMICS_MACHINE_HIERARCHY_PATH=\"$APPDYNAMICS_AGENT_TIER_NAME|\"" >> /etc/profile.d/appd_profile.sh
    if [ -n "${APPDYNAMICS_SIM_ENABLED:+1}" ]
    then
        echo "APPDYNAMICS_SIM_ENABLED=$APPDYNAMICS_SIM_ENABLED" >> /etc/environment
        echo "export APPDYNAMICS_SIM_ENABLED=$APPDYNAMICS_SIM_ENABLED" >> /etc/profile.d/appd_profile.sh
    else
        echo "APPDYNAMICS_SIM_ENABLED not set. Default to false."
        echo "APPDYNAMICS_SIM_ENABLED=false" >> /etc/environment
        echo "export APPDYNAMICS_SIM_ENABLED=false" >> /etc/profile.d/appd_profile.sh
    fi

    # Creation of an intermediate Script that takes care of the Machine Agent Startup
    echo "#!/bin/bash

    function checkError {
        sleep 480
        if [[ ! \$(grep \"$MACHINE_ERROR\" \"/opt/appdynamics/machineagent/logs/machine-agent.log\") ]] && [[ \$(grep \"$MACHINE_SUCCESS\" \"/opt/appdynamics/machineagent/logs/machine-agent.log\") ]] && [[ \$(pgrep -f machineagent) -gt 0 ]]
        then
            exit 0
        else
            pkill -f machineagent
            sleep 10
            find /opt/appdynamics/machineagent/ -iname *.log -exec /bin/bash -c \"rm -f {}\" \\;
            find /opt/appdynamics/machineagent/ -iname *.pid -exec /bin/bash -c \"rm -f {}\" \\;
            /opt/appdynamics/machineagent/bin/machine-agent -d -p /opt/appdynamics/machineagent/bin/machine.pid
        fi
    }

    while [[ !(\$(pgrep -f javaagent) -gt 0) ]]
    do
      sleep 20
    done

    source /etc/profile.d/appd_profile.sh
    /opt/appdynamics/machineagent/bin/machine-agent -d -p /opt/appdynamics/machineagent/bin/machine.pid

    while true
    do
      checkError
    done

    exit 0
    " > /opt/appdynamics/appd-machine.sh

    # Making intermediate Script executable
    chmod 755 /opt/appdynamics/appd-machine.sh

    # If the corresponding Environment Variables are set the Analytics Plugin will be enabled by default
    if [ -n "${APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME:+1}" ] && [ -n "${APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT:+1}" ]
    then
        sed -i "s@false@true@" /opt/appdynamics/machineagent/monitors/analytics-agent/monitor.xml
        sed -i "s@analytics-agent1@$APPDYNAMICS_AGENT_TIER_NAME@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
        sed -i "s@http:\/\/localhost:8090@$APPDYNAMICS_CONTROLLER_PROTOCOL:\/\/$APPDYNAMICS_CONTROLLER_HOST_NAME:$APPDYNAMICS_CONTROLLER_PORT@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
        sed -i "s@=customer1@=$APPDYNAMICS_AGENT_ACCOUNT_NAME@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
        sed -i "s@analytics-customer1@$APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
        sed -i "s@your-account-access-key@$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
        sed -i "s@http:\/\/localhost:9080@$APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT@" /opt/appdynamics/machineagent/monitors/analytics-agent/conf/analytics-agent.properties
    else
        echo "AppDynamics Analytics not enabled cause either APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME or APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT is missing."
    fi

    # Machine Agent Debug Setting
    if [ "$APPDYNAMICS_DEBUG" == "true" ]
    then
        find /opt/appdynamics/machineagent/ -iname log4j.xml -exec sed -i "s@\"info\"@\"debug\"@" {} \;
    fi

    /opt/appdynamics/appd-machine.sh < /dev/null &> /dev/null & disown
else
    echo "AppDynamics Machine Agent does not exist. Skipping."
fi

# Making Profile Script executable
chmod 755 /etc/profile.d/appd_profile.sh

exit 0
