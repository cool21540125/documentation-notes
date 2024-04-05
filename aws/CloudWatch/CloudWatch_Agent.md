
# CloudWatch Agents - CloudWatch Unified Agent


```bash
### Install CloudWatch unified Agent
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html 
sudo yum install amazon-cloudwatch-agent
systemctl start  amazon-cloudwatch-agent
systemctl enable  amazon-cloudwatch-agent


### Configuration
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html


### Trigger event
### 觸發 alarm (debug 使用)
aws cloudwatch set-alarm-state xxx
```


# OLD - CloudWatch Agent

install CloudWatch Agent

2024 的現在, 別用它了~~
