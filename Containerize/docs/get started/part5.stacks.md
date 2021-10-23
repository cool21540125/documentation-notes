# [Part5 - Stack](https://docs.docker.com/v17.09/get-started/part5/)
- 2017/12/20 ~ 2018/01/05 (有點混阿...)

##### 1. [Orientation ](./part1.orientation.md)
##### 2. [Containers](./part2.containers.md)
##### 3. [Services](./part3.services.md)
##### 4. [Swarms](./part4.swarm.md)
### 5. [Stacks](./part5.stacks.md) 
##### 6. [Deploy your app](./part6.deploy.md)

---

### Prerequest:
- 安裝好 Docker
- 安裝好 Docker Compose
- 安裝好 Docker Machine
- 讀完 part1 ~ part4
- 如 part2, 已經建立好 Docker image - friendlyhello, 且以上傳到 Registry
- 如 part4, 正在運行一個 Container `docker run -p 80:80 cool21540125/firstrepo:1.0`
- 如 part4, 稍早建立好的東西正在運行 `docker-machine ls`, 如果已經關掉了, 啟動: `docker-machine start myvm1` && `docker-machine start myvm2`
- 如 part3, 已經建立好 docker-compose.yml
- 如 part4, 已經建立好 Swarm, 且正在運行中, 執行: `docker-machine ssh myvm1 "docker node ls"`

---
### Introduction
從 part4已經知道, swarm這東西就是 一堆執行中的 Container綁成一包來執行一個 Docker Cluster.

此章節要講的是 Stack層級, Stack是一堆相互依賴並且共存的服務的集合. 此 Stack可以很彈性的作擴展及收縮.

單一 Stack其實也可以作整個應用程式的功能

如同 part3所提過, 建立好 compile.yml檔後, 執行 `docker stack deploy`, 這個結果是在本地端執行單一 Stack.

本章節將學會, 如何在多台機器上, 運行多個服務.

```yml
version: "3"
services:
  web:
    image: cool21540125/firstrepo:1.0
    deploy:
      replicas: 5
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50Mb
    ports:
      - "80:80"
    networks:
      - webnet
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
networks:
  webnet:
```

底下只是在作前面章節作過的 啟動 docker-machine...
```sh
$ docker-machine start myvm1
$ docker-machine start myvm2
$ docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.99.100"
# myvm1變成 Docker Swamr的 manager了

$ docker-machine ssh myvm2 "docker swarm join \
--token SWMTKN-1-4g543816l8jhry13seiqiu16s4kkf5hxt8s2n0kw6usxgxrtgn-367mrp4d441mr2kx9tw62nka7 192.168.99.100:2377"
# myvm2加入了 myvm1為首的 Swarm的 worker了

$ eval $(docker-machine env myvm1)
# 讓後面的指令在 myvm1裡頭作用

# 移動到存有 `docker-compose.yml`中的資料夾, 依照組態, 建立服務
$ docker stack deploy -c docker-compose.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_visualizer
Creating service getstartedlab_web
# 可能花上1分鐘吧... 但有時候會跑到當掉T_T...

$ docker service ls
ID             NAME                      MODE         REPLICAS   IMAGE                            PORTS
t30pb9pgvph6   getstartedlab_visualizer  replicated   0/1        dockersamples/visualizer:stable  *:8080->8080/tcp
q1tip5jatk9g   getstartedlab_web         replicated   5/5        cool21540125/firstrepo:1.0       *:80->80/tcp
```

接著, 打開瀏覽器, 進入 http://192.168.99.100:8080/
就可以看到一堆 container起起來的界面了

```sh
$ docker stack ps getstartedlab
ID            NAME                        IMAGE                            NODE   DESIRED STATE  CURRENT STATE                ERROR   PORTS
dvyjv63d28cg  getstartedlab_visualizer.1  dockersamples/visualizer:stable  myvm1  Running        Running about a minute ago
w07pd1uwyax9  getstartedlab_web.1         cool21540125/firstrepo:1.0       myvm2  Running        Running about a minute ago
ghz75r2i41it  getstartedlab_web.2         cool21540125/firstrepo:1.0       myvm1  Running        Running about a minute ago
t4yad886mkje  getstartedlab_web.3         cool21540125/firstrepo:1.0       myvm2  Running        Running about a minute ago
bo32olkmwz2j  getstartedlab_web.4         cool21540125/firstrepo:1.0       myvm1  Running        Running about a minute ago
xdxa2m0oc6jm  getstartedlab_web.5         cool21540125/firstrepo:1.0       myvm2  Running        Running about a minute ago
# 除了進入網頁裡面看以外, 也可單純使用 CLI來看 docker machine的 service啟動狀況
```

---

## 增加 Redis
上頭算是告一個段落, 由於 Container內的東西, 會隨著 Container的關閉而消失... 現在希望把 DB內的資料保存下來

建立另外一個 YML檔, 我取名為 `docker-compose2.yml`
```yml
version: "3"
services:
  web:
    image: cool21540125/firstrepo:1.0
    deploy:
      replicas: 5
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
    ports:
      - "80:80"
    networks:
      - webnet
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
  redis:
    image: redis
    ports:
      - "6379:6379"       # Redis官方預設 port為 6379
    volumes:
      - /home/docker/data:/data   # 在 Container內, 資料存在 /data, 而實際資料, 會存到本機中
    deploy:
      placement:
        constraints: [node.role == manager]     # Redis永遠只能存活在 manager
    command: redis-server --appendonly yes
    networks:
      - webnet
networks:
  webnet:
```

利用新的 YML, 重新部屬 Stack
```sh
# 先前已經建立過 Stack, 此次利用不同的 compose檔, 來重新建立 Stack
$ docker stack deploy -c docker-compose2.yml getstartedlab
Updating service getstartedlab_visualizer (id: v86w97lh59w6cz8im0rpb1buf)
Creating service getstartedlab_redis
Updating service getstartedlab_web (id: ff39xtqspik6315mkpqsc6c4g)

$ docker service ls
ID            NAME                      MODE        REPLICAS  IMAGE                            PORTS
b0r913t0sb8w  getstartedlab_redis       replicated  1/1       redis:latest                     *:6379->6379/tcp
v86w97lh59w6  getstartedlab_visualizer  replicated  1/1       dockersamples/visualizer:stable  *:8080->8080/tcp
ff39xtqspik6  getstartedlab_web         replicated  5/5       cool21540125/firstrepo:1.0       *:80->80/tcp
```

進去看看吧!! [Web Application](http://192.168.99.101)

Redis in Stack, 成功!
