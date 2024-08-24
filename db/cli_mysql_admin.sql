-- MariaDB - Admin SQL Statements
--      https://mariadb.com/kb/en/administrative-sql-statements/
-- GRANT
--      https://mariadb.com/kb/en/grant/

-- LAB
--      https://severalnines.com/blog/database-user-management-managing-roles-mariadb/
-- 
-- 

-- ************************************************ Users ************************************************
-- 
SELECT USER, HOST FROM mysql.user;
SELECT USER(), CURRENT_USER();

-- 建立一個 將來服務使用的 DB User, 名為 app_user, 隨便給個密碼
-- 建立一個 Role, 名為 app_role
-- 授予 app_role 必要的權限 (將來 DB 可能動態增減, 懶得將來又要來改, 因而直接授予 *.*)
-- 授予 app_user 具備 app_role
-- 設定 app_user 的 default role 為 app_role
CREATE USER 'app_user'@'%' IDENTIFIED BY 'init_password_that_will_be_rotate_by_secret_manager_soon';
CREATE ROLE app_role;
GRANT SELECT, INSERT, UPDATE, DELETE, INDEX ON *.* TO app_role;
GRANT app_role TO 'app_user'@'%';
SET DEFAULT ROLE app_role FOR 'app_user'@'%'; -- MariaDB
SET DEFAULT ROLE app_role TO 'app_user'@'%'; -- MySQL


-- **************** 建立 User, 並賦予權限 ****************
-- 法1. 單純建立 User
CREATE USER 'USER'@'%' IDENTIFIED BY 'init_password';

-- 法2. 建立 User 當下, 立馬給 PRIVS
GRANT ALL PRIVILEGES ON *.* TO 'USER'@'%' IDENTIFIED BY 'init_password';


-- 
-- **************** 修改密碼/重設密碼 ****************
-- UPDATE mysql.user SET authentication_string = PASSWORD('new_password') WHERE User = 'USER' AND Host = '%';  -- 盡量別這樣
SET PASSWORD FOR 'USER'@'%' = PASSWORD('new_password');  -- MariaDB
ALTER USER 'USER'@'%' IDENTIFIED BY 'MyNewPass';  -- MySQL
FLUSH PRIVILEGES;

-- **************** 移除 User ****************
DROP USER 'USER'@'%';

-- ************************************************ Roles ************************************************
-- Tips and Tricks for Implementing Database Role-Based Access Controls for MariaDB
--      https://severalnines.com/blog/tips-and-tricks-implementing-database-role-based-access-controls-mariadb/
-- MariaDB privileges
--      https://mariadb.com/kb/en/grant/#database-privileges
--      https://mariadb.com/kb/en/grant/#table-privileges

CREATE ROLE app_developer, app_reader, app_writer, app_structure;
GRANT app_reader TO app_developer;
GRANT app_writer TO app_developer;
GRANT app_structure TO app_developer;

-- `IDENTIFIED BY` 預設使用 PASSWORD function, 基本上使用 mysql_native_password plugin (不然就是 mysql_old_password plugin)
-- 
-- GRANT PRIV1, PRIV2, PRIV3 ON 'DB'.'TBL' TO 'USER'@'%' IDENTIFIED BY 'init_password';
-- GRANT PRIV4               ON 'DB'.'TBL' TO ROLE;
-- 
-- 如果該 'USER'@'%' 已經存在, 則會嘗試做 update password, 否則會 create user
-- 
GRANT ALL PRIVILEGES ON *.* TO 'USER'@'%' IDENTIFIED BY 'init_password';

GRANT ALL PRIVILEGES                                                                                          ON *.* TO dev_role;
GRANT USAGE, SELECT, INSERT, UPDATE, DELETE, INDEX                                                            ON *.* TO app_role;
GRANT SELECT, LOCK TABLES, SHOW VIEW                                                                          ON *.* TO app_reader;
GRANT INSERT, DELETE, UPDATE, CREATE TEMPORARY TABLES                                                         ON *.* TO app_writer;
GRANT CREATE, ALTER, DROP, CREATE VIEW, CREATE ROUTINE, INDEX, TRIGGER, REFERENCES                            ON *.* TO app_structure;
GRANT SELECT,INSERT,UPDATE,DELETE                                                                             ON *.* TO app4_role;
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT                                                        ON *.* TO bak_role;
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, SUPER, ALTER, INSERT, CREATE, DROP, REFERENCES, CREATE ROUTINE ON *.* TO dump_role;

GRANT ROLE TO 'USER'@'%';
SET DEFAULT ROLE first_role FOR 'USER'@'%';

-- 查詢 User/Role 具備哪些 privileges
SHOW GRANTS FOR 'USER'@'%';
SHOW GRANTS FOR ROLE_NAME;
SELECT User, Host, default_role FROM mysql.user;

-- 查看所有 USER 有哪些權限
SELECT * FROM information_schema.user_privileges;

-- 拔掉權限
REVOKE SHOW DATABASES ON *.* FROM 'USER'@'%';
REVOKE SHOW DATABASES ON *.* FROM app_role;


-- 列出所有 ROLES
-- 列出 users 可以適用於哪些 roles
-- 列出整個 DB 總共建立了哪些 Roles 及 roles 架構, 並且列出 Roles 及 Users 的 mapping
-- 分別指令:
SELECT user FROM mysql.user WHERE is_role='Y';
SELECT * FROM information_schema.applicable_roles;
SELECT * FROM mysql.roles_mapping;

-- 切換 ROLE (需先切換到該 User)
SET ROLE NONE;   -- 切換到 default Role
SET ROLE qateam; -- 切換到 qateam Role
