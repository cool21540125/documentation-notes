# Ch11 - Accessing Network Storage with Network File System (NFS)

1. 摘要
2. 手動掛載
3. 固定掛載
4. 自動掛載


## 1. 摘要

### 1.1 本章 demo 的範例

- NFS Server(server22) : `192.168.124.118`, 提供 `/nfsShare`
- NFS Client(desktop22) : `student@192.168.124.129`, 密碼 `student`

### 1.2 故事

Linux 把自己的 `儲存區(檔案系統格式為 : nfs)` 分享給網路上的其他使用者(Linux)掛載 (無法跨 OS)

ex: 192.168.124.118 把 /nfsShare 分享出去, 那問題就來了...

- 位於 192.168.89.9   的 rich  可以存取嗎?
- 位於 192.168.124.88 的 jason 可以存取嗎?
- 位於 192.168.124.44 的 sunny 可以存取嗎?
- 位於 192.168.124.44 的 root  可以存取嗎?

但上述問題更根本的問題是, 192.168.124.88 的 jason 在 192.168.124.118:/nfsShare 作修改, 那麼 192.168.124.118 認識 192.168.124.88 的 jason 囉??(/etc/passwd 存在 jason 這個使用者)????

所以要把所有人的 /etc/passwd, /etc/shadow, /etc/group 作同步囉...@@凸......??

不可能!!

實務上, 掛載遠端磁碟, 會搭配 `集中驗證伺服器` (LDAP, IPAServer, Kerberos 等等), 非常進階, 無能實作

### 1.3 套件

```sh
### CentOS7
# yum install -y nfs-utils    # 預設已安裝 && 已啟用

### Ubuntu
apt install nfs-common
service nfs-utils start
service nfs-utils enable
```

###### ※以上 krb5, 相關的東西, 很進階, 當作不知道

### 1.4 安全性

※ NFS 本身的服務`並沒有`進行身分登入的識別!! (常會搭配 Kerberos, LDAP, IPA Server 來使用...)

`NFS Server` 提供的安全性政策(你把別人家檔案系統掛載到你家之後, 你能對它做些什麼):

Security methods | Setting     | Description 
---------------- | ----------- | -------------------------------------
none             | sec=none    | Client 一律被視為 `nfsnobody (UID=65534)`, 存取規則同 sys
sys(default)     | sec=sys     | Client 的存取權限, 一律以 UID, GID 來對照 DAC 及 ACL
krb5             | sec=krb5    | Client 使用 kerberos 所提供的身分: UID 及 GID
krb5i            | sec=krb5i   | Client 使用 kerberos 所提供的身分: UID 及 GID; 連線方式強化加密保證, 確保資料傳輸時不被竄改
krb5p            | sec=krb5p   | Client 使用 kerberos 所提供的身分: UID 及 GID; 連線傳輸時, 使用密文傳輸(效能會打折扣)

###### 上述 krb5, 皆須啟用 `nfs-secure service`, 且須取得 Kerberos 配送的 `/etc/krb5.keytab` 認證檔, 並且加入 Kerberos Realm (看不懂很正常, 我也不懂)

- 參考 `/rhce2/attach/NFS.xml`

### 1.5 掛載基本概念複習

```sh
# 建立 Client 的 掛載目錄(/fromNFS/tony)
mkdir -p /fromNFS/tony

# 掛載 遠端磁碟 到 本地
mount -t nfs -o [掛載參數1,掛載參數2,...] [來源IP]:[絕對路徑] [本地絕對路徑]
# 「-t nfs」基本上可以省略, CentOS7 會幫忙判斷, 但如果是舊版 or Ubuntu 還啥鬼的, 我就不清楚了

# 把 server22:/share 掛載到本地的 /fromNFS/tony
mount -o sync 192.168.124.118:/nfsShare /fromNFS/tony
# -o sync : 檔案系統同步(預設為 async)
# -o sec=sys : (沒指定的話以此為預設)
# 多個選項之間, 以「,」分隔, 中間不得有「 」

# 卸載
umount [本地絕對路徑]
```

## 2. 手動掛載

```sh
$# mkdir /fromNFS_manual

$# mount -o sync server22:/nfsShare /fromNFS_manual

$# df -h
```

## 3. 固定掛載

開機的時候, 就自動掛好在那邊了(多少會吃點RAM)

```sh
$# mkdir /fromNFS_fstab
$# vim /etc/fstab
# ---------新增這個-----------------
server22:/nfsShare      /fromNFS_fstab  nfs     sync    0 0
# ---------新增這個-----------------

# 確保 fstab 設定無誤
$# mount -a

$# df -h
```

## 4. 自動掛載

### 4-1 基本概念

需要用到的時候即時掛載 ; 若閒置 > 5分鐘, 系統會自動卸載(省資源)

### 4-2 套件:

```sh
### 自動掛載的前置作業
yum install autofs
systemctl start autofs
systemctl enable autofs

### 搭配 krb5 身分驗證時
# yum install nfs-secure

# 準備好 /etc/krb5.keytab 之後, 啟動才不會發生錯誤
# systemctl start nfs-secure
# systemctl enable nfs-secure
```

- /etc/auto.master    : 設定主檔
- /etc/auto.master.d/ : 自訂設定檔目錄

### 4-3 automounter

可區分為 2 種掛載方式 :

1. direct   : 適合用來掛載 特定目錄
2. indirect : 適合用來掛載 家目錄 (Sorry... 我還不會作這東西的 Server)

* `/etc/auto.master` : autofs 組態主檔
* `/etc/auto.master.d/*.autofs` : autofs 自訂組態主檔目錄(裡面的東西, 都得是 `.autofs` 結尾)
  * 內容格式有 2 欄, `本地掛載點起始目錄  autofs副檔位置`
* `/etc/auto.*` : autofs 組態副檔
  * 內容格式有 3 欄, `本地掛載點起始目錄底下的目錄  掛載選項  來源位置`


以下範例為, direct mapping, 目的是將 `server22:/nfsShare 掛載到本地的 /fromNFS`

```sh
# 若是作 direct mapping, 掛載點必須要已存在
$# mkdir /fromNFS
$# mkdir /fromNFS/server

$# vim /etc/auto.master.d/demo.autofs   # 可隨意命名, 但一定得要是 .autofs 結尾
/-    /etc/auto.demo
#↑    ↑↑↑↑↑↑↑↑↑↑↑↑↑↑
# 掛載點     副檔位置

# 此為 自訂設定檔(demo.autofs)之副檔
$# vim /etc/auto.demo
/fromNFS/server -sync   server22:/nfsShare

$# systemctl restart autofs

$# df -h
# 理應找到 /fromNFS
```

