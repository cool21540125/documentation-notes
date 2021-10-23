# [Network containers](https://docs.docker.com/v17.09/engine/tutorials/networkingcontainers/)
- 2018/01/07 (官方估計閱讀時間 6分鐘, 林北讀了 3小時, 乾~)
- 2018/05/02(改寫)
- 2018/06/24(用 Docker on Windows v18.03 測試 可正常執行!)
- 此篇, 是「如何使用 Docker Network」的基礎範例
- `17.09版` 的範例!!


本章目標, 要把 Container的 network 弄成`圖1`的架構<br>

`圖1`
![圖1](./../../../img/bridge3.jpg)

- 兩個 docker network, 分別為 `dockere0` 及 `my_bridge`
- 兩個 docker container, 分別為 `web` 及 `db`
- `web` container 附加 `docker0` 及 `my_bridge`
- `db` container 附加 `my_bridge`

# Prerequest
1. 略懂網路架構(起碼看上圖能有點感覺)
2. 知道 Docker Container是啥東西
3. 知道 Docker Image是啥東西
4. 安裝完 Docker Engine, 本篇範例的版本為 17.09
```sh
$ docker --version
Docker version 17.09.0-ce, build afdb6d4   # 18.03版一樣可以 run
```



# 建立 docker network

```sh
$ docker network ls
NETWORK ID      NAME         DRIVER      SCOPE
0bd6efb035c9    bridge       bridge      local
79a16ba00d8f    host         host        local
7406af2c5d03    none         null        local
# 安裝完 Docker後, 都會有上述 3個預設的 Networks

$ docker network create -d bridge my_bridge     # "-d bridge" 可以省略(因為預設的 Network Driver 就是 bridge)
ccee7fa10da9...
# 建立一個 network, 名為 my_bridge
# 此 network的 driver為 bridge

$ docker network ls
NETWORK ID      NAME         DRIVER      SCOPE
0bd6efb035c9    bridge       bridge      local
79a16ba00d8f    host         host        local
7406af2c5d03    none         null        local
ccee7fa10da9    my_bridge    bridge      local   # <--- 新增的

# 使用 ubuntu 這個 Image, 建立名為 networktest 的 Container, 並且背景執行
$ docker run -itd --name=networktest ubuntu
# -it為持續執行
# -d為背景執行
# --name=networktest為 Container的名稱
# 這邊沒指定要用哪個 Docker Network Driver, 所以會採用預設的 bridge

$ docker container ls
CONTAINER ID   IMAGE    COMMAND       CREATED         STATUS         PORTS   NAMES
a9155d48e932   ubuntu   "/bin/bash"   2 minutes ago   Up 2 minutes           networktest
```

`圖2` 剛剛建立的 Container, 看起來像這樣<br>
![bridge](./../../../img/docker_bridge.jpg)

```sh
$ docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "0bd6efb035c9...",
        "Created": "2018-01-07T23:00:31.287691388+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
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
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {     # 套用這 bridge的 Container
            "6b3c1331550a...": {
                "Name": "networktest",                  # network名稱
                "EndpointID": "66d57c96943e...",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",         # IP在這!!
                "IPv6Address": ""
            }
        },
        ...
    }
]
```

```sh
# 把 networktest這個 Container的 network功能給拔掉
$ docker network disconnect bridge networktest

# 再次檢查...
$ docker network inspect bridge
[
    {
        "Name": "bridge",       # Network Name 為 bridge
        "Id": "0bd6efb035c9...",
        "Created": "2018-01-07T23:00:31.287691388+08:00",
        "Scope": "local",
        "Driver": "bridge",     # Network Driver 為 bridge
        "EnableIPv6": false,
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
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {}, # 沒有任何一個 Container 套用此 network
        ...
    }
]

# 再想想 圖1 的架構(你是不是已經忘了!!), 我們先來看看 my_bridge 這塊網卡
$ docker network inspect my_bridge
[
    {
        "Name": "my_bridge",
        "Id": "ccee7fa10da9...",
        "Created": "2018-01-07T23:21:24.650496745+08:00",
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
# 上頭找不到 Container 這東西..., 要把套用這 network 的 container 納近來
```

