[Back Up and Restore with MongoDB Tools](https://docs.mongodb.com/v4.4/tutorial/backup-and-restore-tools/)

本章節介紹 MongoDB 做備份還原的工具

- `mongodump` & `mongorestore` 使用 BSON data dumps, 可用來作小型資料庫備份還原.
    - 運行 mongodump 時, 必須要有:
        - privileges that grant `find` action for each DB to back up
        - 內建的 `backup` role 提供必要的權限來執行 all DB backup
    - `mongodump` 使用時, 它會連線到 `mongod`, 因此 Mongo Server 必須正在運行中才行.
- 若要使用 resilent(彈性) and non-disruptive(無中斷) backups, 請使用 file system or block-level disk snapshot function
- v4.2+ 以後, 對於 ShardedCluster 的備份還原, 傳統內建的 `mongodump` & `mongorestore` 已無法在安全地使用. 考慮燒錢吧~
- 也可參考使用: `mongoexport` & `mongoimport`

```bash
### mongodump
mongodump \
    --host=127.0.0.1 \
    --port=27017 \
    --out=/data/backup/business_database-2021-08-10.bak \
    --db=business_database \
    --collection=busineesCollection \
    --oplog
```

除非是 開發DB 或是 小型DB, 不然不要用 `mongodump` 就是了
