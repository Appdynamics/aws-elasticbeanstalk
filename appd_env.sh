export APPDYNAMICS_CONTROLLER_HOST_NAME=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_HOST_NAME)
export APPDYNAMICS_CONTROLLER_PORT=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_PORT)
export APPDYNAMICS_CONTROLLER_SSL_ENABLED=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_CONTROLLER_SSL_ENABLED)
export APPDYNAMICS_AGENT_ACCOUNT_NAME=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_NAME)
export APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY)
export APPDYNAMICS_AGENT_APPLICATION_NAME=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_AGENT_APPLICATION_NAME)
export APPDYNAMICS_AGENT_TIER_NAME=$(sudo /opt/elasticbeanstalk/bin/get-config container -k environment_name)
export APPDYNAMICS_SIM_ENABLED=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k APPDYNAMICS_SIM_ENABLED)

JAVA_OPTS=$(sudo /opt/elasticbeanstalk/bin/get-config environment -k JAVA_OPTS)
export JAVA_OPTS="$JAVA_OPTS -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=$APPDYNAMICS_AGENT_TIER_NAME"
