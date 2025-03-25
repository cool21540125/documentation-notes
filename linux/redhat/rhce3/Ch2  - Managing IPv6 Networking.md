# Ch2 - Managing IPv6 Networking

1. nmcli 設定 IPv4
2. 設定 hostname(主機名稱)
3. 門外漢講 IPv6
4. nmcli 設定 IPv6

## 1. nmcli 設定 IPv4

- `/etc/sysconfig/network-scripts/ifcfg-*` : 連線組態(建議透過 `nmcli` 指令來修改)

```sh
ip link                     # 列出所有網卡裝置
ip addr                     # 列出所有連線(較簡明)
ifconfig                    # 查詢 IP 組態(較詳細)

nmcli dev status            # 查看網路介面
nmcli con show              # 查看網路連線

# 新增連線及裝置 ([]裡面, 按幾次 tab 知道該怎麼設定了)
nmcli con add con-name [eno2] type [ethernet] ifname [eno2] ipv4.addresses [192.168.88.1] gw4 [192.168.88.254] autoconnect yes

# 修改連線
nmcli con mod [eno2] ipv4.method manual
nmcli con mod eth0 autoconnect no

# 啟用連線
nmcli con up [eno2]

# 查詢 ipv4 連線設定
nmcli con show [eno2] | grep ipv4
```

### Quiz 1

> 登入 root@192.168.124.129, 新增一個網路連線:

- name 為 demo
- IPv4 為 192.168.124.222/24
- gw 為 192.168.124.254
- DNS 為 168.95.1.1
- 自動啟用

### Quiz 1 - Ans

```sh
### Question 1
ssh root@192.168.124.129

# 新增一個連線, 名為 demo, 把 IP 手動設成 192.168.124.222/24, 自動啟用
nmcli con add con-name demo ifname eth0 type ethernet autoconnect yes
nmcli con mod demo ipv4.addresses '192.168.124.129/24' ipv4.method manual
nmcli con mod demo +ipv4.addresses '192.168.124.222/24'
nmcli con mod eth0 autoconnect no
nmcli con up demo

nmcli con show demo | grep 'ipv4\|IP4'

ping -c2 8.8.8.8

nmcli con mod demo ipv4.gateway '192.168.124.254'
nmcli con up demo

ping -c2 google.com.tw

nmcli con mod demo ipv4.dns '192.168.2.115'
nmcli con up demo

ping -c2 google.com.tw
```

## 2. 門外漢講 IPv6

### 2.1 - IPv6 小知識

~~IPv4 快分發完了 (這句話 10 年前就聽說了)~~

不知道為啥沒有 IPv5 .....

目前還沒普遍的原因:

- **只用 IP6 的電腦** 還無法使用簡單的方法與 **只用 IP4 的電腦** 作溝通
- IPv4 還算夠用(這點是我猜的)
- 早年, 美國很多學校申請了一大堆 IP4, 導致能用的 IP4 幾近枯竭, 後來經由道德勸說, 他們才歸還申請過多的 IP4

目前多數電腦(像是 Google, 中華電信...), 採用雙軌並行(dual-stack), 所以他們可在公網域, 同時使用 IP4 及 IP6

使用 128 bits(128 個 0 或 1), 區分為 8 組, 故每組 16 bits(16 個 0 或 1), 以 16 進位表示的話, 需 4 碼

    2進位      16進位
    1011        b
    0010        2
    0001        1
    1010        a
    1111        f
    10000       10
    11110000    f0

     8組裡面其中一組         16進位
    0001000100000000        1100
    0011001100110011        3333
    1100110011001100        cccc
    1111111111111111        ffff

### 2.2 - IPv6 寫法

```sh
# 8 組 16 進位 (7個分號) 都用小寫!
2001:0db8:0000:0003:0000:0000:0000:0001     最冗長寫法
2001: db8:   0:   3:   0:   0:   0:   1     去掉開頭 0
2001:db8:0:3:0:0:0:1                        去掉空白~~
2001:db8:0:3::1                             可省略一次連續的 1~多組 的 0


# 「::」只能用一次 (正常來講有8組數值, 也就是 7 個 :)
2001:db8:0:10::1
# 多組(>=2) 0 再用 ::

# 下列也可省略
1:2:3:4:5:6:0:8
1:2:3:4:5:6::8

# 連帶 port 一起, ip部份要 [] 起來
[2001:db8:0:10::1]:80



# 下列如何縮寫? ((誰快睡著了我就問誰))
Q1
0:0:0:0:0:0:0:1
::1

Q2
2001:0db8:0000:0001:0000:0000:0000:0001
2001:db8:0:1::1
```

