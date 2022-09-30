

# Aliases & Versions

- 假設現在寫了一個 Lambda Function, 名為 「demo-lambda」, 然後發佈了 3 個 Versions
- Lambda Console
    - 然後希望有不同的 Aliases 指向不同的 Versions, 如下:
        - DEV  -> version: $LATEST
        - TEST -> version: 2
        - PROD -> version: 1
    - 上述動作在 Lambda 分別 Deploy 完成後, 建立他們的 Versions, 並將 Aliases 指向對應 Versions
- API Gateway Console
    - 之後發布 API Gateway, 希望有 3 個 Stages, 指向 3 個 Lambda Aliases, 如下:
        - dev -> DEV stage
        - test -> test stage
        - prod -> prod stage
    - 在 API Gateway > Resources > ${LOCATION} > ${METHOD} > Lambda Function 裡頭
        - 輸入 `demo-lambda:${stageVariables.YOUR_STAGE_NAME}`
        - 會被告知, 因為並沒有一個 Lambda 叫做上面這樣的名字, 因此需要分別賦予給 3 個 Lambda 的 execution role 給這個 API Gateway
        - 因此需要執行下面 AWS CLI(或其他方式, 來做授權)
- AWS CLI
    ```bash
    ### function:dva-apigw-lambda0928:XXXX
    $# $ aws lambda add-permission \
        --function-name "arn:aws:lambda:ap-northeast-1:${ACCOUNT_ID}:function:dva-apigw-lambda0928:DEV" \
        --source-arn "arn:aws:execute-api:ap-northeast-1:${ACCOUNT_ID}:${RANDOM}/*/GET/stagevariables" \
        --principal apigateway.amazonaws.com \
        --statement-id 2340e3db-3f45-4bdd-bc6c-2c06ffceef8b \
        --action lambda:InvokeFunction

    $# $ aws lambda add-permission \
        --function-name "arn:aws:lambda:ap-northeast-1:${ACCOUNT_ID}:function:dva-apigw-lambda0928:TEST" \
        --source-arn "arn:aws:execute-api:ap-northeast-1:${ACCOUNT_ID}:${RANDOM}/*/GET/stagevariables" \
        --principal apigateway.amazonaws.com \
        --statement-id 2340e3db-3f45-4bdd-bc6c-2c06ffceef8b \
        --action lambda:InvokeFunction

    $# $ aws lambda add-permission \
        --function-name "arn:aws:lambda:ap-northeast-1:${ACCOUNT_ID}:function:dva-apigw-lambda0928:PROD" \
        --source-arn "arn:aws:execute-api:ap-northeast-1:${ACCOUNT_ID}:${RANDOM}/*/GET/stagevariables" \
        --principal apigateway.amazonaws.com \
        --statement-id 2340e3db-3f45-4bdd-bc6c-2c06ffceef8b \
        --action lambda:InvokeFunction
    ```
- API Gateway
    - Resources > Actions > Deploy API > 分別發布 dev/test/prod
    - Stages > 分別編輯 dev/test/prod > Stage Variables > Add Stage Variable
        - Name: lambdaAlias
        - Value: 分別輸入 DEV/TEST/PROD
    - 屆時訪問時的 URL 如下:
        - https://${RANDOM}.execute-api.ap-northeast-1.amazonaws.com/dev/stagevariables
        - https://${RANDOM}.execute-api.ap-northeast-1.amazonaws.com/test/stagevariables
        - https://${RANDOM}.execute-api.ap-northeast-1.amazonaws.com/prod/stagevariables