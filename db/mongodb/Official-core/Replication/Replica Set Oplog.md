- [Replica Set Oplog](https://docs.mongodb.com/v4.4/core/replica-set-oplog/#slow-oplog-application)
- 2021/08/22

> The oplog (operations log) is a special capped collection that keeps a rolling record of all operations that modify the data stored in your databases.

- MongoDB 會在 Primary 上執行數據操作, 接著在 Primary 的 oplog 紀錄操作. 而 Secondaries 會有個異步程序, 來 copy and apply 這個 Primary oplog 到自己身上.
    - 所有的 ReplicaSet members 都包含