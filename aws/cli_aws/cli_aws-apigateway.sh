#!/bin/bash
exit 0
# -----------------

export AWS_ACCOUNT=
export AWS_PROFILE=
export AWS_REGION=ap-northeast-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

FUNCTION_NAME=manual_demo_with_api_gateway

### 建立 Http Api
aws apigatewayv2 create-api --name manual --protocol-type HTTP --target arn:aws:lambda:${AWS_REGION}:${AWS_ACCOUNT_ID}:function:${FUNCTION_NAME}

curl "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com"

### 
