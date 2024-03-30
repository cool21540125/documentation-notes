
# Lambda - SQS

- https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html
- Lambda 會 **批次調用** SQS Queue 裡頭的 messages 來做執行, 然而如果其中一個 message 發生錯誤, 會被整批放回 SQS Queue
    - Lambda Function 需要自行處理 idempotent
    - 


# Lambda

- https://docs.aws.amazon.com/lambda/latest/api/API_Invoke.html
- 調用 Lambda Function 可採用:
    - 同步調用: InvocationType 為 RequestResponse (此情境才會有 context)
    - 異步調用: InvocationType 為 Event