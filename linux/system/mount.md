# mount 掛載

- 2018/06/28
- `掛載點` 為 `目錄`
- `單一檔案系統` 不要重複掛載到 `不同的掛載點(目錄)`
- `單一目錄` 不要重複掛載到 `多個檔案系統`
- `要被掛載東西的目錄` 裏頭應該是 `空的` ((不然掛載後, 裡面的東西會`被隱藏`)) <- 卸載的時候, 會再出現
- 如果哪天想為 mount 上來的裝置取名字, 可參考 `mknod` , `xfs_admin` , `tune2fs`

For CentOS7, 掛載時, 會自動到 fs 的 superblock 去分析並測試掛載, 所以可以自動判斷
檔案系統種類, 因此, 使用 `mount` 時, 可省略 `-t`

- `/etc/filesystems` : 系統指定的 測試掛載 fs 類型 的 優先順序
- `/proc/filesystems` : 系統已經載入的 fs 類型
- `/lib/modules/$(uname -r)/kernel/fs/` : Linux 支援的 fs 的所有驅動程式 目錄

# 標準作業流程

1. 插入空的隨身碟
2. 先作磁區分割 ( `fdisk` or `gdisk` )
3. 針對 _分割後的 Partition_ 格式化 `mkfs`
4. 手動掛載 `mount /dev/sdb1 <path>`
5. 自動掛載 : 修改 `/etc/fstab` (有錯誤會導致無法開機! 改後記得用 `mount -a` 測試是否失敗!!)

# 說明... 乾~ 超大一包

簡單版的掛載指令: `mount UUID="<lskid 找到要掛載的裝置 UUID>" <要掛載的空資料夾完整路徑>`

某些特殊情況下, ex: 進入單人維護模式, `根目錄` 會被系統掛載為 `ro`... (看不太懂...), 重新掛載 `根目錄` 的指令為: `mount -o remount,rw,auto /` (沒事別用)

```sh
# mount -a                      依照 設定檔 /etc/fstab 的資料, 把所有 未掛載 的磁碟都掛載上來
# mount [-l Label名稱]
# mount [-t <filesystem>] LABEL='' <掛載點>
# mount [-t <filesystem>] UUID='' <掛載點>
# mount [-t <filesystem>] 裝置名稱='' <掛載點>

# -t : 可以加上 檔案系統種類 來指定要掛載的類型. 但是, CentOS7 會幫忙自動判斷, 所以可不給 -t
# -o : 掛載時的額外參數, ex: 帳密, 權限, 等
#    async, sync : default async
#    ro, rw : 掛載 fs 為 唯讀, 可讀寫
#    auto, noauto : 允許 fs 被以 「mount -a」 自動掛載
#    dev, nodev : 是否允許 fs 可建立裝置檔案
#    suid, nosuid : 是否允許 fs 含有 suid/sgid 的檔案格式
#    exec, noexec : 是否允許 fs 擁有可執行的 binary檔
#    user, nouser : 是否允許 fs 讓任何 User 執行 mount (default 只有 root 能作)
#                   但使用 user 參數後, 也可讓一般 user 對 partition 進行 mount
#    defaults : 預設為 rw, suid, dev, exec, auto, nouser, async
#    remount : 系統出錯 or 重新更新參數時, 再重新掛載吧~
```

掛載時, 也可能因為 os 只支援英文, 但掛上來的裝置有其他語系, 所以要作其他指令才有辦法對此語系有正常解讀 `mount -o codepage=950,iocharset=utf8 UUID="xxx" <要掛載到哪裡>`

# 範例 1 - (把稍早前作的 sda3 掛上去)

- 2018/07/10

```sh
# 查看所有裝置
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 465.8G  0 disk
├─sda1        8:1    0     1G  0 part /boot
├─sda2        8:2    0   218G  0 part
│ ├─cl-root 253:0    0    80G  0 lvm  /
│ ├─cl-swap 253:1    0     8G  0 lvm  [SWAP]
│ ├─cl-var  253:2    0    50G  0 lvm  /var
│ └─cl-home 253:3    0    80G  0 lvm  /home
└─sda3        8:3    0    16G  0 part       # 掛這個
sr0          11:0    1  1024M  0 rom

$# blkid
/dev/sda3: UUID="99ded814-7953-433a-9c22-1d85bcea167c" TYPE="xfs"   # 掛這個
/dev/sda1: UUID="e667a4ef-3733-4c49-bb50-767221d1537e" TYPE="xfs"
/dev/sda2: UUID="N7C7nQ-mO2j-D3HQ-l9dc-M8HF-OyO0-P85EX1" TYPE="LVM2_member"
/dev/mapper/cl-root: UUID="38a08831-a238-46a9-abf9-930a79eb9ec6" TYPE="xfs"
/dev/mapper/cl-swap: UUID="8b182032-3e30-46af-8937-8c05cbbcd277" TYPE="swap"
/dev/mapper/cl-var: UUID="193df025-24c5-45e5-8acf-49825f741754" TYPE="xfs"
/dev/mapper/cl-home: UUID="37a295a7-78fa-47d5-b2e8-78b4b4a10549" TYPE="xfs"

# mkdir -p 遞迴建資料夾
$# cd / ; mkdir -p /data/xfs
$# mount UUID="99ded814-7953-433a-9c22-1d85bcea167c" /data/xfs

$# df -h /data/xfs
檔案系統        容量  已用  可用 已用% 掛載點
/dev/sda3        16G   33M   16G    1% /data/xfs        # 這個是自己作的 swap...
# 掛上去了~~~

$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 465.8G  0 disk
├─sda1        8:1    0     1G  0 part /boot
├─sda2        8:2    0   218G  0 part
│ ├─cl-root 253:0    0    80G  0 lvm  /
│ ├─cl-swap 253:1    0     8G  0 lvm  [SWAP]
│ ├─cl-var  253:2    0    50G  0 lvm  /var
│ └─cl-home 253:3    0    80G  0 lvm  /home
└─sda3        8:3    0    16G  0 part /data/xfs         # 他終於有家惹 QQ~
sr0          11:0    1  1024M  0 rom
```

