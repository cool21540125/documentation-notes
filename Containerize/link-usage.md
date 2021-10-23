## 使用 --link 來連結各個 Container
- Docker Cookbook - 3.3 Linking Containers in Docker
- [Dockerfile (Windows寫法)](https://blog.yowko.com/2017/09/windows-dockerfile-volume.html)
- 2018/05/22

> `--link <container_name>:<alias>` alias存在於 **/etc/host/** && 被當成 已定義好的環境變數的 prefix

目標: 建立有 Database 及 Load-Balance 的 Web application

作法: 起始一個 db, 再起一個web app, 把它連結到 db, 再起一個 load-balancer, 連到 web app


```sh
# 建立 db的 Container
$ docker run -d --name db -e MYSQL_ROOT_PASSWORD=root mysql:5.7
# -e 用來設定環境變數

# 建立 web的 Container
$ docker run -d --link database:db --name web runseb/hostname
# 把 Container: database(取名為 db) 與 Container: web連起來
# runseb/hostname是個僅回傳 hostname的 Flask Image

# 建立 Load-Balance的 Container
$ docker run -d --link web:application --name lb nginx
# 把 Container: web(取名為 application)

$ docker ps
CONTAINER ID  IMAGE            COMMAND                 CREATED         STATUS         PORTS     NAMES
253702a38ff3  nginx            "nginx -g 'daemon of…"  9 minutes ago   Up 9 minutes   80/tcp    lb
ede066e22ba0  runseb/hostname  "python /tmp/hello.py"  10 minutes ago  Up 10 minutes  5000/tcp  web
a093b04fce54  mysql            "docker-entrypoint.s…"  13 minutes ago  Up 13 minutes  3306/tcp  database

# 查詢 Container裡頭的 env (好像不是'環境變數'的概念...)
$ docker exec -it web env | grep DB
DB_PORT=tcp://172.17.0.2:3306
DB_PORT_3306_TCP=tcp://172.17.0.2:3306
DB_PORT_3306_TCP_ADDR=172.17.0.2
DB_PORT_3306_TCP_PORT=3306
DB_PORT_3306_TCP_PROTO=tcp
DB_NAME=/web/db
DB_ENV_MYSQL_ROOT_PASSWORD=root     # 環境變數
DB_ENV_GOSU_VERSION=1.7
DB_ENV_MYSQL_MAJOR=5.7
DB_ENV_MYSQL_VERSION=5.7.21-1debian9

$ docker exec -it lb env | grep APPLICATION
APPLICATION_PORT=tcp://172.17.0.3:5000
APPLICATION_PORT_5000_TCP=tcp://172.17.0.3:5000
APPLICATION_PORT_5000_TCP_ADDR=172.17.0.3
APPLICATION_PORT_5000_TCP_PORT=5000
APPLICATION_PORT_5000_TCP_PROTO=tcp
APPLICATION_NAME=/lb/application

# 用指令送到 Container內查詢 /etc/hosts相關資訊
$ docker exec -it database cat /etc/hosts   # Container: database
172.17.0.2	a093b04fce54                    #  172.17.0.2

$ docker exec -it web cat /etc/hosts        # Container: web
172.17.0.2	db a093b04fce54 database        # 172.17.0.2 -> database
172.17.0.3	ede066e22ba0                    # 172.17.0.3 -> web

$ docker exec -it lb cat /etc/hosts         # Container: lb
172.17.0.3	application ede066e22ba0 web    # 172.17.0.3 -> web
172.17.0.4	253702a38ff3                    # 172.17.0.4 -> lb

# 回傳 「已建立連結的 Container」及「已建立連結的 Container的別名」在 Container內的對應關係
$ docker inspect -f "{{.HostConfig.Links}}" web
[/database:/web/db]

$ docker inspect -f "{{.HostConfig.Links}}" lb
[/web:/lb/application]
```