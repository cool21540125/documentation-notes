
- [DockerHub-mysql](https://hub.docker.com/_/mysql)

```bash

docker run -d \
    --restart always \
    --name mysql \
    --hostname mysql57 \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    mysql:5.7
```


# env

```env
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=

MYSQL_ROOT_PASSWORD_FILE=./secret_file
```


# entrypoint

Docker Image `mysql:5.7` 預設啟動方式為 `docker-entrypoint.sh mysqld`