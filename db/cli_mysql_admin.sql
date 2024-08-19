-- MariaDB - Admin SQL Statements
--      https://mariadb.com/kb/en/administrative-sql-statements/
-- 
-- ================================= admin =================================
-- Create user && grant prives
CREATE USER 'sre' @'%' IDENTIFIED BY '我是密碼';


-- 修改密碼
UPDATE mysql.user SET authentication_string = PASSWORD('我是密碼') WHERE User = 'root' AND Host = '127.0.0.1';
FLUSH PRIVILEGES;

SELECT USER, HOST FROM mysql.user;

SELECT USER(), CURRENT_USER();

SHOW GRANTS for root@localhost;

CREATE USER 'zabbix'@'*' IDENTIFIED BY '我是密碼';
GRANT ALL PRIVILEGES on zabbix.* to zabbix@localhost;

CREATE USER zabbix@localhost IDENTIFIED BY '我是密碼';
GRANT SELECT, PROCESS, FILE, REPLICATION CLIENT ON *.* TO zabbix@localhost;


-- dev user
CREATE USER 'app'@'%' IDENTIFIED BY '我是密碼';
GRANT ALL PRIVILEGES on *.* to tony@'%';
SHOW GRANTS for tony@'%';


-- 修改密碼
SET PASSWORD FOR 'zabbix'@'localhost' = PASSWORD('我是密碼');
FLUSH PRIVILEGES;
SHOW GRANTS for zabbix@localhost;

-- ================================= monitoring =================================