# Ch7  - Providing Remote Block Storage

1. iSCSI 與 SAN
2. iSCSI target
3. iSCSI client

## 1. iSCSI 與 SAN

- DAS(Direct-Attached Storage Storage) : 本機直接存取的儲存裝置
- NAS(Network Attached Storage)        : 網路附加儲存伺服器 (含作業系統 -> 檔案系統 已經幫你弄好了)
- SAN(Storage Area Networks)           : 儲存區域網路 (不含作業系統 -> 檔案系統 得自己作格式化)(使用光纖傳輸)
- iSCSI(Internet SCSI)                 : 使用 Ethernet 來傳輸的 SAN

乙太網路還沒長大以前(速度還很慢), 業界使用檔案, 使用的不外乎是: 自己電腦上磁碟(SCSI介面) 與 區域網路上的磁碟(NAS, SAN, ...). 本章要講的就是 SAN 這東西. 而區域網路之間的檔案傳輸多半依賴 FC (Fibre Channel, 光纖通道), 成本高昂... 後來隨著 乙太網路長大, 傳輸速度快速的朝向光纖邁進, iSCSI 才開始發展起來. 因為 iSCSI 底層跟 SCSI 一樣, 使用 cdb 指令集與硬體溝通, 而網路傳輸依賴 `TCP/IP`, 實現 SAN 傳輸的平價方案. 此外, 區域網路上, 使用 SAN 時, 就有多種選擇:

1. 使用 TOE 網卡, 可直接使用 SAN ;
2. 使用一般的 NIC, 需要搭配 `軟體 iSCSI` **本章要講的**

供需雙方稱呼:

* 儲存供給者 : `iSCSI Server` 或 `target`
* 儲存需求者 : `iSCSI Client` 或 `initiator`

因為 Client 要透過網路, 跟 Server 要資源, 所以便存在 Authentication, Authorization, Security 等問題. ~~但如果是在你所信任的區域網路內, 其實, 這些好就不是非常重要了??~~

### 1-1. 一堆要繼續講下去之前要知道的專有名詞

Term      | Description
--------- | -------------------
initiator | iSCSI Client ; 具有一組不重複的 IQN (PK)
target    | iSCSI Server ; 具有一組不重複的 IQN (PK)
IQN       | iSCSI Qualified Name ; Unique ; Naming:`iqn.YYYY-MM.com.reversed.domain[:optional_string]`
node      | 任何一個 initiator 或 target 都稱為一個 node
TPG       | Target Portal Group ; 此為 ACL + LUN + Portal
 + Portal | node 雙方, 用來傳輸的 IP + Port
 + ACL    | Access Control List(並非檔案系統 Permission 的 ACL) ; 紀錄著 `可存取 target 的 initiator 的 IQN`
 + LUN    | Logical Unit Number ; 附加在 target 上面要拿來被使用的 `儲存體的名稱`

Action    | Description
--------- | ---------------------
discovery | initiator 用來查詢 target 有哪些 LUN 可用
login     | initiator 用來登入 target

> com.reversed.domain 為 到著寫的 Domain Name, ex: `tony.com.tw` 就變成 `tw.com.tony`

> YYYY-MM 為此 Domain Name 的生日年月, ex: `2018-10`

> WWN : FC 使用的 IQN ; 簡單的說, 如果使用光纖的話, IQN 就要改成 WWN

### 1-2. 注意

target 的檔案系統, 請使用 `Global File System(GFS2)`, 否則給 `多用戶同時` 掛載時, 可能會造成 corruption!!

※簡言之, iSCSI 的提供者, 檔案系統請用 `gfs2`

## 2. iSCSI target

### 2-1. 前置作業

#### 2-1-1. 套件
```sh
### iSCSI target
yum install -y targetcli
```

#### 2-2-2. 區塊儲存空間

