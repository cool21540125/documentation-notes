# Ch6  - Controlling Access to Files with Access Control Lists (ACLs)

1. ACL 概念說明
2. ACL 範例
3. ACL 相關指令


## 1. ACL概念說明

### Prerequest

- 要先懂 Linux DAC Permission(rwx啦)
- 最好也懂 SGID, SUID


### ACL 公用

可以針對 `特定檔案` or `特定資料夾` 設定更進階的存取權限, 這一系列的權限, 稱之為 ACL(存取控制清單)

ex: 把某個檔案, 開放 rw 給 sales 群組, 但偏偏 sales 群組內有幾個笨蛋可能把東西改爛, 所以又對 sales 的部份人, 僅給予 readonly 的權限


## 2. ACL 範例

為了下面方便說故事, 先建立使用者

```sh
### root
### 確保電腦上「沒有 8787, 8889, 9898 群組」&&「沒有 12771, 12772, 12773, 12774 使用者」&&「沒有 /home/shares」
grep '8787\|8889\|9898' /etc/group
grep '12771\|12772\|12773\|12774' /etc/passwd
ls /home/shares

### 新增使用者
groupadd -g 8787 swrd
groupadd -g 8889 sales
groupadd -g 9898 hr
useradd howard -u 12771 -G swrd  ; echo 'asdf' | passwd --stdin howard
useradd james  -u 12772 -G swrd  ; echo 'asdf' | passwd --stdin james
useradd lala   -u 12773 -G sales ; echo 'asdf' | passwd --stdin lala
useradd neko   -u 12774 -G hr    ; echo 'asdf' | passwd --stdin neko
mkdir /home/shares
```

設定 ACL `/home/shares`
- swrd群組 可 read, write, execute file, access dir
- sales群組 可 read, access dir
- swrd群組 的 james 是個笨蛋, 所以只准他 read 及 execute file(不具備write)
- 其它非相關人等, 無權作任何動作

```sh
$# ll -d /home/shares
drwxr-xr-x. 2 root root 6 Oct 28 01:34 /home/shares
#   ↑↑↑   ↑  注意這幾個地方, 等下與下面作比較

### 設定 ACLs   -R: recursively
$# setfacl -R -m g:swrd:rwx,g:sales:r-X,u:james:r-x,o::- /home/shares/
#           ↑
#         這東西在此範例沒用處, 因為這資料夾現在是空的

$# ll -d /home/shares
drwxrwx---+ 2 root root 6 Oct 28 01:34 /home/shares
#   ↑↑↑   ↑
# 設定 ACL 之後, group 的 rwx 位置的權限再也不是 group, 而是 mask
# 日後 chmod 改 group 欄位的話, 改的不再是 group, 而是 mask
# mask是啥? 
# mask是「file owner」及「other」以外的其它在 ACL 裏頭的人們的最大可能權限
# 也就是「named user」、「named group」、「group-owner」的最大可能權限

### 查詢 ACLs
$# getfacl /home/shares
getfacl: Removing leading '/' from absolute path names
# file: home/shares
# owner: root           # 擁有此檔案的使用者
# group: root           # 擁有此檔案的群組
user::rwx               # User: file owner
user:james:r-x          # User: james
group::r-x              # Group owner
group:swrd:rwx          # Group: swrd
group:sales:r-x         # Group: sales(為啥上面設 X, 現在變成 x...)
mask::rwx               # 以下3者的最高權限: named user, group owner, named groups (也就是, 不包含 file owner 及 other)
other::---              # 非上述的其它人

### 設定 Default ACL
$# setfacl -d -m g:swrd:rwx,g:sales:r-X,u:james:r-x,o::--- /home/shares/

$# getfacl /home/shares
getfacl: Removing leading '/' from absolute path names
# file: home/shares
# owner: root
# group: root
user::rwx
user:james:r-x
group::r-x
group:swrd:rwx
group:sales:r-x
mask::rwx
other::---
default:user::rwx           # 
default:user:james:r-x      # 
default:group::r-x          # 
default:group:swrd:rwx      # 
default:group:sales:r-x     # 
default:mask::rwx           # 
default:other::---          # 

### 刪除所有 ACL 的設定
$# setfacl -b /home/shares
$# ll -d /home/shares
drwxr-x---. 2 root root 6 Oct 28 01:34 /home/shares
#         ↑ ACL沒了!!
```


故事結束~ 清除

```sh
userdel -r howard
userdel -r james
userdel -r lala
userdel -r neko
groupdel swrd
groupdel sales
groupdel hr
rm -rf /home/shares
```


## 3. ACL 相關指令

- `setfacl -m u:name:rwx dir`   : 指定 ACL(修改已有, 新增未有)
- `setfacl -M u:name:rwx xxx`   : 指定 ACL(完整取代原本的ACL)
- `setfacl -x u:name xxx`       : 個別刪除特定 ACL
- `setfacl -dm u:name xxx`      : 個別刪除 Default ACL
- `setfacl -k xxx`              : 刪除所有 Default ACL
- `setfacl -b xxx`              : 刪除所有 ACL
