[mongoexport](https://docs.mongodb.com/database-tools/mongoexport/#mongodb-binary-bin.mongoexport)

- 2021/08/10

用來 backup MongoDB, 產出檔為 JSON or CSV

※ **只能用來匯出以 Collection 為單位的指令.... 無法針對整個 DB 做匯出**

`mongoexport` 與 `mongoimport` 為 System CLI, 非為 mongo shell

- MongoDB v4.4+ 以後, 已把 `mongoexport` & `mongoimport` 從 MongoDB Server 拆分出來
    - 初始版本為 `100.0.0`...XD
    - `mongoexport` 也可用來做早期版本(v4.2前) 的備份, 但是不保證 100% 穩定
- 使用 `mongoexport` 的時候, 必須搭配指定輸出檔案的路徑, 若不指定, 則會寫到 stdout
- 連線方式可使用:
    - `mongoexport --uri="mongodb://db0.com:27017/reporting" ...`
    - `mongoexport --host="db0.com" --port=27017 --db=reporting ...`
- `mongoexport` 最少需要對要備份的 DB 有 `read role`
- `mongoexport` 選項
    - `--jsonFormat=xxx`
        - 自行參考 [MongoDB Extended JSON (v2)](https://docs.mongodb.com/v4.4/reference/mongodb-extended-json/)

```bash
### 備份 Standalone
MONGO_URI=mongodb://db0.com:27017/reporting
mongoexport \
    --uri="$MONGO_URI" \
    --collection=collectionName \
    --db=businessDB \
    --out=/data/backup/mongo-bak.20210810.json

### 備份 ReplicaSet
MONGO_URI=mongodb://db0.com:27017,db1.com:27017,db2.com:27017/reporting?replicaSet=rs0
mongoexport \
    --uri="$MONGO_URI" \
    --collection=events \
    --out=events.json [additional options]

# 預設, 它會從 Primary of the ReplicaSet 去作讀取. 除非自行指定 readPreference
MONGO_URI=mongodb://db0.com:27017,db1.com:27017,db2.com:27017/reporting?replicaSet=rs0&readPreference=secondary
mongoexport \
    --uri="$MONGO_URI" \
    --collection=events \
    --out=events.json [additional options]

### 備份 ShardedCluster
# 略
```