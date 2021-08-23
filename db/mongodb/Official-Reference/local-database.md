[The local Database](https://docs.mongodb.com/v4.4/reference/local-database/#mongodb-data-local.oplog.rs)

每個 `mongod` 都有自己的 `local` DB. 用來儲存 replication 過程中使用到的數據 && 其它特定 instance-specific data

Replication 動作本身不會去 replicate `local` DB. 反過來說, `local DB` 對於 replication 是 *invisible*

```js
rs0:PRIMARY> show tables;
oplog.rs
replset.election
replset.initialSyncId
replset.minvalid
replset.oplogTruncateAfterPoint
startup_log
system.replset
system.rollback.id
```


### local.startup_log

- 啟動階段會寫入一筆資料到此 Collection. 
    - 此資料是關於 mongod instance 本身的 `diagnostic information` && `host information`
- 此 Collection 是 capped collection.
    - capped collection: 有上限的限制. 基本上若超過, 會抹除最舊, 來儲存新的


### local.system.replset

- 儲存了 ReplicaSet 本身的相關資訊
- 可使用 `rs.conf()` 來做查看
    - 此與直接查詢 `db.getSiblingDB('local').system.replset.find().pretty();` 結果一樣


### local.oplog.rs

- 用來儲存 **oplog**
- 初始化階段, 藉由配置 `oplogSizeMB` 來設定此 Collection 的上限
    - 此為 capped collection
    - 若在運行階段要改變此大小, 再去參考 [Change the Size of the Oplog](https://docs.mongodb.com/v4.4/tutorial/change-oplog-size/)
    - 4.0 開始, oplog 大小有可能會超出此設定. 想知道為啥再去參考 *majority commit point*
- 4.4.2 開始, 無法再對 ReplicaSet 的 replicas 上的 oplog 做手動操作


### local.replset.minvalid

- 包含 ReplicaSet 用來追蹤 replication status 相關資訊