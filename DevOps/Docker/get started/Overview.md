# [Overview](https://docs.docker.com/v17.09/engine/docker-overview/)
- 2018/01/11

## Docker 引擎
![GG engine-components-flow](./../../../img/engine-components-flow.jpg)

---

## Docker 體系結構
![GG Docker結構](./../../../img/architecture.svg)
Docker Client 與 Docker Daemon透過 REST API與 `UNIX sockets` 或 `a network interface` 溝通

---


## Docker registries

Docker images遠端儲藏庫有 `Docker Hub` 及 `Docker Cloud`, 預設由 `Docker Hub` 抓取 Docker images.

```bash
$# docker pull alpine:latest
# 等同於
$# docker pull docker.io/library/apline:latest

# 又如
$# docker pull myregistrydomain:port/abc/xyz
# 表示是從 myregistrydomain:port 這裡的 registry
# 抓取 abc/xyz 的 image
```

If you use Docker Datacenter (DDC), it includes Docker Trusted Registry (DTR).

## Docker Daemon(dockerd)

## Docker Client(docker)

## Control groups (cgroups)


## 名詞
### Namespaces
> Docker 使用 namespace來區隔各個 container

Docker在 Linux使用的 namespaces如下:

    pid : Process isolation (PID: Process ID).
    net : Managing network interfaces (NET: Networking).
    ipc : Managing access to IPC resources (IPC: InterProcess Communication).
    mnt : Managing filesystem mount points (MNT: Mount).
    uts : Isolating kernel and version identifiers. (UTS: Unix Timesharing System).

## Container format
Docker Engine結合 `namespaces`, `control groups`, `UnionFS`到一個包裹物件, 此包裹物件稱為 `Container format`. 預設的 'Container format' 為 `libcontainer`

## dockerfile
> 由一系列的 `Layers`所組成. 每一層都是由 dockerfile中的每行指令所創建.