```sh
# 我的空隨身碟位於 /dev/sdb (看自己的狀況而定, 別無腦跟著操作阿@@!!)
$# fdisk /dev/sdb
# 過程省略了~~ 總之要弄出下面這樣, 不知怎弄請參考 /rhce2/Ch10

Command (m for help): p

Disk /dev/sdb: 15.6 GB, 15552479232 bytes, 30375936 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    30375935    15186944   83  Linux   # 16G 的隨身碟

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```

### 2-2. targetcli 使用

使用方式分為兩種: 

1. one line command : 一口氣打完的那種... 用在 Shell Script 居多
2. interactive shell : 給凡人用的, 有 TAB completion!!

### 2-3. backstores (target 後端儲存設備)

- **block**   : 完整的磁碟, Partition, LVM 的 LV, RAID, any device files ; 區塊儲存空間啦(block device)!!
- **fileio**  : VM image (映像檔, 就是光碟啦)
- **pscsi**   : 實體 SCSI (Physical SCSI)(不常用)
- **ramdisk** : in memory (慎用)

### 2-4. 建立 target

```sh
### 進入互動式介面
$# targetcli

### iSCSI target 的 檔案系統 根目錄結構
/> ls
o- / ............................................................................................... [...]
  o- backstores .................................................................................... [...]
  | o- block ........................................................................ [Storage Objects: 0]
  | o- fileio ....................................................................... [Storage Objects: 0]
  | o- pscsi ........................................................................ [Storage Objects: 0]
  | o- ramdisk ...................................................................... [Storage Objects: 0]
  o- iscsi .................................................................................. [Targets: 0]
  o- loopback ............................................................................... [Targets: 0]

# 建立 iSCSI Block Storage
/> /backstores/block create usb1 /dev/sdb1
Created block storage object usb1 using /dev/sdb1.

# IQN
/> /iscsi create iqn.2018-11.com.smartrd:tonynb
Created target iqn.2018-11.com.smartrd:tonynb.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.

# ACL
/> /iscsi/iqn.2018-11.com.smartrd:tonynb/tpg1/acls create iqn.2018-11.com.smartrd:desktop22
Created Node ACL for iqn.2018-11.com.smartrd:desktop22

# LUN
/> /iscsi/iqn.2018-11.com.smartrd:tonynb/tpg1/luns create /backstores/block/usb1
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.2018-11.com.smartrd:desktop22

# Portal
/> /iscsi/iqn.2018-11.com.smartrd:tonynb/tpg1/portals create 192.168.124.73 3260
Using default IP port 3260
Created network portal 192.168.124.73:3260.

# 完成!!
/> ls
o- / ............................................................................................... [...]
  o- backstores .................................................................................... [...]
  | o- block ........................................................................ [Storage Objects: 1]
  | | o- usb1 ................................................ [/dev/sdb1 (256.0MiB) write-thru activated]
  | |   o- alua ......................................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ............................................. [ALUA state: Active/optimized]
  | o- fileio ....................................................................... [Storage Objects: 0]
  | o- pscsi ........................................................................ [Storage Objects: 0]
  | o- ramdisk ...................................................................... [Storage Objects: 0]
  o- iscsi .................................................................................. [Targets: 1]
  | o- iqn.2018-11.com.smartrd:tonynb .......................................................... [TPGs: 1]
  |   o- tpg1 ..................................................................... [no-gen-acls, no-auth]
  |     o- acls ................................................................................ [ACLs: 1]
  |     | o- iqn.2018-11.com.smartrd:desktop22 .......................................... [Mapped LUNs: 1]
  |     |   o- mapped_lun0 ........................................................ [lun0 block/usb1 (rw)]
  |     o- luns ................................................................................ [LUNs: 1]
  |     | o- lun0 ............................................ [block/usb1 (/dev/sdb1) (default_tg_pt_gp)]
  |     o- portals .......................................................................... [Portals: 1]
  |       o- 192.168.124.73:3260 .................................................................... [OK]
  o- loopback ............................................................................... [Targets: 0]
/> exit
Global pref auto_save_on_exit=true
Configuration saved to /etc/target/saveconfig.json

### Service
$# systemctl start target
$# systemctl enable target

### Port (iSCSI Port = 3260)
$# firewall-cmd --add-port=3260/tcp
$# firewall-cmd --add-port=3260/tcp --permanent
```

