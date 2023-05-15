# 磁碟分割

- 2018/04/21
- 硬梆梆...
- [鳥哥-partition](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_table) search「所以邏輯分割槽的裝置名稱號碼就由5號開始了」


# 概念

磁區(Sector) : 最小物理儲存單位, 分別有 `512 Bytes(早期)` 、 `4K Bytes(近代)`.


    磁碟分割表 分為 2 種
    1. 早期的 MBR分割表 (512 Bytes, max 2TB)    
        |- 非第 1 磁區
        |- 第 1 磁區 (這邊壞了硬碟就掛了)
            |- 主要開機區 (Master boot record, MBR) - 446 Bytes
            |- 分割表 (Partition Table) - 64 Bytes
    2. 近代的 GPT 分割表 (支援 2TB 以上硬碟)


# MBR

```sh
Primary 1       /dev/sda1
Primary 2       /dev/sda2
Primary 3       /dev/sda3
Extended
    +Logical    /dev/sda5
    +Logical    /dev/sda6
    +...
    +Logical    /dev/sda15
```


    /dev/sd[a-p][1-128] : 實體磁碟 的 磁碟檔名
    /dev/vd[a-p][1-128] : 虛擬磁碟 的 磁碟檔名



# GPT

將磁碟所有區塊以 LBA 區塊來記錄分割資訊. 第一個 LBA 稱為 `LBA0`. GPT使用了 34 個 LBA 區塊來記錄分割資訊(相較於 MBR, 只使用一個), GPT除了前面 34 個 LBA 之外, 整個磁碟的最後 33 個 LBA 也拿來做為另一個備份. 

部分磁碟為了與 `MBR` 兼容, 會將 `LBA` 預設為 `512bytes`.

