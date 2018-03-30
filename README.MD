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
## Java Platform
### Supported Environment Variables
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
## Important Notes
There is a significant delay of the Machine Agent Startup (10 minutes by default). This is used to give the Instance some startup time.

[Environment Variables for Agent]: https://docs.appdynamics.com/display/latest/Use+Environment+Variables+for+Java+Agent+Settings
[Analytics Agent]: https://docs.appdynamics.com/display/latest/Installing+Agent-Side+Components#InstallingAgent-SideComponents-InstallAnalyticsAgentonLinux
