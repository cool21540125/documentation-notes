#!/bin/bash
exit 0
#
# 用途: 很類似於 SSH Tunnel, 可以訪問 VPC 內部
#
# Install the Session Manager plugin on macOS
#    https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-macos-overview.html
#
# --------------------------------------------------------------------------------------------------------------

### ==================================== 安裝 & 驗證 ====================================
## 安裝 Session Manager plugin
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg" -o "session-manager-plugin.pkg"
sudo installer -pkg session-manager-plugin.pkg -target /
sudo ln -s /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin


## 安裝完畢以後驗證
session-manager-plugin
#The Session Manager plugin is installed successfully. Use the AWS CLI to start a session.

### ==================================== 使用 ====================================

## 首先, 建立 Session
EC2_INSTANCE_ID=
aws ssm start-session --target ${EC2_INSTANCE_ID_}
#Starting session with SessionId: tony-vyiz6uyq2nlo8x6hpt4tjp2npb
# 看到這個的話, 表示 plugin + SSM agent + IAM + 網路 -- OK

## UseCase: 直接 Tunnel EC2 上頭的 MySQL
aws ssm start-session \
  --target ${EC2_INSTANCE_ID} \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3306"],"localPortNumber":["54088"]}'

## UseCase: Tunnel RDS MySQL -- 本地 54088 到遠端 3306
RDS_ENDPOINT=
aws ssm start-session \
  --target ${EC2_INSTANCE_ID} \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters host="${RDS_ENDPOINT}",portNumber="3306",localPortNumber="54088" \
  --region $AWS_REGION
#Starting session with SessionId: tony-njj3pqjz7xn6ninpkjqbaqq9ou
#Port 54088 opened for sessionId tony-njj3pqjz7xn6ninpkjqbaqq9ou.
#Waiting for connections...


## UseCase: Tunnel to ECS 12345 port
