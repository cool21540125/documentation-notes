# [Part4 - Swarms](https://docs.docker.com/v17.09/get-started/part4/)
- 2017/12/29

##### 1. [Orientation ](./part1.orientation.md)
##### 2. [Containers](./part2.containers.md)
##### 3. [Services](./part3.services.md)
### 4. [Swarms](./part4.swarm.md)
##### 5. [Stacks](./part5.stacks.md) 
##### 6. [Deploy your app](./part6.deploy.md)

---

### Prerequest:
- 安裝好 Docker
- 安裝好 Docker Compose
- 安裝好 [Docker Machine](./dockerMachine.md)
- 以讀完 part1~part3
- 如 part2, 已經建立好 Docker image - friendlyhello, 且以上傳到 Registry
- 如 part2, 正在執行剛建好的 Container, 執行指令備註: `docker run -p 80:80 cool21540125/firstrepo:1.0`
- 如 part3, 已經建立好 docker-compose.yml


本章, 要開始談 Service這鬼東西, 另外會舉例用 docker實作 load-balance

為了作到 load-balance, 我們得把自己看系統架構的層級提高~~
- Stack
- Services (我們在這了~~)
- Container (in part 2)


---

開始之前, 由於我是 Linux, 所以需要額外安裝 Compose

(( 安裝完後想刪除 Compose, 自己到官網看說明囉~ [Install Docker Compose](https://docs.docker.com/compose/install/#uninstallation) ))

```sh
# 1. 下載 Compose
$ sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# 2. 允許目前使用者執行
$ sudo chmod +x /usr/local/bin/docker-compose

# 3. 安裝 Bash completion (可不安裝)
# 我就懶得安裝了...

# 4. 看看版本~
$ docker-compose --version
docker-compose version 1.17.0, build ac53b73
```

---

要開始模擬 docker cluster, 模擬方式採用 VM

建立 docker Virtual-Machine
```sh
# 建立 docker-machine
$ docker-machine create --driver virtualbox myvm1       # 建立第1台 VM
Running pre-create checks...
Creating machine...
(myvm1) Copying /home/tonynb/.docker/machine/cache/boot2docker.iso to /home/tonynb/.docker/machine/machines/myvm1/boot2docker.iso...
(myvm1) Creating VirtualBox VM...
(myvm1) Creating SSH key...
(myvm1) Starting the VM...
(myvm1) Check network to re-create if needed...
(myvm1) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
.Detecting the provisioner...
Provisioning with boot2docker...
1Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env myvm1

$ docker-machine create --driver virtualbox myvm2       # 建立第2台 VM
# 提示訊息同上, 此略

$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376          v17.09.1-ce
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376          v17.09.1-ce
```

> 指定 docker VM啟動 swarm, 並成為 **swarm manager** <br />
  語法: `docker-machine ssh <VM Name> "docker swarm init --advertise-addr <docker VM的 ip>"`

> 指定 docker VM裡的 **swarm manager**, 增加 **swarm worker** <br />
  語法: `docker-machine ssh myvm2 "docker swarm join --token <啟動 swarm init的 token> <docker VM的 IP>:2377"`
```sh
# 啟動 Swarm (這台 docker VM會自動成為 Swarm Manager)
$ docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.99.100"
Swarm initialized: current node (osegh4bhtk25wbzugieg9qck9) is now a manager.
To add a worker to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-3x34nxl3s7ljrq8z30ppgfdf5kzjowuq5u696gsqlb9ya3bce0-3ef8c24650bc863byqj8irwxh 192.168.99.100:2377
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

# 增加 Swarm Worker
$ docker-machine ssh myvm2 "docker swarm join \
--token SWMTKN-1-3x34nxl3s7ljrq8z30ppgfdf5kzjowuq5u696gsqlb9ya3bce0-3ef8c24650bc863byqj8irwxh \
192.168.99.100:2377"
This node joined a swarm as a worker.
```
> 官方建議: 使用 `docker swarm init`及 `docker swarm join`時, 永遠使用預設 port **2377**<br />
  2377 port為 swarm manager port

> 若使用 `docker-machine ls`, VM IP會回傳 **2376 port**, 此為 Docker daemon port. 勿用此 IP, 以免發生錯誤.

> 備註: 若 ssh發生問題, 使用 `docker-machine --native-ssh ssh myvm1 ...`, 詳情參考官方說明



```sh
# 查看 myvm1這台 Swarm Manager為首的 Swarm Nodes
$ docker-machine ssh myvm1 "docker node ls"
ID                            HOSTNAME    STATUS      AVAILABILITY    MANAGER STATUS
osegh4bhtk25wbzugieg9qck9 *   myvm1       Ready       Active          Leader
d0z2empg8l9mgwp4tj9zea3ba     myvm2       Ready       Active
```

## 在 Swarm Cluster部署 app


前面部份, 如果要與 swarm溝通, 都必須使用

`docker-machine ssh <VM Name>` `"<寫死的指令字串>"`

有點不方便, 而我們可以利用另一種方法來對 swarm下指令!! (這裡看不太懂阿@@~~~)
> 語法: `docker-machine env <VM Name>`, 取得 < VM Name> 的組態命令

```sh
# 取得「讓 shell配置為與 myvm1溝通的狀態」的命令
$ docker-machine env myvm1
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/home/tonynb/.docker/machine/machines/myvm1"
export DOCKER_MACHINE_NAME="myvm1"
# Run this command to configure your shell:
# eval $(docker-machine env myvm1)

# 使用前
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376           v17.09.1-ce
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.09.1-ce

# 執行此後, 表示已將 shell配置為可與 myvm1溝通的狀態了
$ eval $(docker-machine env myvm1)
# 離開的話使用 eval $(docker-machine env -u)

# 此時, 已經進入 myvm1這台虛擬機的 shell操作環境了
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   *        virtualbox   Running   tcp://192.168.99.100:2376           v17.09.1-ce
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.09.1-ce
# *為下此指令的機器, 同時也是 swarm manager
```

### Deploy the app on the swarm manager

```sh
# 接續上步, 在 Swarm Manager內, 使用本地已配置好的 compose.yml來套用至 在 VM內部署 cluster
$ docker stack deploy -c docker-compose.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_web
# 依照先前在本地端定義好的 yml, 於 myvm1及 myvm2內, 建立服務

$ docker-machine ssh myvm1 'docker container ls'
CONTAINER ID    IMAGE                        COMMAND           CREATED          STATUS           PORTS     NAMES
5595ad860113    cool21540125/firstrepo:1.0   "python app.py"   10 minutes ago   Up 10 minutes    80/tcp    getstartedlab_web.2.qf...(略)...h4h
0e204d428004    cool21540125/firstrepo:1.0   "python app.py"   10 minutes ago   Up 10 minutes    80/tcp    getstartedlab_web.4.hp...(略)...al3
d97d17dcb83b    cool21540125/firstrepo:1.0   "python app.py"   10 minutes ago   Up 10 minutes    80/tcp    getstartedlab_web.5.70...(略)...ewc

$ docker-machine ssh myvm2 'docker container ls'
CONTAINER ID    IMAGE                        COMMAND           CREATED          STATUS           PORTS     NAMES
4a29169e783e    cool21540125/firstrepo:1.0   "python app.py"   10 minutes ago   Up 10 minutes    80/tcp    getstartedlab_web.3.1n...(略)...7ah
89829c936d16    cool21540125/firstrepo:1.0   "python app.py"   10 minutes ago   Up 10 minutes    80/tcp    getstartedlab_web.1.wl...(略)...loc
# 可以很清楚的看出來, 我們把服務部屬到2台 VM內了, 且這些 VM分別做好 load-balance

$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   *        virtualbox   Running   tcp://192.168.99.100:2376           v17.09.1-ce
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.09.1-ce
# 我們可以在本地端, 打開瀏覽器, 只要輸入「192.168.99.100」or「192.168.99.101」, 就可以看到網頁囉~~
```





---

目前在不同 VM內做好了 load-balance, 如果其中一台 VM離開 swarm呢?
```sh
$ docker-machine ssh myvm2 "docker swarm leave"
Node left the swarm.
# 告知 myvm2已經離開 swarm

$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   *        virtualbox   Running   tcp://192.168.99.100:2376           v17.09.1-ce
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.09.1-ce
# 在複習一下, 這個指令試看 VM的啟動狀況, 和 swarm沒有關係!

$ docker-machine ssh myvm2 'docker container ls'
CONTAINER ID   IMAGE                        COMMAND           CREATED          STATUS          PORTS    NAMES
# myvm2已經離開 swarm了, 理當裡頭沒有"任何的(也沒有未啟動的)" container

$ docker-machine ssh myvm1 'docker container ls'
CONTAINER ID   IMAGE                        COMMAND           CREATED          STATUS          PORTS    NAMES
d3c4a64c630b   cool21540125/firstrepo:1.0   "python app.py"   15 seconds ago   Up 6 seconds    80/tcp   getstartedlab_web.3.bd...(略)...sq0
614e0883ebe4   cool21540125/firstrepo:1.0   "python app.py"   15 seconds ago   Up 6 seconds    80/tcp   getstartedlab_web.1.tb...(略)...lch
5595ad860113   cool21540125/firstrepo:1.0   "python app.py"   23 minutes ago   Up 23 minutes   80/tcp   getstartedlab_web.2.qf...(略)...h4h
0e204d428004   cool21540125/firstrepo:1.0   "python app.py"   23 minutes ago   Up 23 minutes   80/tcp   getstartedlab_web.4.hp...(略)...al3
d97d17dcb83b   cool21540125/firstrepo:1.0   "python app.py"   23 minutes ago   Up 23 minutes   80/tcp   getstartedlab_web.5.70...(略)...ewc
# 神奇的是發生了!! 模擬 swarm cluster中, 有機器掛掉之後, 服務會自己把 container維持在一開始 yml檔定好的數量

# 接著, 再把剛剛脫離 swarm的 node加進來
$ docker-machine ssh myvm1 'docker swarm join-token manager'
To add a manager to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-3x34nxl3s7ljrq8z30ppgfdf5kzjowuq5u696gsqlb9ya3bce0-7owodb8nv75ob3m7d0qrhfdjl 192.168.99.100:2377

$ docker-machine ssh myvm2 'docker swarm join --token SWMTKN-1-3x34nxl3s7ljrq8z30ppgfdf5kzjowuq5u696gsqlb9ya3bce0-7owodb8nv75ob3m7d0qrhfdjl 192.168.99.100:2377'
This node joined a swarm as a manager.

$ 
```

指令備註

```sh
$ docker-machine create --driver virtualbox <Machine Name>        # 建立 docker VM

$ docker-machine ls                                                         # 列出所有 docker VM及其相關資訊
           
$ docker-machine scp <file> <machine>:~                                     # 可跨 VM之間傳輸檔案
           
$ docker-machine ssh <VM Name> "<指令>"                                     # 指定<VM Name>, 執行<指令>
$ docker-machine ssh <VM Name> "docker node ls"                             # 查看<VM Name>這台Swarm Manager裡的 Swarm Nodes
           
$ docker-machine start <VM Name>                                            # 啟動 stopping的 VM
$ docker-machine rm <VM Name>                                               # 移除 docker VM
$ docker-machine stop $(docker-machine ls -q)                               # 停止所有 running的 VMs
$ docker-machine rm $(docker-machine ls -q)                                 # 關閉所有 VMs
           
$ docker-machine ssh <Swarm Worker> "docker swarm leave"                    # Swarm Worker自行離開 swarm
$ docker-machine ssh <Swarm Manager> "docker swarm leave --force"           # Swarm Manager解散 Swarm Cluster


$ eval $(docker-machine env <要進入命令環境的 docker VM Name>)              # 進入 docker VM命令環境
$ eval $(docker-machine env -u)                                             # 離開 docker VM命令環境

$ eval $(docker-machine env -u)                                           # 解除 docker-machine env
```