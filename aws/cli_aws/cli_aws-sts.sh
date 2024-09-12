#!/bin/bash
exit 0
# --------------------------------------------------------------

### assume-role
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/assume-role.html
ROLE_ARN=
creds=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name demo_role_session --no-cli-pager)
export AWS_ACCESS_KEY_ID=$(echo $creds | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $creds | jq -r '.Credentials.SessionToken')
# 如此一來就換成不同的 Role 了~ (使用 `aws sts get-caller-identity --no-cli-pager` 做驗證)

###
