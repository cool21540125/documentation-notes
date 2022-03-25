# Ch10 - Managing Logical Volume Management (LVM) Storage

1. LVM 概念
2. LVM - 建立
3. LVM - 後續擴增
4. LVM 指令整理


## 1. LVM 概念

- 參考 `/rhce2/attach/LVM.xml`
- 目標磁碟要先劃分成 `LVM`(`8e` 或 `31`, 因 CentOS版本不同而異)


## 2. LVM - 建立

使用一堆隨身碟, 組成一個超大磁碟, 然後掛載到檔案系統~

```sh
$# lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb               8:16   1  14.5G  0 disk           # 準備變成連體嬰吧!!
sdc               8:32   1   7.1G  0 disk           # 準備變成連體嬰吧!!

$# fdisk /dev/sdb
### REPL ------------------------------------
Command (m for help): n
Partition number (1-128, default 1):    # ENTER
First sector (34-30375902, default 2048):   # ENTER
Last sector, +sectors or +size{K,M,G,T,P} (2048-30375902, default 30375902):    # ENTER
Created partition 1

### REPL ------------------------------------
Command (m for help): t
Selected partition 1
Partition type (type L to list all types): 31
Changed type of partition 'Linux filesystem' to 'Linux LVM'

### REPL ------------------------------------
Command (m for help): p

Disk /dev/sdb: 15.6 GB, 15552479232 bytes, 30375936 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: gpt
Disk identifier: FADAA141-03C2-4BE8-9D73-FB39941B03A5

#         Start          End    Size  Type            Name
 1         2048     30375902   14.5G  Linux LVM

### REPL ------------------------------------
Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
### REPL ------------------------------------

# 第二個隨身碟, 同上操作, 以下省略
$# fdisk /dev/sdc

# 作完後
$# lsblk -f
NAME            FSTYPE      LABEL UUID             MOUNTPOINT
sdb
└─sdb1      # 要作成 LVm
sdc
└─sdc1      # 要作成 LVM
sr0

# 建立 PV --------------------------------
$# pvcreate /dev/sdb1 /dev/sdc1
  Physical volume "/dev/sdb1" successfully created.
  Physical volume "/dev/sdc1" successfully created.

$# pvs
  PV         VG     Fmt  Attr PSize  PFree
  /dev/sda2  centos lvm2 a--  90.00g     0  # (我原本的檔案系統啦)
  /dev/sdb1         lvm2 ---  14.48g 14.48g     # 隨身碟
  /dev/sdc1         lvm2 ---  <7.14g <7.14g     # 隨身碟

# 建立 VG --------------------------------
$# vgcreate superUSB /dev/sdb1 /dev/sdc1
  Volume group "superUSB" successfully created

$# vgs
  VG       #PV #LV #SN Attr   VSize  VFree
  centos     1   3   0 wz--n- 90.00g     0
  superUSB   2   0   0 wz--n- 21.61g 21.61g # 巨根隨身碟誕生
# VG    : 每個 VG 都有屬於自己的名字 (有點像幫派名稱吧...)
# PV    : 這個 Volume Group 由多少個 PV 所組成
# LV    : 這個 Volume Group 分配了多少個 LV
# VSize : 這個 Volume Group 底下的總容量
# VFree : 這個 Volume Group 底下還沒分配出去的總容量

# 劃分 LV --------------------------------
$# lvcreate -n huge_dixk -L 2G superUSB
  Logical volume "huge_dixk" created.

$# lvs
  LV        VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home      centos   -wi-ao---- 30.00g
  root      centos   -wi-ao---- 30.00g
  var       centos   -wi-ao---- 30.00g
  huge_dixk superUSB -wi-a----- 18.00g  # 新建立的 LV 名稱
# ↑ 把它想像成 partition 的概念, 之後就在這上面作格式化~

# 針對 LV 格式化 
$# mkfs -t ext4 /dev/mapper/superUSB-huge_dixk
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
1179648 inodes, 4718592 blocks
235929 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2153775104
144 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:        # 會執行一陣子  (約10~20秒吧)
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
# LV 名稱格式為 下列兩者都行
# - /dev/mapper/<VG_Name>-<LV_Name>
# - /dev/<VG_Name>/<LV_Name>
$# ll /dev/mapper/superUSB-huge_dixk  /dev/superUSB/huge_dixk
lrwxrwxrwx. 1 root root 7 Nov  8 15:55 /dev/mapper/superUSB-huge_dixk -> ../dm-3
lrwxrwxrwx. 1 root root 7 Nov  8 15:55 /dev/superUSB/huge_dixk -> ../dm-3

$# lvs
  LV        VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home      centos   -wi-ao---- 30.00g
  root      centos   -wi-ao---- 30.00g
  var       centos   -wi-ao---- 30.00g
  huge_dixk superUSB -wi-a----- 18.00g

# 查看檔案系統
$# lsblk
NAME                   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb                      8:16   1  14.5G  0 disk
└─sdb1                   8:17   1  14.5G  0 part
  └─superUSB-huge_dixk 253:3    0    18G  0 lvm     # 兩者結合之後, 這邊的 SIZE 資訊變得比較沒價值了
sdc                      8:32   1   7.1G  0 disk
└─sdc1                   8:33   1   7.1G  0 part
  └─superUSB-huge_dixk 253:3    0    18G  0 lvm     # 兩者結合之後, 這邊的 SIZE 資訊變得比較沒價值了
sr0                     11:0    1  1024M  0 rom

# 查看檔案系統 (因為還沒被掛載, 所以看不到)
$# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root   30G  8.0G   23G  27% /
devtmpfs                 1.9G     0  1.9G   0% /dev
/dev/sda1               1014M  199M  816M  20% /boot
/dev/mapper/centos-home   30G   25G  5.8G  81% /home
/dev/mapper/centos-var    30G  3.0G   28G  10% /var

# 掛載到 /usb
$# mount /dev/mapper/superUSB-huge_dixk /usb
$# df -h
Filesystem                      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root          30G  8.0G   23G  27% /
devtmpfs                        1.9G     0  1.9G   0% /dev
/dev/sda1                      1014M  199M  816M  20% /boot
/dev/mapper/centos-home          30G   25G  5.8G  81% /home
/dev/mapper/centos-var           30G  3.0G   28G  10% /var
/dev/mapper/superUSB-huge_dixk   18G   45M   17G   1% /usb  # 掛上來了~  18G 的空間(隨身碟)
```

