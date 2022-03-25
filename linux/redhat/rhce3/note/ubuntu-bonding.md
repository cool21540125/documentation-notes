# Network Teaming on Ubuntu 16.04

- 2019/01/07
- [What is Network Bonding? Types of Network Bonding](https://www.interserver.net/tips/kb/network-bonding-types-network-bonding/)
- [LACP 與 bonding/team 及 IPv6 簡易設定](http://dic.vbird.tw/linux_server/unit03.php)

1. 概念
2. 實作


## 1. 概念

參考 `/rhce3/Ch3  - Configuring Link Aggregation and Bridging.md`

重要概念:

- 一個 `Network Device` 可以有多個 `Network Connection`

bond 的 7 種模式:

mode | bond strategy | runner(OS7)  | description
---- | ------------- | ------------ | ---------------------------
0    | balance-rr    | roundrobin   | Simple Load-Balance
1    | active-backup | activebackup | High Availability
2    | balance-xor   | loadbalance  | Complex Load-Balance
3    | broadcast     | broadcast    | ?
4    | 802.3ad       | lacp         | ?
5    | balance-tlb   | ?            | ?
6    | balance-alb   | ?            | ?


## 2. 實作

公司內網, 連線至 `user@192.168.124.81`


### 2-1. Teaming && Bonding

- CentOS 7           : Network Teaming
- Ubuntu 16.04       : Network Bonding
- Ubuntu 更老舊的機制 : 不知道叫啥名字, 但請安裝 ifenslave

但對於 CentOS 來說, CentOS6 是使用 Bonding (比較老舊)

```sh
# 讓 Linux Kernel 載入 bonding 這個模組
$# modprobe bonding


# 列出 Linux Kernel 已掛載的模組
$# lsmod
Module                  Size  Used by
bonding               147456  0
#                             ↑ 表示該模組, 並沒有相依性模組
# (以上僅節錄必要模組...)
```

### 2-2. Network

```sh
$# nmcli dev
DEVICE           TYPE      STATE         CONNECTION
enp2s0           ethernet  connected     Wired connection 2     # 第一個 Ethernet 網路介面
eno1             ethernet  disconnected  --                     # 第二個 Ethernet 網路介面
#                ↑↑↑↑↑↑↑↑ 乙太網路

$# nmcli con show
NAME                UUID                                  TYPE            DEVICE
Wired connection 2  d3bbcb6e-8a29-3150-ade0-15a5f6a2bf98  802-3-ethernet  enp2s0        # 第一個 Ethernet 介面的 Connection

# 增加第二個 ethernet 連線 到 eno1 這個網路介面, 連線名稱為 'Wired connection 3'
$# nmcli con add con-name 'Wired connection 3' ifname eno1 type ethernet
Connection 'Wired connection 3' (b5cd2644-5806-48e6-9f85-1f295e3831b9) successfully added.

$# nmcli con show
NAME                UUID                                  TYPE            DEVICE
Wired connection 2  d3bbcb6e-8a29-3150-ade0-15a5f6a2bf98  802-3-ethernet  enp2s0        # 第一個 Ethernet 介面的 Connection
Wired connection 3  b5cd2644-5806-48e6-9f85-1f295e3831b9  802-3-ethernet  eno1          # 第二個 Ethernet 介面的 Connection

# 增加 bonding
$# nmcli con add con-name bond0 ifname bond0 type bond
Connection 'bond0' (b3165eab-73a8-438c-a10b-e7f4f8eeede1) successfully added.

$#
```