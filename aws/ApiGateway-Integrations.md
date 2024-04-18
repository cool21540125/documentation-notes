
# Api Gateway Integration

- Lambda proxy integration
  - 有啟用 Lambda proxy integration
    - Lambda 收到的 event format 可參考: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
    - Lambda Function 回傳給 RestApi Gateway 的 Integration Response format 可參考: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format
  - 沒啟用 Lambda proxy integration
    - Lambda Function 收到的 event, 等同於 發送到 RestApi Gateway 的 Request Body
