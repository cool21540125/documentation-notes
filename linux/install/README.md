#

## yum 查詢 ( **向 Yum Server 請求** )

```bash
### 查看版本
$# cat /etc/*-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

### 查看版本
$# cat /proc/version
Linux version 5.10.104-linuxkit (root@buildkitsandbox) (gcc (Alpine 10.2.1_pre1) 10.2.1 20201203, GNU ld (GNU Binutils) 2.35.2) #1 SMP Thu Mar 17 17:08:06 UTC 2022

### 不一定會有此 CLI
$# lsb_release -a


### 查看 Kernel
$# uname -a
Linux 4450648556ba 5.10.104-linuxkit #1 SMP Thu Mar 17 17:08:06 UTC 2022 x86_64 GNU/Linux
```

## 個別套件

- yum list 'httpd\*' :
- `yum search '用關鍵字查'` : 用來前往 yum server 尋找有沒有關鍵字描述的軟體
- yum search search all 'key words' : 同上, 但會額外找 軟體備註欄位有描述到的關鍵字的軟體
- yum info httpd : info 後面的東西, 名字得完全符合
- `yum provides /var/www/html` : 不管電腦內有沒有, 只要 `/etc/yum.repos.d/*.repo` 查得到東西, 就可以查到相關資訊
- yum install XXX

## 群組套件

- yum groups list
- yum groups info
- yum history
- yum history info
- yum history undo
- yum groups install XXX
- yum remove
- yum groups remove

```sh
$# yum clean all
# 會去清空 /var/cache/yum/.../*.rpm
# 此為 yum install 時, 所下載的暫存快取目錄
```

```sh
# 設定光碟為 Repository
# Repository內一定要有 xxxxdata
$ vim /etc/yum.repo.d/dvd.repo
[DVD]
name=CentOS7 DVD
baseurl=file:///run/media/disk/CentOS\ 7\ x86_64/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

$ yum repolist
```

```sh
$ rpm -qa | grep httpd

$ rpm -ql httpd

$ rpm -qpc xxx
# -c : 路徑
```

# 移除 Line

```sh
# 查詢 line 相關的已安裝軟體套件
$# rpm -qa | grep line
readline-6.2-10.el7.x86_64
gnome-online-accounts-3.22.5-1.el7.x86_64
gnome-online-miners-3.22.0-2.el7.x86_64
libpipeline-1.2.3-3.el7.x86_64

$# rpm -qi line
套件 line 尚未安裝
```

```sh
# 本地 rpm 安裝
$# rpm -ivh XXX

# 建議用 localinstall
$ yum localinstall --nogpgcheck XXX
# 可自動幫忙解決相依性
# 也可留下 Log
# yum history info <number>
```
