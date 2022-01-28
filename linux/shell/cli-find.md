# 搜尋 - find

- [Unix/Linux 的 find 指令使用教學、技巧與範例整理](https://blog.gtwang.org/linux/unix-linux-find-command-examples/)


搜尋相關指令:

- whereis : 只找 特定目錄 下的檔案(快)
- locate : 利用 資料庫 來搜尋檔名(快)
- find : 很操硬碟(慢)


find 指令

param   | description 
------- | ------------------ 
d       | 目錄 
p       | 具名的pipe(FIFO) 
f       | 一般檔案 
l       | 連結檔 
s       | socket檔案 

```sh
$# find [PATH] [option] [action]
# 時間選項 : -atime, -ctime, -mtime
# 使用者/群組參數
# 檔案權限相關參數
# 額外可進行的動作

### 依 檔名 查找
# 找 path 底下的 檔名
$# find [path] -name <要查的檔案名稱> #(可用 * , 但要「'*'」起來)

# 同上, 但忽略大小寫
$# find . -iname xx.txt

### 依 時間 查找
# -mtime n : 表示 「在 n 天前」的「一天之內」被更動過內容的檔案
$# find / -mtime 0
# (會開始搜尋~~~ 有點久, 然後印出一大堆不知道幹嘛的)

# 尋找 /etc 底下, 檔案日期 比 /etc/passwd 還新的
$# find /etc -newer /etc/passwd

# 找出 4天之內被更動過的檔案名稱
$# find /var -mtime -4

# 找出 4天之前的 1天內被更動過的檔案名稱
$# find /var -mtime 4

# 找出 大於 5天之前被更動過的檔案名稱
$# find /var +mtime 4

### 依 使用者/群組 查找
# 尋找 /home 下, 屬於 tony 的檔案
$# find /home -user tony

# 尋找 不屬於任何使用者的檔案
$# sudo ls -l /etc | grep ssmtp
drwxr-s---.  2 root mail       42  4月 11 18:13 ssmtp   # ex: 自行編譯原始碼軟體時, 就會經常看到

# 只列出 (current user) 唯讀檔案
$# find . -perm /u=r

# 列出可執行的檔案
$# find . -perm /a=x

### 依 權限 查找
# 找出 /run 底下, 類型為 Socket的檔案
$# find /run -type s

$# find -perm -324
# 有「-」, 表示權限至少為 324 (至少 011010100)

$# find -perm 324
# 條件為 324

$# find -perm /324
# 條件為 「u=011 或 g=010 或 o=100」

# 目前目錄下, 權限 != 777 的檔案
$# find . -type f ! -perm 777

### 額外附加選項的 find (有點偏, 懶得寫了)
$# find / size +1M
# 找出 > 1MB 檔案

### find file by name 依照名稱找檔案
$# find . -name themes -type f | xargs ls -l

### 把找到的東西壓縮
$# find /apps/tomcat/logs -name "*.log" -mtime +1 -exec gzip {} \;
# or
$# find /apps/tomcat/logs -name "*.log" -mtime +1 | xargs gzip
```