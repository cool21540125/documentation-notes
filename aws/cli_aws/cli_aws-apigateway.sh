#!/bin/bash
exit 0
#
# 似乎是用來作 RestApi Gateway? (相較於 v2)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/apigateway/index.html
#
# --------------------------------------------------------------------

export AWS_ACCOUNT=
export AWS_PROFILE=
export AWS_REGION=ap-northeast-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

FUNCTION_NAME=manual_demo_with_api_gateway

### ============================== RestApi Gateway 查詢 ==============================
### 列出 RestApi Gateway
aws apigateway get-rest-apis --no-cli-pager

###

curl "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com"

###