## 建立 第二個 Container
```sh 
# 使用 training/postgres 這個 Image, 建立名為 db 的 Container, 並且使用的 Network 為 my_bridge
$ docker run -d --net=my_bridge --name db training/postgres
9c815ee0bfcd...

# 再次檢查 my_bridge
$ docker inspect my_bridge
[
    {
        "Name": "my_bridge",
        "Id": "ccee7fa10da9...",
        "Created": "2018-01-07T23:21:24.650496745+08:00",
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
        "Containers": {     # 將將!! db這個 Container使用此 network囉
            "9c815ee0bfcd...": {
                "Name": "db",
                "EndpointID": "e62473d30352...",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]

# 另外, 也可以反過來檢查 Container連結到哪個 network
$ docker inspect --format="{{json .NetworkSettings.Networks}}"  db
{
    "my_bridge": {
        "IPAMConfig": null,
        "Links": null,
        "Aliases": [
            "9c815ee0bfcd"
        ],
        "NetworkID": "ccee7fa10da9...",
        "EndpointID": "e62473d30352...",
        "Gateway": "172.18.0.1",
        "IPAddress": "172.18.0.2",
        "IPPrefixLen": 16,
        "IPv6Gateway": "",
        "GlobalIPv6Address": "",
        "GlobalIPv6PrefixLen": 0,
        "MacAddress": "02:42:ac:12:00:02",
        "DriverOpts": null
    }
} # 此 output 經排版過, 原始 output 全擠在一起

# 回想 圖1, 開始架設左半部的 Container囉~
$ docker run -d --name web training/webapp python app.py
# 使用 training/webapp(Image), 建立 web(Container), 並預設使用 bridge(Network), 
# 建立後, 使用 python app.py來運行這個 Container

$ docker container ls
CONTAINER ID   IMAGE               COMMAND                  CREATED   STATUS   PORTS      NAMES
e1468e5ff61a   training/webapp     "python app.py"          (pass)    (pass)   5000/tcp   web
9c815ee0bfcd   training/postgres   "su postgres -c '/..."   (pass)    (pass)   5432/tcp   db
6b3c1331550a   ubuntu              "/bin/bash"              (pass)    (pass)              networktest

# 檢查 web container 套用那些 network
$ docker inspect --format="{{json .NetworkSettings.Networks}}"  web
{
    "bridge": { # (我不確定它是指 network driver 還是 network name...), 推測應該是 name
        "IPAMConfig": null,
        "Links": null,
        "Aliases": null,
        "NetworkID": "0bd6efb035c9...",
        "EndpointID": "b9c316dae820...",
        "Gateway": "172.17.0.1",
        "IPAddress": "172.17.0.2",
        "IPPrefixLen": 16,
        "IPv6Gateway": "",
        "GlobalIPv6Address": "",
        "GlobalIPv6PrefixLen": 0,
        "MacAddress": "02: 42:ac: 11: 00: 02",
        "DriverOpts": null
    }
}

# 取得此 Container的 IP Address
$ docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" web
172.17.0.2
```


## 該建的都建完後 (開啟2個 Shell)
### Shell 1: 進入 db 這個 Container
```sh
# 使用 bash, 進入到 db(Container)裏頭去執行~
$ docker exec -it db bash

root@9c815ee0bfcd:/# ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:ac:12:00:02  
          inet addr:172.18.0.2  Bcast:0.0.0.0  Mask:255.255.0.0            # 注意這邊的 ip
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:136 errors:0 dropped:0 overruns:0 frame:0
          TX packets:23 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:21057 (21.0 KB)  TX bytes:2198 (2.1 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:39 errors:0 dropped:0 overruns:0 frame:0
          TX packets:39 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:2701 (2.7 KB)  TX bytes:2701 (2.7 KB)

root@9c815ee0bfcd:/# ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2) 56(84) bytes of data.
# ping 得到才有鬼! 兩者根本就是在不同的網段!!!
```

### Shell 2: 進入 web 這個 Container
```sh
# 使用 bash, 進入到 web(Container)裏頭去執行~
$ docker exec -it web bash

root@e1468e5ff61a:/opt/webapp# ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:ac:11:00:02  
          inet addr:172.17.0.2  Bcast:0.0.0.0  Mask:255.255.0.0             # 注意這邊的 ip
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:58 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:8688 (8.6 KB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

`圖4`: 目前的 Container network架構, 導致 web(Container) ping不到 db(Container) <br>
![圖4](./../../../img/bridge2.jpg)<br>
解法是, 只需要讓 web 使用與 db 相同的 Network 就行了!!

> 附加網卡, 語法 : <br>
    `docker network connect <Network Name> <Container Name>`


```sh
# 讓 web(Container)使用 my_bridge
$ docker network connect my_bridge web
```

如此一來, 架構就完成了!!<br>
![圖1](./../../../img/bridge3.jpg)<br>
web 與 db 可以找到彼此了!!

```sh
$ docker exec -it db bash

root@9c815ee0bfcd:/# ping web -c 2
64 bytes from web.my_bridge (172.18.0.3): icmp_seq=1 ttl=64 time=0.350 ms
64 bytes from web.my_bridge (172.18.0.3): icmp_seq=2 ttl=64 time=0.145 ms
```