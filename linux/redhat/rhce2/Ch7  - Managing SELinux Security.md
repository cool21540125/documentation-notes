# Ch7  - Managing SELinux Security

1. 概念
2. SELinux mode
3. package
4. SELinux Boolean
5. SELinux Contexts
6. SELinux Log


## 1. 概念
SELinux : Security Enhanced Linux

- 以 `政策規則` 訂定 `特定程序` 可存取 `特定檔案`, 此稱為 `委任式存取控制(Mandatory Access Control, MAC)` 取代僅有 rwx 的 `自主式存取控制(Discretionary Access Control, DAC)`
    - DAC : 警察可以槍殺壞人
    - MAC : 值勤中的警察可以槍殺壞人


### SELinux 參考流程圖
1. `/rhce2/attach/SystemSecurity.xml` (Tony純手工打造@@)
2. `/rhce2/attach/SELinuxFlow.xml` (參考鳥哥)


### SELinux 政策等級, 可分成 3 種:
1. targeted(預設) : 針對網路服務有較多的限制
2. minimum : 只有特定程序來作限制, 最寬鬆
3. mls : 最嚴謹

```sh
$ ls -lZ /bin
lrwxrwxrwx. root root system_u:object_r:bin_t:s0       bin -> usr/bin
#                     ________ ________ _____ __
#                         A        B      C   D 
# 以上的 A, B, C, D 稱之為 security context(安全性本文, 安全脈絡標籤, ...)
# 分別為 「Identify:role:type:??」 ((??我忘了它是啥了...))
# 如果用的政策等級為 targeted, 則別理會 A, B, D (有點進階)
# C : 稱之為 「type context」, 只要理它就好, 通常它都是「_t」結尾
```


## 2. SELinux mode

啟用後, 分為 2 種模式: 

1. enforcing mode : 施行 SELinux 防禦政策 && 作log
2. permissive mode : 僅作 log

```sh
$# getenforce
Enforcing

$# setenforce 0
Permissive

$# setenforce 1
$# getenforce
Enforcing
```

* 設定檔位於 : `/etc/selinux/config` (不建議修改)


## 3. package

```sh
# 有一些一開始已經安裝了, 但我忘了哪個了...
$# yum install selinux-policy-devel policycoreutil policycoreutil-python
# policycoreutil        有好用的指令工具: restorecon
# policycoreutil-python 有好用的指令工具: semanage
```

## 4. SELinux Boolean

### 4.1- 生活化的想法

把 SELinux Boolean 想像成, 你有一堆家規清單, 裡面列出了類似下面的資訊:

```
吃飯前喝飲料            no,  no
看人不爽可以打他        no,  yes
肚子餓了可以哭腰        yes, yes
                       ↑     ↑
                     現在   最近一次起床之後
```


### 4.2- CentOS7 系統上的 SEBoolean

```sh
# 列出所有 客製化的 SELinux Booleans
$# semanage boolean -l -C
# (沒東西)

# 列出所有 SELinux Booleans(取前5個) 法一
$# getsebool -a | head -n 5
abrt_anon_write --> off
abrt_handle_event --> off
abrt_upload_watch_anon_write --> on
antivirus_can_scan_system --> off
antivirus_use_jit --> off

# 列出所有 SELinux Booleans(取前5個) 法二
$# semanage boolean -l | head -n 5
SELinux boolean         State  Default Description

ftp_home_dir            (off  ,  off)  Allow ftp to home dir
smartmon_3ware          (off  ,  off)  Allow smartmon to 3ware
mpd_enable_homedirs     (off  ,  off)  Allow mpd to enable homedirs
#                        now    permanent

# 查看特定 SELinux Boolean 法一
$# getsebool abrt_anon_write
abrt_anon_write --> off

# 查看特定 SELinux Boolean 法二
$# semanage boolean -l | grep abrt_anon_write
abrt_anon_write                (on   ,  off)  Allow abrt to anon write

# 新增自訂的 SELinux Boolean (current)
$# setsebool abrt_anon_write on
abrt_anon_write --> on

# 新增自訂的 SELinux Boolean (permanent)
$# setsebool -P abrt_anon_write on

# 再次查看
$# semanage boolean -l | grep abrt_anon_write
abrt_anon_write                (on   ,  on)  Allow abrt to anon write

# 回歸初始設定
$# semanage boolean -l -D
# 會把「所有」自訂的 SEBoolean 全部刪除
```


### 4-3. 查詢

```sh
$ man semanage-boolean
```


## 5. SELinux Contexts

- 預設每個檔案(資料夾)都有它預設的 SELinux Context

### 5-1. 查看 SELinux Context

```sh
$# ls -Zd /var/www/html
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html
#                     _______u:_______r:__________________t:__

$# echo 'Hello' > /var/www/html/test.html

$# ls -Z /var/www/html
-rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 test.html
#                     ___________u:_______r:__________________t:__

$# rm -f /var/www/html/test.html
```


### 5-2. 改變 SELinux Context

#### 5-2-1. example: chcon

- `chcon` : 不建議使用
- `restorecon` : 重新貼標的概念 (`yum install policycoreutil`)
- `semanage` : ... (`yum install policycoreutil-python`)

