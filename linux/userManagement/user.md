# 帳戶管理 與 ACL權限

```
/etc/passwd         # 使用者帳號 與 UID, GID 之對映
/etc/shadow         # 使用者帳號 的 密碼 && 該密碼的相關屬性
/etc/group          # 使用者群組 分別有哪些 使用者帳號 加入
/etc/gshadow        # 使用者群組 的 群組管理員及其密碼 (幾乎被 sudo 取代了)
```


## 目錄:

- [ACL](#ACL)
- [使用者及群組](#使用者及群組)
- [協作目錄](#協作目錄)
- [ACLs](#ACLs)





# ACL

- [ACL](http://linux.vbird.org/linux_basic/0220filemanager.php#suid)

1. SUID (權限 4)    `只能用於 檔案`
    - 非擁有者可執行此二進位檔案(runtime 期間, 擁有 owner權限)
2. SGID (權限 2)    `可用於 檔案 or 目錄`
    - 執行者所具備的 `secondary group` 只要符合該 檔案 or 目錄 的擁有者群組, 即 **暫時具備** 檔案擁有者的權限
3. SBIT (權限 1)    `只能用於 目錄`
    - (我不會... 遇到再說)

```sh
ls -ld /tmp; ls -l /usr/bin/passwd
drwxrwxrwt. 20 root root 4096  6月  9 20:59 /tmp                # 有 t 出現在 rwx 裏頭
-rwsr-xr-x. 1 root root 27832  6月 10  2014 /usr/bin/passwd     # 有 s 出現在 rwx 裏頭

### 其他範例
$ touch test

$ chmod 4755 test; ll test
-rwsr-xr-x. 1 tony tony 0  6月  9 22:01 test

$ chmod 6755 test; ll test
-rwsr-sr-x. 1 tony tony 0  6月  9 22:01 test

$ chmod 1755 test; ll test
-rwxr-xr-t. 1 tony tony 0  6月  9 22:01 test

$ chmod 7666 test; ll test
-rwSrwSrwT. 1 tony tony 0  6月  9 22:01 test    # test為紅底, 且具有空的 SUID/SGID權限 (大寫)

$ $ chmod u=rwxs,go=x test; ls -l test # 「,」前後不能加空白
-rws--x--x. 1 tony tony 0  6月  9 22:01 test

$ chmod g+s,o+t test; ls -l test
-rws--s--t. 1 tony tony 0  6月  9 22:01 test
```

# 使用者及群組

- `useradd` : 靜態腳本常用
- `adduser` : 互動式新增使用者
- `usermod` : 修改 User
- `groupadd` : 建議明確指定 `-g "group id"` [附註1](#附註1)
- `userdel` : 建議明確指定 `-r "user id"` [附註2](#附註2)
- `groupdel` : 刪除群組
- `chown` : 改變檔案 User Owner
- `chgrp` : 改變檔案 Group Owner


## 備註

```sh
### 把 使用者 -> 使用者群組
$# useradd -G <使用者群組> <新使用者帳戶>
# -g xxx : 初始群組 為 xxx
# -G xxx : 次要群組 為 xxx
# -u xxx : 手動分配 UID xxx 給該使用者
# -e xxx : 指定帳號失效日 xxx
# -f xxx : 密碼到期期限 為 xxx (重設密碼), 0:立即失效 ; -1:永遠不會失效
# -M : 告訴系統, 建立使用者就好了, 不用幫他建立 家目錄
# -r : 讓這個變成系統帳號

### 使用 inter-activate 的互動方式, 新增使用者
$# adduser tony
# 然後就開始輸入密碼那堆東西~

### 修改帳戶
$# usermod -[agGLU] <使用者帳戶>
# -a : 通常用 -aG, 來讓已經存在的使用者, 新增附屬群組
# -g : 設定 primary group
# -G : 設定 supplementary groups
# -L : 鎖帳戶
# -U : 解鎖帳戶

### 建立使用者群組 (-g 指定 附屬群組 gid)
$# grep 5000 /etc/group
$# groupadd -g 5000 controller

### 改變擁有者
$ sudo chown -R <owner>:<group> <dirName>   # 改變 dir 內所有檔案的 owner
$ sudo chown <owner>:<group> <fileName>     # 改變 file 的 owner

# 改變擁有群組
$ chgrp <Group Name> <dir name>
# 也可以寫成 chown :<Group Name> <dir name> (但不建議)

$# usermod -aG <使用者群組> <已經存在的使用者帳戶>

# 設定 使用者 密碼
$# echo "<密碼>" | passwd --stdin <使用者帳戶>

# 查看 使用者 已經加入到那些 使用者群組
$# groups <使用者帳戶>
```



# 協作目錄

- [SUID/SGID/SBIT 權限](http://linux.vbird.org/linux_basic/0220filemanager.php#suid)

```sh
# 建立要共享的資料夾 (共享資料夾)
$# mkdir /home/shared

# 改變這個資料夾的使用者群組
$# chgrp <使用者群組> /home/shared

# 設定目錄具有 SGID的權限
$# chmod 2770 /home/shared

$# ll -d /home/shared
drwxrws---. 2 root shared 15  7月 14 15:41 /home/shared/
```



# ACLs

- `setfacl` : 設定 ACLs
- `getfacl` : 查看 ACLs



## 備註

- Mask settings : 設定 `Named user`, `Group owner`, `Named group` 的檔案最大權限. 但不影響 `User owner`, `Other`

```sh

```

## chmod 注意事項

```sh
# 遞迴修改 dir 內所有權限
$# chmod -R g+rwX <dir Name>
# 裏頭的 「X」
# 確保 x 權限只套用到 dir (資料夾都進得去)
# 而不套用到 file (檔案不應該預設可執行)
```


## 使用 Shell Script 增加使用者

```sh
# 快速新增使用者 && 設定同名密碼
$# uu=smartTony
$# useradd ${uu} ; echo ${uu} | passwd --stdin ${uu}
# 新增使用者, 名為 $uu
# 將 $uu 丟給 passwd(需要 sudo 權限) 的標準輸入, 藉此來設定密碼
```



# User ID && 使用者帳號 && `/etc/passwd`

Linux 不會認識帳號, 而是透過 `/etc/passwd` 找到 `帳號` 對映的 `UID`

```sh
$ cat /etc/passwd | grep tony
tony:x:1000:1000:tony:/home/tony:/bin/bash
# 上面有 7 個欄位 (由 6 個「:」分隔), 分別為
# 1 tony         -> 使用者帳號名稱
# 2 x            -> 密碼(加密存於 /etc/shadow) (Linux 早期把密碼放這)
# 3 1000         -> 使用者帳號 對映的 UID
# 4 1000         -> 使用者帳號 對映的 GID
# 5 tony         -> 使用者 資訊欄位說明 (可以亂改沒差XD)
# 6 /home/tony   -> 登入後, 進入的 家目錄
# 7 /bin/bash    -> 登入後, 取得的 shell 位置

# 可以更改上述第五個欄位(沒啥用XD)
$ usermod -c SmartTony tony
$ $ cat /etc/passwd | grep tony
tony:x:1000:1000:SmartTony:/home/tony:/bin/bash


# 假如沒事亂改上面的第三欄的 1000 為 2000
$ ll -d /home/tony
drwx--x---+ 33 tony tony 4096  7月 16 22:47 /home/tony      # 亂改前
drwx--x---+ 33 1000 tony 4096  7月 19 22:17 /home/tony      # 把 /etc/passwd 的 tony 第三欄改為 2000 之後
#                ↑ 應該是 superblock 還什麼鬼的依然指向 第三欄的 UID 1000 吧!!  會導致之後的 tony 近不了 /home/tony

$ id tony
uid=1000(tony) gid=1000(tony) groups=1000(tony),10(wheel),983(docker),1002(shared)  # 亂改前
uid=2000(tony) gid=1000(tony) groups=1000(tony),10(wheel),983(docker),1002(shared)  # 把 /etc/passwd 的 tony 第三欄改為 2000 之後

# 後記
# 某天改成 2000後, 忘了改回來, 發現網路連不上了, 也沒辦法關機@@!  重開機之後, 發現 tony 無法登入...
# 使用其他帳戶登入, 去把 /etc/passwd 的 tony 的 UID改回 1000 後, 就正常了~
```


## UID range:

- 0 : 系統管理員 (一般使用者把這改為 0, 利碼晉級 Linux 之神)
- 1~999 : 系統帳號 (通常是安裝軟體後產生的)
    - 1~200 : 由 Linux Distribution 自行產生
    - 200~999 : 一般使用者 晉級 系統帳號 && 安裝軟體 的範圍 (我到底在寫什麼...)
- 1000~非常大的數字 : 一般使用者



# Group ID && 使用者群組 && `/etc/group`

```sh
$ cat /etc/group | grep tony
wheel:x:10:tony,tony2
tony:x:1000:tony                # tony
docker:x:983:tony
tony2:x:1001:                   # tony2
shared:x:1002:tony2,tony        # 之前作的 共享目錄
# 有 4 個欄位, 3 個「:」分隔
# 1 群組名稱
# 2 群組密碼 , 放在 /etc/gshadow
# 3 GID
# 4 此群組底下的弟兄們, 使用「,」分隔


# /etc/group 裏頭儲存的密碼, 格式兩者幾乎相同
$# cat /etc/gshadow | grep tony
wheel:::tony
tony:!!::tony
docker:!::tony
# 有 4 個欄位, 3 個「:」分隔
# 1 群組名稱
# 2 群組密碼 , 開頭為「!」表示無合法密碼, 無群組管理員
# 3 群組管理員 的帳號 (因為有 sudo 這東西, 導致 群組管理員 現在很少在用了)
# 4 (同 /etc/group )
```


## 有效群組(effective group) vs 初始群組(initial group)

有效群組, ex: Tony 加入 登山社, 口琴社, 烘焙社等 (此皆為 次要群組, 可切換 有效群組 為 其中一種 次要群組)

另外, Tony 也是 Tony群組 的人 (即為 初始群組, 預設的 有效群組 = 初始群組)

```sh
$# grep tony /etc/passwd /etc/group /etc/gshadow
/etc/passwd:    tony:x:1000:1000:tony:/home/tony:/bin/bash
/etc/group:     wheel:x:10:tony
/etc/group:     tony:x:1000:tony    # 某些 Linux Dist , 若為 初始群組, 最後一欄會沒東西
/etc/gshadow:   wheel:::tony
/etc/gshadow:   tony:!!::tony       # 某些 Linux Dist , 若為 初始群組, 最後一欄會沒東西
```

- `groups` : 列出該使用者已加入的所有群組
- `newgrp` : 切換該使用者的 `有效群組`

```sh
# 現在的使用者是 tony
$ groups
tony wheel docker shared    # tony 有加入的 所有群組 (所有 次要群組 們)
# 第一個為 有效群組

$ touch a

$ newgrp shared             # 以另外一個 子shell 的方式執行 (所以可以 exit 離開)
$ groups
shared wheel docker tony    # tony 的 有效群組 改變了

$ touch b

$ ll a b
-rw-rw-r--. 1 tony tony   0  7月 19 22:17 a
-rw-r--r--. 1 tony shared 0  7月 19 22:18 b     # 有效群組改變了

# 清空使用者的 附屬群組
$ usermod -G '' <userid>
```



# 登入過程

1. 尋找 `/etc/passwd` 是否有此帳號, 找出 `UID`
2. 依照剛找到的帳號, 前往 `/etc/group` 尋找 `GID`
3. 前往 `/etc/shadow`, 依照 `帳號`(還是 `UID`) 及 `輸入的密碼`, 與此 家密後的密碼 作 @^#%"^&... 換算 && 比對

- su username   : 起始 non-login shell
- su - username : 起始 login shell

> The main distinction is **su -** sets up the shell environment as if this were a clean login as that user, while **su** just starts a shell as that user with the current environment settings.

```sh
$ ll /etc/passwd
-rw-r--r--. 1 root root 2541  7月 16 23:08 /etc/passwd

$ ll /etc/shadow
----------. 1 root root 1483  7月 14 15:41 /etc/shadow
# ↑ Ubuntu 16.04 為 -rw-r-----

$# cat /etc/shadow | grep -n 3
root:%*ht^6...(PASS)...msW02/::0:99999:7:::
bin:*:17110:0:99999:7:::
daemon:*:17110:0:99999:7:::
# 上面有 8 個 「:」, 9個欄位分別為
# 1 使用者帳號
# 2 很厲害的加密加密之後讓人看不懂的密碼
# 3 最近更動密碼的日期, start from 1970/1/1, 過一天 +1, (GOOGLE Linux date 累積總秒數)
# 4 密碼不可被更動的日數
# 5 密碼需要重新變更的天數
# 6 密碼需要變更期限前的警告天數
# 7 密碼過期後的寬限時間(過了就失效了)
# 8 帳號失效日
# 9 (目前沒用到)
```



# root 密碼忘記了@@?

- 有救!

重開機進入 `單人維護模式` (會取得約當於 root 權限的 shell), 再使用 `passwd` 修改密碼

or

`用光碟開機` 掛載到 / , 把 /etc/shadow 的 root 密碼欄位清空, 重開機後再改密碼

```sh
$ $ authconfig --test | grep hashing
 password hashing algorithm is sha512       # 目前密碼的加密機制
```


# wheel

CentOS7 開始, 任何具備 `wheel` 群組的使用者, 都可以使用 `sudo` 來執行任何指令.

CentOS6 以前, 無法這麼做, 權限設定在 `/etc/sudoers`



# 其他

Windows 的 `User Account Control (UAC)` 與 Linux 的 `PolicyKit` 相當


###### 附註1:

因為新增使用者 `useradd` 時, 預設都會新增一個同名的 "group id" 當成它預設的 "primary group" (可能將來會導致 「uid number != gid number」~~~ 讓人看不爽阿 && 減少日後混淆的可能 )


###### 附註2:

移除 User 時, 一併刪除家目錄. 如果不這麼做, 殘存的家目錄的 Owner (原為 username), 會變成 已被刪除的 UID 所擁有(沒有 username 的 UID). 而 UID 會隨著日後增加使用者時, 被重新指派!! 新使用者, 可能會莫名其妙的得到殘存的家目錄的所有權 (超幸運的~ 得到一個有遺產的 UID)

```sh
# 移除無主的檔案
$# find / -nouser -o -nogroup 2> /dev/null
# 尋找所有 nouser && nogroup 的檔案們, 並將他們移除 (以免被將來的使用者無償取得...)
```
