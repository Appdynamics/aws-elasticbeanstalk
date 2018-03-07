# AppDynamics Agent Deployment on AWS Elastic Beanstalk
## Supported Technologies/Agents
| Platform | Application Agent | Machine Agent | Analytics Agent |
|:--------:|:-----------------:|:-------------:|:---------------:|
| Java     | Yes               | Yes           | WIP             |
## Repository Structure
| Folder                                           | Description                                                     |
|--------------------------------------------------|-----------------------------------------------------------------|
| `_common`                                        | Files that span across each platform                            |
| `_common/.ebextensions/nginx`                    | Nginx configuration for the sample application                  |
| `<platform>-(machine)-(analytics)`               | Platform and Agent specific scripts                             |
| `<platform>-(machine)-(analytics)/.ebextensions` | Platform specific AWS Elastic Beanstalk Extension Configuration |
| `<platform>-(machine)-(analytics)/testing`       | Testing Script                                                  |
## Sample App Deployment
