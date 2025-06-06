-- 
-- 管理 PostgreSQL users and roles
--   https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/
-- 
-- ================================= admin =================================
-- 查詢 DB Size
SELECT pg_size_pretty (pg_database_size ('postgres'));

-- 查詢 Table Size
SELECT pg_size_pretty (pg_relation_size ('TABLE_NAME'));

-- 等同於 MySQL 的 SHOW processlist;
SELECT * FROM pg_stat_activity;


-- Show User && Database
SELECT session_user, current_database();

-- 查詢 ROLE 及 attributes (功能等同於 \du, 但比較沒那麼詳細)
SELECT usename AS role_name,
  CASE 
    WHEN usesuper AND usecreatedb THEN 
      CAST('superuser, create database' AS pg_catalog.text)
    WHEN usesuper THEN 
      CAST('superuser' AS pg_catalog.text)
    WHEN usecreatedb THEN 
      CAST('create database' AS pg_catalog.text)
    ELSE 
      CAST('' AS pg_catalog.text)
  END role_attributes
FROM pg_catalog.pg_user
ORDER BY role_name desc;

-- 列出 ROLEs 的繼承架構
SELECT 
      r.rolname, 
      ARRAY(SELECT b.rolname
            FROM pg_catalog.pg_auth_members m
            JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
            WHERE m.member = r.oid) as memberof
FROM pg_catalog.pg_roles r
WHERE r.rolname NOT IN ('pg_signal_backend','rds_iam',
                        'rds_replication','rds_superuser',
                        'rdsadmin','rdsrepladmin')
ORDER BY 1;

-- Revoke
REVOKE USAGE ON ALL SEQUENCES IN SCHEMA public TO app_user;


-- 授予 ROLE 新的 privilege
ALTER ROLE app_user WITH XXX;
ALTER ROLE app_user WITH LOGIN;

GRANT USAGE, CREATE ON SCHEMA __SCHEMA__ TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA __SCHEMA__ TO app_user;

-- 讓 __SCHEMA__ 將來直接具備 default privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA __SCHEMA__ GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
-- 反向操作: ALTER DEFAULT PRIVILEGES IN SCHEMA __SCHEMA__ REVOKE SELECT ON TABLES FROM app_user;

-- 新增
CREATE ROLE app_user WITH LOGIN PASSWORD 'init_password_that_will_be_rotate_by_secret_manager_soon';
GRANT CONNECT ON DATABASE demo TO app_user;
GRANT USAGE, CREATE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;


-- 改密碼
ALTER USER dms_user WITH PASSWORD '@#@#@#@#@#';


-- 移除
REVOKE CONNECT ON DATABASE demo FROM app_user;
REVOKE USAGE, CREATE ON SCHEMA public FROM app_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM app_user;
REVOKE USAGE ON ALL SEQUENCES IN SCHEMA public FROM app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM app_user;
DROP ROLE app_user;


-- ================================================== 拔權限 / 砍權限 ==================================================
-- Delete User / Delete Role / Drop User / Drop Role
-- 得先將 ROLE 所擁有的 Objects 的這層關聯先拔掉, 才能移除 ROLE
-- 列出 Users / Roles (PostgreSQL 裡, 並沒有 User 的概念, User 其實就是 Role)
-- 說白了就是 User = Role + login_permission
SELECT * FROM pg_catalog.pg_user;
SELECT * FROM pg_catalog.pg_roles;
SELECT * FROM information_schema.role_table_grants;
SELECT * FROM information_schema.table_privileges;

ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM app_user;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM app_user;
DROP ROLE IF EXISTS app_user;


-- !!!!!!! 如果不知道自己在幹嘛, 那就別這樣幹 !!!!!!!
REVOKE CREATE ON SCHEMA public FROM PUBLIC;  -- 拔掉 public role 對於 public schema 預設允許的 '可進行任意操作的權限'
REVOKE ALL ON DATABASE YOUR_DB FROM PUBLIC;  -- 拔掉 YOUR_DB 預設的 public schema 預設的 public role 所允許的操作
-- !!!!!!! 如果不知道自己在幹嘛, 那就別這樣幹 !!!!!!!


-- 
REVOKE ALL PRIVILEGES ON YOUR_TABLE FROM app_user;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM app_user;
REVOKE CONNECT ON DATABASE YOUR_DB FROM app_user;


REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA __SCHEMA__ FROM dms_user