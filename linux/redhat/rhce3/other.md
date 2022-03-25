

```sh
# 自訂裝置名稱, 鎖 HardWare
nmcli connection modify enp1s0 802-3-ethernet.mac-address xx:xx:xx:xx:xx:xx connection.interface-name DMZ
```


# IPv6

32個字, 8組, 2^128, 16進位

1. IPv6 位址格式 `xx:xx:xx:xx:xx:xx:xx:xx`

2. IPv6 位址類型
  - 2-1 Unitcast
    - Global :        `2000::/3` 跟 ISP 申請到再來設定 (考試就考這個!!)
    - Unique-local :  `FC00::/7` 私有領域可以 route
    - Link-local :    `FE80::/10` 私有領域不可 route, ex: 中華民國身份證 (無法跨越路由器)
  - 2-2 Multicast :       `FF00::/8`
  - 2-3 Anycast(對最近點的單一主機) : Address 同 Global unitcast

3. IPv6 定址架構
  - ISP Prefix :      `...::/32` (ISP業者拿到的)
  - Site Prefix :     `...::/48` (通常是企業用)
  - Subnet Prefix :   `...::/64` (終端裝置)
  IPv6 位址在終端裝置的使用, `SubnetPrefix:InterfaceID/64`

4. IPv6位址的設定方法
  - Static
    - Manual (考試就考這個!!)
    - EUI-64
  - Dynamic
    - Stateless (Router)
    - Statefull (Router + DHCPv6)




# dns

