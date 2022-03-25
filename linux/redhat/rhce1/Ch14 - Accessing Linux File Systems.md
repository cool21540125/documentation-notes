# Ch14 - Accessing Linux File Systems

1. 磁碟裝置
2. 掛載
3. 連結
4. 尋找


## 1. 磁碟裝置

### 1-1. partition

一個磁碟(disk)可以劃分多個磁區(partition) → 房子可以有很多隔間


### 1-2. filesystem

一個磁區(partition) 格式化成特定的檔案系統(file system) → 各個房間內的地板因各種用途, 可以有所不同


### 1-3. naming

```sh
/dev/
    /sda                # 第一顆磁碟裝置
    /sda1               # 第一顆磁碟的第一個磁區
    /sda2               # 第一顆磁碟的第二個磁區
    /sdb                # 第二顆磁碟裝置
    /vda                # 第一顆虛擬磁碟
    /cdrom              # 光碟機裝置

    /sd1                # SCSI硬碟裝置
    /xvda               # 第一顆虛擬磁碟
    /md0                # 第一顆 軟體磁碟陣列裝置
    /hda                # IDE硬碟裝置
    /lp0                # 印表機裝置
```


### 1-4. quiz

下面那些是啥鬼~ 講不出來的話不宜繼續下去...

```sh
/dev/sdc
/dev/sda2
/dev/vdb
/dev/sdb3
```


### 1-5. 指令(目前可不理會)

```sh
# 查看 /dev/sda
$# ls -l /dev/sda
brw-rw----. 1 root disk 8, 0 Oct 18 10:16 /dev/sda
↑ 此為一個 storage device, 也稱為 block device

# 查詢磁碟上的 partition
$# df -hT
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        30G  7.8G   23G  26% /
devtmpfs                devtmpfs  1.9G     0  1.9G   0% /dev
tmpfs                   tmpfs     1.9G     0  1.9G   0% /dev/shm
tmpfs                   tmpfs     1.9G  9.8M  1.9G   1% /run
tmpfs                   tmpfs     1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/sda1               xfs      1014M  199M  816M  20% /boot
/dev/mapper/centos-home xfs        30G   22G  8.1G  74% /home
/dev/mapper/centos-var  xfs        30G  2.0G   29G   7% /var
tmpfs                   tmpfs     386M   12K  386M   1% /run/user/42
tmpfs                   tmpfs     386M     0  386M   0% /run/user/1000
```


## 2. 掛載

把 `裝置`, 掛載到 `特定目錄`, 掛載後就會出現在 `/dev/xxx`


### 2-1. filesystem 相關指令

```sh
$# blkid /dev/sda*
/dev/sda:  PTTYPE="dos"
/dev/sda1: UUID="32e1b5c9-e273-4c5f-bb3d-12e3bfb0a0b1"   TYPE="xfs"
/dev/sda2: UUID="8Kfav2-8j0m-mwLl-sqTP-oH25-Uj1T-a6HPss" TYPE="LVM2_member"
/dev/sda3: UUID="05652c15-4dcd-487d-924f-310b5cfeb718"   TYPE="xfs"
#   A                             B                               C
# A: 分割區
# B: 分割區的 UUID
# C: 分割區的檔案系統格式

$# lsblk -f
NAME            FSTYPE      LABEL UUID                                   MOUNTPOINT
sda
├─sda1          xfs               32e1b5c9-e273-4c5f-bb3d-12e3bfb0a0b1   /boot
├─sda2          LVM2_member       8Kfav2-8j0m-mwLl-sqTP-oH25-Uj1T-a6HPss
│ ├─centos-root xfs               f822af8a-f0da-4442-94a2-1eab5958856f   /
│ ├─centos-var  xfs               60a9801d-3d65-4d7d-bf4a-573642a59597   /var
│ └─centos-home xfs               623c0a3e-4b29-4b2b-bb31-c3b9d64ca200   /home
└─sda3          xfs               05652c15-4dcd-487d-924f-310b5cfeb718
sr0
```

### 2-2. mount

拿根隨身碟, 插上去吧~

```sh
# mount <隨身碟分割區> <絕對路徑>
# umount <絕對路徑>
```


## 3. 連結

- hard link : (Java) 只要有變數指向物件, 該物件就不會被記憶體回收機制給砍掉的概念
- soft link : (Windows) 捷徑的概念


## 4. 尋找

教學意義不大, 略 (真的不是我偷懶)

- [搜尋](https://github.com/cool21540125/documentation-notes/blob/master/linux/shell/find.md)
- [鳥哥-搜尋](http://linux.vbird.org/linux_basic/0220filemanager.php)
