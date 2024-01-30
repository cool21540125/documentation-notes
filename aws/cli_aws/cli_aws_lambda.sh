#!/bin/bash
# AWS CLI for Lambda
exit 0
# ----------------------------

export AWS_ACCESS_KEY_ID=

export AWS_REGION=ap-northeast-1

# ----------------------------

API_URL=$(aws cloudformation describe-stacks --stack-name ${CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldApi`].OutputValue' --output text)
LAMBDA_ARN=$(aws cloudformation describe-stacks --stack-name ${CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldFunction`].OutputValue' --output text)
echo API_URL=$API_URL
echo LAMBDA_ARN=$LAMBDA_ARN


### invoke lambda with event
aws lambda invoke --function-name $LAMBDA_ARN --payload '{}' --output json result.json


### list lambda functions
aws lambda list-functions
aws lambda list-functions --region ${AWS_REGION}


### invoke Lambda Function
# 必要參數為 --function-name 及 OutFile(response.json)
aws lambda invoke --function-name ${LAMBDA_FUNCTION_NAME} \
    --cli-binary-format raw-in-base64-out \
    --payload '{"key1": "value1", "key2": "value2", "key3": "value3" }' \
    --region ${AWS_REGION} \
    response.json
#(Terminal Print)
#{
#    "StatusCode": 200,
#    "ExecutedVersion": "$LATEST"
#}
# Out file "response.json" (local dir 會出現這個檔案)

cat response.json
#{"statusCode": 200, "body": "Server 回覆的 Response Body", "headers": {"Content-Type": "application/json"}}


### 


### ========================================================================================

### 建立 Lambda Function (using zip)
zip -r function.zip .
# 

aws lambda create-function \
    --zip-file fileb://function.zip \
    --function-name ${LAMBDA_FUNCTION_NAME} \
    --runtime ${RUN_TIME} \
    --handler index.handler \
    --role arn:aws:iam::${AWS_ACCESS_KEY_ID}:role/${ROLE_NAME}
# Role 必須要是先建立完畢, 基本上必須要有 AWSLambdaBasicExecutionRole
# handler 的 index.handler 意思是, Lambda FN 的 entrypoint 是從 index.js 這檔案的 handler 這個 Function 去做調用


### ========================================================================================
