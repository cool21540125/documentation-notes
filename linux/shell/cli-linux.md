
# find

- [Unix/Linux 的 find 指令使用教學、技巧與範例整理](https://blog.gtwang.org/linux/unix-linux-find-command-examples/)
- 會去搜尋 Disk, 速度較慢
    - 視情況使用 whereis, locate

param   | description 
------- | ------------------ 
d       | 目錄 
p       | 具名的pipe(FIFO) 
f       | 一般檔案 
l       | 連結檔 
s       | socket檔案 


```bash
### find [PATH] [option] [action]
# 時間選項 : -atime, -ctime, -mtime
# 使用者/群組參數
# 檔案權限相關參數
# 額外可進行的動作

### 依 檔名 查找
# 找 path 底下的 檔名
find [path] -name <要查的檔案名稱> #(可用 * , 但要「'*'」起來)

# 同上, 但忽略大小寫
find . -iname xx.txt

### 依 時間 查找
# -mtime n : 表示 「在 n 天前」的「一天之內」被更動過內容的檔案
find / -mtime 0
# (會開始搜尋~~~ 有點久, 然後印出一大堆不知道幹嘛的)

# 尋找 /etc 底下, 檔案日期 比 /etc/passwd 還新的
find /etc -newer /etc/passwd

# 找出 4天之內被更動過的檔案名稱
find /var -mtime -4

# 找出 4天之前的 1天內被更動過的檔案名稱
find /var -mtime 4

# 找出 大於 5天之前被更動過的檔案名稱
find /var +mtime 4

### 依 使用者/群組 查找
# 尋找 /home 下, 屬於 tony 的檔案
find /home -user tony

# 尋找 不屬於任何使用者的檔案
sudo ls -l /etc | grep ssmtp
drwxr-s---.  2 root mail       42  4月 11 18:13 ssmtp   # ex: 自行編譯原始碼軟體時, 就會經常看到

# 只列出 (current user) 唯讀檔案
find . -perm /u=r

# 列出可執行的檔案
find . -perm /a=x

### 依 權限 查找
# 找出 /run 底下, 類型為 Socket的檔案
find /run -type s

find -perm -324
# 有「-」, 表示權限至少為 324 (至少 011010100)

find -perm 324
# 條件為 324

find -perm /324
# 條件為 「u=011 或 g=010 或 o=100」

# 目前目錄下, 權限 != 777 的檔案
find . -type f ! -perm 777

### 額外附加選項的 find (有點偏, 懶得寫了)
find / size +1M
# 找出 > 1MB 檔案

### find file by name 依照名稱找檔案
find . -name themes -type f | xargs ls -l

### 把找到的東西壓縮 tar gzip
find /apps/tomcat/logs -name "*.log" -mtime +1 -exec gzip {} \;
# or
find /apps/tomcat/logs -name "*.log" -mtime +1 | xargs gzip


### 
```


# whereis

> 只會去尋找`特定目錄`, 主要針對 `/bin`, `/sbin`, `/usr/share/man` 等資料夾作搜尋而已, 可用 `whereis -l` 來看究竟找了那些資料夾

```bash
### Usage
# whereis [-bmsu] <file or dir>

whereis ifconfig
#ifconfig: /usr/sbin/ifconfig /usr/share/man/man8/ifconfig.8.gz


### 
```


# locate

通常會與 `updatedb` 一起使用

locate 依據 「已建立的資料庫 /var/lib/mlocate/」, 找出要查的關鍵字 ; `updatedb`(此指令下下去, 可能要等一下子) 根據 `/etc/updatedb.conf` 設定去搜尋磁碟內的檔名, 並更新 `/var/lib/mlocate` 內的資料庫檔案

```bash
### Usage
# locate [-ir] keywork
# -i : 忽略大小寫
# -r : 可用 regex 查找

locate -l 5 passwd    # 「-l 5」找出所有與 passwd 相關的檔名, 僅輸出 5 個
#/etc/passwd
#/etc/passwd-
#/etc/pam.d/passwd
#/etc/security/opasswd
#/opt/anaconda3/pkgs/openssl-1.0.2l-h077ae2c_5/ssl/man/man1/passwd.1


### 
```


# curl

- [curl command](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)

```bash
### 基本語法
curl -X<Verb> '<Protocol>://<Host>:<Port>/<Path>?<Query_String>' -d '<Body>'
# -H : 預設的 Content-Type: application/x-www-form-urlencoded
# -d : Request Body (Key1=Value1&Key2=Value2)
# -L : 若 URL 經由 3XX 作重導, 則自動導向該頁面
# -X <VERB> : Request Method (GET, POST, PUT, HEAD, DELETE, ...)
# -O : 把爬下來的東西寫入到檔案系統
# -I : 僅擷取 HTTP-head
# -i : 包含 HTTP-header
# -k : 允許不安全的 https(未經過)
# -s : (silent) 不顯示進度及錯誤訊息
# -4 : 使用 IPv4 位址作解析
# -6 : 使用 IPv6 位址作解析
# -v : 列出詳細資訊(Debug使用居多)


### 藉由 Unix Socket(而非 TCP Socket) 的方式做連線
curl --unix-socket /path-to-docker/docker.sock http://localhost/version


### 若域名有做 load balance, 此方式可強制訪問特定一台
$# DOMAIN=tonychoucc.com
$# IP=1.2.3.4
$# curl -sv --resolve www.${DOMAIN}:${IP} https://www.${DOMAIN}/checked


### 
```