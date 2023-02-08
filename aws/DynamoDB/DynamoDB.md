
# DynamoDB Common

- [What is Amazon DynamoDB?](https://docs.amazonaws.cn/en_us/amazondynamodb/latest/developerguide/Introduction.html)
- [CLF-DynamoDB](./cert-CLF_C01.md#dynamodb)
- 摘要特色:
    - Operations
        - Serverless -> 無需 operations
        - Auto Scaling
    - Security
        - IAM Policy
        - KMS encryption
        - SSL in flight
    - Reliability
        - Multi AZ, Backups
    - Performance
        - 毫秒等級 latency
        - 若要 caching, 可搭配 DynamoDB Accelerator, DAX
    - Cost
        - Pay for usage
- Table Classes:
    - Standard
    - Infrequent Access, IA
- store documents, key-value
    - max: 一筆 400 KB
    - 可配置 `Read Capacity Unit, RCU` && `Write Capacity Unit, WCU`
- 常見查詢
    - Scan
        - 應盡可能地避免, 因為會把 all data in Table 全部跑過 (耗費大量 RCU)
            - 即使使用了 FilterExpression 也一樣
            - 等同於 `SELECT * FROM <table> WHERE xxx`, 不過一樣會把 all records 全掃過
        - 如果真的逼不得已, 像是 BatchJob (需要定期把所有 data 全跑過)
            - 可參考 parallel scans using multi-threading (可加速作業)
        - 一次只能回傳 1 MB (需要 pagination)
    - Query
        - 可藉由使用 Partition Key 或 Partition Key + Range Key 來做查詢
            - 藉由使用 RangeKey 的 **ConditionExpressions** 做進一步過濾
        - 如果要查詢特定 Range Key, 但是不知道 Partition Key, 則需要借助 GSI
        - Performance 為 O(1)
    - GetItem API
- 多人同時寫入的問題
    - 如果發生 multiple users 同時寫入到 DynamoDB
        - 預設寫入 DynamoDB(`PutItem`, `UpdateItem`, `DeleteItem`) 為 unconditional 操作
        - 不過, DynamoDB 提供了 `Conditional Writes` 的操作
- 名詞解釋
    - FilterExpression
        - If you need to further refine the Query results, you can optionally provide a filter expression. A filter expression determines which items within the Query results should be returned to you. All of the other results are discarded.
    - [ProjectionExpression](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ProjectionExpressions.html)
        - To read data from a table, you use operations such as GetItem, Query, or Scan. Amazon DynamoDB returns all the item attributes by default. To get only some, rather than all of the attributes, use a projection expression.

# DynamoDB Streams


# Local DynamoDB

- [Setting up DynamoDB local (downloadable version)](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
    - [跑容器化吧](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html#docker)
- [NoSQL Workbench for DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html)
