# Ch8  - Providing File-based Storage

1. NFS
2. SAMBA

## 1. NFS

### 1-1. NFS Server

NFS 使用明碼傳輸, 本身不作身分驗證

- `/etc/exports`             : NFS設定檔 (我覺得寫在這就可以了="=)
- `/etc/exports.d/*.exports` : NFS自訂設定檔路徑

```sh
$# vim /etc/exports
# 裡面就只有 "兩個欄位"
/nfsShare       192.168.124.0/24(rw,sync,no_root_squash)
# 分享本地 /nfsShare
# 給 192.168.124.0/24 這網段上的所有網路介面
# rw : read-write
# sync : synchronize
# no_root_squash : 把 Client root 視為 Local root

##### 合理寫法 #####
/nfsShare   server22.example.com
/nfsShare   *.example.com
/nfsShare   server[0-30].example.com
/nfsShare   192.168.124.129
/nfsShare   192.168.124.0/24
/nfsShare   2000:487:87:c87:9487:1
/nfsShare   2000:487:87:c87::/64
/nfsShare   *.example.com 192.168.124.0/24
/nfsShare   192.168.124.129(ro) 192.168.124.130(rw)
/nfsShare   desktop[1-5].example.com(rw,no_root_squash)
```

分享本地磁碟 `/nfsShare`

```sh
### 1. 安裝 && 啟動服務
$# systemctl start nfs-server
$# systemctl enable nfs-server

### 2. 製作要分享的 nfs
$# mkdir /nfsShare
$# echo '看不到的是白癡' >> /nfsShare/hi
$# echo '/nfsShare  192.168.124.129(rw,sync,no_root_squash)' >> /etc/exports
$# exportfs -var
# -v : 顯示 export share 訊息
# -a : Export 或 Unexport 所有的 shares dir
# -r : Re-export

### 3. 防火牆
$# firewall-cmd --add-service=nfs
$# firewall-cmd --add-service=nfs --permanent

### 4. SELinux
# NFS Server 要分享的 share, 不用動到 SELinux
```

### 1-2. NFS Client

```sh
$# mkdir /mnt/fromNFS

### 手動掛載
$# mount server22:/nfsShare /mnt/fromNFS
$# df -h /mnt/fromNFS
$# umount /mnt/fromNFS

### 固定掛載
$# echo 'server22:/nfsShare      /mnt/fromNFS   nfs     sync    0 0' >> /etc/fstab
# ※※※ 謹慎操作!! 「>>」別用成「>」了...XD

$# mount -a

### SELinux
$# ll -Zd /mnt/fromNFS
drwxr-xr-x. root root system_u:object_r:nfs_t:s0       /fromNFS
# 客戶端掛好 NFS Share 之後, SELinux 預設幫你弄好了

$# df /mnt/fromNFS
server22:/nfsShare  11524096 4727296   6796800  42% /mnt/fromNFS
```

### 1-3. NFS Server export 選項

- 身分
    - root_squash(預設) : 把 `Client root` 視為 `本地 nfsnobody (UID=65534)` ;
    - no_root_squash : 把 `Client root` 視為 `本地 root`
    - all_squash : 不管是誰, 都視為 `本地 nfsnobody (UID=65534)`
- 存取權限:
    - ro(預設) : read-only
    - rw : read-write
- 同步/異步
    - sync(預設) : 同步寫入 NFS Server 磁碟
    - async : 異步處理; 先寫入 NFS Server 記憶體, 之後再寫入 NFS Server 磁碟

### 1-4. 清除現場

```sh
### desktop22 root
cd /
umount /mnt/fromNFS
rmdir /mnt/fromNFS

vim /etc/fstab
# 把剛剛 echo 進來的東西刪除

mount -a
# 請確保沒出錯!!
```

```sh
### server22 root
vim /etc/exports
# 把 export 出去的東西刪除

firewall-cmd --remove-service=nfs
firewall-cmd --remove-service=nfs --permanent

systemctl stop nfs-server
systemctl disable nfs-server

rm -rf /nfsShare
```

## 2. SAMBA

### 2-1. SAMBA 概念

- Windows 使用 SMB(Server Message Block), 以 SAMBA 這名稱來註冊
- Unix-like 使用 NFS(Network FileSystem)
- Unix-like 供 跨平台 使用 CIFS(Common Internet File System)

### 2-2. SAMBA Server

#### 2-2-1. 安裝

```sh
### 安裝
# 很特殊!! Server 端 要安裝 「samba-client」
$# yum install -y samba samba-client
# samba        : samba 主程式
# samba-client : samba 額外指令套件包 (因為要用 smbpasswd 這個指令)
```

#### 2-2-2. 設定檔

- `/etc/samba/smb.conf` : 設定主檔

```sh
### 設定檔
# 查看設定主檔 smb.conf
$# grep -v '^[#;]' /etc/samba/smb.conf | grep -v '^$' -
[global]    # 1 SMB Server 整體設定
        workgroup = SAMBA
        security = user                 # 若為 user, 則使用 username && password 作身分識別
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw
[homes]     # 2 特殊用途 (讓遠端電腦掛載家目錄)
        comment = Home Directories
        valid users = %S, %D%w%S        # 此會再覆寫「write list」; 若此為空, 所有 user 都可以 access share
        browseable = No
        read only = No
        inherit acls = Yes
[printers]  # 3 特殊用途 (不知道幹嘛用的)
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No
[print$]    # 4 特殊用途 (不知道幹嘛用的)
        comment = Printer Drivers
        path = /var/lib/samba/drivers   # Samba 分享的位置
        write list = @printadmin root   # writable = no 的 白名單
        force group = @printadmin
        create mask = 0664
        directory mask = 0775

# --------------- 以上分為 4 段 ---------------
# - hosts allow = XXX           僅允許特定人存取 Samba(若沒給, 所有人都可以 access Samba); 使用「 」「,」「\t」分隔; 若寫再 global 區塊, 則會「覆寫所有特例」; man hosts_access; EX: 「192.168.124.0/24」, 「192.168.124.」, 「.example.com」
# - workgroup                   Windows workgroup (預設為 WORKGROUP, WinXP 則為 MSHOME) This is used to help systems browse for the server using the NetBIOS for TCP/IP name service.
# - writable                    (預設為 no) 除非 ACL 的管控權限設得非常好, 否則建議額外再給「write list = @GROUP USER」
# - write list = @swrd, katy    此白名單內的人, 具有 rw 權限; 反之, 只有 ro (((注意!!! 我覺得這個超怪!!!!))))
# - valid users = @swrd         此清單內的人, 可以 access Samba, 不在該清單的人, 不被允許存取; 但此清單若為空, 則允許所有人存取; 此設定會再覆寫 write list (超級怪!!)
```

#### 2-2-3. 實作

##### 1. SAMBA Share Permission

###### 1-1. 改設定主檔

```sh
$# vim /etc/samba/smb.conf
# 新增下面的東西到最後------------------------------
[smbShareGG]
    path        =   /smbShare
    valid users =   frnk, @swrd
    hosts allow =   192.168.124.0/24
# 新增上面的東西到最後------------------------------
# 表示此為 ro (因 writable = no), 也沒給 「write list」
# 只允許 frnk 及 swrd 群組 具備 /sharepath 的 read-only 權限
```

###### 1-2. 製作 SAMBA Share

```sh
# 先建立 smb user
$# groupadd -r swrd                         # -r 表示, 給 <1000 的 gid
$# useradd -u 9001 -s /sbin/nologin howr
$# useradd -u 9002 -s /sbin/nologin frnk
$# useradd -u 9003 -s /sbin/nologin neko
$# usermod -aG swrd howr               # 加入附屬群組

# 建立 SMB user -> SMB DB
$# smbpasswd -a howr    # 密碼 howr
$# smbpasswd -a frnk    # 密碼 frnk
# 此 user 並非儲存到  /etc/shadow, 而是記錄到 SAMBA DB

# 查看哪些 user 已加入密碼至 SAMBA DB
$# pdbedit -L
howr:9001:
swrd:4294967295:
frnk:9002:

# 將 howr 從 SMB DB 移除
# $# smbpasswd -x frnk
# Deleted user frnk.
```

###### 1-3. 測試

```sh
### 組態檔設完之後, 測試組態檔, 看看是否有誤
$# testparm     # ENTER
Load smb config files from /etc/samba/smb.conf
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
Processing section "[homes]"
Processing section "[printers]"
Processing section "[print$]"
Loaded services file OK.
Server role: ROLE_STANDALONE

Press enter to see a dump of your service definitions
# 按 ENTER 後可以看到一堆 SAMBA 相關資訊, 此略
```

##### 1-3-1. Firewall

```sh
$# firewall-cmd --add-service=samba
$# firewall-cmd --add-service=samba --permanent
# smdb daemon TCP/445 port for SMB conn on TCP/139 for NetBIOS over TCP
# nmdb daemon UDP/137 && UDP/138 to NetBIOS over TCP/IP
```

##### 1-3-2. Service

```sh
$# systemctl start smb nmb
$# systemctl enable smb nmb
# nmb : 微軟 netbios 使用
```

##### 1-3-3. File System Permission

```sh
### root
mkdir /smbShare
echo '看不到的是智障' >> /smbShare/hi
chgrp swrd /smbShare
chmod 2775 /smbShare
ll -dZ /smbShare
```

##### 1-3-4. SELinux

- 要分享的 SAMBA share, SELinux 一定得是 `samba_share_t`

```sh
semanage fcontext -a -t samba_share_t '/smbShare(/.*)?'
restorecon -RF /smbShare
ll -dZ /smbShare

####### 下面的 SELinux 都屬於比較特殊的用法, 僅寫在這就不說了
# SAMBA ro
setsebool -P public_content_t    on
setsebool    public_content_t    on

# SAMBA rw
setsebool -P public_content_rw_t on
setsebool    public_content_rw_t on
setsebool -P smbd_anon_write     on
setsebool    smbd_anon_write     on

# SAMBA Server 允許把使用者家目錄當成 samba share 分享出去
setsebool    samba_enable_home_dirs on
setsebool -P samba_enable_home_dirs on
# 此為 /etc/samba/smb.conf 的 [homes] 區塊

# SAMBA Client 允許本地使用 遠端的 samba share 到家目錄
setsebool    use_samba_home_dirs on
setsebool -P use_samba_home_dirs on
```

### 2-3. SAMBA Client - CentOS7

參考 `/rhce2/Ch12 - Accessing Network Storage with SMB.md : 2-3 章節`

### 2-4 SAMBA Client - Windows 10

參考 `/rhce2/ch12 - Accessing Network Storage with SMB.md : 2-2 章節`

### 2-5. 清除現場

```sh
### Windows
# 好像要登出="= 不然快取那邊, 會讓 SAMBA Server 誤會還有人在用

### desktop22 root
vim /etc/fstab
# 把固定掛載SMB那行清除
mount -a
# 確保沒有出錯!!

cd /
umount /mnt/fromSMB

systemctl stop autofs
systemctl disable autofs
rmdir /mnt/autoSMB
rm -f /root/howr.key

rm -f /etc/auto.autosmb
rm -f /etc/master.d/smb.autofs
yum -y remove autofs

rmdir /mnt/fromSMB

ll /mnt
# 應該沒東西了~
```

```sh
### server22 root
smbpasswd -x howr
smbpasswd -x frnk

systemctl stop smb nmb
systemctl disable smb nmb

firewall-cmd --remove-service samba
firewall-cmd --remove-service samba --permanent

userdel -r howr 
userdel -r neko
userdel -r frnk
groupdel swrd

vim /etc/samba/smb.conf
# 移除最下面的 [smbShareGG] 區塊

rm -rf /smbShare
yum -y remove samba samba-client
```


### 2-6. 其他(懶得整理, 砍掉又有點不捨, 但又沒啥重點)

#### NetBIOS(Network Basic Input/Output System)

早期由 IBM 發展出來給 **少數電腦** 溝通之用, 後來被 微軟 拿去用

#### NetBIOS over TCP/IP

因為 NetBIOS 無法跨路由, 後來便利用此技術, 來實現跨路由傳輸

#### NetBEUI(NetBIOS Extended User Interface)

NetBIOS 改良版, 也是 IBM 開發

