# Ch9  - Configuring MariaDB Databases

## install

```sh
# 安裝 Mariadb
yum groupinstall -y mariadb mariadb-client

# 啟動
systemctl start mariadb

# 防火牆
firewall-cmd --add-service mysql

# 強化 Mariadb 安全性
mysql_secure_installation

# 設定檔
vim /etc/my.cnf

# 連線 Socket
ll /var/lib/mysql/mysql.sock

# 查看服務連線提供狀況
ss      -tulnp | grep mysql
netstat -tulnp | grep mysql

# 關閉 Mariadb Socket 連線(連 127.0.0.1 都不行)
echo '[mysqld]' >> /etc/my.cnf
echo 'skip-networking=1' >> /etc/my.cnf
```

## user && privileges

```mysql
CREATE USER user@localhost IDENTIFIED BY 'centos';

GRANT INSERT, DELETE, SELECT, UPDATE on DB.TABLE TO user@localhost;

FLUSH PRIVILEGES;
```

## backup && restore

```sh
# 備份
mysql -u root db3 > /tmp/db3.dump

# 還原
mysql -u root db3 < /tmp/db3.dump
```

