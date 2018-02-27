#!/bin/bash

while [[ !($(pgrep -f javaagent) -gt 0) ]]
do
  sleep 10
done

sleep 60

source /etc/profile.d/appd_profile.sh
/opt/appdynamics/machineagent/bin/machine-agent -d -p /opt/appdynamics/machineagent/bin/machine.pid

exit 0
