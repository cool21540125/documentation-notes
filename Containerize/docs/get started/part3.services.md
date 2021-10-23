# Part3 - Services
- [Services](https://docs.docker.com/v17.09/get-started/part3/)
- 2017/12/17
- 2020/05/14 Updated

##### 1. [Orientation ](./part1.orientation.md)
##### 2. [Containers](./part2.containers.md)
### 3. [Services](./part3.services.md)
##### 4. [Swarms](./part4.swarm.md)
##### 5. [Stacks](./part5.stacks.md) 
##### 6. [Deploy your app](./part6.deploy.md)

---

本章, 要開始談 Service這鬼東西, 另外會舉例用 docker實作 load-balance

為了作到 load-balance, 我們得把自己看系統架構的層級提高~~
- Stack
- Services (我們在這, 以這邊的視野, 來操控 Container)
- Container (in part 2)


---

開始之前, 由於我是 Linux, 所以需要額外安裝 [Compose](https://docs.docker.com/compose/overview/)

(( 安裝完後想刪除 Compose, 自己到官網看說明囉~ [Install Docker Compose](https://docs.docker.com/compose/install/#uninstallation) ))

```sh
# 1. 下載 Compose
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 2. 給目前使用者執行 docker-compose的權限
$ sudo chmod +x /usr/local/bin/docker-compose

# 3. 安裝 Bash completion (可不安裝)
# 我就懶得安裝了...

# 4. 看看版本~
$ docker-compose --version
docker-compose version 1.25.3, build d4d1b42b
```

寫 `docker-compose.yml`
> 說明: 這東西定義了 Container該如何執行 && 資源配置方式等 <br />
  `.yml`檔, # 後頭為註解
```yml
version: "3"
services:
  web:    # 服務為 web
    # replace <username>/<repo>:<tag> with your name and image details
    image: cool21540125/firstrepo:1.0    # 從指定的 repo pull image
    deploy:
      replicas: 5     # 執行 5個 instance
      resources:
        limits:
          cpus: "0.1"   # 每個 instance最多只能使用道每個 CPU的 10%
          memory: 50M   # 每個 instance最多只能使用 50M的 RAM
      restart_policy:
        condition: on-failure   # 若其中一個 instance失敗, 該 instance立刻重啟
    ports:
      - "80:80"   # 開放 80 port(前) 映射到 container的 80 port(後)
    networks:
      - webnet    # 指示 web container透過具有 load-balanced的 network(稱為webnet), 來共同使用 80 port
networks:
  webnet:   # 使用預設的 webnet(具有 load-balanced overlay network)
```


> 實作 load-balance <br />
  語法: `docker stack deploy -c <compose file名稱> <app名稱>` <br />

```sh
# 進入 swarm mode && 讓本電腦成為 swarm manager 
$ docker swarm init
Swarm initialized: current node (c2lalqhoqull7m9noj8534sto) is now a manager.
To add a worker to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-1l23c7kapy9...(略)...rxspxk3 192.168.1.121:2377
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
# 日後可以使用 `docker swarm join`來加入其他機器到 swarm worker

# 在本地執行一個服務, 服務名稱為 getstartedlab
$ docker stack deploy -c docker-compose.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_web

# 上面指令啟動的服務, 一口氣啟動了 5個 Container
$ docker service ls
ID              NAME                MODE          REPLICAS    IMAGE                        PORTS
43m6gvn1rbd8    getstartedlab_web   replicated    5/5         cool21540125/firstrepo:1.0   *:80->80/tcp
# Service ID為 43m6gvn1rbd8

# 一個服務若僅執行單一Container, 稱為 task, 每個 task都會有它自己的 Service ID.
$ docker service ps getstartedlab_web
ID            NAME                 IMAGE                       NODE    DESIRED STATE   CURRENT STATE           ERROR    PORTS
pw98wiilku9n  getstartedlab_web.1  cool21540125/firstrepo:1.0  tonynb  Running         Running 32 minutes ago
vq80qtwgbkl1  getstartedlab_web.2  cool21540125/firstrepo:1.0  tonynb  Running         Running 32 minutes ago
s3syxvlnf8r5  getstartedlab_web.3  cool21540125/firstrepo:1.0  tonynb  Running         Running 32 minutes ago
ijhli2eslivg  getstartedlab_web.4  cool21540125/firstrepo:1.0  tonynb  Running         Running 32 minutes ago
tp4eyh8um1ig  getstartedlab_web.5  cool21540125/firstrepo:1.0  tonynb  Running         Running 32 minutes ago

$ docker container ls -q
ad1db85b5fd1
ad79e1829e18
eeae7322c56e
1f70a5ff06b6
5ffe3070fc00
```

Load-Balance的威力!! (底下的指令可以多執行幾次)
> 每次進入的 Container都不同!! <br />
> 如果反應時間太久(可能達數十秒), 並不是 Container或電腦效能問題, 而是 Container未能滿足 REDIS的依賴關係 (part 5會談到). <br />
> 底下出現的 `counter disabled` 是因為服務內, 還沒有儲存數據的機制<br />
> Linux terminal, 要用 `curl -4`, 原理不懂... 單純 `curl` 抓不到orz 
```sh
$ curl -4 http://localhost
<h3>Hello World!</h3><b>Hostname:</b> ad79e1829e18<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
$ curl -4 http://localhost
...(略) eeae7322c56e (略)...
$ curl -4 http://localhost
...(略) 5ffe3070fc00 (略)...
$ curl -4 http://localhost
...(略) 5ffe3070fc00 (略)...
```

---

指令備註
```sh
$ docker stack ls                               # 列出 所有的 stack or app(Swarm Manager的指令)
$ docker service ls                             # 列出 所有執行中的 stack or app(Swarm Manager的指令)

$ docker service ps <Service ID>                # 例出 某個服務底下的 tasks

$ docker inspect <task or container>            # 列出 task or container詳細資訊(非常多東西)

$ docker ps -q
$ docker container ls -q                        # 顯示所有 Container ID

$ docker stack rm <Service ID>                  # 砍掉 任一 的 docker服務
$ docker service rm <Service ID>                # 砍掉 任一執行中 的 docker服務

$ docker swarm leave --force                    # 拿掉單一節點的 swarm
```


# 疑難排解
```bash
$# vim /etc/docker/daemon.json
# 把 live-restore 改為 false
# 如此才可使用 docker swarm init || docker swarm join

### 發生以下問題, 很有可能是 Server 時間跑掉了
$# docker swarm join --token XXXXXXX 1.2.3.4:2377
Error response from daemon: error while validating Root CA Certificate: x509: certificate has expired or is not yet valid
# 另外, master 記得開 port

$# yum install -y chrony
$# systemctl start chronyd
$# systemctl enable chronyd
$# chronyc sources -v
```
