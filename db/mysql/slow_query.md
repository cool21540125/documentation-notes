SLOW Query

- 2022/03/29 工作中遇到的範例

開發告知, 目前某頁面開了會 hang 在那邊...

依序排查 服務, 網路, DB, 發現是 DB 問題...


### Example 1

```sql
root@localhost [db]> SHOW processlist;
--                     找到了造成 slow query 的元兇
root@localhost [db]>
root@localhost [db]> SELECT * FROM some_table WHERE fid=886 AND displayorder>=0 ORDER BY `dateline` DESC LIMIT 1;
(~略~)
1 row in set (16.84 sec)
-- 一個 Query, 將近 17 秒!!

root@localhost [db]>
root@localhost [db]> SHOW CREATE TABLE some_table\G
*************************** 1. row ***************************
       Table: some_table
Create Table: CREATE TABLE `some_table` (
  (~略~)
  PRIMARY KEY (`tid`),
  KEY `typeid` (`fid`,`typeid`,`displayorder`,`lastpost`),
  (~略~)
  KEY `idx_displayorder` (`displayorder`),
  KEY `idx_dateline` (`dateline`),
  KEY `displayorder` (`fid`,`displayorder`,`dateline`)
) ENGINE=InnoDB AUTO_INCREMENT=65432187 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

root@localhost [db]>
root@localhost [db]> EXPLAIN SELECT * FROM some_table WHERE fid=886 AND displayorder>=0 ORDER BY `dateline` DESC LIMIT 1;
+----+-------------+------------+------------+-------+--------------------------------------+--------------+---------+------+------+----------+-------------+
| id | select_type | table      | partitions | type  | possible_keys                        | key          | key_len | ref  | rows | filtered | Extra       |
+----+-------------+------------+------------+-------+--------------------------------------+--------------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | some_table | NULL       | index | typeid,idx_displayorder,displayorder | idx_dateline | 4       | NULL |  198 |     0.25 | Using where |
+----+-------------+------------+------------+-------+--------------------------------------+--------------+---------+------+------+----------+-------------+
--                                                     ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑        ↑
--                                                        MySQL 自行研判可能的 Key               這句 SQL 實際使用的 Key
-- 
-- 因此, 這句 ORDER BY 會用到 Key, 不過 WHERE 無 Key, 造成 Slow Query
1 row in set, 1 warning (0.00 sec)

root@localhost [db]>
root@localhost [db]> SELECT * FROM some_table FORCE INDEX (displayorder) WHERE fid=886 AND displayorder>=0 ORDER BY `dateline` DESC LIMIT 1\G
*************************** 1. row ***************************
(~略~)
1 row in set (0.02 sec)

root@localhost [db]>
```


### Example 2

```sql

root@localhost [discuz_db]> show processlist;
+------+-------+---------------+----+---------+----------+---------------------+-----------------------------------------------------------------------+
| Id   | User  | Host          | db | Command | Time     | State               | Info                                                                  |
+------+-------+---------------+----+---------+----------+---------------------+-----------------------------------------------------------------------+
| 8015 | user  | 1.2.3.4:56144 | db | Query   |       23 | Creating sort index | SELECT * FROM table WHERE followuid=1 ORDER BY dateline DESC LIMIT 20 |
| 9854 | root  | localhost     | db | Query   |        0 | starting            | show processlist                                                      |
+------+-------+---------------+----+---------+----------+---------------------+-----------------------------------------------------------------------+
2 rows in set (0.00 sec)

root@localhost [discuz_db]> SELECT * FROM table WHERE followuid=1 ORDER BY dateline DESC LIMIT 20;
(~略~)
20 rows in set (24.55 sec)
-- 其實沒必要再執行這個... 因為前面的 processlist 已經可看出查了 20 多秒了

root@localhost [discuz_db]> 
root@localhost [discuz_db]>
root@localhost [discuz_db]> SHOW CREATE TABLE table\G
*************************** 1. row ***************************
       Table: table
Create Table: CREATE TABLE `table` (
(~略~)
  PRIMARY KEY (`uid`,`followuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

root@localhost [discuz_db]>
root@localhost [discuz_db]> 
root@localhost [discuz_db]>
root@localhost [discuz_db]> EXPLAIN  SELECT * FROM table WHERE followuid=1 ORDER BY dateline DESC LIMIT 20;
+----+-------------+-------+------------+------+---------------+------+---------+------+----------+----------+-----------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows     | filtered | Extra                       |
+----+-------------+-------+------------+------+---------------+------+---------+------+----------+----------+-----------------------------+
|  1 | SIMPLE      | table | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 22636403 |    10.00 | Using where; Using filesort |
+----+-------------+-------+------------+------+---------------+------+---------+------+----------+----------+-----------------------------+
--                                                                ↑                        ↑ 
--                                                              搜尋了 2000 多萬筆, 但沒用到 Key
1 row in set, 1 warning (0.00 sec)
```