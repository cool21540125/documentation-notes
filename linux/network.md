- 相關指令
- 知識概念備註
- [Ubuntu16.04的pdf](http://arbas.assam.gov.in/resources/pdf/ubuntu_16.04.pdf)
- [還蠻初階的語法教學](https://www.puritys.me/docs-blog/article-357-Linux-%E5%9F%BA%E6%9C%AC%E6%8C%87%E4%BB%A4%E6%95%99%E5%AD%B8.html)


# 快速設定固定 IP

```bash
### 設定
nmcli con mod eth0 ipv4.addresses 192.168.0.101/24 ipv4.gateway 192.168.0.1 ipv4.method manual autoconnect yes
nmcli con mod eth0 ipv4.dns 192.168.1.251 +ipv4.dns 192.168.1.250
nmcli con up eth0

### 測試
ping google.com.tw
```

# Network

- 2018/08/18

基本上, `會產生網路監聽埠口的 Process`, 就稱為 `Network Service`

查詢主機上的 網路連線資訊 && port 的使用. 語法: `netstat <options>`

```sh
$ netstat -[tulnpacr]    # 與網路介面相關
# -t : 列出 TCP 連線
# -u : 列出 UDP 連線
# -l : 列出有在 Listen 的服務的網路狀態
# -n : 用 ip, port 代替 主機名稱, 服務名稱. ex: 將 ssh 改為 22
# -p : 列出 PID && 程式名稱 (每個連線由哪個 process處理)
# -a : 列出所有連線狀態
# -c xxx : xxx 秒後自動更新一次
# -r : 列出 route table (功能與 route 相同)

# Note: 可以使用 netstat -ntp 與 netstat -tp 比較後, 就可以知道 `service 對應的 port`

### 常用
$ netstat -tulnp | grep XXX
```


# Naming

`wlp2s0`, `enp1s0`, `eth0`, ... 到底是啥挖歌

CentOS6 以前(包含目前的虛擬機), 都是按照 **eth0**, **eth1**, **eth2** 的方式來對網卡作命名, 而命名依據則是 `網卡插在電腦上的哪個 port(硬體上的那個洞啦!!), 就會給予 該 port 的編號. 簡單的說, 插在第一個洞=eth0, 插在第二個洞=eth1, ...`; 而虛擬機裏頭, 因為是 `虛擬作業系統`, 透過 **開機時核心偵測的時機**, 抓取實體作業系統的網卡, 所以一樣會看到 `eth0` 這東西

CentOS7: 裝置名稱改為 `p1p1, p2p1, p3p1`等 BIOS名稱, 目的是為了維持設備名稱的一致性, 並以 **名稱得知網路卡在主機板上插槽的位置**.

可能因為更換硬體設備而異動. 網卡名稱變動可能造成防火牆錯誤

ex: `wlp2s0`, `enp1s0`

前 2 碼 Begin Name

- en : 乙太雙絞線
- wl : 無線
- ww : 廣域網路介面

第 3 碼(可能多碼)

- o : `on-board` 主機板上的網卡
- s : `hotplug slot` USB網卡
- p : `PCI geographic location` PCI介面網卡
- x : `MAC address`

第 4 碼

- 1 : PCI介面第 1 孔
- 2 : PCI介面第 2 孔

第 5~6 碼

- s0 : 網卡上第 1 個孔


範例:
```
wlp2s0 : PCI介面第二孔的第一張無線網卡
enp1s0 : 第一孔PCI介面第一張乙太網卡
eno1   : 第一張內建網路介面卡
```


## ip

`ip`指令可以拿來作 **變更網路組態**, **增刪改特定設備的 ip位址**.... 遇到再 google

```sh
# 查看 網路介面 相關細節
$ ip addr show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether c8:5b:76:7e:4d:8e brd ff:ff:ff:ff:ff:ff  # MAC Address
    inet 192.168.124.73/24 brd 192.168.124.255 scope global dynamic enp1s0  # ipv4, 廣播位址, 範圍global, 動態命名為 enp1s0
       valid_lft 843020sec preferred_lft 843020sec
    inet6 fe80::be4e:db5a:2ead:fc61/64 scope link  # ipv6
       valid_lft forever preferred_lft forever

# 查看 網路介面 流量資訊
$ ip -s link show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether c8:5b:76:7e:4d:8e brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   # 收到
    663371186  752235   0       0       0       5242
    TX: bytes  packets  errors  dropped carrier collsns # 傳送
    23762562   261538   0       0       0       0

# 查看 網路介面 路由資訊
$ ip route show   # 可省略 show
default via 192.168.124.254 dev enp1s0 proto static metric 100
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1
192.168.124.0/24 dev enp1s0 proto kernel scope link src 192.168.124.73 metric 100
# proto: 此 route 的 route protocol, 有 redirect, kernel, boot, static, ra, ...
#    - kernel, 直接由 核心(kernel) 判斷自動設定
# scope: routing 的範圍. 主要為 link, 也就是與 本裝置 有關的 直接連線.
# 藉由 enp1s0, 會送到 Default Router:192.168.124.254
# 前往 192.168.122.0/24 的流量會藉由 virbr0
# 前往 192.168.124.0/24 的流量會藉由 enp1s0
```


## ping - 請求主機回應

送出 `icmp protocal 的 ECHO_REQUEST 封包` 至 特定主機, 主機在同樣以 `icmp回傳封包`

```sh
# ping 2次 (Windows 用 -c)
$ ping -c 2 168.95.1.1
PING 168.95.1.1 (168.95.1.1) 56(84) bytes of data.
64 bytes from 168.95.1.1: icmp_seq=1 ttl=241 time=2.72 ms
64 bytes from 168.95.1.1: icmp_seq=2 ttl=241 time=2.89 ms

--- 168.95.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 2.721/2.806/2.891/0.085 ms
# time=2.72 ms : 伺服器 與 主機 之間的連線回應狀況
```


## ss - socket 統計

```sh
# ss -[antu]
# -a : 　顯示 正在監聽 + 已建立 的 socket
# -l : 只顯示 正在監聽         的 socket
# -n : 使用 port number 取代 service name
# -t : TCP Socket
# -u : UDP Socket

$ ss -ta  # 查看所有有在監聽的 TCP Channel
State    Recv-Q Send-Q   Local Address:Port       Peer Address:Port
LISTEN   0      128                  *:sunrpc                *:*
LISTEN   0      128                  *:http                  *:*
LISTEN   0      5        192.168.122.1:domain                *:*
LISTEN   0      128                  *:ssh                   *:*        # 監聽　 任何地方來的 ipv4 ssh 連線
ESTAB    0      264     192.168.124.73:ssh     192.168.124.101:63000    # 已建立 的 ssh 連線來自於 192.168.124.101
LISTEN   0      80                  :::mysql                :::*
LISTEN   0      128                 :::sunrpc               :::*
LISTEN   0      128                 :::ssh                  :::*        # 監聽　 任何地方來的 ipv6 ssh 連線
```


##  ifconfig

```sh
$ ifconfig enp1s0
enp1s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.124.73  netmask 255.255.255.0  broadcast 192.168.124.255
        inet6 fe80::be4e:db5a:2ead:fc61  prefixlen 64  scopeid 0x20<link>
        ether c8:5b:76:7e:4d:8e  txqueuelen 1000  (Ethernet)
        RX packets 84842  bytes 6617933 (6.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3073  bytes 507757 (495.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
# RX 網路從 啟動 到 現在, 接收自網路的 封包數, Bytes
# TX                     傳送到
# txqueuelen 用來傳輸資料的緩衝區的儲存長度
# collisions 封包碰撞數, 若越多表示網路越不好

$ ifconfig enp1s0 up          # 開啟 enp1s0網路卡
$ ifconfig enp1s0 down        # 關閉 enp1s0網路卡 (別白痴到在 ssh時使用阿XD )

# 重新手動指定 ip
$ ifconfig enp1s0 <new IP>

# 重新手動指定 ip及 mask
$ ifconfig enp1s0 <new IP> netmask <new Mask>
```


# NetworkManager 服務 與 network 服務(比較傳統的方式)

NetworkManager服務(NM) 專門設計用來給 `移動設備(ex: NB)` 使用, 可以在各種場合切換連線方式. 所以像是 Server或是一般桌電, 大都不使用 NM, 而是使用 network服務. **兩者澤一啟用即可**.

NM 這東西從 OS6 時期就有了, 但是 BUG 一大堆~~, 直到 OS7 的時候, 基本 BUG 幾乎都修好了 (進階使用一樣會有 BUG)

CentOS7 的 NetworkManager 預設的組態路徑 : `/etc/sysconfig/network-scripts/ifcfg-*`

```
CentOS7 的 網路連線, 都要 Bind on Device
Device
    + Connection1
    + Connection2
    |  + Ip address1
    |  + Ip address2
    |  + ...
    |
    + Connection3
    + ...
```

```sh
$ systemctl status NetworkManager.service
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
   Active: active (running) since 三 2018-03-07 09:09:49 CST; 14h ago    ### 啟動中!!(running)
     Docs: man:NetworkManager(8)
 Main PID: 850 (NetworkManager)
   Memory: 21.3M
   CGroup: /system.slice/NetworkManager.service
           ├─  850 /usr/sbin/NetworkManager --no-daemon
           └─12031 /sbin/dhclient -d -q -sf /usr/libexec/nm-dhcp-helper -pf /var/run/dhclient-enp1s0.pid -lf /var/lib/NetworkManager/dhclient-1e1bba3e...
(還有超多...略...)

$ systemctl status network.service
● network.service - LSB: Bring up/down networking
   Loaded: loaded (/etc/rc.d/init.d/network; bad; vendor preset: disabled)
   Active: active (exited) since 三 2018-03-07 09:09:55 CST; 14h ago     ### 存在, 但沒啟用(exited)
     Docs: man:systemd-sysv-generator(8)
  Process: 957 ExecStart=/etc/rc.d/init.d/network start (code=exited, status=0/SUCCESS)
   Memory: 0B
```

由於多數 Linux Server 都是使用 `network service`, 所以底下開始說明 `network service`的組態

```sh
# 服務程式位置
/etc/init.d/network

# network服務會讀取 「系統網路組態目錄」內的設定檔, 並配置所有網路的組態
$ ls /etc/sysconfig/network-scripts/
ifcfg-andy.lee  ifcfg-enp1s0    ifcfg-lo        ifcfg-wha  # (還有很多很多)

# 網路卡的設定檔
$ cat ifcfg-enp1s0
TYPE=Ethernet
BOOTPROTO=dhcp
# [dhcp, static, none]
# 若 BOOTPROTO=none, 則需要額外設定底下 4 個:
# IPADDR=<IP address of the appliance>
# PREFIX=<CIDR prefix>   (不確定是 PREFIX 還是 NETMASK)
# GATEWAY=<gateway IP address>
# DNS1=<DNS server IP address>
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes        # 是否支援 ipv6
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp1s0
UUID=1e1bba3e-ea82-4b79-9071-b64b659bd9fe
DEVICE=enp1s0       # 設備名稱
ONBOOT=no           # 開機是否啟用此網路卡
# USERCTL           # 使用者是否有權限控制此網路卡
# NM CONTROLLED     # 是否交由 NetworkManager工具來管理此網路卡

### 以上都可以直接編輯後, 重新啟動 network.service即可作用 ###
```

↑ 改完後重啟 `systemctl restart network`


## nmcli - 查看 network information

```sh
# 顯示網卡資訊
$ nmcli dev status
DEVICE           TYPE      STATE       CONNECTION
br-7cf996dfe9d1  bridge    已連線      br-7cf996dfe9d1
virbr0           bridge    已連線      virbr0
enp1s0           ethernet  已連線      enp1s0
wlp2s0           wifi      離線        --
lo               loopback  不受管理的  --
virbr0-nic       tun       不受管理的  --

# 查電腦上的連線
$ nmcli connection show
NAME           UUID                                  TYPE             DEVICE
14f-classroom  7249c377-ce83-4233-a40c-ddc5c4021be9  802-11-wireless  wlp2s0  # 目前啟用的無線網路連線
virbr0         9dcffbd1-d53f-4c7e-8c3a-f3b261ece9de  bridge           virbr0

$  nmcli connection show "14f-classroom"
connection.id:                          14f-classroom
connection.uuid:                        7249c377-ce83-4233-a40c-ddc5c4021be9
...(PASS)...
ipv4.method:                            auto    # 自動取得 ip
ipv4.dns:                               --
ipv4.dns-search:                        --
ipv4.dns-options:                       (default)
ipv4.dns-priority:                      0
ipv4.addresses:                         --      # 手動設定的 ip
ipv4.gateway:                           --
...(PASS)...
IP4.ADDRESS[1]:                         172.16.1.57/23  # 自動取得 ip 所分配到的 IP (大寫不能改)
IP4.GATEWAY:                            172.16.1.254
IP4.DNS[1]:                             168.95.1.1
...(PASS)...
IP6.GATEWAY:                            --
```


## nc

任意啟動 TCP/UDP 封包的 port 連線

- `nc` 可用來檢測服務, 可直接連到某個 port 進行溝通; 另外還可啟動一個 port 來等待別人連線

```sh
$# nc [-u] [IP|host] [port]     # -u: 使用 UDP
$# nc -l [IP|host] [port]       # -l: 啟用一個 port 來監聽連線

$# yum install -y nc

### Terminal 1
$# nc -l localhost 22222

### Terminal 2
$# netstat -tulnp | grep nc
Proto Recv-Q Send-Q Local Address   Foreign Address   State       PID/Program name
tcp6  0      0      ::1:22222       :::*              LISTEN      31911/nc
# 僅節錄部分

$# ss -tulnp | grep nc
Netid  State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
tcp    LISTEN     0      10      ::1:22222                :::*                   users:(("nc",pid=31911,fd=3))
# 僅節錄部分

$# nc localhost 22222
hi~
# ↑ 此時, Terminal 1 也會出現該訊息, 兩者可開始溝通了
```


# 其他

- ifup, ifdown : 只能針對 `/etc/sysconfig/network-scripts/` 內的 `ifcfg-ethXX` 進行動作


```bash
### route
$# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         gateway         0.0.0.0         UG    100    0        0 enp0s3  # 路由規則找不到的話, 送往這
192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s3  # 網域路由
# Destionation + Genmask 組合成 host/domain
#
```


# CentOS6 以前的作法

```bash
### 重新載入網路參數 /etc/sysconfig/network-scripts/
$# /etc/init.d/network restart

### 這是在 macbook 起的 CentOS7 的 VM
$# /etc/init.d/network status
設定好的裝置：
lo enp0s3
目前作用中的裝置：
lo enp0s3

### 啟動/關閉 某張網路介面
$# ifup enp0s3
$# ifdown enp0s3
# 啟動/關閉 /etc/sysconfig/network-scripts/ifcfg-enp0s3
```


### 設定自動取得 ip 的 connection

```bash
NEW_CONN=auto
IFNAME=eth0
nmcli con add con-name ${NEW_CONN} ifname ${IFNAME} type ethernet ipv4.method auto autoconnect yes
nmcli con up ${NEW_CONN}
```


### 手動設定 IP

```bash
CONN=fixed
IP4=172.17.91.94/28
GW4=172.17.91.81


nmcli con add con-name ${CONN} ifname eth0 type ethernet ipv4.method manual ipv4.addresses ${IP4} ipv4. autoconnect yes
nmcli con up ${CONN}

nmcli con mod ${CONN} ipv4.addresses 

nmcli con mod eth0 autoconnect no

nmcli con up ${CONN}

```