![鳥哥 - GPT分割表](http://linux.vbird.org/linux_basic/0130designlinux/gpt_partition_1.jpg)
圖片來源: 鳥哥

上圖, 分為3個部分說明:

1. LBA0 (MBR相容區塊)

    基本上同MBR, 存了 `開機管理程式` 及 特殊標誌的分割(單純用來表示此磁碟為 GPT格式).
    此磁區是受到保護的.

2. LBA1 (GPT表頭紀錄)
    
    記錄了`分割表本身的位置與大小`, 同時也記錄 備份用的 GPT分割放置的位置, 以及 檢驗機制碼(CRC32).

3. LBA2-33 (實際紀錄分割資訊處)

    這些區塊, 每個 LBA都可以記錄 4筆分割紀錄, 預設可以有 4*32=128筆 分割紀錄. 而每筆紀錄用到 128bytes的空間, 扣除其他必要紀錄的欄位, **GPT在每筆紀錄中分別提供了 64 bits來記載 開始/結束 的磁區號碼**, 經過一般人看不懂的計算後, 最終作業系統可以認識 *8ZB* 的磁碟.



# 檔案系統 Filesystem(以下以 fs 表示)

> 一般來說, `一個分割槽(partition)` 只能裝 `一個 fs`. 但因為後續的新技術, ex: LVM, 軟體磁碟陣列(RAID), `一個分割槽`, 可以裝 `多個 fs 了`, 所以 ~~針對 partition 來格式化~~, `一個可被掛載的資料 = 一個 fs (而非分割槽)`

Linux fs 通常把 `檔案權限(rwx)` 與 `檔案屬性(owner, group, time, ...)` 存到不同區塊

- `superblock` : fs 整體資訊. 包括 inode/block 的總量, 使用量, 剩餘量.
- `inode` : 紀錄檔案屬性. 一個檔案占用一個 inode, 並記錄 `data block 號碼`
- `block` : 實際檔案內容. 若檔案太大, 會占用多個 block


## Linux 支援的檔案系統

- 傳統 fs : ext2 / minix / MS-DOS / FAT 等
- 日誌式 fs : ext3 / ext4 / ReiserFS / Windows' NTFS / SGI's XFS / ZFS 等
- 網路 fs : NFS / SMBFS

> 從 `CentOS7 開始`, 拋棄了對 Linux 支援度最廣的 ext 家族, `投入了 xfs 的懷抱`. 有一大堆原因啦!!  ex : ext家族 格式化時採用 `預先配置`(大硬碟會弄超久~~ 而 `xfs 採用 動態配置`)、還有其他我看不懂的... 參考 [鳥哥-XFS檔案系統簡介](http://linux.vbird.org/linux_basic/0230filesystem.php#harddisk-xfs).

> journal功能 : 檔案系統裏頭, 如果有說明支援 `日誌功能(System Log)` , 表示如果哪天出了問題, 重開機的時候, 不用作 Disk Scan, 而是直接去檢查 syslog 之類的東西, 然後開始作修復 or 還原.


```sh
# 查看 Linux 支援的檔案系統有哪些
$ ls -l /lib/modules/$(uname -r)/kernel/fs

# 查看 已經載入到 Memory 中支援的 fs
$ cat /proc/filesystems
nodev   tmpfs
nodev   sockfs
nodev   autofs
nodev   pstore
nodev   selinuxfs
        xfs
...(略)... # 約30個

# xfs 檔案系統 查看 superblock的方式
$ xfs_info <掛載點|裝置檔名>

# /boot 底下的 superblock
$ df -hT /boot
檔案系統       類型  容量  已用  可用 已用% 掛載點
/dev/sda1      xfs  1014M  242M  773M   24% /boot

# 這我看不懂, 鳥哥寫的解說我也不想看懂 @@" 用到再來談了...
$ xfs_info /dev/sda1
meta-data=/dev/sda1              isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks # sunit=0: 沒在使用磁碟陣列
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```



# 查硬碟容量 df 與 du

## df

> 列出 檔案系統 的 整體磁碟使用量 : `df` ,針對整個檔案系統, 讀取範圍主要是在 Superblock 內的資訊(速度快). `※「/」容量剩下很小的話, 就代表快出事了!`

```sh
$ df [-ahikHTm] <目錄 or 檔案>
# a : 所有的檔案系統, 包含「/proc」(都在記憶體裡面, 不佔用磁碟空間)
# h : 已 kb, mb, gb, tb...表示  (預設以 bytes呈現)
# T : 列出該 partition的 filesystem名稱, ex: xfs
# i : 已 inode代替 磁碟容量

$ df -hT
# Filesystem         Type      1K-blocks  Used  Avail  Use%   Mounted on
檔案系統              類型      容量       已用   可用    已用%  掛載點
/dev/mapper/cl-root  xfs        80G      9.3G    71G   12%    /
devtmpfs             devtmpfs  1.8G         0   1.8G    0%    /dev
tmpfs                tmpfs     1.9G      7.9M   1.8G    1%    /dev/shm # 記憶體模擬(快); 通常是 總記憶體/2
tmpfs                tmpfs     1.9G       33M   1.8G    2%    /run
tmpfs                tmpfs     1.9G         0   1.9G    0%    /sys/fs/cgroup
/dev/sda1            xfs      1014M      242M   773M   24%    /boot
/dev/mapper/cl-var   xfs        50G       15G    36G   30%    /var
/dev/mapper/cl-home  xfs        80G       13G    68G   16%    /home
tmpfs                tmpfs     370M       44K   370M    1%    /run/user/1000
# 檔案系統(Filesystem) : 所在 partition (裝置名稱)

$ df -h /boot
檔案系統        容量  已用  可用 已用% 掛載點
/dev/sda1      1014M  242M  773M   24% /boot

# 也可以拿來看 路徑的掛載點
$ df -hT /home/tony
檔案系統            類型  容量  已用  可用 已用% 掛載點
/dev/mapper/cl-home xfs    80G   20G   61G   24% /home
# /home/tony/ 掛在 「/dev/mapper/cl-home」 底下
```


## du

> 評估 檔案系統 的 磁碟使用量(目錄所佔容量) : `du`, 會實際到 檔案系統 內搜尋所有的 檔案資料(費時).

```sh
$ du [-ahskm] <檔案 or 目錄>
# a : 列出所有的檔案與目錄容量(預設只有統計檔案數量)
# S : 不包含子目錄下的統計
# s : 只列出總容量
# h : 人看得懂的 kb, mb, gb, ...
# c : 

$ du -a | head -3
0	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/langpack-zh-TW@firefox.mozilla.org.xpi
4	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/.fedora-langpack-install
4	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}

# --max-depth=1, 最多到第一層子目錄的空間使用情形
$ du ~ -h --max-depth=1 | head -3
21M	/home/tony/.mozilla
662M	/home/tony/.cache
536M	/home/tony/.config

$ du -h --max-depth=0 /usr/share/man
55M     /usr/share/man
```


# 磁碟分割

- 2018/06/26

## 1. 查看 磁碟分割 (掛載樹狀結構)

```sh
# lsblk : list block device, 列出所有儲存裝置
# lsblk [-dfimpt] [device]   (device需要為完整檔名)
# -f : 可查看磁碟的檔案系統名稱
# -m : 可以查看 owner, group, mode
# -p : 呈現裝置完整檔名
# -t : 磁碟裝置的詳細資料, 包含磁碟柱列機制, 預讀寫的資料大小...(一堆我看不懂的)
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 465.8G  0 disk           # 第一個磁碟
├─sda1        8:1    0     1G  0 part /boot
└─sda2        8:2    0   218G  0 part
  ├─cl-root 253:0    0    80G  0 lvm  /
  ├─cl-swap 253:1    0     8G  0 lvm  [SWAP]
  ├─cl-var  253:2    0    50G  0 lvm  /var
  └─cl-home 253:3    0    80G  0 lvm  /home
sdb           8:16   0 931.5G  0 disk           # 第二個磁碟 (1T的外接硬碟)
└─sdb1        8:17   0 931.5G  0 part
sdc           8:32   1  14.5G  0 disk           # 第三個磁碟 (16G的隨身碟)
└─sdc1        8:33   1  14.5G  0 part /run/media/tony/7AA4-35FC
sr0          11:0    1  1024M  0 rom
# 目前系統上的主要裝置: sr0 及 sda(實體磁碟)
# sda 裝置底下, 又分為 2個分割
# MAJ:MIN   Kernel 透過這兩個`主要`,`次要` 代碼, 來認識裝置 (major:minor)
# RM        是否 可卸載
# RO        是否 Read Only
# TYPE      磁碟(disk), 分割槽(partition), 唯讀記憶體(rom)等

# 查看 所有裝置的 UUID   (「lsblk -pf」 完全取代掉...)
$# blkid
/dev/sda1: UUID="e667a4ef-3733-4c49-bb50-767221d1537e" TYPE="xfs"
/dev/sda2: UUID="N7C7nQ-mO2j-D3HQ-l9dc-M8HF-OyO0-P85EX1" TYPE="LVM2_member"
/dev/mapper/cl-root: UUID="38a08831-a238-46a9-abf9-930a79eb9ec6" TYPE="xfs"
/dev/mapper/cl-swap: UUID="8b182032-3e30-46af-8937-8c05cbbcd277" TYPE="swap"
/dev/mapper/cl-var: UUID="193df025-24c5-45e5-8acf-49825f741754" TYPE="xfs"
/dev/mapper/cl-home: UUID="37a295a7-78fa-47d5-b2e8-78b4b4a10549" TYPE="xfs"
```

- [MBR equals msdos for gparted?](https://superuser.com/questions/700770/mbr-equals-msdos-for-gparted)

```sh
# parted 列出磁碟分割表類型、分割資訊
$# parted /dev/sda print
型號：ATA TOSHIBA MQ01ABF0 (scsi)       # 磁碟的模組名稱(廠商)
磁碟 /dev/sda：500GB
磁區大小 (邏輯/物理)：512B/4096B          # 磁碟的每個邏輯/物理磁區容量
分割區：msdos                           # 分割表的格式 (mbr/gpt)  (看上面的參考網址, mbr = msdos)
Disk Flags:

編號    起始點  結束點  大小    類型      檔案系統   旗標   # 此底下為 分割資料
 1    1049kB  1075MB  1074MB  primary  xfs       啟動
 2    1075MB  235GB   234GB   primary            lvm
```


## 2. 使用 gdisk/fdisk 來做 磁碟分割 (這會更新系統的 分割表, 還不會動到磁碟)

- MBR 分割表 : 使用 `fdisk`
- GPT 分割表 : 使用 `gdisk` 或 `parted`

```sh
$# fdisk /dev/sda       # 針對整個裝置做分割
裝置呈現的邏輯區大小小於
實體磁區大小。建議對齊到實體磁區 (或最佳化
I/O) 大小邊界，否則效能也許會被影響。
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

# 裡面的一切一切, 可以全部亂按~~~  但是最後千萬不要選擇「w」(儲存), 而選擇「q」(不儲存離開)
# 使用 n 建立一個16G 的 主要分割區, size那邊選擇 「+16G」, 最後選擇 w 
# 會出現 WARNING 等字樣, 因為目前作業系統我們正在用啦!!

## 使用 partprobe 更新 核心的分割表資訊
$# partprobe -s /dev/sda
/dev/sda: msdos partitions 1 2 3

$# cat /proc/partitions
major   minor   #blocks     name
   8        0  488386584    sda
   8        1    1048576    sda1
   8        2  228592640    sda2
   8        3   16777216    sda3    # 多出了這個了~~
  11        0    1048575    sr0
 253        0   83886080    dm-0    # 我不知道這底下是啥鬼...
 253        1    8384512    dm-1
 253        2   52428800    dm-2
 253        3   83886080    dm-3

# 底下, 如果要把剛剛建好的 partition 移除~
$# fdisk /dev/sda
# 選 d ... w...
# partprobs -s /dev/sda
# 非常簡單非常直覺~~  懶的寫了
```


## 3. 磁碟格式化 (建置檔案系統)

```sh
# 完成「分割」後, 緊接著就要開始建置檔案系統了! (格式化)
# mkfs : make filesystem
$# mkfs.xfs /dev/sda3
meta-data=/dev/sda3              isize=512    agcount=4, agsize=1048576 blks    # 看下面說明
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=4194304, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# agcount: CPU核心數量? 還是 block group?
# isize: 磁碟上檔案的分割區塊(stripe)

$# blkid /dev/sda3
/dev/sda3: UUID="99ded814-7953-433a-9c22-1d85bcea167c" TYPE="xfs"
```


## 4. 檔案系統檢驗@@

```sh
# xfs_repair [-fnd] 目標名稱
# -f: 針對哪個裝置下的分割
# -n: 只檢查, 不作修改
# -d: (危險慎用!) 單人維護模式底下, 針對 / 進行檢查與修復的動作  ((別用就對了!))
$ sudo xfs_repair /dev/sda3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 2
        - agno = 1
        - agno = 3
        - agno = 0
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
```



# 比較 lsblk && df -h

```sh
$# df -hT
檔案系統            類型      容量  已用  可用 已用% 掛載點
/dev/mapper/cl-root xfs        80G  9.9G   71G   13% /
devtmpfs            devtmpfs  1.8G     0  1.8G    0% /dev
tmpfs               tmpfs     1.9G  108M  1.7G    6% /dev/shm
tmpfs               tmpfs     1.9G  9.2M  1.8G    1% /run
tmpfs               tmpfs     1.9G     0  1.9G    0% /sys/fs/cgroup
/dev/sda1           xfs      1014M  252M  763M   25% /boot
/dev/mapper/cl-home xfs        80G   18G   63G   23% /home
/dev/mapper/cl-var  xfs        50G   13G   38G   25% /var
tmpfs               tmpfs     370M   48K  370M    1% /run/user/1000


$# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 465.8G  0 disk       # 第一顆磁碟
├─sda1        8:1    0     1G  0 part /boot     # 第一個磁區
├─sda2        8:2    0   218G  0 part           # 第二個磁區
│ ├─cl-root 253:0    0    80G  0 lvm  /             # 根目錄磁區
│ ├─cl-swap 253:1    0     8G  0 lvm                # SWAP空間
│ ├─cl-var  253:2    0    50G  0 lvm  /var          # /var
│ └─cl-home 253:3    0    80G  0 lvm  /home         # 家目錄
└─sda3        8:3    0    16G  0 part           # 第三個磁區
sdb           8:16   1  14.5G  0 disk       # 第二顆磁碟
└─sdb1        8:17   1  14.5G  0 part           # part是啥阿...@@?
sr0          11:0    1  1024M  0 rom        # sr: CDROM/DVDROM
```



# LVM 指令彙整

Task      | PV         | VG         | LV        | filesystem(xfs \| ext4)
--------- | ---------- | ---------- | --------- | ------------
Scan      | pvscan     | vgscan     | lvscan    | lsblk, blkid
Create    | pvcreate   | vgcreate   | lvcreate  | mkfs.xfs \| mkfs.ext4
Display   | pvdisplay  | vgdisplay  | lvdisplay | df, mount
Extend    | -          | vgextend   | lvextend  | xfs_growfs \| resize2fs
Reduce    | -          | vgreduce   | lvreduce  | - \| resize2fs
Remove    | pvremove   | vgremove   | lvremove  | umount
Resize    | -          | -          | lvresize  | xfs_growfs \| resize2fs
attribute | pvchange   | vgchange   | lvchange  | /etc/fstab, remount



# 其他零碎知識片段

- 開機管理程式, `grub` 不認識 GPT, 需要用 `grub2`
- 並非所有作業系統都認識 GPT, 也並非所有硬體都認識 GPT.
- NTFS 是 `windows 2000` 以後的產物
- UUID(universally unique identifier) : Linux系統給予 `所有裝置` 個別獨一無二的識別碼, 可拿來做為 掛載 or 使用這個裝置 之用
- 是否能讀寫 GPT 與 `開機的檢測程式(BIOS 與 UEFI)` 有關.
- MBR : Master Boot Record
- GPT : GUID Partition Table
