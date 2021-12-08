
# 壓縮, 解壓縮, 打包 概念

- 2018/07/04
- 系統作 `備份` 時, 這邊的指令細節必須要注意!!


```bash
###!! 快速打包本地資料夾所有檔案
$# tar czf all.tar.gz *
# 若檔案很大, 為加速傳輸效率, 上述 z 改 j(bz2) 或 J(xz)

### 解壓縮 tar ball 到本地資料夾
$# tar xzf all.tar.gz
```


```sh
    c   z              .gz
tar xv  jf  tarName.tar.bz2
    t   J              .xz
# 打包 c, 壓縮任選 z / j / J
# 解包 x, 解壓縮依附檔名選擇
# 壓縮解壓縮對應:
#  z  -> .gz
#  j  -> .bz2
#  J  -> .xz

# tar [-zjJ] ctxvf <檔名> [-C 目錄]
# -c : 建立 tar
# -t : 查看 tar 裡面有那些東西
# -x : 解開已打包的檔案
# -v : 顯示進度
# -f : 指定包裹檔案的名稱 (( 這個參數一定要放在最右邊! ))
# -C : 解壓縮時, 把東西解壓縮到~

# -z : 透過 gzip
# -j(小) : 透過 bzip2
# -J(大) : 透過 xz

# -C : 解壓縮 特定目錄

# -p(小) : 保留原檔案的權限與屬性 (preserve permission)
# -P(大) : 保留絕對路徑 (打包系統檔時, 慎用!!!  不然日後解壓縮時, 舊資料 會蓋掉 新資料!! )

# --exclude=XX : 不打包 XX
```

# 壓縮技術:

- 7z        (Windows常見)
- zip       (Windows常見)
- gzip(gz)  (Linux常見)
- bZ2       (Linux常見)
- xz        (Linux常見)

Linux 常用壓縮技術, 因為多半壓縮只能對單一檔案作壓縮, 所以會將他們作 `tar 打包` 後, 再來壓縮 ( `tar` = `打包的軟體` )


    *.Z         由 compress 壓縮    # 老舊~
    *.zip       由 zip 壓縮         # 為了支援 Windows
    *.gz        由 gzip 壓縮        # 可以解開 compress, zip, gz
    *.bz2       由 bzip2 壓縮       # 
    *.xz        由 xz 壓縮          # 這個比較新(壓縮品質不錯)

    *.tar       由 tar 打包, 未壓縮
    *.tar.gz    由 tar 打包, 由 gzip 壓縮
    *.tar.bz2   由 tar 打包, 由 bzip2 壓縮
    *.tar.xz    由 tar 打包, 由 xz 壓縮


## gzip, zcat/zmore/zless/zgrep

- 這邊只舉 `gzip`, `zcat`, `zgrep` 為例
- 可以把 `gzip` 想像成是為了取代 `compress` 而生

```sh
$ gzip [-cdtv#] filename
-c : 壓縮資料流導向螢幕, 可重新導向資料流
-d : 有寫這個的話, 表示是在作 解壓縮
-t : 有點像是在測試檔案用的吧, 檢驗壓縮檔的一致性
-v : 顯示出 原/壓縮後 的壓縮比資訊
-# : #為數字, 1(最快)~9(最佳), 預設 -6

$ ls -ldSr /etc/*   # ldSrh:詳細資訊, 只顯示Dir, 大小排序, 反向列出, 顯示KB MB GB
...(略)...

$ cp /etc/services /tmp/.   # 把剛剛看到最大的Dir 複製出去

$  gzip -v services
services:        79.7% -- replaced with services.gz

$ ll -h /etc/services /tmp/services*
-rw-r--r--. 1 root root 655K  6月  7  2013 /etc/services
-rw-r--r--. 1 tony tony 133K  7月  4 00:31 /tmp/services.gz
# gzip 預設會打包成 .gz
# 且原始檔會消失
# 此檔案可被 Windows 的 WinRAR/7zip解壓縮

# 等同 cat 看檔案, zcat 可看 .gz 的內容
$ zcat services.gz

# zgrep 可以找 .gz檔內的某些文字, 放在第幾行
$ zgrep -n 'http' services.gz
14:#       http://www.iana.org/assignments/port-numbers
89:http            80/tcp          www www-http    # WorldWideWeb HTTP
90:http            80/udp          www www-http    # HyperText Transfer Protocol
```