# 範例 2 - 把 CentOS7 的光碟 塞到電腦後~~

```sh
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 465.8G  0 disk
├─sda1        8:1    0     1G  0 part /boot
├─sda2        8:2    0   218G  0 part
│ ├─cl-root 253:0    0    80G  0 lvm  /
│ ├─cl-swap 253:1    0     8G  0 lvm  [SWAP]
│ ├─cl-var  253:2    0    50G  0 lvm  /var
│ └─cl-home 253:3    0    80G  0 lvm  /home
└─sda3        8:3    0    16G  0 part /data/xfs
sr0          11:0    1   4.1G  0 rom  /run/media/tony/CentOS 7 x86_64   # CentOS7 光碟

$# mkdir /data/cdrom

$# mount /dev/sr0 /data/cdrom
mount: /dev/sr0 is write-protected, mounting read-only
# 掛載光碟, 預設使用 ro 來掛載喔!

$# df -h /data/cdrom
檔案系統        容量  已用  可用 已用% 掛載點
/dev/sr0        4.1G  4.1G     0  100% /data/cdrom
# 掛載上去之後@@... 就無法退出光碟片了!!!
# 用 GUI 點進去之後, 可以看到光碟內容出現在 /data/cdrom

# 這時候發現 /run/media/tony/ 及 /data/cdrom 都有光碟的資料~~

# 卸載它~
$ umount /data/cdrom

# 卸載後~ /data/cdrom/就變空了~~
```

# 範例 3 - symbolic link 的替代方式 - `mount --bind dirA dirB`

某些情況下, 無法使用軟連結, 可以用 `mount` 的方式, 來把特定目錄 掛載到 另一個地方...

```sh
$# mkdir /data/var
$# mount --bind /var /data/var

$# ls -lid /var /data/var
96 drwxr-xr-x. 23 root root 4096  6月 26 21:43 /data/var
96 drwxr-xr-x. 23 root root 4096  6月 26 21:43 /var
# 挖~~ 長一樣耶

$# mount | grep var
/dev/mapper/cl-var on /var type xfs (rw,relatime,seclabel,attr2,inode64,noquota)        # 這東西是我一開始安裝時, 就已經把分割區切出去了
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
/dev/mapper/cl-var on /data/var type xfs (rw,relatime,seclabel,attr2,inode64,noquota)   # 剛剛把這個掛載上來了
```

# /etc/fstab

```sh
$# cat /etc/fstab

# /etc/fstab
# Created by anaconda on Tue Feb 27 13:45:22 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
# 1                      2       3          4       5     6
/dev/mapper/cl-root     /       xfs     defaults    0     0
UUID=e6...(pass)...7e   /boot   xfs     defaults    0     0
/dev/mapper/cl-home     /home   xfs     defaults    0     0
/dev/mapper/cl-var      /var    xfs     defaults    0     0
/dev/mapper/cl-swap     swap    swap    defaults    0     0
#
# 1.裝置/UUID等
# 2.掛載點
# 3.檔案系統
# 4.檔案系統參數
# 5.dump -  能否被 dump 備份指令作用
# 6.fsck - 是否以 fsck 檢驗磁區
```

# swap 相關

使用檔案建置 swap

```bash
### 先查看 Disk 的 Block Size
$# fdisk -l
# 假設 「Units = sectors of 1 * 512 = 512 bytes」
# 則 底下 dd 的 bs, 盡可能為 512 的倍數, 以優化讀寫效能
# (會造成一定程度的浪費, 不過可盡量降低磁碟的搜尋成本)

### 配置 4 GB 的 swap
$# dd if=/dev/zero of=/swapfile count=2097152 bs=4KiB

### 安全性問題, 務必使用 root read only
$# chmod 600 /swapfile

### 讓系統 setup up swap space
$# mkswap /swapfile
Setting up swapspace version 1, size = 4194300 KiB
no label, UUID=6ec8f68c-f6cf-43ae-96e9-6e15294c563d

### 掛載使用 swap
$# swapon /swapfile

### 確認 swap 的使用
$# swapon -s
Filename				Type		Size	Used	Priority
/swapfile                              	file	4194300	0	-2

### 永久配置
$# vim /etc/fstab
# ↓↓↓↓↓↓ 配置 ↓↓↓↓↓↓
/swapfile   swap    swap    sw  0   0 # 兩者皆可
/swapfile   none    swap    sw  0   0 # 兩者皆可
# ↑↑↑↑↑↑ 配置 ↑↑↑↑↑↑

### 配置後記得確認
$# mount -a
```