```sh
### 不建議使用 chcon 的說明範例
$# mkdir /hellogg

$# ll -Zd /hellogg/
drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /hellogg/
#                     ___________u:_______r:________t:__


### 使用 chcon 修改 安全脈絡標籤 的 type context
$# chcon -t httpd_sys_content_t /hellogg/
$# ll -Zd /hellogg/
drwxr-xr-x. root root unconfined_u:object_r:httpd_sys_content_t:s0 /hellogg/
#                     ___________u:_______r:__________________t:__


### 實務上, 可能會因為各種原因, 或是因為某些逼不得已的狀況, 重新對系統 selinx-relabel, 所以不要用這個
$# restorecon -RFv /hellogg/
restorecon reset /hellogg context unconfined_u:object_r:httpd_sys_content_t:s0->system_u:object_r:default_t:s0
#                                 ___________u:_______r:__________________t:__  _______u:_______r:________t:__
# -R : recursive
# -F : 連同 user, role, range
# -v : 列出改變前後


$# ll -Zd /hellogg/
drwxr-xr-x. root root system_u:object_r:default_t:s0   /hellogg/
#                     _______u:_______r:________t:__
# 看吧!! 之前貼好的 'httpd_sys_content_t' 又變回原本的 'default_t' 了


$# rmdir /hellogg
```


#### 5-2-2. example: relabel

- 若使用 `vim`, `cp`, `touch` 等指令產生的檔案, SELinux Context 會繼承自 parent dir
- 若使用 `mv`, `cp -a` 等指令產生的檔案, SELinux Context 會維持不變

```sh
$# touch /tmp/file1 /tmp/file2
$# ls -Z /tmp/file{1,2}
-rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /tmp/file1
-rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /tmp/file2
#                     ___________u:_______r:_________t:__

$# mv /tmp/file1 /var/www/html
$# cp /tmp/file2 /var/www/html
$# ls -Z /var/www/html/file{1,2}
-rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /var/www/html/file1
-rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2
#                     ___________u:_______r:__________________t:__

# 以正規表達式, 找出「相關資料夾 && 相關關鍵字」的 SELinux Context
$# semanage fcontext -l | grep '/var/www.*:httpd'
/var/www(/.*)?                  all files    system_u:object_r:httpd_sys_content_t:s0       # SELinux 允許 httpd 的靜態頁面存放處, 應該要有的 SELinux Context
/var/www(/.*)?/logs(/.*)?       all files    system_u:object_r:httpd_log_t:s0
/var/www/[^/]*/cgi-bin(/.*)?    all files    system_u:object_r:httpd_sys_script_exec_t:s0
/var/www/svn(/.*)?              all files    system_u:object_r:httpd_sys_rw_content_t:s0
# 僅節錄前幾個...

# 
$# restorecon -RFv /var/www
restorecon reset /var/www/html/file1 context unconfined_u:object_r:user_tmp_t:s0->system_u:object_r:httpd_sys_content_t:s0
restorecon reset /var/www/html/file2 context unconfined_u:object_r:httpd_sys_content_t:s0->system_u:object_r:httpd_sys_content_t:s0

$# ls -Z /var/www/html/file{1,2}
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/file1
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2
#                     _______u:_______r:__________________t:__

$# rm /tmp/file2 /var/www/html/file{1,2}
```


#### 5-2-3. example: httpd 的靜態頁面資料夾想般家...

httpd 想把網頁由「/var/html/www/」→「/virtualPage/」

```sh
$# mkdir /virtualPage
$# touch /virtualPage/index.html
$# ls -Zd /virtualPage
drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /virtualPage
#                     ___________u:_______r:________t:__

$# ls -Z /virtualPage
-rw-r--r--. root root unconfined_u:object_r:default_t:s0 index.html
#                     ___________u:_______r:________t:__

# 查看
$# semanage fcontext -l | grep '/virtualPage'
# 沒東西

$# semanage fcontext -a -t httpd_sys_content_t '/virtualPage(/.*)?'

$# restorecon -RFv /virtualPage
restorecon reset /virtualPage context unconfined_u:object_r:default_t:s0->system_u:object_r:httpd_sys_content_t:s0
restorecon reset /virtualPage/index.html context unconfined_u:object_r:default_t:s0->system_u:object_r:httpd_sys_content_t:s0

$# rm -rf /virtualPage
```


## 6 - SELinux Log

* `/var/log/audit/audit.log` : SELinxu 原生 Log(很不好懂)
* `/var/log/messages` : 到這邊找 `sealert -l xxxxxxxxxxxxxx` 的關鍵字, 查看 SELinux 人性化報告
* 關鍵字: `setroubleshoot`, `sealert`

```sh
echo '<h1>你看得到我嗎? 恭喜!!</h1>' > /root/ohno.html
mv /root/ohno.html /var/www/html

curl http://localhost/ohno.html
# 403

setenforce 0
curl http://localhost/ohno.html
# 87% 的信心~ 應該是 SELinux

setenforce 1
curl http://localhost/ohno.html
# 100% 沒錯!! 就是 SELinux

# SELinux 人性化報告 有可能會有錯!!!!
cat -n /var/log/messages | grep 'sealert -l'

# 報告裡頭會有建議的解法  「/sbin/restorecon -v /var/www/html/ohno.html」

curl http://localhost/ohno.html

rm -f /var/www/html/ohno.html
```
