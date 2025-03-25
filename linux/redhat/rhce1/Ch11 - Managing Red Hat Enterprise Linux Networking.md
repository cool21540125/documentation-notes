# Ch11 - Managing Red Hat Enterprise Linux Networking

1. TCP/IP
2. 網卡命名
3. nmcli
4. 主機名稱 && 名稱解析

## 1. TCP/IP

詳 [TCP/IP](https://github.com/cool21540125/documentation-notes/blob/master/network/tcpip.md)

## 2. 網卡命名

`wlp2s0`, `enp1s0`, `eth0`, `eth1`, ... 到底是啥挖歌

CentOS6 以前 及 虛擬機 : **eth0**, **eth1**, **eth2** . 命名依據則是 `網卡插在電腦上的哪個 port(硬體上的那個洞啦!!), 就會給予 該 port 的編號. 簡單的說, 插在第一個洞=eth0, 插在第二個洞=eth1, ...`; 而虛擬機裏頭, 因為是 `虛擬作業系統`, 透過 #@)\*^!#... 的機制, 抓取實體作業系統的網卡, 所以一樣會看到 `eth0` 這東西

ex: `wlp2s0`, `enp1s0`

#### 第 1~2 碼

- en : 乙太雙絞線
- wl : 無線
- ww : 廣域網路介面

#### 第 3 碼(可能多碼)

- o : `on-board` 主機板上的網卡
- s : `hotplug slot` USB 網卡
- p : `PCI geographic location` PCI 介面網卡
- x : `MAC address`

#### 第 4 碼

- 1 : PCI 介面第 1 孔
- 2 : PCI 介面第 2 孔

#### 第 5~6 碼

- s0 : 網卡上第 1 個孔

別問我, 為何我筆電上面插 USB 網卡時, 怎麼會出現 `wlp0s20f0u1`, `wlp0s20f0u3`... 這類的怪名字, 我不知道!

## 3. nmcli

Network Manager Command LIne

- OS6 : 就已經存在了~ 但是 BUG 一大堆~~
- OS7 : 基本功能基本上沒 BUG, 但是進階設定仍有些問題...

一張 `網路介面卡(NIC)` 能設定多組的 `connection`, 但是同一時間, 只能啟用其中一組 `connection`

```sh
# 查看 網路介面卡
$ nmcli dev
DEVICE     TYPE        STATE         CONNECTION
enp1s0     ethernet    已連線        enp1s0
docker0    bridge      已連線        docker0
wlp2s0     wifi        離線          --
lo         loopback    不受管理的    --

# 查看 連線
$ nmcli con
NAME             UUID                                    TYPE        DEVICE
docker0          08d8ebe4-b98d-4e72-83fa-85c0c875e886    bridge      docker0
enp1s0           05ffb7ea-a013-4941-93b2-6c78c28babd4    ethernet    enp1s0
14f-classroom    d55d8f48-b7ce-449f-bb99-edbecd6829a2    wifi        --
XZS              bb519419-0ccb-4557-9afb-61bb920a8cfc    wifi        --
tonyCJ           ef896290-e66a-4968-b38e-4ce6104d78df    wifi        --
wifi383-13       d5097dd9-b0db-4201-9ab0-df79b7219bd3    wifi        --
```

指令提示: 善用 <kbd>tab</kbd>

```sh
# 查看 connection 細節 (通常會用 | grep xxx 來找關鍵字)
$ nmcli con show enp1s0 | grep ipv4
ipv4.method:                            auto
ipv4.dns:                               --
ipv4.addresses:                         --
ipv4.gateway:                           --
ipv4.routes:                            --
ipv4.ignore-auto-dns:                   否
ipv4.dhcp-send-hostname:                是
ipv4.dhcp-hostname:                     --
# 僅節錄部分

# 增加一個連線, 名稱為 wahaha, 靜態IP為 192.168.124.222
$# nmcli con add \
    con-name wahaha \
    type ethernet \
    ifname enp1s0 \
    ipv4.addresses 192.168.124.222/24 \
    ipv4.method manual \
    autoconnect yes

$# nmcli con mod eth0 autoconnect no

$# nmcli con up wahaha
```

## Common Usage

```bash
### 網卡名稱
$# IFNAME=eth0
$# nmcli con add \
      con-name auto \
      type ethernet \
      ifname ${IFNAME} \
      ipv4.method auto \
      autoconnect yes

$# OLD_CONN=eth0
$# nmcli con mod ${OLD_CONN} autoconnect no

$# nmcli con up auto
```

網卡連線檔, 放在 `/etc/sysconfig/network-scripts/ifcfg-*`

## 4. 主機名稱 && 名稱解析

#### 名詞定義:

- 名稱解析: 用 網址 查找 IP
- 名稱反查: 用 IP 查找 網址

#### 釐清 URI, URL, URN

- [Uniform Resource Identifier (URI): Generic Syntax](http://www.ietf.org/rfc/rfc3986.txt)
- [What is the difference between a URI, a URL and a URN?](https://stackoverflow.com/questions/176264/what-is-the-difference-between-a-uri-a-url-and-a-urn?page=1&tab=active#tab-top)

* 本機名稱定義檔, 放在 `/etc/hostname`, 使用 `hostnamectl` 會去查找此定義檔, 若該檔案不存在, 則會前往 DNS 作名稱反查(用 IP 查 hostname)
* 名稱查找定義檔, 放在 `/etc/resolv.conf`,
