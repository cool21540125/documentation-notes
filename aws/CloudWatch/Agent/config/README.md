# Note

- [CloudWatch Agent 的配置檔寫法](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)
- [Linux 及 macOS 可被 CloudWatch Agent 搜集的 metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html#linux-metrics-enabled-by-CloudWatch-agent)
- [CloudWatch agent files and locations](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/troubleshooting-CloudWatch-Agent.html#CloudWatch-Agent-files-and-locations)

> Linux 內部, 安裝完 CloudWatch Unified Agent 以後的路徑結構 & 檔案用途
>
> /opt/aws/amazon-cloudwatch-agent/

# 相關路徑

| Path                                    | Usage                                                                  |
| --------------------------------------- | ---------------------------------------------------------------------- |
| bin/amazon-cloudwatch-agent-ctl         | 用來 start/stop CW Agent 的 CLI                                        |
| logs/amazon-cloudwatch-agent.log        | CW Agent Logs                                                          |
| logs/configuration-validation.log       | CW Agent validation logs                                               |
| bin/config.json                         | 如果使用 `bin/amazon-cloudwatch-agent-config-wizard` 預設生成的 config |
| etc/amazon-cloudwatch-agent.json        | 如果使用 Parameter Store 用來配置 CW Agent 使用                        |
| etc/amazon-cloudwatch-agent.toml        | **不要修改它** 此為 amazon-cloudwatch-agent-ctl 自動生成               |
| etc/amazon-cloudwatch-agent.yaml        | **不要修改它** 此為 amazon-cloudwatch-agent-ctl 自動生成               |
| etc/common-config.toml                  | 用來覆寫 system default 的 Region 及 credential information            |
| etc/env-config.json                     |
| doc/amazon-cloudwatch-agent-schema.json | CW Agent Configuration File 的 Schema Definition (上千行的結構定義檔)  |
| etc/amazon-cloudwatch-agent.json        | 如果監控情境並非非常 Customerized 的話, 配置檔直接放這邊來做使用吧!!   |
| etc/amazon-cloudwatch-agent.d/\*.json   | 如果監控情境很 Customerized 的話, 在使用到這邊                         |

CloudWatch Unified Agent 的 configs:

- agent_config_agent.jsonc
- agent_config_logs.jsonc
- agent_config_metrics.jsonc
- agent_config_traces.jsonc
