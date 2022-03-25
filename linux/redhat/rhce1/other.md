
# 下面都還很亂  還沒整理


## 安裝語言套件

```sh
# 幫1~20號電腦, 安裝語言套件 ((講師用的腳本))
for i in $(seq 1 20) ; do
    ping -c l foundation${i} &> /dev/null && \
    ssh root@foundation${i} yum -y install cjk* ibus* lftp &> /dev/null || \
    echo fail${i} >> /root/test.f1 ;
done
```


## Xming

安裝在 Windows 底下, 可以擷取 X-Window System 的桌面資訊,

ex: 在 Windows 10 開啟 putty, 選項中選擇擷取 X-Windows System, 在 putty中, 使用

gedit a.txt 之後, Xming 可以擷取開啟 gedit 開始編輯


## sudo

```sh
# 可以直接開啟 /etc/sudoers
$# visudo
# 它會幫忙作 語法檢查!!! 比較安全

# 底下, %wheel 代表 「wheel群組」
$# sudo cat /etc/sudoers | grep wheel
## Allows people in group wheel to run all commands

%wheel	ALL=(ALL)	ALL
# %wheel	ALL=(ALL)	NOPASSWD: ALL

# %wheel	     ALL              =  (ALL)	                ALL
# %wheel           Hostname          = (UserAccount)          Command
# wheel group      可在 All(所有主機)  = UserAccount(所有帳號)   執行任何指令
# 可以把 %wheel 想像成 root 群組啦!!
```


Account info -> `/etc/passwd`
- useradd
- usermod
- userdel -r : 如果使用者被刪除時, 沒有用 -r, 會使得那個被刪除的使用者留存的檔案還在, 東西會有被竊取的疑慮

Group info -> `/etc/group`
- groupadd
- groupmod
- groupdel

Password info -> `/etc/shadow`
- passwd
- chage

- `passwd -l <userID>`  : 鎖密碼
- `usermod -U <userID>` : 鎖帳號


# 2018/08/06

SetUID : /usr/bin/passwd -> /etc/shadow

SetGID : /usr/bin/locate -> /var/lib/mlocate/mlocate.db

`sticky bit`

- u+s 4
- g+s 2
- o+t 1

rwxrwxrwx 的最後一個 x 的位置
- x : 執行的x
- t : sticky + x
- T : 僅 sticky

```sh
$# chmod g+s <dir name>
# 設定 目錄 為 SGID, 將來不管誰在此目錄內新增東西, 新增的檔案的 group owner 都為 <dir name> 的 Group owner
```


# 2018/08/08

```sh
# 測試指令
$ dd < /dev/zero > /dev/null
# block住目前的 terminal

$ dd if=/dev/zero bs=1M count=200 of=/run/media/...
# 產生200個 block size=1M的檔案 , 也就是產生一個 200M 的檔案, 丟到 /run/media/...
```


```sh
$# ps aux | grep ssh-agent
tony      2257  0.0  0.0  51332   584 ?        Ss   18:13   0:00 /usr/bin/ssh-agent /bin/sh -c exec -l /bin/bash -c "env GNOME_SHELL...(pass)...ome-classic"
root      5681  0.0  0.0 112664   968 pts/0    S+   18:52   0:00 grep --color=auto ssh-agent

$# kill 2257

$# ps aux | grep ssh-agent
```


## Shell Script

```sh
# 迴圈寫法:
while 條件式 ; do
  cmd1
  cmd2
  ...
done

for 條件式 ; do
  cmd3
  cmd4
  ...
done
```

```sh
while true ; do
  echo -n "rock " >> abc.txt
  sleep 1
done
```

```sh
$ echo -n xxx
# echo後, 不要加上斷行字元
```


## 送訊號
- kill    : 殺 job or ps
- killall : 殺 job or ps or command
- pkill   : 殺 job or ps or command && 可用額外指令
- pgrep   : (忘了)


## systemctl

```sh
$ systemctl -t help

$ systemctl -l
$ systemctl -al
$ systemctl --type=service -l
$ systemctl list-unit-files
```



## 教室上網問題

```sh
# (電腦比老師早開機)
# 因教室內, 講師機為 「Gateway+DNS+DHCP+...@&^%(#@!...」 虛擬機預設自動取得ip
# 所以一開始抓到的 ip 會是無效的! 
# 等講師機開機之後, 再重新啟用連線(重新自動取得IP), 才能上網
$ nmcli con up "System eth0"
```


## Company

```sh
# My IP 122.147.166.7

$ sudo traceroute -I access.redhat.com
traceroute to access.redhat.com (23.193.97.178), 30 hops max, 60 byte packets
 1  gateway (192.168.124.254)  2.416 ms  2.393 ms  2.388 ms
 2  vpn.perfect.com.tw (192.168.2.7)  0.719 ms  0.751 ms  0.748 ms
 3  122.147.166.1 (122.147.166.1)  2.817 ms  2.954 ms  2.955 ms
 4  220.228.20.165 (220.228.20.165)  1.922 ms  1.930 ms  1.982 ms
 ...PASS...
 15  a23-193-97-178.deploy.static.akamaitechnologies.com (23.193.97.178)  135.276 ms  135.337 ms  135.311 ms

#   Internet
#      |
#      o    對外IP 122.147.166.1
#    Router
#      o        GW 
#      |   
#      o           192.168.2.7
#    Router 
#      o        GW 192.168.124.254
#      | 
# My Computer      192.168.124.73
```

