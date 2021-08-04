
```env
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=

MYSQL_ROOT_PASSWORD_FILE=./secret_file
```

```bash
docker run -d \
    --name mysql57 \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=1qaz@WSX \
    mysql:5.7
```