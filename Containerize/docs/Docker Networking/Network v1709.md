
# Container networking
- [Docker and iptables Linux防火牆的設定吧!?](https://docs.docker.com/network/)
- 2018/06/19

```sh
$# docker network ls
NETWORK ID      NAME      DRIVER    SCOPE
eada4c9a1c64    bridge    bridge    local   # 對應 docker0 網卡
dc201b36ce6d    host      host      local   # 直接使用 Docker Host 的網卡
1d7619669ced    none      null      local   # 無網路服務

### 安裝 docker 之後, 會自動建立 虛擬橋接器 docker0
$# ifconfig docker0
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255  # 172.17.0.1/16
        inet6 fe80::42:fff:fe72:f251  prefixlen 64  scopeid 0x20<link>
        ether 02:42:0f:72:f2:51  txqueuelen 0  (Ethernet)
        RX packets 133  bytes 19283 (18.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1287  bytes 245884 (240.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# 檢視預設網卡 : bridge
$# docker network inspect bridge
[
    {
        "Name": "bridge",           # Network Name : bridge
        ...,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        ...,
        "Containers": {},
        ...
    }
]
```

## 故事開始
```sh
$# docker run -itd --name=container1 busybox
$# docker run -itd --name=container2 busybox

$# docker inspect bridge
[
    {
        "Name": "bridge",
        ...,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        ...,
        "Containers": {
            "8905204af6b7...": {       # Container 2
                "Name": "container2",
                "EndpointID": "2abf58f1cb40...",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            },
            "df714af76fabdd...": {      # Container 1
                "Name": "container1",
                "EndpointID": "8a81acc804caed9a...",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },
        ...
    }
]
# container1 : 172.17.0.2/16    df714af76fab
# container2 : 172.17.0.3/16    8905204af6b7

$# docker attach container1
$# cat /etc/hosts
127.0.0.1       localhost
172.17.0.2      df714af76fab    # default bridge 幫忙做好預設
# (IPv6 pass...)
```

> default `bridge` network 並沒有 **automatic service discovery**, 所以只能藉由 `ip address` 來互相溝通, `無法使用 ping <ContainerName>`; 但是 user-defined network 則有此功能! <br>
  此外, 也可使用 (legacy option) `docker run --link` 來連結 兩個 Container (但已經不建議)

> external network 的順序 : 如果一個 Container 一口氣附加了很多個可對外的 network, 則預設是使用 `lexical 排序 的第一個 non-internal network`

## Bridge networks

```sh
$# docker network create --driver bridge isolated_nw
$# docker network inspect isolated_nw
[
    {
        "Name": "isolated_nw",
        "Id": "7cf996dfe9d1...",
        "Created": "2018-06-19T23:28:44.032085588+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]

$# docker network ls
NETWORK ID      NAME           DRIVER    SCOPE
eada4c9a1c64    bridge         bridge    local
dc201b36ce6d    host           host      local
7cf996dfe9d1    isolated_nw    bridge    local
1d7619669ced    none           null      local

$# docker run --network=isolated_nw -itd --name=container3 busybox
[
    {
        "Name": "isolated_nw",  # user-defined network 無法使用 (legacy option) --link
        "Id": "7cf996dfe9d1...",
        "Created": "2018-06-19T23:28:44.032085588+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "6d343c65bf30...": {                    # container3
                "Name": "container3",
                "EndpointID": "2d92acb055e3...",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",     # isolated_nw 網卡的 ip為 172.18.0.2/16
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

適用時機比較:
- bridge network  : single host 建立 small network
- overlay network : 大型網路上運作的 container


## [The `docker_gwbridge` network](https://docs.docker.com/v17.09/engine/userguide/networking/#the-docker_gwbridge-network)
- `docker_gwbridge` network 在下列兩種情況下, 會自行建立:
    - `initialize or join a swarm`, 用來提供 swarms 之間溝通
    - `none of a container's networks can provide external connectivity`, 提供 swarms 及 external networks 溝通

```sh
# Docker network - docker_gwbridge 也可以先自行建立(不讓系統預設建立)
$# docker network create \
    --subnet 172.30.0.0/16 \
    --opt com.docker.network.bridge.name=docker_gwbridge \
    --opt com.docker.network.bridge.enable_icc=false \
    docker_gwbridge
```

## [Overlay networks in swarm mode](https://docs.docker.com/v17.09/engine/userguide/networking/#overlay-networks-in-swarm-mode)
- Docker manager node 可以建立 `overlay network`
- `Only swarm services` 可以連到 `overlay networks` (standalone 無法)

```sh
# 建立 overlay network driver (要事先啟動 docker swarm)
$# docker network create \
    --driver overlay \
    --subnet 10.0.9.0/24 \
    my-multi-host-network
```



## [Overlay networks in swarm mode](https://docs.docker.com/v17.09/engine/userguide/networking/#overlay-networks-in-swarm-mode) pass...


## [Custom network plugins ](https://docs.docker.com/v17.09/engine/userguide/networking/#custom-network-plugins) - pass...



## Embedded DNS server
- 2018/06/20
- user-defined network 其實有內建 DNS server的功能
- [Embedded DNS server in user-defined networks](https://docs.docker.com/v17.09/engine/userguide/networking/configure-dns/) - 有點重要 改天讀

> **使用者自訂 Network** 其實有內建 DNS server 的功能. <br>   To facilitate this when the container is created, only the embedded DNS server reachable at `127.0.0.11` will be listed in the `container’s resolv.conf` file. ((這句是重點, 但我不會翻譯...))



## [Exposing and publishing ports](https://docs.docker.com/v17.09/engine/userguide/networking/#exposing-and-publishing-ports)

- Docker networking 有兩種機制:

    - exposing ports
        - docker run時, 使用 `--expose` 關鍵字
        - Dockerfile內, 使用 `EXPOSE` 關鍵字

    - publishing ports
        - docker run時, 使用 `--publish` or `--publish-all`
        - Dockerfile內, 無此選項

```sh
# 隨機映射 (>30000的 port) 對應到 Container內的 80 port
$# docker run -it -d -p 80 nginx

$# docker ps
CONTAINER ID    IMAGE    COMMAND    CREATED    STATUS    PORTS                    NAMES
2ba6bec4866a    nginx    (pass)     (pass)     (pass)    0.0.0.0:32768->80/tcp    upbeat_bose
# 使用到 Docker host的 32768 port -> Container內的 80 port

# 這樣就可以連進去惹~
$# curl -4 localhost:32768

# 打開防火牆後, 外面的電腦也可以進去湊熱鬧惹~
$# sudo firewall-cmd --zone=public --add-port=32768/tcp

# 自訂映射 : Docker Host 8080 port -> Docker Container 80 port
$# docker run -it -d -p 8080:80 nginx
```
