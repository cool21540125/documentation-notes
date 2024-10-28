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

| Cost                  | RCU               | WCU               |
| --------------------- | ----------------- | ----------------- |
| Eventually consistent | 8 KB / per unit   | 1 KB / per unit   |
| Strongly consistent   | 4 KB / per unit   | 1 KB / per unit   |
| Transactional request | 4 KB / per 2 unit | 1 KB / per 2 unit |

---

- Table Class 分成 2 種:
  - Standard Table Class
  - Infrequent Access(IA) Table Class
    - 雖說 Storage Cost 較低, 不過 throughput cost 較高. 因此使用尚須留意, 此較適合真的很少 r/w 的 data 才能真的省錢
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
    - Strongly consistent 讀取 1 個 4 KB 物件
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

# DynamoDb 的 Read & Write

- Ddb 的日常使用(CRUD), 可藉由下面 2 種方式:
  - DynamoDb Api
    - 針對 Item 及 attributes 做操作:
      - Single Item APIs: `GetItem` | `PutItem` | `UpdateItem` | `DeleteItem`
      - Batch Items APIs:
        - `BatchGetItem`
          - 最多可拿回 100 items (16 MB)
        - `BatchWriteItem`
    - 針對 Item collections(items 之間具有相同的 partition key) 做操作:
      - `Query` operations
        - Key condition expression
          - 使用 Partition Key 或是 index attribute 做篩選
        - Filter expression
          - 針對查詢到的 items 做 refine (並不會降低 consumed capacity)
  - PartiQL for DynamoDb (也可以使用在 AWS CLI/API 的情境)

# DynamoDb Global Table

- Ddb Global Table 可作為 multi-Region replication (災備), 並且可以實現:
  - multi-active database
  - localized read and write performance
- 可作 active-active r/w replication

# DynamoDB Index 另有 2 種 Secondary Index

## Global secondary index, GSI

> An index with a partition key and a sort key that can be different from those on the base table. A global secondary index is considered "global" because queries on the index can span all of the data in the base table, across all partitions. A global secondary index is stored in its own partition space away from the base table and scales separately from the base table.

- Shadow Table
- 可使用截然不同的 Partition Key (+ Sort Key)
- 可在 Create Table 之後隨時增減 GSI, 每張 Table 軟限 20 個 GSI
- 因為會使用不同的 Partition Key, 因此只能使用 Eventually Consistency Read

## Local secondary index, LSI

> An index that has the same partition key as the base table, but a different sort key. A local secondary index is "local" in the sense that every partition of a local secondary index is scoped to a base table partition that has the same partition key value.

- 使用既有 Partition Key, 可另外設定其他 attribute 升格為 LSI
- Create Table 時就需要定義好, 且每個 Table 硬限 5 個, 無法事後異動
- 位於既有 Partition, 因而有下列限制需要知道:
  - LSI 更像是 hot partition
  - Item collections 無法被切割, 因而有 10GB 大小限制 (1000 WCU && 3000 RCU) <- 不是很懂
  - Item + LSIs 限制為 400KB (需要留意, Ddb Item 每筆最大為 400 KB)
  - 強一致性 (資料位於相同的 base table, 相同 Partition)

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

# Local DynamoDB (本地開發用)

- [Setting up DynamoDB local (downloadable version)](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
  - [跑容器化吧](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html#docker)
- [NoSQL Workbench for DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html)

# DynamoDb Modeling (進階)

- [Data modeling building blocks in DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-modeling-blocks.html)
- [Multitenancy on DynamoDB](https://docs.aws.amazon.com/whitepapers/latest/multi-tenant-saas-storage-strategies/multitenancy-on-dynamodb.html)
- Scan API : (沒事別用啊!! 非常昂貴)
- GetItem API : 查詢單一 Item 最具備效率的做法
- PutItem API :
  - Insert (PutItem API is used to create a new item or to replace existing items completely with a new item)
- UpdateItem API :
  - Update (UpdateItem API is used to create a new item or to replace existing items completely with a new item)
