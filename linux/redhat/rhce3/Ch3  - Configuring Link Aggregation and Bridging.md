# Ch3  - Configuring Link Aggregation and Bridging

1. Network Teaming
2. Network teaming config
3. Software Bridges
4. 結合 Software Bridges 及 Network Teaming

## 1. Network Teaming (12/13 補)

首先, 你的電腦得有 `2 個以上的 Network Device`

- [/rhce3/attach/NetworkTeaming.xml](https://www.draw.io/)

網卡們作成 Teaming 是依照 `runner` 這個軟體機制, 而 runner(理解成 Teaming 的方式) 可區分成下面 5 種:

runner       | Usage                  | 設定設定難易度
------------ | ---------------------- | --------------
broadcast    | ?                      | Simple
activebackup | High Availability      | Simple
roundrobin   | Simple Load-Balance    | Simple
loadbalance  | Complex Load-Balance   | @@...
lacp         | ?                      | @@...

### * 需求 :

建立一個 `team interface` 名為 **team0**, 並指定 static IP `192.168.124.223/24`

而此 team0 包含了 2 張網卡所組成, 分別為 `enp2s0` 及 `enp3s0`

teaming 的目的為 `fault-tolerant/active-backup`

### * 動手做:

1. 建立 team interface
2. 設定 team interface 的 IP (v4 and/or v6)
3. 把 port interfaces 加入 team
4. 讓 team interface && port interfaces up

```sh
### 先看一下目前的 NIC (重點是 eno1 及 eno2)
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP
 mode DEFAULT qlen 1000
    link/ether 63:54:00:01:12:0b brd ff:ff:ff:ff:ff:ff
4: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP
 mode DEFAULT qlen 1000
    link/ether 01:10:18:3b:98:86 brd ff:ff:ff:ff:ff:ff
6: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP
 mode DEFAULT qlen 1000
    link/ether 62:31:50:18:80:6f brd ff:ff:ff:ff:ff:ff


### 1 建立
$# nmcli con add \
    type team \
    con-name team0 \
    ifname team0 \
    config '{"runner": {"name": "activebackup"}}'
# METHOD = roundrobin, activebackup, ...


### 2 設IP
$# nmcli con mod team0 \
    ipv4.addresses 192.168.124.223/24 \
    ipv4.gateway 192.168.124.254 \
    ipv4.method manual


### 3 加入 team
$# nmcli con add \
    type team-slave \
    con-name team0-port1 \
    ifname eth0 \
    master team0        # NIC1

$# nmcli con add \
    type team-slave \
    con-name team0-port2 \
    ifname eno2 \
    master team0        # NIC2


### 4 啟用
$# nmcli con up team0
$# nmcli con up team0-port1
$# nmcli con up team0-port2


### 測試~
$# ping -I team0 192.168.124.254
# 如果沒錯的話, 可以正常 ping 到

### 查看
$# teamdctl team0 state
setup:
  runner: activebackup
ports:
  eth0
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link up
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link up
runner:
  active port: eth0         # eno1 啟用中...


### 假設 eno1 崩潰了!
$# nmcli dev dis eno1


### 依然可以正常運作
$# ping 192.168.0.254


### 再次查看
$# teamdctl team0 state
setup:
  runner: activebackup
ports:
  eno2
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link up
runner:
  active port: eno2         # eno2 來救援了!!
```


## 2. Network teaming config

```sh
# 組態檔放在
ll /etc/sysconfig/network-scripts/ifcfg-*
```

```sh
# 可把之前設定過的組態倒出來
teamdctl team0 config dump > /tmp/team0.cfg

# 將來在指定給其他的 team
nmcli con add \
    con-name team1 \
    ifname team1 \
    type team \
    team.config /tmp/team0.cfg
```


## 3. Software Bridges

```sh
### bridge interface
nmcli con add \
    con-name br0 \
    ifname br0 \
    type bridge \
    ip4 192.168.0.100/24

### 加入 port interface -> bridge interface
nmcli con add \
    con-name br0-port1 \
    ifname eth0 \
    type bridge-slave \
    master br0              # eno1

nmcli con add \
    con-name br0-port2 \
    ifname eno2 \
    type bridge-slave \
    master br0              # eno2
```


## 4. 結合 Software Bridges 及 Network Teaming

nmcli 指令在 RHEL7.0 有 BUG(不弄範例了), 但實務上此需求很可能會遇到

示意圖如下:

```
    ---- bridge interface ----
    |                        |
    |    ---- teaming ---    |
    |    |   --------   |    |
    |    |   | NIC1 |   |    |
    |    |   --------   |    |
    |    |   --------   |    |
    |    |   | NIC2 |   |    |
    |    |   --------   |    |
    |    |--------------|    |
    |                        |
    --------------------------
```
