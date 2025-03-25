# Api Gateway Integration

- [How does Amazon API Gateway support OpenAPI?](https://www.serverlessguru.com/blog/a-deep-dive-into-openapi-and-amazon-api-gateway)

- Lambda proxy integration

  - 有啟用 Lambda proxy integration
    - Lambda 收到的 event format 可參考: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
    - Lambda Function 回傳給 RestApi Gateway 的 Integration Response format 可參考: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format
  - 沒啟用 Lambda proxy integration
    - Lambda Function 收到的 event, 等同於 發送到 RestApi Gateway 的 Request Body

- ApiGateway - HTTP
  - 支援了底下整合:
    - Lambda Proxy Integration
    - HTTP Proxy Integration
- ApiGateway - REST
  - 可以在 Lambda 處理前後, 修改資料內容(做資料轉換啦), 不過需要額外學 VTL
  - 支援了底下整合:
    - Lambda Proxy Integration
    - non-Lambda Proxy Integration
    - Custom Integration
- ApiGateway Extensions to OpenAPI
  - ApiGateway extensions 都以: `"x-amazon-apigateway-"` 作為開頭
  - 目前支援的 extensions[OpenAPI extensions for API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions.html)
- ApiGateway 若使用 LambdaFunction 作為 Backend(無論是否有 proxy-integration), 各種 extensions 有不同用途:
  - `x-amazon-apigateway-integration` : OpenAPI
  - `x-amazon-apigateway-authorizer` : 用來定義 Lambda authorizer, 與 Cognito user pool / JWT authorizer(like OAuth) 整合使用
