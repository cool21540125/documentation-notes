#!/bin/bash
exit 0
#- [Create the CloudWatch agent configuration file](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html)
#- [Metrics collected by the CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html)

# -------------------------------------------------------------------------------------------------------------------

####################################################################################################
# Install CloudWatch unified Agent
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
#
####################################################################################################
sudo yum install amazon-cloudwatch-agent.service
sudo systemctl start amazon-cloudwatch-agent.service
sudo systemctl enable amazon-cloudwatch-agent.service
sudo systemctl restart amazon-cloudwatch-agent.service

systemctl status amazon-cloudwatch-agent.service
ps aux | grep -v grep | grep "USER\|amazon-cloudwatch-agent"

####################################################################################################
# 啟動 CloudWatch Unified Agent (必須要有 Configuration)
####################################################################################################

### 版本驗證
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent --version
#CWAgent/1.300041.0b681 (go1.22.3; linux; amd64)

###
tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log

### =========== 一開始 CloudWatch Unified Agent 安裝完成以後, 並不會有配置檔案 ===========
### 法1. 使用 wizard 生成 default config
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# CloudWatch Unified Agent 其中有一段會詢問使用 Basic/Standard/Advanced
# Basic: 包含了 memory 及 disk
# Standard: 額外增加 cpu idle/iowait... && diskio... && swap
# Advanced: 額外增加 netstat && disk io bytes

### 法2. 使用 manual 方式生成... (比較 hardcode... PASS)
cd /opt/aws/amazon-cloudwatch-agent/

### 啟動服務 (並生成 systemd service)
sudo bin/amazon-cloudwatch-agent-ctl -a stop
sudo bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
# -a ACTION
#    fetch-config: apply config for agent (必須再額外聲明 -c CONFIG_FILE)
#    start
#    stop
#    status
#    append-config
#    remove-config
#
# -m MODE
#    ec2
#    auto
#
# -c CONFIGURATION
#    file:CONFIG_PATH
#    ssm:PARAMETER_STORE_NAME
#
# -s
#    僅適用於 -a [ fetch-config / append-config / remove-config ], 表示套用後重啟 agent

bin/amazon-cloudwatch-agent-ctl -a status
