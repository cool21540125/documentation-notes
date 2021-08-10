[MongoDB Backup Methods](https://docs.mongodb.com/v4.4/core/backups/)

- 2021/08/10

MongoDB 用於生產環境的化, 需要搭配適當的備份策略, 來保全資料

## 1. Backup Up with Atlas

有預算再考慮


## 2. Backup Up with MongoDB Cloud Manager

有預算再考慮


## 3. Backup Up with Ops Manager

有預算再考慮


## 4. Back Up with Filesystem Snapshots

藉由各種 filesystem 支援的 point-in-time snapshot 做 backup

不僅限於 MongoDB. 目前對 snapshot 還不是很懂, 將來再來看


## 5. Back Up with cp or rsync

若要單純使用 `cp` 或 `rsync` 來做資料備份, 需要停止對 MongoDB 的寫入再來做(避免資料破碎)

但這種 backup by copying the underlying data 並不支援 `point in time recovery` for *ReplicaSet* 以及 *ShardedCluster*.

此外這種複製的備份方式, 會重複備份許多重複的資料, ex: indexes, underlying storage padding and fragmentation. 

因此相對之下, `mongodump` 是個較佳的解決方案


## 6. Back Up with mongodump

- `mongodump` 會將 DB 備份至 BSON files; 可使用 `mongorestore` 來作還原
    - 用來備份還原 **小型資料庫** 是個很棒的工具, 但不要拿來處理 大型資料庫, 會出事情
- `mongodump` 並不會對 `local` 這個 DB 做備份
    - NOTE: local DB 用來作 Replication && instance-specific data 使用. 此 DB 並不會被 Replica 進行 replicate
- 此種備份方式節省空間, 但資料還原以後, 必須重建索引(不是很懂, 原文如下):
    > mongodump only captures the documents in the database. The resulting backup is space efficient, but mongorestore or mongod must rebuild the indexes after restoring data.
- `mongodump` 會影響 `mongod` 的效能
    - 如果 Data Size > System Memory, 則 queries will push the working set out of memory, causing page faults
- mongodump 可搭配 --oplog 來包含在 mongodump 操作期間發生的 output oplog entries
    - 還原時, mongorestore 要搭配 --oplogReplay
- `mongodump` && `mongorestore` 無法用於 `SharededCluster` v4.2+ 做 備份還原