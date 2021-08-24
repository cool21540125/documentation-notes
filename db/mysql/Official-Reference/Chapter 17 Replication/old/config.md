
## [Setting the Replication Source Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterbaseconfig.html)

```sh
### /etc/my.cnf

[mysqld]
# For the greatest possible durability and consistency in a replication setup using InnoDB with transactions
innodb_flush_log_at_trx_commit=1
sync_binlog=1

# 若設置為0, 也在合理範圍內, 但此不允許 replicas 來作 replication
server_id=1
# 使用 server_id OR server-id, 有一樣的結果

# 務必確保底下這個沒有被 ON 起來(default OFF)
# skip_networking=OFF
```


## [Setting the Replica Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slavebaseconfig.html)

```sh
### /etc/my.cnf
server_id=2
```


## 相關指令

```sql
SET GLOBAL server_id = 21;    --#; MySQL run time 改變server_id
SHOW VARIABLES LIKE 'server_id';

--#; 建立 專門用來做 Replication 的用戶
CREATE USER 'repl'@'%.example.com' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.example.com';
```

使用 [FLUSH TABLES WITH READ LOCK](https://dev.mysql.com/doc/refman/8.0/en/flush.html#flush-tables-with-read-lock), 
會針對 InnoDB 的 **all DB && Table** 作 **flush all tables and block write** (也就是 block commit, 此鎖為 global read lock). 後續使用 `UNLOCK TABLES` 來解鎖.

要開始製作 Replication 的當下, 如果 master 與 slave 的資料並未同步到的話, 需要先讓 master 停止繼續更新(不要讓他資料異動), 在此同時, 把目前資料 backup 下來, 讓他們同步到 slave

```sh
### 在 master 上作
mysqldump --all-databases --master-data > dbdump.db
# --master-data : 會連同把 CHANGE MASTER TO ... 的指令也一起產生
#     Ref: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_master-data
#    - Write the binary log file name and position to the output
# --all-databases, -A : 所有 DB 都做 backup
#     Ref: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_all-databases
# --databases, -B : 只做要 backup 的 DB 
#     Ref: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_databases
# --ignore-table=db_name.tbl_name : 排除特定 table
#     Ref: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_ignore-table
```

```sql
CHANGE MASTER TO
    MASTER_HOST='10.1.244.21',
    MASTER_PORT=7980,
    MASTER_USER='replusr',
    MASTER_PASSWORD='aaadfsfd125473f872',
    MASTER_LOG_FILE='mysql-bin.000007',
    MASTER_LOG_POS=13834;

CHANGE MASTER TO
    MASTER_HOST='10.1.244.21',
    MASTER_PORT=7980,
    MASTER_USER='root',
    MASTER_PASSWORD='1qaz@WSX',
    MASTER_LOG_FILE='recorded_log_file_name',
    MASTER_LOG_POS=recorded_log_position;
```