## 3. iSCSI client

### 3-1. 套件

```sh
# iSCSI Client
$# yum install -y iscsi-initiator-utils
```

### 3-2. 設定檔

- `/etc/iscsi/iscsid.conf`         : (未研究)
- `/etc/iscsi/initiatorname.iscsi` : 紀錄 iSCSI Client 自己的 IQN (Target 許可的 Initiator)

### 3-3. 連線 (使用 iSCSI)

```sh
$# vim /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2018-11.com.smartrd:desktop22
# 稍早 Target 所允許的 Initiator (存檔離開)

$# systemctl restart iscsi  # inactive

# 探索 Target (tab-completion 完全不給提示orz)
$# iscsiadm -m discovery -t sendtargets -p 192.168.124.73
192.168.124.73:3260,1 iqn.2018-11.com.smartrd:tonynb

# 登入 && 驗證 && 使用 (tab-completion 完全不給提示orz)
$# iscsiadm -m node -T iqn.2018-11.com.smartrd:tonynb -p 192.168.124.73 -l
Logging in to [iface: default, target: iqn.2018-11.com.smartrd:tonynb, portal: 192.168.124.73,3260] (multiple)
Login to [iface: default, target: iqn.2018-11.com.smartrd:tonynb, portal: 192.168.124.73,3260] successful.

$# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   12G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   11G  0 part
  ├─centos-root 253:0    0 10.5G  0 lvm  /
  └─centos-swap 253:1    0  508M  0 lvm  [SWAP]
sdb               8:16   0  256M  0 disk            # iSCSI 成功!!!!

$# tail /var/log/messages
Nov 13 17:33:42 desktop22 kernel: scsi 4:0:0:0: alua: Attached
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: alua: transition timeout set to 60 seconds
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: [sdb] 524288 512-byte logical blocks: (268 MB/256 MiB)
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: [sdb] Write Protect is off
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn\'t support DPO or FUA
Nov 13 17:33:42 desktop22 kernel: sd 4:0:0:0: [sdb] Attached SCSI disk
Nov 13 17:33:43 desktop22 iscsid: Could not set session1 priority. READ/WRITE throughout and latency could be affected.
Nov 13 17:33:43 desktop22 iscsid: Connection1:0 to [target: iqn.2018-11.com.smartrd:tonynb, portal: 192.168.124.73,3260] through [iface: default] is operational now

$# ll /var/lib/iscsi/nodes
total 0
drw-------. 3 root root 35 Nov 13 17:32 iqn.2018-11.com.smartrd:tonynb

$# ll /var/lib/iscsi/nodes/iqn.2018-11.com.smartrd\:tonynb/
total 0
drw-------. 2 root root 21 Nov 13 17:32 192.168.124.73,3260,1

$# ll /var/lib/iscsi/nodes/iqn.2018-11.com.smartrd\:tonynb/192.168.124.73\,3260\,1/
total 4
-rw-------. 1 root root 2068 Nov 13 17:32 default
```

### 3-4. 斷線

```sh
# 登出~ (tab-completion 完全不給提示orz)
$# iscsiadm -m node -T iqn.2018-11.com.smartrd:tonynb -p 192.168.124.73 -u
Logging out of session [sid: 1, target: iqn.2018-11.com.smartrd:tonynb, portal: 192.168.124.73,3260]
Logout of [sid: 1, target: iqn.2018-11.com.smartrd:tonynb, portal: 192.168.124.73,3260] successful.

$# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   12G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   11G  0 part
  ├─centos-root 253:0    0 10.5G  0 lvm  /
  └─centos-swap 253:1    0  508M  0 lvm  [SWAP]
# 已經沒有 sdb 了

# 移除探索到的裝置
$# iscsiadm -m node -T iqn.2018-11.com.smartrd:tonynb -p 192.168.124.73 -o delete

$# ls /var/lib/iscsi/nodes/
# 沒東西了~
```

