# 目錄與檔案權限

- 2018/06/09

# 檔案權限

> 檔案是實際含有資料的地方

- r: 可讀取檔案
- w: 編輯, 新增, 修改 檔案的內容(不含刪除)
- x: 檔案可被執行

僅針對「檔案的內容」, 與檔案名稱的存在與否無關

# 目錄權限

> 目錄主要的內容, 在記錄檔案清單

- r: 具備讀取目錄清單的權限, ex: 使用 ls 查看
- w: 可以異動該目錄結購清單的權限(與檔名有關的異動啦)

  - 建立新的 檔案 && 目錄
  - 刪除已經存在的 檔案 && 目錄(不論該檔案的權限為何)
  - 移動檔案位置(更改名字)

- x: 目錄具備 x 權限, 表示使用者可以 cd 進入

## 範例 - ACLs

RH 134 Ch6 p110

```sh
### 環境設定 (su)
groupadd -g 5001 controller
groupadd -g 5002 sodor
useradd student ; echo redhat | passwd --stdin student
useradd james ; echo redhat | passwd --stdin james
useradd thomas ; echo redhat | passwd --stdin thomas
usermod -aG sodor james
usermod -aG sodor thomas
usermod -aG controller student


### 移除
gpasswd --delete user group

mkdir -p /shares/steamies
touch /shares/steamies/display_engines.sh
echo 'echo "You are executing \"/shares/steamies/display_engines.sh\""' > /shares/steamies/display_engines.sh
touch /shares/steamies/roster.txt
chgrp -R controller /shares/steamies/
chmod g+s /shares/steamies
chmod u+x,g+x /shares/steamies/display_engines.sh

### Start
sudo su -
cd /shares/
setfacl -Rm u:james:-,g:sodor:rwX,o::- /shares/steamies/
setfacl -m d:g:sodor:rwx,d:u:james:-,d:o::- /shares/steamies/

setfacl -Rm u:node_exporter:rwx,u:ubuntu:rwx,g:node_exporter:rwX,o::- /srv/node_exporter
setfacl -m d:g:node_exporter:rwx,d:u:ubuntu:rwx,d:u:node_exporter:-,d:o::- /srv/node_exporter

getfacl /shares/steamies

### 還原
rm -rf /shares
userdel -r student
userdel -r james
userdel -r thomas
groupdel sodor
groupdel controller
```

## 範例 2 - ACLs

RH134 Ch6 p114

```sh
### 環境設定 (su)
groupadd -g 6001 bakerstreet
groupadd -g 6002 scotlandyard
useradd holmes ; echo redhat | passwd --stdin holmes
useradd waston ; echo redhat | passwd --stdin waston
useradd lestrade ; echo redhat | passwd --stdin lestrade
useradd gregson ; echo redhat | passwd --stdin gregson
useradd jones ; echo redhat | passwd --stdin jones
usermod -aG bakerstreet holmes
usermod -aG bakerstreet waston
usermod -aG scotlandyard lestrade
usermod -aG scotlandyard gregson
usermod -aG scotlandyard jones

mkdir -p /shares/cases
touch /shares/cases/adventures.txt
touch /shares/cases/moriarity.txt
touch /shares/cases/do_NOT_delete.grading.txt
chgrp -R bakerstreet /shares/cases
chmod 660 /shares/cases/*
chmod g+s /shares/cases

### op
setfacl -Rm u:jones:rX,g::rwX,g:scotlandyard:rwX,o::- /shares/cases
setfacl -m d:u:jones:rx,d:g::rwx,d:g:scotlandyard:rwx,d:o::- /shares/cases

ls -ld /shares/cases
ls -l /shares/cases/*
getfacl /shares/cases

### 還原
rm -rf /shares/cases
userdel -r holmes
userdel -r waston
userdel -r lestrade
userdel -r gregson
userdel -r jones
groupdel bakerstreet
groupdel scotlandyard

```

```bash
echo -e "用戶名\\n用戶密碼" | adduser -s /bin/sh -h /home/bigboss bigboss
```
