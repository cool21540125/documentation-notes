# MySQL 5.7 && 8.0 阿哩阿雜筆記

## ER-Model 資料庫規劃

- 2018/06/13
- [關於 Cascade](https://dba.stackexchange.com/questions/44956/good-explanation-of-cascade-on-delete-update-behavior?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)

若 2 個 Table, `Parent` 及 `Child`

如果 **Foreign Key** 已經被定義為 `ON DELETE CASCADE`

表示一旦 `Parent` 的 **Primary Key** 被移除後, 則不留孤兒. 

而 `ON DELETE RESTRICT` 放在 **Foreign Key** 則表示, 需要把 `Child` 淨空之後, 才可以殺 `Parent`.


## Normalization 正規化

- 第一正規化: 去除重複性
- 第二正規化: `非 Key屬性` 與 `Key 屬性` 完全依賴
- 第三正規化: `非 Key屬性` 之間相互獨立

![參考完整性](../../img/ER-Relationship.png)

關聯式資料模型 vs 關聯式資料庫管理系統
RDB Model                                   | RDBMS
------------------------------------------- | -----------------------
Collection of objects or relations          | DB Objects
Set of operations to act on the relations   | Data Operations
Data integrity for accuracy and consistancy | DB Constraints


## 連線相關

- 2021/02/15
- [Waiting for table metadata lock問題](http://ctripmysqldba.iteye.com/blog/1938150)
- [MySQL出现Waiting for table metadata lock的原因以及解决方法](http://blog.51cto.com/11286233/2048000)
- [MySQL show status - active or total connections?](https://stackoverflow.com/questions/7432241/mysql-show-status-active-or-total-connections)
- [How do I find which transaction is causing a “Waiting for table metadata lock” state?](https://stackoverflow.com/questions/13148630/how-do-i-find-which-transaction-is-causing-a-waiting-for-table-metadata-lock-s)
- [資料庫連線占用](https://blog.csdn.net/sinat_30397435/article/details/62932057)


#### 建議 timeout 的保護措施

因為下了一個有問題的 Alter table 指令, 導致 Table 變成 `Waiting for table metadata lock`... (獨佔鎖啥鬼的)

建議設定 `lock_wait_timeout` 設定超時時間, 避免長時間的 metadata鎖.

```sql
--;# 用來查詢 lock_wait_timeout
show variables like 'innodb_lock_wait_timeout';
```


#### 指令

```sh
> SHOW PROCESSLIST;                              # Info 欄位只取前幾個字, 有排序, 好閱讀
# 等同於 
> SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST;  # 完整資訊
+-------+-------------+-----------------+-------+-------------+--------+-------+------+
| Id    | User        | Host            | db    | Command     | Time   | State | Info |
+-------+-------------+-----------------+-------+-------------+--------+-------+------+
|    13 | repl        | 10.40.0.7:29892 | NULL  | Binlog Dump | 368436 | @@1   | NULL |
|    13 | repl        | 10.40.0.7:29892 | NULL  | Binlog Dump |    384 | init  | NULL |
|    13 | system user | connecting host | NULL  | Connect     | 360800 | @@2   | NULL |
|    14 | system user |                 | NULL  | Query       |      1 | @@3   | NULL |
|  9061 | tony        | 10.40.0.5:60220 | appdb | Sleep       |     24 |       | NULL |
+-------+-------------+-----------------+-------+-------------+--------+-------+------+
# @@1: Master has sent all binlog to slave; waiting for more updates  ← Replication Master
# @@2: Waiting for master to send event                               ← Replication Slave
# @@3: Slave has read all relay log; waiting for more updates         ← Replication Slave
# 上述表格都是拼湊出來的, 改用底下:
# SELECT user, host, db, command, info FROM INFORMATION_SCHEMA.PROCESSLIST;
# SELECT user, host, db, command, state, info FROM INFORMATION_SCHEMA.PROCESSLIST;
# SELECT user, host, db, command, state, info FROM INFORMATION_SCHEMA.PROCESSLIST WHERE command != 'Sleep';


> SHOW STATUS WHERE `variable_name` = 'Threads_connected' OR `variable_name` = 'Max_used_connections';
+----------------------+-------+
| Variable_name        | Value |
+----------------------+-------+
| Max_used_connections | 13    |  # 可得知, 歷史以來(自從此次 Service 開始), 最多的一次連線數
| Threads_connected    | 8     |  # 目前只有 Value 條連線
+----------------------+-------+
2 rows in set (0.00 sec)


> SHOW VARIABLES LIKE "max_connections";
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 9190  |  # Server 允許的同時最多連線數
+-----------------+-------+
1 row in set (0.00 sec)
```


## Key

```sql
> show index from <Table Name>;
+--------------+------------+--------------------+--------------+----------------+----------+--------+
| Table        | Non_unique | Key_name           | Seq_in_index | Column_name    | Sub_part | Packed |
+--------------+------------+--------------------+--------------+----------------+----------+--------+
| data_counter |          0 | PRIMARY            |            1 | id             |     NULL | NULL   |
| data_counter |          1 | fk_wod_code_idx    |            1 | fk_wod_serial  |     NULL | NULL   |
| data_counter |          1 | fk_sensor_code_idx |            1 | fk_sensor_code |     NULL | NULL   |
+--------------+------------+--------------------+--------------+----------------+----------+--------+
--;# 已移除部分欄位
```

## 關於 CASCADE:

- [MySQL 建立Foreign Key ( InnoDB ) 時要注意的一件事](http://lagunawang.pixnet.net/blog/post/25455909-mysql-%E5%BB%BA%E7%AB%8Bforeign-key-%28-innodb-%29-%E6%99%82%E8%A6%81%E6%B3%A8%E6%84%8F%E7%9A%84%E4%B8%80%E4%BB%B6%E4%BA%8B)

預設 FK **不作** `連動更改` (NO ACTION)

- `CASCADE`   : FK 欄位一併 刪改
- `SET NULL`  : FK 欄位設為 NULL
- `NO ACTION` : FK 欄位一旦被參照, 則 PK 欄位無法刪改
- `RESTRICT`  : 同 `NO ACTION`


## 修改 分隔符號 (預設為 ;)

- [只談MySQL (第16天) Stored Procedure及Function](https://ithelp.ithome.com.tw/articles/10032363)

MySQL預設以「;」為分隔符號, 可使用「delimiter //」, 就可把分隔符號改為「//」了.


## 毫秒、微秒 欄位

- [milliseconds](https://stackoverflow.com/questions/13344994/mysql-5-6-datetime-doesnt-accept-milliseconds-microseconds?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)

- DATETIME(3) -> 毫秒
- DATETIME(6) -> 微秒


## mysql 命令提示字元

MySQL內, 以下種種, 都有它們所要表達的意思, [看官網說明](https://dev.mysql.com/doc/refman/5.7/en/entering-queries.html)

```sh
# mysql>
# ->
# '>
# ">
# `>
# /*>
```


# 指令問題

```sql
--#; MySQL 曾經是 5.6, 升級成 5.7, 執行指令發生問題... 可藉由這樣來處理
> SHOW STATUS WHERE `variable_name` = 'Threads_connected' OR `variable_name` = 'Max_used_connections';
ERROR 1682 (HY000): Native table 'performance_schema'.'session_status' has the wrong structure


> SELECT @@global.show_compatibility_56;
+--------------------------------+
| @@global.show_compatibility_56 |
+--------------------------------+
|                              0 |
+--------------------------------+
1 row in set (0.00 sec)


> SET @@global.show_compatibility_56=ON;
```


```sql
--#; 
> \s
--------------
/usr/local/mysql/bin/mysql  Ver 14.14 Distrib 5.7.26, for linux-glibc2.12 (x86_64) using  EditLine wrapper

Connection id:		    5
Current database:       
Current user:		    root@localhost
SSL:			        Not in use
Current pager:		    stdout
Using outfile:		    ''
Using delimiter:	    ;
Server version:		    5.7.26-log MySQL Community Server (GPL)
Protocol version:	    10
Connection:		        Localhost via UNIX socket
Server characterset:	utf8
Db     characterset:	utf8
Client characterset:	utf8
Conn.  characterset:	utf8
UNIX socket:		    /data/db/mysql/mysql.sock
Uptime:			        13 days 22 hours 56 min 59 sec
--#; ↑ 服務時間

Threads: 2  Questions: 28  Slow queries: 0  Opens: 109  Flush tables: 1  Open tables: 102  Queries per second avg: 0.000
--------------

```