# Ch6. Controlling Access to Files with Linux File System Permissions

1. 基本概念
2. 相關指令
3. 共用目錄
4. 特殊權限


## 1. 基本概念

Permission | file      | Dir
---------- | --------- | -----------------
r          | 可看      | 可看有那些東西
w          | 可改      | 可建立/刪除檔案
x          | 可執行    | 可進入


```sh
$ ll /home
drwx------. 31 tony tony 4096  9月 21 10:27 tony
↑↑↑↑↑↑↑↑↑↑↑
12345678901
 ~~~~ 放大 ~~~~
d rwx --- --- .
|  |   |   |  +- ACL選項(比較進階的東西)
|  |   |   |
|  |   |   +---- other
|  |   | 
|  |   +-------- group        
|  | 
|  +------------ user
|
+--------------- d:資料夾 ; -:檔案 ; l:軟連結(捷徑)
```


## 2. 相關指令

### 2-1. chmod - 改變檔案 Permission

```sh
## 用法1
$ chmod u+x file1
        ↑↑↑
        ABC

# A: Who
# 可用選項: u,g,o,a
# 分別代表: User,Group,Other,All

# B: What
# 可用選項: +,-,=
# 分別代表: 附加,減少,設定

# C: Which
# 可用選項: r,w,x,X
# 分別代表: 讀,改,執行,對dir套用x但對file不套用x


## 用法2
$ chmod ### file1
        ↑↑↑
		範圍一定是0~7, ex: 700, 644


## 其他備註
$ chmod -R xxx /tmp/dir1
# -R : recursive (對資料夾內的資料夾內的資料夾...內的檔案, 一起套用)
```


### 2-2. chown - 改變檔案擁有者

```sh
## 用法1: chown owner 標的物
## 用法2: chown owner:group 標的物

$# touch /tmp/a
$# chown tony /tmp/a
$# ll /tmp/a
-rw-r--r--. 1 tony root 0  9月 21 10:54 /tmp/a

$# mkdir -p /tmp/dir1/dir2/
$# touch /tmp/dir1/ff1
$# touch /tmp/dir1/dir2/ff2
$# chown -R tony /tmp/dir1
$# ll /tmp/dir1
drwxr-xr-x. 2 tony root 17  9月 21 10:57 dir2
-rw-r--r--. 1 tony root  0  9月 21 10:57 ff1
```


### 2-3. chgrp - 改變檔案擁有群組

```sh
$# chgrp tony /tmp/dir1
$# ll -d /tmp/dir1
drwxr-xr-x. 3 tony tony 29  9月 21 10:57 /tmp/dir1

$# ll /tmp/dir1
drwxr-xr-x. 2 tony root 17  9月 21 10:57 dir2
-rw-r--r--. 1 tony root  0  9月 21 10:57 ff1
```


## 3. 共用目錄(非協作目錄)

```sh
###  使用 su 執行 ###

# 建立共用目錄
mkdir /home/shares

grep 8787 /etc/group		# 先確認是否有此 GID
groupadd -g 8787 cowork		# 若無 8787 在使用 8787 建立群組

# 改變目錄的擁有群組
chgrp cowork /home/shares
ll -d /home/shares			# drwxr-xr-x. 2 root cowork 6  9月 21 11:06 /home/shares

chmod 770 /home/shares/
ll -d /home/shares			# drwxrwx---. 2 root cowork 6  9月 21 11:06 /home/shares
usermod -aG cowork tony


### 使用 tony 執行 ###
newgrp cowork				# 刷新 session
cd /home/shares
touch a
ll							# -rw-r--r--. 1 tony cowork 0  9月 21 11:23 a
```


## 4. 特殊權限

### 4-1. setuid, setgid, sticky bit

```sh
$ ll /usr/bin/passwd
-rwsr-xr-x. 1 root root 27832  6月 10  2014 /usr/bin/passwd
   ^
   What The Fuck!?
```

出現非「rwxX」的東西, 例如: s, t, T... 就比表示此檔案具有特殊權限

Special Permission | file                         | dir
------------------ | ---------------------------- | ------------------
u+s (suid)         | 以檔案 擁有者 的地位來執行     | 無作用
g+s (sgid)         | 以檔案 擁有群組 的地位來執行   | 在此dir內建立的檔案, 檔案擁有群組 會預設為此 dir的擁有群組
o+t (sticky)       | 無作用                       | 具備wx時, 只能刪除自己擁有的檔案


```sh
$ which passwd
/usr/bin/passwd

$ ll /usr/bin/passwd
-rwsr-xr-x. 1 root root 27832  6月 10  2014 /usr/bin/passwd
   ^
   這個
```