- [Unbound DNS Tutorial](https://calomel.org/unbound_dns.html)
- 2018/12/03

```sh
# 7-11 they build their own mail server
$ host -t MX 7-11.com.tw
7-11.com.tw mail is handled by 5 cpmailproxy.7-11.com.tw.

# uuu use Microsoft mail service
$ host -t MX uuu.com.tw
uuu.com.tw mail is handled by 10 uuu-com-tw.mail.protection.outlook.com.

# Teacher's mail (Use Google mail service)
$ host -t TXT i-sun.tw
i-sun.tw descriptive text "google-site-verification=f1dOfjwlLMdFYeZ6yHHdbst79m-3l4T1f1nN9R8lWQA"
```

## dns caching configurations
1. `Simple recursive caching DNS`              : 使用  `53/UDP` 連接 public DNS(不加密),  此為標準的 DNS 方法.
2. `DNS Over TLS simple recursive caching DNS` : 使用 `853/TCP` 連接 public DNS(TLS加密), 因此所有的 DNS request 都隱藏在 DNS Server
We have two(2) simple dns caching configurations. The first, "" uses UDP port 53 to connect to public DNS servers without encryption which is the standard DNS method. The second option is "" which connects to compatable public DNS servers over TCP port 853 with TLS encryption so all of your DNS requests are hidden on the wire up to the DNS server itself.



# NFS (2018/10/14)

- NFS Server : 分享檔案系統
- 使用 NFS 的 Server 及 Client, 都得開啟 RPC(port 111)
- Server 端的 NFS 會向 RPC 註冊, RPC 便知道 NFS 相關的 port, PID, IP 等等
- Client 使用 RPC 向 Server 詢問相關 NFS 服務
- NFS Server 為 RPC Server 之一
- NFS Server 以匿名帳號 nfsnobody (65534) 來作驗證


## NFS Server

### requests:

1. `rpcbind`
2. `nfs-utils`
    - rpc.nfsd : 登入驗證(能否掛載)
    - rpc.mountd : 權限驗證


### 相關檔案

- 設定檔 : `/etc/exports`
- 主程式 : `/usr/sbin/exportfs`
- 登錄檔
    - 權限設定檔 : `/var/lib/nfs/etab` (細部的 權限 設定資料)
    - 用戶端資料 : `/var/lib/nfs/xtab` (哪些 用戶端 掛載了 本機 提供的 NFS)
- 用戶端查詢 NFS Server 資源 : `/usr/sbin/showmount`
- 查 RPC 註冊狀況 : `rpcinfo`
- NFS Server 提供之資料重新掛載(免 restart) : `exportfs -var`


#### NFS Server 權限參數

- no_root_squash : 把 Client root 視為 Local root
- root_squash(預設) : 把 Client root 視為 匿名使用者(預設為 nfsnobody)
- all_squash : 不管是誰, 都視為 匿名使用者(預設為 nfsnobody)
- ro : read-only
- rw : read-write
- async : 異步處理; 先寫入 NFS Server 記憶體, 之後再寫入 NFS Server 磁碟
- sync(預設) : 同步寫入 NFS Server 磁碟
- anonuid : 自訂的 匿名使用者 (NFS Server 內的 /etc/passwd 中, 要有此 UID)
- anongid : 自訂的 匿名使用者 (NFS Server 內的 /etc/group 中, 要有此 GID)


### Example

```sh
##### NFS Server
$# systemctl start rpcbind  # also enable
$# systemctl start nfs      # also enable
$# mkdir /sharing
$# touch demo > /sharing
$# cat '/sharing    192.168.124.73(rw,no_root_squash)' > /etc/exports
$# exportfs -var            # 重新讀取組態檔

##### NFS Client 查 NFS 資源
$# showmount -e 192.168.124.133
clnt_create: RPC: Port mapper failure - Unable to receive: errno 113 (No route to host)
# NFS Server 沒開 rpc-bind 防火牆啦~

##### Server 開放 rpc-bind~~
$# firewall-cmd --add-service=rpc-bind      # also --permanent

##### NFS Client
$# showmount -e 192.168.124.133
rpc mount export: RPC: Unable to receive; errno = No route to host
# ㄇㄉ, NFS Server 沒開 mount 相關防火牆啦~

##### Server 再開放 mountd
$# firewall-cmd --add-service=mountd        # also --permanent

##### NFS Client
$# showmount -e 192.168.124.133
Export list for 192.168.124.133:
/sharing 192.168.124.73
# 192.168.124.133 分享了 /sharing 給 192.168.124.73

$# mkdir /fromNFS

# 掛載~~~
$# mount -t nfs 192.168.124.133:/sharing /fromNFS
mount.nfs: No route to host
# 然後發現, ㄊㄋㄋㄉ, 對方兩光系統管理員, 防火牆一直沒開好

##### Server 再開放 nfs
$# firewall-cmd --add-service=nfs           # also --permanent

##### NFS Client
$# mount -t nfs 192.168.124.133:/sharing /fromNFS
```


## 自動掛載

```sh
##### NFS Client
$# systemctl start autofs                   # also enable


```




# iSCSI

```sh
##### iSCSI Server
$# yum install -y targetcli

$# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

# 進入後的起始位置
/backstores> ls
o- backstores ....................................................................... [...]
  o- block ........................................................... [Storage Objects: 0]
  o- fileio .......................................................... [Storage Objects: 0]
  o- pscsi ........................................................... [Storage Objects: 0]
  o- ramdisk ......................................................... [Storage Objects: 0]

# 根目錄結構
/backstores> ls /
o- / ................................................................................ [...]
  o- backstores ..................................................................... [...]
  | o- block ......................................................... [Storage Objects: 0]
  | o- fileio ........................................................ [Storage Objects: 0]
  | o- pscsi ......................................................... [Storage Objects: 0]
  | o- ramdisk ....................................................... [Storage Objects: 0]
  o- iscsi ................................................................... [Targets: 0]
  o- loopback ................................................................ [Targets: 0]

# 建立 Disk Image
/backstores> cd block
/backstores/block> create san1 /dev/sda5
Created block storage object san1 using /dev/sda5.

# 查看變化
/backstores/block> ls /backstores/
o- backstores ....................................................................... [...]
  o- block ........................................................... [Storage Objects: 1]
  | o- san1 .................................. [/dev/sda5 (0 bytes) write-thru deactivated]
  |   o- alua ............................................................ [ALUA Groups: 1]
  |     o- default_tg_pt_gp ................................ [ALUA state: Active/optimized]
  o- fileio .......................................................... [Storage Objects: 0]
  o- pscsi ........................................................... [Storage Objects: 0]
  o- ramdisk ......................................................... [Storage Objects: 0]


# 建立 target
/backstores/block> cd /iscsi
/iscsi> create iqn.2018-10.com.demo:tony
Created target iqn.2018-10.com.demo:tony.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.

# 查看變化
/iscsi> ls /
o- / ................................................................................ [...]
  o- backstores ..................................................................... [...]
  | o- block ......................................................... [Storage Objects: 1]
  | | o- san1 ................................ [/dev/sda5 (0 bytes) write-thru deactivated]
  | |   o- alua .......................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp .............................. [ALUA state: Active/optimized]
  | o- fileio ........................................................ [Storage Objects: 0]
  | o- pscsi ......................................................... [Storage Objects: 0]
  | o- ramdisk ....................................................... [Storage Objects: 0]
  o- iscsi ................................................................... [Targets: 1]
  | o- iqn.2018-10.com.demo:tony ................................................ [TPGs: 1]
  |   o- tpg1 ...................................................... [no-gen-acls, no-auth]
  |     o- acls ................................................................. [ACLs: 0]
  |     o- luns ................................................................. [LUNs: 0]
  |     o- portals ........................................................... [Portals: 1]
  |       o- 0.0.0.0:3260 ............................................................ [OK]
  o- loopback ................................................................ [Targets: 0]

```



# IPv6

IPv6 address 或 network | 目的 | 說明
--- | --- | ---
::1/128 | localhost | loopback interface
:: | 無法指定 Address | 可能發生 IP 衝突了
::/0 | IPv6 default route | 類似 0.0.0.0/0
2000::/3 | Global unicast addr | 
fd00::/8 | Unique Local addr | 
fe80::/64 | Link-local addr | 
ff00::/8 | Multicast | 

```sh
# Multicast
ping6 ff02::1%eth0  # ping6 link local, 要指定外送介面
```


# SAMBA users

`/etc/samba/smb.conf` 裏頭的 `security = user`, 需要有:
1. Linux account
2. Samba account 及 NTLM password (NT LAN Manager)

```sh
### root
useradd -s /sbin/nologin sambauser
yum install -y samba-client
smbpasswd -a sambauser  # 加入 samba account
smbpasswd -x sambauser  # 刪除 samba account
pdbedit -L              # 查看那些人已加入密碼到 samba db
systemctl start smb nmb # 啟用 smdb, nmdb
```

* smdb daemon 使用 `TCP/445`
* smdb daemon 也使用 `TCP/139` 來作 NetBIOS over TCP 作向後兼容
* nmdb daemon 使用 `UDP/137` 及 `UDP/138` 提供 `NetBIOS over TCP/IP network browsing support`
* 以上都是廢話!! 直接防火牆開服務就好了 `firewall-cmd --add-service samba --permanent`




# nfs

```sh
### Package
# nfs server
yum install -y nfs-utils
yum install -y nfs-secure-server

# nfs client
yum install -y nfs-utils
yum install -y nfs-secure
yum install -y autofs
```

# samba

```sh
### Package
# samba server
yum install -y samba
yum install -y samba-client

# samba client
yum install -y cifs-utils
yum install -y autofs

# multiuser mount
cifscreds add server22

# fstab
# //server22/smbshare   /mnt/multiuser  cifs    credentials=/root/smb.txt,multiuser,sec=ntlmssp 0 0
```

