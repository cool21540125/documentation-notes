
# using index

- 2018/08/07
- [SELECT語法效能](https://kejyuntw.gitbooks.io/high-scaling-websites-structure-learning-notes/Database/Database-MySQL-SELECT-SQL-Explain-Test.html)
- [What is the meaning of filtered in MySQL explain?](https://dba.stackexchange.com/questions/164251/what-is-the-meaning-of-filtered-in-mysql-explain)
- [MySQL5.7 - Exaplain Output Format](https://dev.mysql.com/doc/refman/5.7/en/explain-output.html)

Explain Query後, 所能看到的 `type` 欄位, **依照效能排序**
- System (效能最佳)
- const
- eq_ref
- ref
- fulltext
- ref_or_null
- index_merge
- unique_subquery
- index_subquery
- range
- index
- ALL (效能最差)

```sql
explain select * from datas where dt >= '2017-06-12 03:00:00' and dt<= '2017-06-12 06:00:00' order by dt desc;
-- +-------+------+---------+----------+-----------------------------+
-- | type  | key  | rows    | filtered | Extra                       |
-- +-------+------+---------+----------+-----------------------------+
-- | ALL   | NULL | 5245344 |    11.11 | Using where; Using filesort |--;# 無 Index, 180 rows in set (1.58 sec)
-- | range | dt   |     180 |   100.00 | Using index condition       |--;# 有 Index, 180 rows in set (0.00 sec)
-- +-------+------+---------+----------+-----------------------------+
-- 僅節錄部分欄位 並列出比較
```

- `type` : 觀察重點! 
- `key` : 實際使用的索引, 上例為 NULL, `rows` = 5245344, 也就是把 所有資料都找遍了~
- `rows` : 同 `key` 說明
- `filtered` : 不是很好的觀察指標... 僅為參考用, 重點還是得看 type && Extra
- `Extra` : (不會解釋...)



# Lock Table

- [鎖表 (Lock Table)](https://kejyuntw.gitbooks.io/high-scaling-websites-structure-learning-notes/Database/Database-MySQL-Lock-Table.html)

可以區分為:
- Table-level lock (default)
- Row-level lock

若改為 `Row-level lock` 時, 必須明確指定要異動的PK欄位, 否則預設使用 `Table-level lock`

MySQL 5.7 預設 DBEnginee = `InnoDB`, 預設支援 `Row-level lock`

Table `user` 有 `id`(PK) 與 `name` 欄位

SQL	                                                   | Table lock | Row lock | No lock | Note
------------------------------------------------------ |:----------:|:--------:|:-------:| ----------------
SELECT * FROM `user` WHERE `id`='1' FOR UPDATE         | -          | v        | -       | 明確指定主鍵，並且有此筆資料，row lock
SELECT * FROM `user` WHERE `id`='-1' FOR UPDATE;       | -          | -        | v       | 明確指定主鍵，若查無此筆資料，無 lock
SELECT * FROM `user` WHERE `name`='KeJyun' FOR UPDATE; | v          | -        | -       | 無主鍵，table lock
SELECT * FROM `user` WHERE `id`<>'1' FOR UPDATE;       | v          | -        | -       | 主鍵不明確，table lock
SELECT * FROM `user` WHERE `id` LIKE '3' FOR UPDATE;   | v          | -        | -       | 主鍵不明確，table lock

`FOR UPDATE` 只能作用在 `InnoDB`, 必須要 transactions 內才能使用
