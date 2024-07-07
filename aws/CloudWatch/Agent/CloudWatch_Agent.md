
# CloudWatch Agents - CloudWatch Unified Agent

前身為 `CloudWatch Agent` (別用它了)


```bash
### Install CloudWatch unified Agent
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html 
sudo yum install amazon-cloudwatch-agent.service
sudo systemctl start  amazon-cloudwatch-agent.service
sudo systemctl enable  amazon-cloudwatch-agent.service
sudo systemctl restart  amazon-cloudwatch-agent.service
systemctl status amazon-cloudwatch-agent.service

### Configuration
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html


### Trigger event
### 觸發 alarm (debug 使用)
aws cloudwatch set-alarm-state xxx
```


# CloudWatch Unified Agent - 配置檔

- [Wizard 細節](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html)
- [CW Agent metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html)

```bash
### 版本驗證
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent --version
#CWAgent/1.300041.0b681 (go1.22.3; linux; amd64)


### =========== 一開始 CloudWatch Unified Agent 安裝完成以後, 並不會有配置檔案 ===========
### 法1. 使用 wizard 生成 default config
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# CloudWatch Unified Agent 其中有一段會詢問使用 Basic/Standard/Advanced
# Basic: 包含了 memory 及 disk
# Standard: 額外增加 cpu idle/iowait... && diskio... && swap
# Advanced: 額外增加 netstat && disk io bytes


### 法2. 使用 manual 方式生成... (比較 hardcode... PASS)

```


# 啟動 CloudWatch Unified Agent

```bash
### 啟動 CloudWatch Unified Agent (必須要有 config)
cd /opt/aws/amazon-cloudwatch-agent/
bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json


bin/amazon-cloudwatch-agent-ctl -a status

systemctl status amazon-cloudwatch-agent.service
```