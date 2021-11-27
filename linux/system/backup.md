# backup備份 restore還原

- [Backup](http://linux.vbird.org/linux_basic/0610hardware.php#backup_type)


## 工具

- dd (直接讀取磁碟, 非常慢喔) (`備份`, 建立大型檔案, ....)
- cpio (得要有 find 之類的找檔名指令)
- xfsdump/xfsrestore (可直接進行累積備份)
- rsync (非常快速)
- ghost (很早期的備份工具, 針對單機作backup&&restore)
- 再生龍(可把磁碟的東西複製成一個大檔案, 鳥哥很推薦這個)

## 完整備份之累積備份(Incremental backup)

週日作完整備份, 爾後則比較今天與`昨天`的差異, 備份差異部分. 再隔天, 一樣與`昨天`比較後, 備份差異的部分. 依此類推~


## 完整備份之差異備份(Differential backup)

週日作完整備份, 爾後則比較今天與`第一天`的差異, 備份差異部分. 再隔天, 一樣與`第一天`比較後, 備份差異的部分. 依此類推~ (`差異備份`會越來越大包)


### 鏡像備份(Mirror backup)

```sh
$ rsync -av <來源> <目標>
```



# 差異備份範例

- 2018/07/08
- [鳥哥 - 僅備份比某個時刻還要新的檔案](http://linux.vbird.org/linux_basic/0240tarcompress.php#pack)

```sh
# 某些情況下, 只會想要備份 `比某日期還新` 的檔案
# 找出比 /etc/passwd 還新, 且放在 /etc/裏頭的東西 (su)
$# find /etc -newer /etc/passwd
/etc
/etc/resolv.conf
/etc/rwtab.d
/etc/logrotate.d
/etc/shadow
/etc/selinux/targeted
/etc/selinux/targeted/tmp
/etc/selinux/targeted/tmp/modules
/etc/selinux/targeted/tmp/modules/100
...(略)...

$# ll /etc/passwd
-rw-r--r--. 1 root root 2541  6月 26 21:43 /etc/passwd

# 僅對於 (mtime) 2018/06/26 以後有異動過的檔案, 作差異備份~ (打包壓縮)
$# tar zcf bb.tar.gz --newer-mtime="2018/06/26" /etc/*
tar: 選項 --newer-mtime: 以 2018-06-26 00:00:00 格式來處理日期「2018/06/26」
tar: 從成員名稱中移除前端的「/」
/etc/selinux/targeted/tmp/policy.linked                                  # 有備份
tar: /etc/abrt/abrt-action-save-package-data.conf：檔案沒有變更；未傾印     # 沒備份
...(略)...

# 查看 tar 內, 結尾非 「/」的檔名
$# tar ztf bb.tar.gz | grep -v '/$'
-rw-r----- root/lp         410 2018-06-27 23:02 etc/cups/subscriptions.conf.O
-rw-r----- root/lp         111 2018-06-28 09:06 etc/cups/subscriptions.conf
-rw-r--r-- root/root      1062 2018-06-26 21:43 etc/group
...(略)...
```



# xfs 檔案系統 (CentOS7 預設)

- 2018/07/09


## xfsdump && xfsrestore

- 只能備份 `XFS "檔案系統"` (`無法備份 XFS檔案系統 裡的 特定目錄`)
- 備份的東西只能讓 `xfsrestore` 解析
- 只能備份已掛載的檔案系統(不支援沒有掛載的檔案系統)
- 透過 檔案系統 的 UUID 來分辨 各個備份檔, 所以不能備份兩個 相同 UUID 的檔案系統

第一次備份一定是 `完整備份`, 完整備份 在 `xfsdump` 當中被定義為 `level0`, 日後的 `增量備份`, 則一次為 `level1`, `level2`, `level3`, ..., 而這些 `level們`, 放在 `/var/lib/xfsdump/inventory/`


## 1. xfsdump 備份~~

```sh
$ xfsdump [-L S_Label] [-M M_Label] [-l #] [-f <backup name>] <target file>
# -L : xfsdump 會記錄每次備份的 session 標頭
# -M : xfsdump 可以記錄 儲存媒體的標頭
# -l : 0~9級, (default=0), 0: 完整備份
# -f : 總之一定要 「-f <backup name> 就對了」, 指定備份的檔案名稱
# -I : 從 「/var/lib/xfsdump/inventory」列出備份的東西

$ xfsdump -I
xfsdump: Dump Status: SUCCESS

# 拿 /boot 來作備份練習, 先確認一下掛載點~~
$ df -hT /boot
檔案系統       類型  容量  已用  可用 已用% 掛載點
/dev/sda1      xfs  1014M  242M  773M   24% /boot

# xfsdump 只能在 root 下執行~~~
$# xfsdump -l 0 -L boot_all -M boot_all -f boot.dump /boot
[sudo] password for tony:
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.4 (dump format 3.0) - type ^C for status and control
xfsdump: level 0 dump of tonynb:/boot               # level 0 完整備份 /boot
xfsdump: dump date: Mon Jul  9 21:44:02 2018
xfsdump: session id: a3f2ed02-b6c0-4f80-af31-fa708622668b   # dump ID
xfsdump: session label: "boot_all"                  # -L 所寫的 標籤訊息
xfsdump: ino map phase 1: constructing initial dump list        # 開始備份程序
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 219780416 bytes
xfsdump: /var/lib/xfsdump/inventory created         # <--- 使用 xfsdump -I 就能看到東西了~
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 219464808 bytes
xfsdump: dump size (non-dir files) : 219222760 bytes
xfsdump: dump complete: 5 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /home/tony/tmp/qq/boot.dump OK (success)
xfsdump: Dump Status: SUCCESS
# 如果備份時, 沒有給 「-L」「-M」, 會進入 REPL 的環境

# 觀看備份資訊
$ xfsdump -I
file system 0:
        fs id:          e667a4ef-3733-4c49-bb50-767221d1537e
        session 0:          ### session 0
                mount point:    tonynb:/boot
                device:         tonynb:/dev/sda1
                time:           Mon Jul  9 21:44:02 2018
                session label:  "boot_all"
                session id:     a3f2ed02-b6c0-4f80-af31-fa708622668b
                level:          0           ### Level 0
                resumed:        NO
                subtree:        NO
                streams:        1
                stream 0:
                        pathname:       /home/tony/tmp/qq/boot.dump # 備份的檔案放這~
                        start:          ino 100 offset 0
                        end:            ino 1069155 offset 0
                        interrupted:    NO
                        media files:    1
                        media file 0:
                                mfile index:    0
                                mfile type:     data
                                mfile size:     219464808
                                mfile start:    ino 100 offset 0
                                mfile end:      ino 1069155 offset 0
                                media label:    "boot_all"
                                media id:       33a25ae1-51f3-47d3-a11e-c787ee7460ac
xfsdump: Dump Status: SUCCESS

$ ll
總計 214324
-rw-r--r--. 1 root root 219464808  7月  9 21:44 boot.dump

$ ll /var/lib/xfsdump/inventory/
總計 16
-rw-r--r--. 1 root root 5080  7月  9 21:44 dfa1a473-aa41-4543-8a64-34b349aa3ea8.StObj
-rw-r--r--. 1 root root  312  7月  9 21:44 e667a4ef-3733-4c49-bb50-767221d1537e.InvIndex
-rw-r--r--. 1 root root  576  7月  9 21:44 fstab

# 底下為了進行 增量備份, 所以先弄個假東西在裏頭XD
$# dd if=/dev/zero of=/boot/testing.img bs=1M count=10
# block size=1M
# count 10 份
# of=... 輸出到
# 總計 1M * 10 = 10M

$# touch /boot/QQQ

# 進行 level 1 增量備份~~
$# sudo xfsdump -l 1 -L second_bak -M second_bak -f boot.dump1 /boot
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.4 (dump format 3.0) - type ^C for status and control
xfsdump: level 1 incremental dump of tonynb:/boot based on level 0 dump begun Mon Jul  9 21:44:02 2018
xfsdump: dump date: Mon Jul  9 21:59:41 2018
xfsdump: session id: 570aa31f-48b9-40a0-a93b-a27b47c1f160
xfsdump: session label: "second_bak"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: pruning unneeded subtrees
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 10507200 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 10511568 bytes
xfsdump: dump size (non-dir files) : 10487872 bytes
xfsdump: dump complete: 0 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /home/tony/tmp/qq/boot.dump1 OK (success)
xfsdump: Dump Status: SUCCESS

$ ll
總計 224592
-rw-r--r--. 1 root root 219464808  7月  9 21:44 boot.dump
-rw-r--r--. 1 root root  10511568  7月  9 21:59 boot.dump1

$ ll /var/lib/xfsdump/inventory
總計 16
-rw-r--r--. 1 root root 5760  7月  9 21:59 dfa1a473-aa41-4543-8a64-34b349aa3ea8.StObj
-rw-r--r--. 1 root root  312  7月  9 21:59 e667a4ef-3733-4c49-bb50-767221d1537e.InvIndex
-rw-r--r--. 1 root root  576  7月  9 21:44 fstab

$ xfsdump -I
file system 0:
        fs id:          e667a4ef-3733-4c49-bb50-767221d1537e
        session 0:          # 第一次備份的 Session
                mount point:    tonynb:/boot
                device:         tonynb:/dev/sda1
                time:           Mon Jul  9 21:44:02 2018
                session label:  "boot_all"
                session id:     a3f2ed02-b6c0-4f80-af31-fa708622668b
                level:          0       # 完整備份唷!!
                resumed:        NO
                subtree:        NO
                streams:        1
                stream 0:
                        pathname:       /home/tony/tmp/qq/boot.dump # 備份的檔案放這~
                        start:          ino 100 offset 0
                        end:            ino 1069155 offset 0
                        interrupted:    NO
                        media files:    1
                        media file 0:
                                mfile index:    0
                                mfile type:     data
                                mfile size:     219464808
                                mfile start:    ino 100 offset 0
                                mfile end:      ino 1069155 offset 0
                                media label:    "boot_all"
                                media id:       33a25ae1-51f3-47d3-a11e-c787ee7460ac
        session 1:          # 第二次備份的 Session阿~~
                mount point:    tonynb:/boot
                device:         tonynb:/dev/sda1
                time:           Mon Jul  9 21:59:41 2018
                session label:  "second_bak"
                session id:     570aa31f-48b9-40a0-a93b-a27b47c1f160
                level:          1           # 增量備份!!!!!
                resumed:        NO
                subtree:        NO
                streams:        1
                stream 0:
                        pathname:       /home/tony/tmp/qq/boot.dump1    # 備份的檔案放這~
                        start:          ino 241092 offset 0
                        end:            ino 241096 offset 0
                        interrupted:    NO
                        media files:    1
                        media file 0:
                                mfile index:    0
                                mfile type:     data
                                mfile size:     10511568
                                mfile start:    ino 241092 offset 0
                                mfile end:      ino 241096 offset 0
                                media label:    "second_bak"
                                media id:       b76fa227-c982-404c-9576-966dd5a5daff
xfsdump: Dump Status: SUCCESS
```


## 2. xfsrestore 還原~~

```sh
$ xfsrestore -I     # 結果99% 與 「xfsdump -I」 相同

# 假設~~  原本備份檔的位置被移動過了, 但是上面指令查到的, 一樣是移動前的路徑... 別理它! 依照目前最真實的位置來指定備份檔即可
$# xfsrestore -f boot.dump -L boot_all /tmp
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
xfsrestore: using online session inventory
xfsrestore: searching media for directory dump
xfsrestore: examining media file 0
xfsrestore: reading directories
xfsrestore: 9 directories and 336 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: restore complete: 2 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /home/tony/tmp/qq/a/boot.dump OK (success)
xfsrestore: Restore Status: SUCCESS

# 以 du 掃描磁碟(/boot && tmp)使用量, m: Mega顯示 ; s: 只顯示總容量
$# du -sm /boot tmp
220     /boot
210     tmp
# 差了 10 MB, 就是剛剛新增的假東西啦!!

# 查詢差異~
$# diff -r tmp/ /boot/
只在 /boot/ 存在：QQQ           # 英文為 Only in /boot: QQQ
只在 /boot/ 存在：testing.img   # 　　　 Only in /boot: testing.img
# 以上的結果, 就算把原本的 boot.dump 復原到 /boot 也是一樣
# 因為, 還原的東西會蓋掉既有檔案 ; 而在此新增的東西, 不會被蓋掉也不會刪除...

# 另外還有 -s 作部分還原
# -i 可用互動式還原 (在此省略)
```



# dd - 製作檔案, 壓縮, ...

預設 dd 是逐磁區去作讀/寫, 所以不用理會 檔案系統, 都可以作備份還原

```sh
# 製作空檔案
$ dd if=/dev/zero of=/tmp/big_file bs=1M count=10

$ dd if="input_file" of="output_file" bs="block_size" count="number"
# if 為 input file, 也可以是裝置(usb, disk)
# of 為 output file (同上)
# bs 為 規劃的一個 block 的大小, 沒指定預設為 512 bytes
# count : 有多少個 bs

# 把 /etc/passwd 備份到 /home/tony/tmp/passwd.bak
$ dd if=/etc/passwd of=/home/tony/tmp/passwd.bak
4+1 records in
4+1 records out
2541 bytes (2.5 kB) copied, 0.00142874 s, 1.8 MB/s

$ ll passwd.bak /etc/passwd
-rw-r--r--. 1 root root 2541  6月 26 21:43 /etc/passwd
-rw-rw-r--. 1 tony tony 2541  7月  9 23:10 passwd.bak
# 檔案大小為 2541 bytes, 而因為 dd 時, 沒有指定 bs, 預設為 512 bytes
# 512*4 < 2541 < 512*5=2560
# 所以~ 4+1 表示有 4 個完整的 512 bytes + 1 個還沒滿的
```
