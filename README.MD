# AppDynamics Agent Deployment on AWS Elastic Beanstalk
## Supported Technologies/Agents
| Platform | Application Agent | Machine Agent | Analytics Agent |
|:--------:|:-----------------:|:-------------:|:---------------:|
| Java     | Yes               | Yes           | Yes             |
## Repository Structure
| Folder                                           | Description                                                     |
|--------------------------------------------------|-----------------------------------------------------------------|
| `_common`                                        | Files that span across each platform                            |
| `_common/.ebextensions/nginx`                    | Nginx configuration for the sample application                  |
| `<platform>-(machine)-(analytics)`               | Platform and Agent specific scripts                             |
| `<platform>-(machine)-(analytics)/.ebextensions` | Platform specific AWS Elastic Beanstalk Extension Configuration |
| `<platform>-(machine)-(analytics)/testing`       | Testing Script for Linux                                        |
## Supported Environment Variables
| Variable                              | Description                                                         | Required | Default   |
|---------------------------------------|---------------------------------------------------------------------|----------|-----------|
| APPDYNAMICS_CONTROLLER_HOST_NAME      | [Environment Variables for Agent]                                   | Yes      | N/A       |
| APPDYNAMICS_CONTROLLER_PORT           | [Environment Variables for Agent]                                   | Yes      | N/A       |
| APPDYNAMICS_CONTROLLER_SSL_ENABLED    | [Environment Variables for Agent]                                   | No       | false     |
| APPDYNAMICS_AGENT_ACCOUNT_NAME        | [Environment Variables for Agent]                                   | No       | customer1 |
| APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY  | [Environment Variables for Agent]                                   | Yes      | N/A       |
| APPDYNAMICS_AGENT_APPLICATION_NAME    | [Environment Variables for Agent]                                   | Yes      | N/A       |
| APPDYNAMICS_AGENT_TIER_NAME           | [Environment Variables for Agent]                                   | No       | Env Name  |
| APPDYNAMICS_SIM_ENABLED               | [Environment Variables for Agent]                                   | No       | false     |
| APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME | Setting required for Business iQ. See [Analytics Agent] for details | No       | N/A       |
| APPDYNAMICS_ANALYTICS_EVENT_ENDPOINT  | Setting required for Business iQ. See [Analytics Agent] for details | No       | N/A       |
| APPDYNAMICS_DEBUG                     | Will set the Agents Logging Level to Debug if true                  | No       | N/A       |
## Sample Deployment
### Linux using Testing Script
* Make sure you have `git` and `eb` (Elastic Beanstalk CLI) installed
* Clone this Repository `git clone https://github.com/michaelenglert/aws-elasticbeanstalk.git`
* Navigate to the Agent Combination you want to test `cd ./aws-elasticbeanstalk/<platform>-(machine)-(analytics)/testing`
* Execute the `test.sh` script with the corresponding options
  * e.g. `./test.sh -a <APP_NAME> -b <BASE_DIR> -e <ENV_NAME> -r <AWS_REGION> -i <AWS_INSTANCE_TYPE> -c <APPDYNAMICS_CONTROLLER_HOST_NAME> -p <APPDYNAMICS_CONTROLLER_PROTOCOL> -K <APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY>`
  * The script will prompt if you forget to specify all required options
  * You can display the Usage Info by `./test.sh -h`

### Screenshots
* Sample Application UI
![Sample Application UI](screenshots/java_sample_app.png)
* Elastic Beanstalk UI
![Elastic Beanstalk UI](screenshots/java_sample_app_eb_console.png)
* AppDynamics Flowmap
![AppDynamics Flowmap](screenshots/java_sample_app_appd_flowmap.png)
* AppDynamics Server Visibility
![AppDynamics Server Visibility](screenshots/java_sample_app_appd_server.png)
* AppDynamics Analytics Agent
![AppDynamics Analytics Agent](screenshots/java_sample_app_appd_analytics.png)
## Important Notes
* There is a delay of the Machine Agent Startup, so give it some time.

[Environment Variables for Agent]: https://docs.appdynamics.com/display/latest/Use+Environment+Variables+for+Java+Agent+Settings
[Analytics Agent]: https://docs.appdynamics.com/display/latest/Installing+Agent-Side+Components#InstallingAgent-SideComponents-InstallAnalyticsAgentonLinux
