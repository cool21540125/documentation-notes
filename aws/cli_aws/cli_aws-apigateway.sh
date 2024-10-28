#!/bin/bash
exit 0
# -----------------

export AWS_ACCOUNT=
export AWS_PROFILE=
export AWS_REGION=ap-northeast-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

FUNCTION_NAME=manual_demo_with_api_gateway

### list api-gateways
aws apigateway get-rest-apis --no-cli-pager

### 建立 Http Api
aws apigatewayv2 create-api --name manual --protocol-type HTTP --target arn:aws:lambda:${AWS_REGION}:${AWS_ACCOUNT_ID}:function:${FUNCTION_NAME}

curl "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com"

### 列出 Api Mappings
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/apigatewayv2/get-api-mappings.html
# get-api-mappings
DOMAIN=
aws apigatewayv2 get-api-mappings --output json --domain-name $DOMAIN | jq
aws apigatewayv2 get-api-mappings --output json --domain-name $DOMAIN --next-token $TOKEN | jq

###
