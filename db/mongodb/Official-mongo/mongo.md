[The monog Shell](https://docs.mongodb.com/v4.4/mongo/)

- `mongo` 會隨著安裝 MongoDB Server 一並安裝, 但也可自行獨立安裝 `mongo`
    - 也可自行安裝更新版本的 mongo shell: [mongosh](https://docs.mongodb.com/mongodb-shell/)
    - 可查看 [mongo 與 mongosh 的不同](https://docs.mongodb.com/v4.4/mongo/#std-label-compare-mongosh-mongo)


# mongo Shell 登入操作

```bash
### 連結到 Standalone Mongo Server ====================
mongo "mongodb://mongodb0.example.com:28015"

mongo "mongodb://alice@mongodb0.examples.com:28015/?authSource=admin"

mongo --username alice \
    --password \
    --authenticationDatabase admin \
    --host mongodb0.examples.com \
    --port 28015
# 跳出提示輸入密碼

mongo --host mongodb0.example.com:28015

mongo --host mongodb0.example.com --port 28015

### 連結到 Replica Set Mongo Server ====================
mongo "mongodb://db0.com:27017,db1.com:27017,db2.com:27017/?replicaSet=replA"
# 上下兩者都相同
mongo --host replA/db0.com:27017,db1.com:27017,db2.com:27017
```

使用 TLS/SSL Connection, [有需要再來學](https://docs.mongodb.com/v4.4/mongo/#tls-ssl-connection)


# mongo Shell 基本操作

```bash
> db
admin
# 可以查出目前所在的 Database
```