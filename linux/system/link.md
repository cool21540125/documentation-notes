# 連結方式 : `實體連結` && `符號連結`

1. Hard link
    1. 節省儲存空間, 防止檔案誤刪
    2. 只能建立在 `檔案` 上, 不能跨 File System
2. Soft link (與 Windows的捷徑一樣)

```sh
$ ln [-sf] <來源> <目的地>
# s : 軟連結
# f : 如果目標檔存在, 則覆蓋

$ ln -s /opt/anaconda3/bin/python3    ~/bin/python
#       ^^^^^ 可以連到這裡             ^^^^^ 藉由這裡
$ ll ~/bin/python
lrwxrwxrwx. 1 root root   26  3月  2 14:10 python -> /opt/anaconda3/bin/python3

$ cd ~
$ mkdir qq
$ cd qq
$ cp -a /etc/passwd .   #(-a 為 連同 屬性 一起複製)

# 查看目前目錄底下的 inode 與 block 的容量
$ du -sb ; df -i .
2420	.   # <-- 目前資料夾用了多少 bytes
檔案系統               Inode I已用    I可用 I已用% 掛載點
/dev/mapper/cl-home 41943040 53861 41889179     1% /home
# I已用 53861

$ ln passwd passwd-hd       ### hard link
$ du -sb ; df -i .
2437	.   # <-- 查看目前資料夾用了多少 bytes (與鳥哥範例不一樣, 他這裡沒變@@... )
檔案系統               Inode I已用    I可用 I已用% 掛載點
/dev/mapper/cl-home 41943040 53861 41889179     1% /home
# I已用 53861

$ ll -i passwd*
201351502 -rw-r--r--. 2 tony tony 2400  2月 27 23:31 passwd
201351502 -rw-r--r--. 2 tony tony 2400  2月 27 23:31 passwd-hd

$ ln -s passwd passwd-so    ### soft link
$ du -sb ; df -i .
2460	.
檔案系統               Inode I已用    I可用 I已用% 掛載點
/dev/mapper/cl-home 41943040 53863 41889177     1% /home

$ ll -i passwd*
201351502 -rw-r--r--. 2 tony tony 2400  2月 27 23:31 passwd
201351502 -rw-r--r--. 2 tony tony 2400  2月 27 23:31 passwd-hd
201351512 lrwxrwxrwx. 1 tony tony    6  4月  7 16:00 passwd-so -> passwd

$ rm passwd
$ ll passwd*
-rw-r--r--. 1 tony tony 2400  2月 27 23:31 passwd-hd
lrwxrwxrwx. 1 tony tony    6  4月  7 16:00 passwd-so -> passwd  # 'passwd-so' 變紅了!!

# hard link 的東西還活著
$ cat passwd-hd | head -3
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

# soft link 的東西掛了
$ cat passwd-so | head
cat: passwd-so: 沒有此一檔案或目錄
```
