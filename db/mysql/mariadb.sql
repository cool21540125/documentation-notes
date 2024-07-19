
--#; 修改密碼
UPDATE mysql.user SET authentication_string = PASSWORD('zabbix') WHERE User = 'root' AND Host = '127.0.0.1';
FLUSH PRIVILEGES;

SELECT USER, HOST FROM mysql.user;

SELECT USER(), CURRENT_USER();

SHOW GRANTS for root@localhost;

CREATE USER 'zabbix'@'*' IDENTIFIED BY 'myadmin';
GRANT ALL PRIVILEGES on zabbix.* to zabbix@localhost;

CREATE USER zabbix@localhost IDENTIFIED BY 'monitoring';
GRANT SELECT, PROCESS, FILE, REPLICATION CLIENT ON *.* TO zabbix@localhost;

--#; 建立 zabbix 用戶
UPDATE mysql.user SET authentication_string = PASSWORD('zabbix') WHERE User = 'zabbix' AND Host = 'localhost';
--#; ↑ 不知道為什麼, 這個失敗
FLUSH PRIVILEGES;
SHOW GRANTS for zabbix@localhost;


--#; dev user
CREATE USER 'tony'@'%' IDENTIFIED BY '傻瓜才會複製貼上';
GRANT ALL PRIVILEGES on *.* to tony@'%';
SHOW GRANTS for tony@'%';


--#; 修改密碼
SET PASSWORD FOR 'zabbix'@'localhost' = PASSWORD('zabbix');
FLUSH PRIVILEGES;
SHOW GRANTS for zabbix@localhost;