```sh
### gzip 壓縮 && gunzip 解壓縮
$ touch aa
$ ls
aa

$ gzip aa           # 使用 gzip壓縮 (取代原始檔案)
$ ls
aa.gz

$ gunzip aa.gz      # 使用 gunzip解壓縮 (取代原始檔案)
$ ls
aa
```

```sh
### zip 壓縮 && unzip 解壓縮
$ ls
aa

$ zip -r qq.zip aa          # 使用 zip 壓縮
  adding: aa (stored 0%)

$ ls
aa  qq.zip

$ rm aa

$ unzip qq.zip              # 使用 unzip 解壓縮
Archive:  qq.zip
 extracting: aa

$ ls
aa  qq.zip
```

```sh
### zip 壓縮 && unzip 解壓縮 (加密碼~)
$ touch a1 a2 a3

# 將 a1, a2, a3 壓縮為 FF.zip, 並設定密碼
$ zip -er FF.zip a1 a2 a3   # -er 設定 解壓縮密碼~
Enter password:     # 設定 解壓縮密碼
Verify password:    # 再次設定 解壓縮密碼
  adding: a1 (stored 0%)
  adding: a2 (stored 0%)
  adding: a3 (stored 0%)

$ rm a1 a2 a3

# 把 FF.zip 裡面的檔案全部解壓縮出來
$ unzip FF.zip
Archive:  FF.zip
[FF.zip] a1 password:   # 輸入 解壓縮密碼
 extracting: a1
 extracting: a2
 extracting: a3
```


## bzip2, bzcat/bzmore/bzless/bzgrep

- 可以把 `gzip2` 想像成是為了取代 `gzip` 而生
- 指令幾乎與 `gzip` 一樣 ; 
- 相較 `gzip`, 大檔案的話, 壓縮品質提升, 但速度較慢

```sh
$ gzip2 [-cdkzv#] filename
-c : 壓縮資料流導向螢幕, 可重新導向資料流
-d : 有寫這個的話, 表示是在作 解壓縮
-k : 有寫的話, 壓縮完仍保留原始檔不刪除
-z : 壓縮的參數(此為預設, 沒必要寫這個...)
-v : 顯示出 原/壓縮後 的壓縮比資訊
-# : #為數字, 1(最快)~9(最佳), 預設 -6

$ bzip2 -v services
services:  5.409:1,  1.479 bits/byte, 81.51% saved, 670293 in, 123932 out.
# 122K
# 筆上面的 79% 還要強大~~  變成 81.5%
```


## xz, xzcat/xzmore/xzless/xzgrep

- 語法也幾乎與 `gzip2` 一樣
- 壓縮品質筆 `gzip2` 還要好, 時間更久 =..=

```sh
$ xz [-dtlkc#] filename
-d : 有寫這個的話, 表示是在作 解壓縮
-t : 檢驗壓縮檔的完整性
-l : 列出壓縮檔的相關資訊
-k : 有寫的話, 壓縮完仍保留原始檔不刪除
-c : 壓縮資料流導向螢幕, 可重新導向資料流
-# : #為數字, 1(最快)~9(最佳), 預設 -6

$ xz -v services
services (1/1)
  100 %        97.3 KiB / 654.6 KiB = 0.149

# 三種壓縮技術比較~
$ ll -h
-rw-r--r--. 1 tony tony 133K  7月  4 00:55 services.gz
-rw-r--r--. 1 tony tony 122K  7月  4 00:55 services.bz2
-rw-r--r--. 1 tony tony  98K  7月  4 00:31 services.xz

# 可看壓縮前後比較
$ xz -l services.xz
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1       1     97.3 KiB    654.6 KiB  0.149  CRC64   services.xz
```



