
# Docker 自學筆記

- [官方](https://docs.docker.com/engine/reference/builder/#usage)
- [Docker 網路架構](https://github.com/docker/libnetwork/blob/master/docs/design.md)
- [Docker daemon.json - 寫得還不錯](https://blog.csdn.net/u013948858/article/details/79974796)

```bash
### 2020/04/06 的今天, 目前為 19.03 版, 底下可看離線教學文件
$# docker run --rm -p 4000:4000 --name doc docs/docker.github.io:latest
```


> Docker 使用 `storage drivers` 來管理 `image layers` 及 `writable container layer` 的內容. 然而各種 `drivers` 實作方式不同, 但都使用 `stackable image layers` 及 `copy-on-write(CoW)策略`.


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


- 每個運行在 service內的單一 container, 都稱為 **task**, 且每個 task都有專屬的 **task id**


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
