# Install MariaDB by Docker

- 2020/03/27
- [Docker-MariaDB](https://hub.docker.com/_/mariadb)


```bash
### 2020/03/27 的今天, latest 為 10.4.12
### 2020/01/29 的今天, latest 為 10.5.8
$# docker pull mariadb:10.5.8

MYSQL_ROOT_PASSWORD=1qaz@WSX

$# docker run -d \
    --name maria \
    -p 3307:3306 \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    mariadb:10.5.8

ALTER USER 'zabbix'@'%' BY '5tgb^YHN';

d rm --force maria

CREATE DATABASE zabbix;
CREATE USER 'zabbix'@'%' IDENTIFIED BY '5tgb^YHN';
GRANT ALL PRIVILEGES on zabbix.* to 'zabbix'@'%';
```
