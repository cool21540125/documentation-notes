# backup

## 使用 `mysqldump` 做完整備份

- [mysqldump](https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html#mysqldump-ddl-options)


```sh
$ mysqldump -u '<id>' -p '<pd>' \
    --single-transaction \
    --flush-logs \
    --master-data=2 \
    --all-databases \
    --delete-master-logs > PATH_TO_BACKUP/full_backup_`date +\%H\%M`.sql
# ex: full_backup_1036.sql
# non-lock online backup(for InnoDB)
# 將 transaction flush到檔案
# 使用二進制
# 所有 DB的所有 table
```


* 累積備份(Incremental backup)
    * 第 t 天都與第 t-1 天相比較, 作差異備份
* 差異備份(Differential backup)
    * 第 t 天都與第 1 天相比較, 作差異備份
    

pyhsical                           | logical
---------------------------------- | --------
快                                 | 慢
企業級                              | -
無法 backup Memory中資料            | 可
mysqlbackup                        | mysqldump
會有 Engine問題                     | 可跨 Engine
可能需要關服務, backup比較不會有問題  | 可以暖備份

```sql
mysql> SELECT table_name, engine FROM information_schema.tables WHERE table_schema = 'dbname';
+--------------+--------+
| TABLE_NAME   | ENGINE |
+--------------+--------+
| table1       | InnoDB |
| table2       | MyISAM |
| table3       | MyISAM |
+--------------+--------+
```


## 還原 restore

- 依備份檔還原資料庫, 語法: `mysql [DB Name] -uroot -p < [備份的文檔名稱.sql]`

```sh
# 還原前, 關閉二進位日誌
$ mysql > set sql_log_bin=0;

$ mysql tt -uroot -p < ttbck.sql

$ mysql > set sql_log_bin=1;
```


## other

- [LVM快照備份](https://ithelp.ithome.com.tw/articles/10081811)


# MySQL5.6 mysqlcopy ( `mysqldump` 前身 )

- [用mysqlhotcopy 備份MySQL](https://blog.longwin.com.tw/2005/01/%E7%94%A8mysqlhotcopy-%E5%82%99%E4%BB%BDmysql/)

```sh
$ mysqlhotcopy --checkpoint dbinfo.checkpoint --addtodest db_douzi_org /var/db_backup
```

```sql
CREATE DATABASE `dbinfo`;
USE dbinfo;
CREATE TABLE `checkpoint` (
    `time_stamp` timestamp(6) NOT NULL,
    `src` varchar(32) NOT NULL default '',
    `dest` varchar(60) NOT NULL default '',
    `msg` varchar(255) NOT NULL default '',
    PRIMARY KEY (`time_stamp`)
);
```