## 3. nmcli 設定 IPv6

- server22 ipv6: `fe80::97f9:62ec:f9d5:ea49/64` (自動取得)
- desktop22 ipv6: `fe80::97f9:62ec:f9d5:ea50/64` (改成這個)
- Host ipv6: `fe80::80f5:8c6f:43f9:dd4f%23` (桌機外部交換器)

```sh
$# nmcli con add con-name demo6 ifname eth0 type ethernet autoconnect yes
$# nmcli con mod demo6 ipv6.addresses 'fddb:fe2a:ab1e::c0a8:1/64' ipv6.method manual
$# nmcli con mod demo6 +ipv6.address 'fe80::e15a:db6b:41ed:e8ab/64'
$# nmcli con mod demo6 +ipv6.address 'fe80::97f9:62ec:f9d5:ea50/64'
$# nmcli con mod eth0 autoconnect no
$# nmcli con up demo6

$# nmcli con show demo6 | grep 'ipv6\|IP6'

###### ((免責聲明 - 下面做的事情, 我不懂, 所以不解釋)) ######
$# ip a
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:00:08:0a brd ff:ff:ff:ff:ff:ff
    inet 172.25.8.10/24 brd 172.25.8.255 scope global dynamic eth0
       valid_lft 21529sec preferred_lft 21529sec
    inet6 fddb:fe2a:ab1e::c0a8:1/64 scope global    # global
       valid_lft forever preferred_lft forever
    inet6 fe80::97f9:62ec:f9d5:ea50/64 scope link   # link local
       valid_lft forever preferred_lft forever
    inet6 fe80::e15a:db6b:41ed:e8ab/64 scope link   # link local
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe00:80a/64 scope link
       valid_lft forever preferred_lft forever

# ping6
$# ping6 -c2 fddb:fe2a:ab1e::c0a8:1            # Global unicast ping desktop22
$# ping6 -c2 fe80::e15a:db6b:41ed:e8ab%eth0    # Link-local ping desktop22(需指定外送介面)
$# ping6 -c2 fe80::97f9:62ec:f9d5:ea50%eth0    # Link-local ping server22(需指定外送介面)
$# ping6 -c2 fe80::80f5:8c6f:43f9:dd4f%eth0    # ?? ping ExternalSwitch(需指定外送介面)

# 可以透過 ipv6 進到 server22 了
$# ssh root@fe80::97f9:62ec:f9d5:ea49%eth0

# Host 可以透過 ipv6 進到 desktop22 了
$# ssh root@fe80::e15a:db6b:41ed:e8ab%23
```

### Quiz 2

> 發現剛剛所有舉動都太過瘋狂了, 還原案發現場吧!!

### Quiz - Ans

```sh
### Question 2
ssh root@desktop22

nmcli con up eth0
nmcli con mod eth0 autoconnect yes
nmcli con del demo
nmcli con del demo6

nmcli con show
```

# IPv6 其他

- `::1/128` (localhost) : 等同 `127.0.0.1/8` on loopback interface
- `::` (unspecified address) : 等同 `0.0.0.0`, 可能是 ip 衝突, 另此設定可能會 listening on all configured IP addresses.
- `::/0` (default route) : 等同 `0.0.0.0/0`.
- `2000::/3` (Global unicast address) : 此由 IANA 發布. 範圍為 [`2000::/16`, `3fff::/16`]
- `fd00::/8` (Unique local addresses) : private routable IP address. 通常是 `/48` or `/64` (我到底在寫三小我也看不懂)
- `fe80::/64`(Link-local addresses) : 所有 IPv6 介面, 都會自動設定 link-local address. 而這些 local link 只能在同網段內使用.
