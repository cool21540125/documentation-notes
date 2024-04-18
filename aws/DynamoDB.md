
# [DynamoDB](https://docs.amazonaws.cn/en_us/amazondynamodb/latest/developerguide/Introduction.html)


- Performance
    - 毫秒等級 latency
        - single digit millsecond performance
    - 若要 caching, 可搭配 DynamoDB Accelerator, DAX
        - DynamoDB 專用的快取
        - DynamoDB fully managed in-memory cache
        - 10x performance improvement
- Cost
    - 儲存容量計費
    - 流量計費
    - WCU & RCU 計費

---

Cost                  | RCU               | WCU
--------------------- | ----------------- | ---------------
Eventually consistent | 8 KB / per unit   | 1 KB / per unit
Strongly consistent   | 4 KB / per unit   | 1 KB / per unit
Transactional request | 4 KB / per 2 unit | 1 KB / per 2 unit

---


- Table Class 分成 2 種:
    - Standard Table Class
    - Infrequent Access(IA) Table Class
- store documents, key-value
    - max: 一筆 400 KB
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
- RCU(Read Capacity Unit)
    - 1 單位的 RCU, 表示每秒鐘的讀取量能為:
        - Strongly consistent   讀取 1 個 4 KB 物件
        - Eventually consistent 讀取 2 個 4 KB 物件 (預設查詢)
- WCU(Write Capacity Unit)
    - 1 單位的 WCU, 表示每秒鐘能寫入 1 KB
- 多人同時寫入的問題
    - 如果發生 multiple users 同時寫入到 DynamoDB
        - 預設寫入 DynamoDB(`PutItem`, `UpdateItem`, `DeleteItem`) 為 unconditional 操作
        - 不過, DynamoDB 提供了 `Conditional Writes` 的操作
- 名詞解釋
    - FilterExpression
        - If you need to further refine the Query results, you can optionally provide a filter expression. A filter expression determines which items within the Query results should be returned to you. All of the other results are discarded.
        - 這只會減少 ResultSet 的數量, Query 本身也是一樣耗費了原本查詢的資料筆數, 只是回傳的資料量能有效減少(類似 SQL 的 where clauses)
    - [ProjectionExpression](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ProjectionExpressions.html)
        - To read data from a table, you use operations such as GetItem, Query, or Scan. Amazon DynamoDB returns all the item attributes by default. To get only some, rather than all of the attributes, use a projection expression.
- DynamoDB - Global Table
    - 可作 active-active r/w replication

```
TableName: Products

Primary Key
    Partition Key (needed)
    SortKey       (optional)

Attributes
    name
    age
    ...
    (每筆資料的欄位都可不同)
```


# DynamoDB Index

- DynamoDB 支援底下 2 種 types 的 secondary indexes:
    - GSI, Global secondary index
        - 可替換原有的 Partition Key 及 Sort Key
        - 可以事後異動
    - LSI, Local secondary index
        - 沿用既有的 Partition Key, 此 LSI 替換掉原有的 Sort Key
        - 需要在 Table 建立的時候就先建立好 LSI (無法事後異動)


# DynamoDB backup

- 支援了 2 種類型的 backup
    - On-Demand backup and restore
        - 依照使用的需求, 可隨時快速地做備份還原
        - 需要自行配置 backup
    - Point-in-Time Recovery
        - 依照特定時間點, 還原到當時的狀態
        - 最久可還原到 35 天前的狀態
        - 由 AWS 實作 backup


# DynamoDB Streams


# Local DynamoDB

- [Setting up DynamoDB local (downloadable version)](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
    - [跑容器化吧](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html#docker)
- [NoSQL Workbench for DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html)


# DynamoDb Api

- Scan API       : (沒事別用啊!! 非常昂貴)
- GetItem API    : 查詢單一 Item 最具備效率的做法
- PutItem API    : 
    - Insert (PutItem    API is used to create a new item or to replace existing items completely with a new item)
- UpdateItem API : 
    - Update (UpdateItem API is used to create a new item or to replace existing items completely with a new item)


# DynamoDb CLI

- [DynamoDb hands-on 101](https://amazon-dynamodb-labs.workshop.aws/hands-on-labs/setup.html)