## 3. LVM - 後續擴增

後來發現, 以前的空間不夠用~~  需要提升到 20G

```sh
$# lvextend -L +2G /dev/superUSB/huge_dixk
  Size of logical volume superUSB/huge_dixk changed from 18.00 GiB (4608 extents) to 20.00 GiB (5120 extents).
  Logical volume superUSB/huge_dixk successfully resized.

$# lvs
  LV        VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home      centos   -wi-ao---- 30.00g
  root      centos   -wi-ao---- 30.00g
  var       centos   -wi-ao---- 30.00g
  huge_dixk superUSB -wi-ao---- 20.00g      # lv 看起來長大了~

$# df -h
Filesystem                      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root          30G  8.0G   23G  27% /
devtmpfs                        1.9G     0  1.9G   0% /dev
/dev/sda1                      1014M  199M  816M  20% /boot
/dev/mapper/centos-home          30G   25G  5.8G  81% /home
/dev/mapper/centos-var           30G  3.0G   28G  10% /var
/dev/mapper/superUSB-huge_dixk   18G   45M   17G   1% /usb      # 但是檔案系統 認識的這個 partition, 並沒有變大!!!

# 記得 resize 一下
$# resize2fs /dev/mapper/superUSB-huge_dixk
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/mapper/superUSB-huge_dixk is mounted on /usb; on-line resizing required
old_desc_blocks = 3, new_desc_blocks = 3
The filesystem on /dev/mapper/superUSB-huge_dixk is now 5242880 blocks long.

$# df -h
Filesystem                      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root          30G  8.0G   23G  27% /
devtmpfs                        1.9G     0  1.9G   0% /dev
/dev/sda1                      1014M  199M  816M  20% /boot
/dev/mapper/centos-home          30G   25G  5.8G  81% /home
/dev/mapper/centos-var           30G  3.0G   28G  10% /var
/dev/mapper/superUSB-huge_dixk   20G   45M   19G   1% /usb      # 真的長大了~
```


## 4. LVM 操作會用到的指令...

### 指令彙整(嚇人用)

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

### 指令彙整(參考用)

-   | Create                                       | Verify                     | Extend                                                                                                               | Reduce                                        | Remove
--- | -------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- | -----------------------------
PV  | pvcreate \<Device> ...                       | pvs<br>pvdisplay<br>pvscan | -                                                                                                                    | pvmove <PV>                                   | pvremove <PV> ...
VG  | vgcreate \<vgName> ...                       | vgs<br>vgdisplay<br>vgscan | vgextend \<vgName> \<PV> ...                                                                                         | vgreduce \<vgName> <PV> ...                   | vgremove \<vgName>
LV  | lvcreate -n \<lvName> -L \<lvSize> \<vgName> | lvs<br>lvdisplay<br>lvscan | lvextend -L +\<lvSize> /dev/vgName/lvName<br> 搭配下列其一 <br> - resize2fs \<Device> <br> - xfs_growfs \<MountPoint> | ~~lvreduce~~<br>lvresize<br>(xfs 無法變小)     | lvremove /dev/vgName/lvName
