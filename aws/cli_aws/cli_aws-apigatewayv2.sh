#!/bin/bash
exit 0
#
# 不曉得這個 apigatewayv2 和 apigateway 到底差在哪邊 =..=
# 似乎 v2 是用來作 HTTPApi Gateway?
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/apigatewayv2/index.html
#
# --------------------------------------------------------------------

### HTTP APIs VPC links
aws apigatewayv2 get-vpc-links
# (目前公司有 3 個 HTTP Api - VPC links, 但好像沒在使用)

### 建立 Http Api
aws apigatewayv2 create-api --name manual --protocol-type HTTP --target arn:aws:lambda:${AWS_REGION}:${AWS_ACCOUNT_ID}:function:${FUNCTION_NAME}

### 列出 Api Mappings
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/apigatewayv2/get-api-mappings.html
# get-api-mappings
DOMAIN=
aws apigatewayv2 get-api-mappings --output json --domain-name $DOMAIN | jq
aws apigatewayv2 get-api-mappings --output json --domain-name $DOMAIN --next-token $TOKEN | jq
