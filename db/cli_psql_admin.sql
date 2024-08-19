-- ================================= admin =================================
-- 查詢 DB Size
SELECT
    pg_size_pretty (pg_database_size ('DB_NAME'));

-- 查詢 Table Size
SELECT
    pg_size_pretty (pg_relation_size ('TABLE_NAME'));