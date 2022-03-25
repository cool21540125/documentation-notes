# Ch5 - User and Group

1. 基本概念
2. 使用者
3. 群組
4. 大量建立及刪除的標準作法


## 1. 基本概念

Linux 的任何 process, 都有一個 User 在執行它

```sh
/etc/passwd         # 1 User 資料
/etc/shadow         # 2 User 密碼相關
/etc/group          # 3 Group 資料
/etc/gshadow        # 4 Group 密碼相關
/etc/sudoers        # 5 超級使用者相關設定(使用 visudo 間接修改)
/var/log/secure     # 所有 sudo 執行的資訊 
```

```sh
### /etc/passwd
#    1    :  2   : 3 : 4 :  5 : 6  :  7
# UserName:空密碼:UID:GID:說明:HOME:shell


### /etc/shadow
#    1    :    2   :            3           :         4        :         5          :       6      :         7        :        8     :     9
# UserName:密碼相關:上次變更密碼到今天的天數:至少幾天得更換密碼:密碼到期前幾天會提示:密碼幾天後到期:密碼到期後的寬限期:帳戶到期的時間:(將來擴展用)


### /etc/group
#    1    :    2   : 3 :          4
# GroupName:空密碼:GID:此群組底下有哪些UID


### /etc/gshadow
#    1     :2:3:4:5:6:7:8:9
# GroupName:(同/etc/shadow)

### /etc/sudoers
# 檔案內其中一行
# root    ALL=(ALL)   ALL       # root,           可執行任何指令在任何地方
#
# %wheel  ALL=(ALL)   ALL       # wheel群組內的人, 可執行任何指令在任何地方
```


## 2. 使用者

```sh
### 建立 使用者 &&  設定密碼
useradd andyy; echo 'password' | passwd --stdin andyy   # UID=1001
useradd maryy; echo 'password' | passwd --stdin maryy   # UID=1002
ll /home
# vim 看 /etc/passwd

### Andyy 做了某些操作
sudo -i -u andyy
echo '超級機密的東西' > secret.txt
exit

### Andyy 離職了~~  不安全的殺人方式
userdel andyy
ll /home
# vim 看 /etc/passwd

### 當新人再次加入... 因為 /etc/passwd 已無 1001
useradd -u 1001 angell; echo 'password' | passwd --stdin angell # 指定 angell UID=1001
ll /home
# vim 看 /etc/passwd
# 潮爽der 撿到一個 Andyy

### ((還沒新增 angell 前))的補救方式...
find /home -user 1001               # 找出無主檔案
rm -rf /home/andyy                  # 慢慢砍

### ((事後發現))的補救方式
chown 9999 andyy

### 安全的移除方式
userdel -r angell
userdel -r maryy

### 結論 : 殺人 就要殺他全家
```


## 3. 群組

```sh
# This is an user
useradd tony2

# This is a group
groupadd -g 7000 powerful

# powerful user tony2
usermod -aG powerful tony2

# 退出群組
gpasswd -d tony2 powerful

# User 摘要
$ id
uid=1000(tony) gid=1000(tony) groups=1000(tony),10(wheel),375(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

# 主要群組 && 附屬群組
$ groups
tony wheel docker
```


## 4. 大量建立及刪除的標準作法

```sh
# 建立使用者
for UU in tony2 jason james howard sunny
do
    useradd ${UU}; echo 'iam87' | passwd --stdin ${UU}
done

# 刪除使用者
for UU in jason james howard sunny
do
    userdel -r ${UU}
done
```
