
Docker 早期使用 Linux Container(LXC) 技術來實現, v0.9 以後, 改用 libcontainer, 並且開始推動 **容器規範(runC)**, 目的是想打造更通用的容器虛擬化底層函式庫.

Docker 依賴 Linux 作業系統的:

- namespace: 命名空間(Namespace)
- CGroups: 控制群組(Control Group)
- UnionFS: 聯合檔案系統(Union File System)
    - run Container 以後, Docker 將此 `read-only layer(image)` + `read-write layer` 的組合稱之為 `Union File System`
- Linux網路虛擬化

---

- Docker Client && Docker Server, 可透過 *socket* 或 *RESTFul API* 來進行溝通.
- Docker Server 預設開啟 unix:///var/run/docker.sock 通訊介面, 也可透過 `docker daemon -H 0.0.0.0:1234` 來改變啟動 && 監聽方式
- Docker Client 預設透過 unix:///var/run/docker.sock 通訊介面發送命令到 Docker Server, 也可透過 `docker -H tcp://127.0.0.1:1234 version` 來發送命令給 Docker Server

以前, 如果 Docker Server 上的 docker daemon 掛掉, 會導致 容器服務也通通掛掉, v1.11.0 以後, 把容器服務放到 containerd 來做管理, 並遵從 OCI 的 runC 規範. 解除掉該耦合(但是 Docker API 依舊依賴於 docker daemon)

## 關於 docker.sock

- [Docker Tips : about /var/run/docker.sock](https://betterprogramming.pub/about-var-run-docker-sock-3bfd276e12fd)

> `docker.sock`: Unix socket the Docker daemon listens on by default, and it can be used to communicate with the daemon from within a container.

Docker daemon 會去 listen on `/var/run/docker.sock` (可看 docker.service 的 `... -H unix:///var/run/docker.sock ...`)

底下範例, 列出如何使用 Docker API v2 來與 Docker Daemon 互動

```bash
### build Container
curl -XPOST --unix-socket /var/run/docker.sock -d '{"Image": "alpine"}' -H 'Content-Type: application/json' http://localhost/containers/create
# 印出 {"Id":"8544be54169b183117d1d8472286fb98e6b40ab5271c0a9f50c6c2b9f5c293fa","Warnings":[]}

### run Container
curl -XPOST --unix-socket /var/run/docker.sock http://localhost/containers/8544be54169b183117d1d8472286fb98e6b40ab5271c0a9f50c6c2b9f5c293fa/start
```

```bash
### 容器內觀察 Docker Daemon 使用
docker run -v /var/run/docker.sock:/var/run/docker.sock -ti alpine sh
apk update && apk add curl

### 藉由 Docker API /events 看到 Docker Host 的使用狀況
curl --unix-socket /var/run/docker.sock http://localhost/events
```


## namespace


## CGroups


## UnionFS


## Linux網路虛擬化