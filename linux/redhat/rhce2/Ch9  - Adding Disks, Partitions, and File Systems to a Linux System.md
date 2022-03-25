# Ch9  - Adding Disks, Partitions, and File Systems to a Linux System

1. 磁碟裝置(複習)
2. 概念
3. 磁區分割 && 格式化 && 掛載(手動)
4. 固定掛載~
5. swap
6. 本章指令回顧
7. 後續處理~~


## 1. 磁碟裝置(複習)

### 1-1. partition

一個磁碟(disk)可以劃分多個磁區(partition) → 房子可以有很多隔間


### 1-2. filesystem

一個磁區(partition) 格式化成特定的檔案系統(file system) → 各個房間內的地板因各種用途, 可以有所不同


### 1-3. naming

```sh
/dev/sdc
/dev/sda1
/dev/sdd5
/dev/sdb
/dev/sd1
/dev/vdb
# 參考 /rhce1/Ch14
```


## 2. 概念

- [Tony之前寫的](https://github.com/cool21540125/documentation-notes/blob/master/linux/system/diskPartition.md)
- [鳥哥](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_table)

簡言之, 目前只需要知道磁碟有下列兩種格式就好
- MBR
- GPT (2TB以上大磁碟)


## 3. 磁區分割 && 格式化 && 掛載(手動)

### 3-1 磁區分割

```sh
# 針對裝置分割!! 而非針對磁區分割 ------------------------------------
$# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).
# ↓↓↓ 裡面的一切一切, 可以全部亂按~~~  但是最後千萬不要選擇「w」(儲存), 而選擇「q」(不儲存離開)
Changes will remain in memory only, until you decide to write them.     
Be careful before using the write command.
# ↑↑↑ 裡面的一切一切, 可以全部亂按~~~  但是最後千萬不要選擇「w」(儲存), 而選擇「q」(不儲存離開)

### REPL ------------------------------------
Command (m for help): p    # ENTER

Disk /dev/sdb: 15.6 GB, 15552479232 bytes, 30375936 sectors     # 按p之後都能看到這些, 後面的筆記會省略這部份
Units = sectors of 1 * 512 = 512 bytes                          # 按p之後都能看到這些, 後面的筆記會省略這部份
Sector size (logical/physical): 512 bytes / 512 bytes           # 按p之後都能看到這些, 後面的筆記會省略這部份
I/O size (minimum/optimal): 512 bytes / 512 bytes               # 按p之後都能看到這些, 後面的筆記會省略這部份
Disk label type: gpt                                            # 按p之後都能看到這些, 後面的筆記會省略這部份
Disk identifier: FADAA141-03C2-4BE8-9D73-FB39941B03A5           # 按p之後都能看到這些, 後面的筆記會省略這部份

#         Start          End    Size  Type            Name

### REPL ------------------------------------
Command (m for help): n    # ENTER
Partition number (1-128, default 1):    # ENTER
First sector (34-30375902, default 2048):    # ENTER
Last sector, +sectors or +size{K,M,G,T,P} (2048-30375902, default 30375902): +5G    # ENTER
Created partition 1

### REPL ------------------------------------
# (接著筆記省略~~  砸們作 1 個分割區吧!!)
# n →  →  → +5G →          # 「→」: 按ENTER

### REPL ------------------------------------
Command (m for help): p

#         Start          End    Size  Type            Name
 1         2048     10487807      5G  Linux filesyste
 2     10487808     20973567      5G  Linux filesyste

### REPL ------------------------------------
Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
# ↑↑↑ 離開後的訊息, 有變更離開後, 請務必看仔細

### REPL ------------------------------------
$# 
```


### 3-2 格式化

```sh
# 查看已掛載磁區
$# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root   30G  8.0G   23G  27% /
devtmpfs                 1.9G     0  1.9G   0% /dev
/dev/sda1               1014M  199M  816M  20% /boot
/dev/mapper/centos-var    30G  3.0G   28G  10% /var
/dev/mapper/centos-home   30G   25G  5.8G  81% /home
/dev/sdb1                7.0G   16K  7.0G   1% /run/media/tony/E45E-DB6B        # 這裡我不懂啊~~~
#                        ↑↑↑↑        ↑↑↑↑  推測應該是之前作的分割, 但因為只是快速格式化造成的...

# 查看分割區
$# lsblk -p
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
/dev/sda                      8:0    0 465.8G  0 disk
├─/dev/sda1                   8:1    0     1G  0 part /boot
├─/dev/sda2                   8:2    0    90G  0 part
│ ├─/dev/mapper/centos-root 253:0    0    30G  0 lvm  /
│ ├─/dev/mapper/centos-var  253:1    0    30G  0 lvm  /var
│ └─/dev/mapper/centos-home 253:2    0    30G  0 lvm  /home
└─/dev/sda3                   8:3    0     2G  0 part
/dev/sdb                      8:16   1  14.5G  0 disk
├─/dev/sdb1                   8:17   1     5G  0 part /run/media/tony/E45E-DB6B # 這裡我不懂啊~~~
└─/dev/sdb2                   8:18   1     5G  0 part                           # 這裡我不懂啊~~~
/dev/sr0                     11:0    1  1024M  0 rom

# 現在要把 /dev/sdb2 格式化成 ext4
$# mkfs -t ext4 /dev/sdb2
```

### 3-3 手動掛載

```sh
# 掛載~~~
$# mount /dev/sdb2 /usb
$# lsblk -p
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
/dev/sda                      8:0    0 465.8G  0 disk
├─/dev/sda1                   8:1    0     1G  0 part /boot
├─/dev/sda2                   8:2    0    90G  0 part
│ ├─/dev/mapper/centos-root 253:0    0    30G  0 lvm  /
│ ├─/dev/mapper/centos-var  253:1    0    30G  0 lvm  /var
│ └─/dev/mapper/centos-home 253:2    0    30G  0 lvm  /home
└─/dev/sda3                   8:3    0     2G  0 part
/dev/sdb                      8:16   1  14.5G  0 disk
├─/dev/sdb1                   8:17   1     5G  0 part /run/media/tony/E45E-DB6B
└─/dev/sdb2                   8:18   1     5G  0 part /usb                          # DONE!
/dev/sr0                     11:0    1  1024M  0 rom
```


## 4. 固定掛載

- 設定檔在 `/etc/fstab` : 注意!! 改壞可能導致無法正常開機!!!!

```sh
# 先把剛剛的東西都卸載
$# umount /dev/sdb1
$# umount /dev/sdb2

$# # lsblk -p
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
/dev/sda                      8:0    0 465.8G  0 disk
├─/dev/sda1                   8:1    0     1G  0 part /boot
├─/dev/sda2                   8:2    0    90G  0 part
│ ├─/dev/mapper/centos-root 253:0    0    30G  0 lvm  /
│ ├─/dev/mapper/centos-var  253:1    0    30G  0 lvm  /var
│ └─/dev/mapper/centos-home 253:2    0    30G  0 lvm  /home
└─/dev/sda3                   8:3    0     2G  0 part
/dev/sdb                      8:16   1  14.5G  0 disk
├─/dev/sdb1                   8:17   1     5G  0 part               # 卸載了~
└─/dev/sdb2                   8:18   1     5G  0 part               # 卸載了~
/dev/sr0                     11:0    1  1024M  0 rom

# 希望將來開機的時候, 主動把 /dev/sdb2 掛載到 /usb
$# blkid /dev/sdb2
/dev/sdb2: UUID="8ac205c1-8f08-4a1a-8564-1f50fbc635ea" TYPE="ext4" PARTUUID="506a7e47-d669-41b7-9ae3-6283d02f890f"
# blkid 與 lsblk 與 df 指令功能大同小異, 自行google

# 危險操作!!!!!!!!  ↓↓ 請記得要用「>>」, Tony 有過 2 次, 只打「>」, 會把原本的 fstab(filesystem table) 蓋掉, 將來開機就GG了
$# blkid /dev/sdb2 >> /etc/fstab

# 修改 fstab
$# vim /etc/fstab
/dev/mapper/centos-root                         /       xfs     defaults    0 0
UUID=32e1b5c9-e273-4c5f-bb3d-12e3bfb0a0b1       /boot   xfs     defaults    0 0
/dev/mapper/centos-home                         /home   xfs     defaults    0 0
/dev/mapper/centos-var                          /var    xfs     defaults    0 0
UUID="8ac205c1-8f08-4a1a-8564-1f50fbc635ea"     /usb    ext4    defaults    0 0
# 要被掛載的裝置                                掛載點    type    掛載選項    (後面兩個你不需要知道, 很進階)
# 要被掛載的裝置, 可以用「絕對路徑」or「UUID」, 建議使用 UUID, 以免掛錯裝置!!!

# 設定完 fstab後, 務必這麼做!!!
$# mount -a
# ↑ 依照 /etc/fstab 的設定方式, 立馬褂載~  如果設定有錯的話, 會出現錯誤訊息

# 重開機後, UUID="8ac205c1-8f08-4a1a-8564-1f50fbc635ea" 都會出現在 /usb 了~~~
```


## 5. swap

> swap space is an area of a disk which can be used with the Linux kernel memory manage subsystem. Swap spaces are used to supplement the system RAM by holding inactive pages of memory. The combined system RAM plus swap spaces is called *virtual memory*.

```sh
$# free -h
              total        used        free      shared  buff/cache   available
Mem:           3.8G        1.1G        1.8G        227M        827M        2.1G
Swap:            0B          0B          0B
# free      : 1.8G (目前閒置的記憶體)
# available : 2.1G (如果系統需要, 可以再使用的記憶體)
# ↑ 也就是說, 0.3G 隨時可以被釋放掉啦~~~

$# lsblk -p
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
/dev/sda                      8:0    0 465.8G  0 disk
├─/dev/sda1                   8:1    0     1G  0 part /boot
├─/dev/sda2                   8:2    0    90G  0 part
│ ├─/dev/mapper/centos-root 253:0    0    30G  0 lvm  /
│ ├─/dev/mapper/centos-var  253:1    0    30G  0 lvm  /var
│ └─/dev/mapper/centos-home 253:2    0    30G  0 lvm  /home
└─/dev/sda3                   8:3    0     2G  0 part           # 這分割區目前沒被掛載(然後我假設它是空的...)
/dev/sdb                      8:16   1  14.5G  0 disk
├─/dev/sdb1                   8:17   1     5G  0 part
└─/dev/sdb2                   8:18   1     5G  0 part /usb
/dev/sr0                     11:0    1  1024M  0 rom

$# fdisk /dev/sda

### REPL ------------------------------------
Command (m for help): p

Disk /dev/sda: 500.1 GB, 500107862016 bytes, 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x00017159

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200   190849023    94374912   8e  Linux LVM
/dev/sda3       190849024   195043327     2097152   8e  Linux LVM       # ← 動刀之前~

### REPL ------------------------------------
Command (m for help): t
Partition number (1-3, default 3):      # 把第三個分割區重新貼標成 swap
Hex code (type L to list all codes): L
# -------------------- ((僅節錄部分)) --------------------
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt
# -------------------- ((僅節錄部分)) --------------------
Hex code (type L to list all codes): 82
Changed type of partition 'Linux LVM' to 'Linux swap / Solaris'

### REPL ------------------------------------
Command (m for help): p

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200   190849023    94374912   8e  Linux LVM
/dev/sda3       190849024   195043327     2097152   82  Linux swap / Solaris    # ←動完刀後~

### REPL ------------------------------------
Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
# 因為 「/dev/sda」這裝置, 目前正在使用, 這邊是跟你說, 你必須讓現在運作中的 kernel 重新讀取現在磁碟上的最新狀態~
# 如果是 磁碟使用空間異動, 參考 partprobe
# 如果是 swap 異動,       參考 swapon

### REPL ------------------------------------
$# swapon /dev/sda3

$# free -h
              total        used        free      shared  buff/cache   available
Mem:           3.8G        1.1G        1.8G        227M        830M        2.1G
Swap:          2.0G          0B        2.0G                                         # 多出來 2G 的 SWAP 了~

$# lsblk -p
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
/dev/sda                      8:0    0 465.8G  0 disk
├─/dev/sda1                   8:1    0     1G  0 part /boot
├─/dev/sda2                   8:2    0    90G  0 part
│ ├─/dev/mapper/centos-root 253:0    0    30G  0 lvm  /
│ ├─/dev/mapper/centos-var  253:1    0    30G  0 lvm  /var
│ └─/dev/mapper/centos-home 253:2    0    30G  0 lvm  /home
└─/dev/sda3                   8:3    0     2G  0 part [SWAP]            # 變成 SWAP 了
/dev/sdb                      8:16   1  14.5G  0 disk
├─/dev/sdb1                   8:17   1     5G  0 part
└─/dev/sdb2                   8:18   1     5G  0 part /usb
/dev/sr0                     11:0    1  1024M  0 rom
```

### 5-2 自動啟用 SWAP

```sh
$# blkid /dev/sda3
/dev/sda3: UUID="a4c1263a-9d31-4f51-b57b-949a8fc57b41" TYPE="swap"

$# blkid /dev/sda3 >> /etc/fstab
$# vim /etc/fstab
# 僅節錄部分
UUID="a4c1263a-9d31-4f51-b57b-949a8fc57b41" swap    swap    defaults    0 0   # 改成這樣
# 僅節錄部分

# 異動完 /etc/fstab 之後, 務必檢查~~
$# swapon -a
$# mount -a
# 沒錯的情況之下, 以上都不應該有任何訊息才對(起碼我這幾個月還沒看過)

# 重開機後, 就會有新鮮的 SWAP 可以用了~
```


## 6. 本章指令回顧

- 列出 Partition 系列
    - `lsblk`
    - `blkid`
    - `df`
- 修改 Partition 系列
    - `fdisk`
    - `gdisk`
- 製作 Partition 系列
    - `mkswap`
    - `mkfs`
- 掛載 && 卸載 Partition 系列
    - `swapon` ←-→ `swapoff`
    - `mount` ←-→ `umount`
- 修改完 /etc/fstab 務必作的(確保沒改錯)
    - `swapon -a`
    - `mount -a`


## 7. 後續處理~~

本章節結束後, 記得把 你拿來玩的掛載裝置, 從 /etc/fstab 移除掉~, 不然你把 USB 的掛載寫到 fstab, 將來隨身碟拔掉之後, 開機會等比較久~~