```sh
# COPY 講師機的所有評分程式
$ lftp classroom/content/courses/rh124/rhel7.0/

$ mirror grading-sripts/
```


# 

```sh
$# du / -h --max-depth=1 2> /dev/null
278M	/boot
0	/dev
19G	/home
0	/proc
9.2M	/run
0	/sys
14G	/var
63M	/etc
4.7M	/root
12M	/tmp
6.7G	/usr
0	/media
0	/mnt
3.4G	/opt
0	/srv
0	/data
42G	/
```



# review

```sh
rht-vmctl reset server
rht-vmctl reset desktop
```


## Server

```sh
lab sa1-review setup
```


## Server

```sh
##### 1
head -n 12 /usr/bin/clean-binary-files > /home/student/headtail.txt
tail -n 9 /usr/bin/clean-binary-files >> /home/student/headtail.txt

##### 2
touch ~student/system_changes-machine{1..10}-month_{jan,feb,mar}.txt
mkdir -p /home/student/syschanges/{jan,feb,mar}
mv ~student/system_changes-machine*jan.txt /home/student/syschanges/jan
mv ~student/system_changes-machine*feb.txt /home/student/syschanges/feb
mv ~student/system_changes-machine*mar.txt /home/student/syschanges/mar
rm -f /home/student/syschanges/*/system_changes-machine{9,10}*.txt

##### 3
# man ls
echo "--color=never" >/home/student/lscolor.txt

##### 4
cp /home/student/vimfile.txt /home/student/longlisting.txt
# vim /home/student/longlisting.txt
# 使用 ctrl+v , ctrl+x 作編輯後, :wq 離開

##### 5 
sudo vim /etc/login.defs # sudo sudo sudo sudo sudo sudo sudo sudo sudo
# 新建的使用者, 改成 60 天後到期

cat /etc/login.defs
sudo groupadd -g 30000 instructors
tail -5 /etc/group
sudo useradd -G instructors gorwell ; echo 'firstpw' | passwd --stdin gorwell
sudo useradd -G instructors rbradbury ; echo 'firstpw' | passwd --stdin rbradbury
sudo useradd -G instructors dadams ; echo 'firstpw' | passwd --stdin dadams
tail -5 /etc/group

date -d "+60 days"

sudo chage -E 2018-12-14 gorwell
sudo chage -E 2018-12-14 rbradbury
sudo chage -E 2018-12-14 dadams

sudo chage -M 10 gorwell
chage -l gorwell

sudo chage -d 0 gorwell
sudo chage -d 0 rbradbury
sudo chage -d 0 dadams

##### 6 (使用 sudo su -)
mkdir /home/instructors
chgrp instructors /home/instructors
chmod 2774 /home/instructors
ls -ld /home/instructors

##### 7
# top
pkill cpuhog

##### 8
systemctl stop cups
systemctl disable cups
systemctl status cups

##### 9
ssh-keygen
ssh-copy-id desktop12

ssh student@desktop12

exit

vim /etc/ssh/sshd_config
# 取消 root 遠端登入
# 取消密碼驗證
systemctl restart sshd

##### 10
tzselect
# 2
# 5
# 1

timedatectl set-timezone America/Nassau

##### 11
echo "journalctl --since 9:05:00 --until 9:15:00" > /home/student/systemdreview.txt

##### 12
echo "authpriv.alert /var/log/auth-errors" > /etc/rsyslog.d/auth-errors.conf
systemctl restart rsyslog
logger -p authpriv.alert "Logging test authpriv.alert"
tail -n 5 /var/log/auth-errors
tail -n 5 /var/log/auth-errors

##### 13
nmcli con add con-name review ifname eth0 type ethernet ip4 172.25.12.11/24 gw4 172.25.12.254 autoconnect yes
nmcli con mod con-name eth0 autoconnect no
nmcli con mod "review" +ipv4.addresses 10.0.12.1/24
nmcli con mod "review" ipv4.dns 172.25.254.254
nmcli con up
echo "10.0.12.1" >> /etc/hosts
hostnamectl set-hostname server12.example.com

##### 14
mkdir /configbackup
rsync -av /etc /configbackup

##### 15
tar czf /root/configuration-backup-server.tar.gz /configbackup

##### 16
ssh root@server12

mkdir /tmp/configcompare
cd /tmp/configcompare
tar xzf /root/config-backup-server.tar.gz

##### 17
ssh student@desktop12 'hostname > /tmp/scpfile.txt'
scp root@desktop12:/tmp/scpfile.txt /home/student

##### 18
echo '[updates]' > /etc/yum.repos.d/localupdates.repo
echo 'name=Red Hat Updates' >> /etc/yum.repos.d/localupdates.repo
echo 'baseurl=http://content.example.com/rhel7.0/x86_64/errata' >> /etc/yum.repos.d/localupdates.repo
echo 'enabled=1' >> /etc/yum.repos.d/localupdates.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/localupdates.repo

##### 19
yum update -y kernel
yum install -y xsane-gimp rht-system
yum remove -y wvdial

##### 20
du /usr/share/fonts > /home/student/dureport.txt

##### 21
blkid
mkdir /mnt/datadump
mount UUID="" /mnt/datadump

##### 22
ln -s /mnt/datadump /root/mydataspace

##### 23
echo "find / -type l -name '*data*'" > /home/student/find.txt
```
