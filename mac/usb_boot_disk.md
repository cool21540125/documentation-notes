

# macbook 製作 Linux 安裝隨身碟

First thing first

先去把 RockyLinux / Ubuntu / CentOS / ..... 的 iso 下載下來

```zsh
### 將 Ubuntu iso 製作成 OS X 的 UDRW (UDIF read/write image) 格式的 dmg file
hdiutil convert -format UDRW -o ubuntu-18.04.6-desktop-amd64.dmg ubuntu-18.04.6-desktop-amd64.iso
# ...(略)...
#經過時間：11.363s
#速度：422.8MB/秒
#節省：0.0%
#created: /Users/tony/Downloads/ubuntu-18.04.6-desktop-amd64.dmg


### 查詢 USB 的 Partition
diskutil list
# (僅節錄部分, 由此可知位於 /dev/disk2)
#/dev/disk2 (external, physical):
#   #:                       TYPE NAME                    SIZE       IDENTIFIER
#   0:     FDisk_partition_scheme                        *30.8 GB    disk2
#   1:                       0xEF                         7.3 MB     disk2s2


### 先做 umount
diskutil unmountDisk /dev/disk2
#Unmount of all volumes on disk2 was successful


### 把 dmg 寫入到 USB
sudo dd if=ubuntu-18.04.6-desktop-amd64.dmg of=/dev/rdisk2 bs=1m
# (要等他跑一陣子, 10 mins)
# 然後就會跳出一個視窗, 告知「讀取不到磁碟(讀取不到隨身碟啦)」
# 點選 退出


### 退出 USB
diskutil eject /dev/disk2
#Disk /dev/disk2 ejected
```

就可以拿去重灌了~
