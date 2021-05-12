
# Docker 自學筆記

- [官方](https://docs.docker.com/engine/reference/builder/#usage)
- [Docker 網路架構](https://github.com/docker/libnetwork/blob/master/docs/design.md)
- [Docker daemon.json - 寫得還不錯](https://blog.csdn.net/u013948858/article/details/79974796)

```bash
### 2020/04/06 的今天, 目前為 19.03 版, 底下可看離線教學文件
$# docker run --rm -p 4000:4000 --name doc docs/docker.github.io:latest
```


> Docker 使用 `storage drivers` 來管理 `image layers` 及 `writable container layer` 的內容. 然而各種 `drivers` 實作方式不同, 但都使用 `stackable image layers` 及 `copy-on-write(CoW)策略`.


# 1. Docker Command

## 指令

```sh
$ docker run -d --name nginx nginx

# 查看 Container 內的 IP Address(查Container的IP)
$ docker inspect --format '{{ .NetworkSettings.IPAddress }}' nginx
172.17.0.2

# 用 Image: busybox 建立 Container: foo, 指定他的 host為 foobar, 並執行 "sleep 300"的指令
$ docker run -d --name foo -h foobar busybox sleep 300

# 查看 運行中的 Container: foo, 並查看他的 foobar這個 host的 相關資訊
$ docker exec -it foo cat /etc/hosts | grep foobar
172.17.0.2	foobar

# 依照本地的 dockerfile建立名為 flask 的 image
$ docker build -t flask .

# 查看 foobar Container的 5000 port資訊
$ docker port foobar 5000
0.0.0.0:32768

# 建立並執行 Container: nginx, 並且查看本機端的 iptables
$ docker run -d -p 5000/tcp -p 53/udp --name nginx nginx
$ sudo iptables -L
...(一堆)...
Chain DOCKER (2 references)
target    prot opt source      destination
ACCEPT    tcp  --  anywhere    172.17.0.2     tcp dpt:commplex-main
ACCEPT    udp  --  anywhere    172.17.0.2     udp dpt:domain
...(一堆)...
```

```sh
# Container 複製到 Host
$ docker cp testcopy:/root/file.txt .

# Host 複製到 Container
$ docker cp host.txt testcopy:/root/host.txt
```

```sh
# 追 Container 異動紀錄
$ docker diff <Container>
# A: 增
# C: 改
# D: 刪
```


# 分享 Containers

- 使用 `save` and `load`, image <-> tarball
- 使用 `import` and `export`, container <-> tarball

```sh
### import && export
$ docker ps -a
CONTAINER ID    IMAGE           COMMAND                  CREATED        STATUS              PORTS      NAMES
9eac4abf6565    redis:3.2.12    "docker-entrypoint.s…"   11 days ago    Exited 1 days ago   6379/tcp   redis
# ↑ 9eac

# 使用 docker export 匯出成 tarball
$ docker export 9eac > aa.tar

# tarball 還原 Image
$ docker import - aaimage < aa.tar
sha256:c1d29501022185ede31996c72336e71f57fcbb4b9e4c964f0bb6c332eb0612be

$ docker images
REPOSITORY     TAG       IMAGE ID        CREATED          SIZE
aaimage        latest    c1d295010221    6 minutes ago    73.4MB
redis          3.2.12    2fef532eadb3    5 weeks ago      76MB


### save && load
$ docker images
REPOSITORY    TAG      IMAGE ID        CREATED         SIZE
redis         3.2.12   2fef532eadb3    5 weeks ago     76MB
# Image ID: 2fef

$ docker save -o aa.tar 2fef
$ ls
aa.tar

$ docker rmi 2fef
$ docker images
REPOSITORY    TAG      IMAGE ID        CREATED         SIZE

$ docker load < aa.tar
$ docker images
```


## 操作 Container
```sh
# 快速離開 Container (但不結束)
# <Ctrl+p> + <Ctrl+q>
```


## [dockerd 組態](https://docs.docker.com/engine/reference/commandline/dockerd/)
- 2018/06/19

os      | default config file path
------- | -----------
Windows | %programdata%\docker\config\daemon.json
Linux   | /etc/docker/daemon.json



- 每個運行在 service內的單一 container, 都稱為 **task**, 且每個 task都有專屬的 **task id**

```

6. 查看 load-balance的威力~~~, 每次進入的 container都不同!!
- 如果反應時間太久(可能達數十秒), 並不表示 container效能問題, 而是未能滿足 REDIS的依賴關係(後面會談到)
- 底下出現的 `counter disabled`, 是因為服務內, 還沒有儲存數據的機制
- Linux terminal, 要用 `curl -4`, 原理不懂... 單純 `curl` 抓不到orz
```sh
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> e7d33737b65f<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> 1e61d9e996b0<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> f93397cceb7b<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> dc42c0ebc7af<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> e0008228c4f9<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
```

7. 調整 scale
- 去修改前面建立的 `docker-compose.yml`
- 重新執行 `docker stack deploy -c docker-compose.yml getstartedlab` 即可, 不需要手動刪除或重起任何 container
- 可以在運行期間, 修改 `docker-compose.yml`, 並且重新執行 `docker stack deploy`的指令, 變可在生產途中作 scale outdock.


8. 關閉服務  && 關閉 swarm
> 關閉 app語法: `docker stack rm <app名稱>`
```sh
$ docker stack rm getstartedlab
Removing service getstartedlab_web
Removing network getstartedlab_webnet
```
> 關閉 swarm
```sh
$ docker swarm leave --force
Node left the swarm.
```


# 3. Dockerfile Examples

#### 範例 - Flask起 Server
- [官方範例](https://docs.docker.com/get-started/part2/#dockerfile)
- 2017/12/07

> 先建立 3個檔案, 再建立 Image

1. dockerfile
```dockerfile
FROM python:2.7-slim
WORKDIR /app
ADD . /app
RUN pip install --trusted-host pypi.python.org -r requirements.txt
EXPOSE 80
ENV NAME World
CMD ["python", "app.py"]
```

2. requirement.txt
```
Flask
Redis
```

3. app.py
```py
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

4. run
```sh
$ ls
app.py  requirements.txt  dockerfile

$ docker build .

$ docker images
REPOSITORY    TAG         IMAGE ID        CREATED           SIZE
<none>        <none>      c8d0def6863d    28 seconds ago    148MB
python        2.7-slim    4fd30fc83117    7 weeks ago       138MB
# 因為並沒有指定建立的 Image的名稱..., 所以只有 Image ID

$ docker run -p 4000:80 c8d0
```


## Volume 使用方式

```sh
# 建立Container後, 獨立建立 Container Volume
$ docker run -it --name os7A -v /data ubuntu14.04 /bin/bash
root@7c49:/$# touch /data/foobar
root@7c49:/$# ls data/
foobar
root@7c49:/$# exit

# 查看 Volume
$ docker inspect -f {{.Mounts}} 7c49
[{volume b8e1ff
/var/lib/docker/volumes/b8e1ff/_data /data local  true }]

# 使用別的 Volume
$ docker run -it --volumes-from os7A --name os7B ubuntu14.04 /bin/bash
root@895f:/$# ls /data
foobar
```


### 用字遣詞:

```bash
#### Example
docker run -it --name vol-test -h CONTAINER -v /data debian /bin/bash
# Docker has mounted /data inside the container as a directory somewhere under /var/lib/docker

#### Example
docker volume create --name my-vol
docker run -d -v my-vol:/data debian 
# This example will mount the my-vol volume at /data inside the container.

#### Example
docker run -v /home/adrian/data:/data debian ls /data
# Will mount the directory /home/adrian/data on the host as /data inside the container
```


### boot2docker

```sh
# 使用 Docker Machine 後, 裏頭的 Docker
$ boot2docker init

# 升級 Docker Machine 內的 Docker version
$ boot2docker stop
$ boot2docker upgrade
$ boot2docker start
```


# 5. 知識

## 定義Docker容器如何在生產中運行的文件: yml
docker-compose.yml 範例
```yml
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
networks:
  webnet:
```


### 額外備註

在 `centos:7` 的 docker image內, 編譯 git 時, 因為缺乏許多套件, 發生下列錯誤

```sh
### Problem
$# make
    * new build flags
    CC credential-store.o
In file included from credential-store.c:1:0:
cache.h:42:18: fatal error: zlib.h: No such file or directory
 #include <zlib.h>
                  ^
compilation terminated.
make: *** [credential-store.o] Error 1

### Solution
$# yum install zlib-devel
```


# Useful docker CLI

> `docker inspect -f`: 可使用 Golang 的範本來提取資訊

```bash
$# docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          8         0         2.488GB   2.488GB (100%)
Containers      0         0         0B        0B
Local Volumes   0         0         0B        0B
Build Cache     0         0         0B        0B

$# docker inspect -f '{{.NetworkSettings.IPAddress}}' myredis
172.17.0.2

# 查看容器, 啟用了那些 process
$# docker exec mypg ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
postgres     1  0.0  0.2 330360 41176 ?        Ss   Mar24   2:16 postgres
postgres    25  0.0  0.8 330920 139896 ?       Ss   Mar24   1:27 postgres: checkpointer
postgres    26  0.0  0.8 330620 138256 ?       Ss   Mar24   4:49 postgres: background writer
# ...(超多)...f
```
