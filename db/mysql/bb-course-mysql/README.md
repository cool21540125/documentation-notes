

```bash
### 課程使用的 Sample DB Volume
docker volume create --name bb-course-data
# 設定密碼後, 密碼已預設儲存在 volume 裏頭


### 
docker compose up -d
docker exec -it bb-course-mysql bash
mysql -uroot -p
# password

use mydb;
```


# Note

- Unix 的 Database Name 及 Table Name 皆為 case-sensitive