# tar (ball) - 把一堆東西 包成一包

複習~ 

前面提到, 壓縮解壓縮有 3 種格式
- gzip          : 最快
- bzip2 (bz2)   : 沒特色...
- xz            : 最省空間


```sh
$# time tar zpcf /root/etc.tar.gz /etc    # 用 gz 壓縮 && 打包
tar: 從成員名稱中移除前端的「/」    # @@ 這是啥? 後面揭曉~~

real    0m2.068s
user    0m2.022s
sys     0m0.165s
$# time tar jpcf /root/etc.tar.bz2 /etc   # 用 bzip2 壓縮 && 打包

tar: 從成員名稱中移除前端的「/」    # 英文為 「tar: Removing leading `/' from member names」
real    0m5.748s
user    0m5.667s
sys     0m0.163s

$# time tar Jpcf /root/etc.tar.xz /etc    # 用 xz 壓縮 && 打包
tar: 從成員名稱中移除前端的「/」
real    0m21.362s
user    0m21.192s
sys     0m0.381s

$# ll -h /root/ | grep etc.tar.*
-rw-r--r--. 1 root root  20M  7月  8 19:39 etc.tar.gz
-rw-r--r--. 1 root root  17M  7月  8 19:40 etc.tar.bz2
-rw-r--r--. 1 root root  14M  7月  8 19:40 etc.tar.xz

$# du -sm /etc
63      /etc
# 實際目錄約佔了 63MB
```


## 壓縮打包系統資料時, 務必加上 「`P`」, 去除絕對路徑

```sh
$# tar -jtvf /root/etc.tar.bz2
drwxr-xr-x root/root         0 2018-07-08 13:20 etc/
-rw-r--r-- root/root       617 2018-02-27 13:45 etc/fstab
-rw------- root/root         0 2018-02-27 13:45 etc/crypttab
(...略...)                                    # ↑ @@
# 注意!! 最右邊的路徑, 都已經移除了 根目錄的絕對路徑「/」
# 目的很明瞭~  防止解壓縮之後, 解壓縮的檔案們會跑回絕對路徑, 把最新的資料蓋掉
```

```sh
# 只解壓縮 單一檔案
$ touch a b c

$  tar -zcvf file.tar.gz a b c
a
b
c

$ rm a b c

# 查看裡面有什麼
$ tar ztvf file.tar.gz
-rw-rw-r-- tony/tony         0 2018-07-08 20:24 a
-rw-rw-r-- tony/tony         0 2018-07-08 20:24 b
-rw-rw-r-- tony/tony         0 2018-07-08 20:24 c

# 解壓縮 tar 內單一檔案的話, ex: file.tar.gz
$ tar zxvf file.tar.gz a            # 在最後指定要 解壓縮出哪些東西
a

$ ls
a  file.tar.gz      # 只把 a 解壓縮出來~
```


## `tarfile` vs `tarball`

- tarfile : 只作了打包, 沒作壓縮
- tarball : 打包 + 壓縮

但是大家常常通稱 tarball...

底下, 有點進階, 詳見[鳥哥-檔案壓縮,打包與備份](http://linux.vbird.org/linux_basic/0240tarcompress.php)
```sh
$ cd /tmp
$# tar -cvf - /etc | tar -xvf -
# tar: 從成員名稱中移除前端的「/」
# -c : 建立新檔案
# 把 | 前半部的 「-」交由後半部的「-」繼續作(不產生中繼檔案)

$# ll
總計 12
drwxr-xr-x. 150 root root 8192  7月  8 20:15 etc

# 將 /etc 打包, 「-」 不留中介檔, 直接透過 「|」 導向 stdout, 作解開的動作, 後面的「-」 即為前面的 「-」, 資料夾下不會有東西, 這也是實作 「cp -r」 的一種方式...
```
