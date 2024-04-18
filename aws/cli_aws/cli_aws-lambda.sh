#!/bin/bash
exit 0
# ----------------------------

### ======================== Easy Usage 不解釋 ========================
aws lambda list-functions --region $AWS_REGION


### ======================== 調用 ========================
### ------ 同步調用 ------
aws lambda invoke \
  --invocation-type RequestResponse \
  --function-name $FUNCTION_NAME \
  --payload 'PAYLOAD_JSON_STRING' \
  --region $AWS_REGION \
  --output json \
  response.json
# --invocation-type RequestResponse 此為預設
# --invocation-type 可以是: RequestResponse(default) | Event | DryRun(僅測試是否有權限)
#(Terminal Print)
#{
#    "StatusCode": 200,
#    "ExecutedVersion": "$LATEST"
#}
# Out file "response.json" (local dir 會出現這個檔案)
cat response.json
#{"statusCode": 200, "body": "Server 回覆的 Response Body", "headers": {"Content-Type": "application/json"}}

### ------ 異步調用 ------
aws lambda invoke \
  --function-name FUNCTION_NAME \
  --invocation-type Event \
  --payload '{"x": 3, "y": "SSS"}' /dev/stdout


### ========================================================================================

### ------ 建立 Lambda Function using Zip ------
zip -r function.zip .

aws lambda create-function \
  --zip-file fileb://function.zip \
  --function-name $LAMBDA_FUNCTION_NAME \
  --runtime $RUN_TIME \
  --handler index.handler \
  --role arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME
# Role 必須要是先建立完畢, 基本上必須要有 AWSLambdaBasicExecutionRole
# handler 的 index.handler 意思是, Lambda FN 的 entrypoint 是從 index.js 這檔案的 handler 這個 Function 去做調用

### ========================================================================================

### 授權給 Api Gateway 不同的 Stage 可以調用 Lambda Function
aws lambda add-permission \
  --function-name "arn:aws:lambda:$REGION:$ACCOUNT_ID:$LAMBDA_FUNCTION:$STAGE_NAME" \
  --source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$RANDOM/*/GET/stagevariables" \
  --principal apigateway.amazonaws.com \
  --statement-id 2340e3db-3f45-4bdd-bc6c-2c06ffceef8b \
  --action lambda:InvokeFunction
# (然後我忘了上面的 --statement-id 是從哪邊來的了=.=)
# stagevariables 則是在 Api Gateway 上面設定的, 細節我也忘了

### ========================================================================================

### Source Mapping (忘了在幹嘛)
aws lambda create-event-source-mapping \
  --function-name $FUNCTION_NAME \
  --batch-size 500 \
  --maximum-batching-window-in-seconds 5 \
  --starting-position LATEST \
  --event-source-arn $DynamoDB_Stream_ARN
