
- [安裝與使用 registry](https://peihsinsu.gitbooks.io/docker-note-book/content/registory-install-and-use.html)
- 依舊有點問題

```bash
### 自架 docker registry (192.168.2.158)
$# docker pull registry:2

### run
$# docker run -d \
    -p 5000:5000 \
    -v /var/docker_data/registry:/tmp/registry \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    --name myregistry \
    --restart always registry:2

$# firewall-cmd --add-port 5000/tcp

###
$# docker ps
CONTAINER ID  IMAGE    COMMAND                 CREATED             STATUS             PORTS                   NAMES
5b5738c59fe0  registry "/entrypoint.sh /etc…"  About a minute ago  Up About a minute  0.0.0.0:5000->5000/tcp  myregistry

### 用這個來做實驗吧
$# docker pull alpine

### docker tag IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
$# docker tag alpine:latest 192.168.2.158:5000/demo
$# docker tag alpine:latest vm158:5000/demo

$# docker images
REPOSITORY             TAG     IMAGE ID      CREATED      SIZE
registry               2       708bc6af7e5e  3 weeks ago  25.8MB
alpine                 latest  e7d92cdc71fe  4 weeks ago  5.59MB
localhost:5000/v0217   latest  e7d92cdc71fe  4 weeks ago  5.59MB  # 剛剛製作好的s

### 上傳~
$# docker push localhost:5000/v0217
The push refers to repository [localhost:5000/v0217]
5216338b40a7: Pushed
latest: digest: sha256:ddba4d27a7ffc3f86dd6c2f92041af252a1f23a8e742c90e6e1297bfa1bc0c45 size: 528


### 把剛剛的 alpine 相關的 images 砍光

$# docker images
REPOSITORY               TAG     IMAGE ID      CREATED      SIZE
registry                 2       708bc6af7e5e  3 weeks ago  25.8MB

### 本地下載看看吧
$# docker pull 192.168.2.158:5000/myalpine


### 另一台 (指定從 158 拉下來)
$# docker push 192.168.2.158:5000/demo

$# docker pull
```