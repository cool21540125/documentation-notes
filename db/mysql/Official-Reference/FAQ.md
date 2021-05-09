## 顯示所有的 Stored Procedures && Stored Functions in DB

```sql
-- #; 針對 DB 做查詢
SELECT ROUTINE_TYPE, ROUTINE_NAME
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_SCHEMA='dbname';

-- #; 也可透過 information_schema 來查詢
SELECT * FROM information_schema.routines WHERE ROUTINE_SCHEMA='dbname'\G
```