#!/bin/bash
exit 0
#
# Create the CloudWatch agent configuration file
#     https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html
#
# Metrics collected by the CloudWatch agent
#     https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html
#
# Install CloudWatch unified Agent
#     https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
#
# -------------------------------------------------------------------------------------------------------------------

### ================================= 版本 =================================
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent --version
#CWAgent/1.300041.0b681 (go1.22.3; linux; amd64)

### ================================= 初始化 Configuration =================================
### ------------------------ 法1. 使用 Wizard ------------------------
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# CloudWatch Unified Agent 其中有一段會詢問使用 Basic/Standard/Advanced
# Basic: 包含了 memory 及 disk
# Standard: 額外增加 cpu idle/iowait... && diskio... && swap
# Advanced: 額外增加 netstat && disk io bytes
#
# 完成後, CloudWatch Agent Configuration file 會放到:
#/opt/aws/amazon-cloudwatch-agent/bin/config.json
#
### ------------------------ 法2. Manually ------------------------
# (放棄吧~~~ 使用 wizard, 世界更廣闊~~)
#

### ================================= 資料位置 =================================

cd /opt/aws/amazon-cloudwatch-agent/etc
sudo vim /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/*

cd /opt/aws/amazon-cloudwatch-agent/logs
tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log # logs

### ================================= CloudWatch Agentd 程序操作 =================================
# 啟動 CloudWatch Unified Agent (必須要有 Configuration)

sudo systemctl start amazon-cloudwatch-agent.service
sudo systemctl stop amazon-cloudwatch-agent.service

sudo systemctl enable amazon-cloudwatch-agent.service

sudo systemctl restart amazon-cloudwatch-agent.service

systemctl status amazon-cloudwatch-agent.service
ps aux | grep -v grep | grep "USER\|amazon-cloudwatch-agent"

### 啟動服務 (並生成 systemd service)
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux
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

### =================================  =================================
