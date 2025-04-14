#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

### 使用 CLI 運行 RunCommand 安裝 CloudWatch Agent (並且使用已有的 SSM Paramater)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ssm/send-command.html
INSTANCE_ID=

#
### ==================================================== 使用 SSM 操作 CloudWatch Agent ====================================================
#
### 使用 CLI 運行 RunCommand 安裝 CloudWatch Agent
aws ssm send-command \
  --document-name "AWS-ConfigureAWSPackage" \
  --document-version "1" \
  --parameters '{"action":["Install"],"installationType":["Uninstall and reinstall"],"version":[""],"additionalArguments":["{}"],"name":["AmazonCloudWatchAgent"]}'

### 使用 CLI 運行 RunCommand, 使用 SSM Parameter 上頭的 Agent Configuration
SSM_PARAMETER_FOR_CW_AGENT_NAME="AmazonCloudWatch-linux"
aws ssm send-command \
  --document-name "AmazonCloudWatch-ManageAgent" \
  --document-version "11" \
  --targets "[{\"Key\":\"InstanceIds\",\"Values\":[\"$INSTANCE_ID\"]}]" \
  --parameters "{\"action\":[\"configure\"],\"mode\":[\"ec2\"],\"optionalConfigurationSource\":[\"ssm\"],\"optionalConfigurationLocation\":[\"$SSM_PARAMETER_FOR_CW_AGENT_NAME\"],\"optionalRestart\":[\"yes\"]}"

### 更新 CloudWatch Agent (基本上不需要跑這個... 可以配置讓它定期自動更新)
aws ssm send-command \
  --document-name "AWS-UpdateSSMAgent" \
  --document-version "1" \
  --targets "[{\"Key\":\"InstanceIds\",\"Values\":[\"$INSTANCE_ID\"]}]" \
  --parameters '{"version":[""],"allowDowngrade":["false"]}'

#
### ====================================================  ====================================================
#
