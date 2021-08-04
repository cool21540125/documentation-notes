# MySQL in Docker

- [MySQL各種Ports的介紹](https://dev.mysql.com/doc/mysql-port-reference/en/mysql-ports-reference-tables.html)

```bash
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=abcd1234 -p 3306:3306 mysql:5.7
```