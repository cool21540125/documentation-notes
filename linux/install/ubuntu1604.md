# Ubuntu 16.04


## Install nginx

- 2020/04/11
- [Ubuntu 16.04 安裝 Nginx](https://www.opencli.com/linux/ubuntu-16-04-install-nginx-mysql-php-lemp)

```bash
$# sudo apt-get install nginx
```


## Install nodejs

- [GitHub-Nodejs](https://github.com/nodesource/distributions/blob/master/README.md)


## apt 無法執行動作 (被lock住的解法)
- [更新套件被占用](http://hep1.phys.ntu.edu.tw/~phchen/apfel/linux/install/problem-solving.txt)
- 2018/04/23

更新套件庫或安裝套件遇到「無法將 /var/lib/dpkg/lock 鎖定」 解法
```sh
# 若出現 /var/lib/dpkg/lock 鎖定 - open (11: 資源暫時無法取得)
# 原因是使用 apt-get, aptitude, synaptic, software-center …等等的程式還沒有關閉

# 如果忘記是那個程式沒關的話，可使用 lsof(list open files) 找出是那個程序佔用檔案, 再用手動關閉或是使用指令的方法, 殺掉正在執行程序

# 1. 用 lsof 找出目前是那個程序在使用 /var/lib/dpkg/lock

$ sudo lsof /var/lib/dpkg/lock
# 從訊息可看出目前是 aptitude 在佔用 /var/lib/dpkg/lock, 可以找找看是不是剛使用 aptitude, 如果有的話等程式跑完應該就可 更新/安裝了

COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
aptitude 8891 root    4uW  REG   6,47        0 248214 /var/lib/dpkg/lock

# 2. 若找出來的程序是己經沒在執行又遺忘在那開啟的話, 直 kill~. 而這裡是 aptitude 它的 PID 為 8891, 殺掉就能正常使用

$ sudo kill 8891

# 如果出現
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.

# 就輸入
$ sudo dpkg --configure -a
```


# 無網路服務時, 安裝網路工具

- [Docker - Ubuntu - bash: ping: command not found](https://stackoverflow.com/questions/39901311/docker-ubuntu-bash-ping-command-not-found)

```sh
$# apt update
$# apt install iputils-ping
```



# install mysql 5.7

[MySQL官方教學](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install)

```sh
# 1. 連到這裡  https://dev.mysql.com/downloads/file/?id=472914
# 抓官方的repo

# 2.加入官方repo
$ sudo dpkg -i mysql-apt-config_0.8.8-1_all.deb

# 3. 更新一下apt
$ sudo apt-get -y update

# 4. 安裝mysql server
$ sudo apt-get -y install mysql-server

# 5. 服務
$ sudo service mysql status
$ sudo service mysql stop
$ sudo service mysql start
```



# MongoDB 3.4

- [官方教學](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-mongodb-community-edition)

```sh
1. 加入官方public key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

2. 建立16.04版的list file (這啥鬼...)
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

3. update
sudo apt-get update

4. 安裝
sudo sudo apt-get install -y mongodb
```



# Docker

- 2018/01/30
- [官方教學](https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements)

```sh
$ sudo apt-get update

$ sudo apt-get install docker-ce

$ apt-cache madison docker-ce
# 生產環境底下, 避免永遠都預設使用最新版

$ sudo apt-get install docker-ce=<VERSION>

$ sudo usermod -aG docker <userName>
# 使目前使用者能使用 Docker ((重新登入!!))
```



# vim (有顏色的 vi)

- 2018/01/30
- [Linux 安裝 vim](https://www.phpini.com/linux/linux-install-vim)
- [How to change syntax color in vim?](https://askubuntu.com/questions/912404/how-to-change-syntax-color-in-vim)
- [Backspace in insert mode in vi doesn't erase the character](https://askubuntu.com/questions/296385/backspace-in-insert-mode-in-vi-doesnt-erase-the-character)

```sh
$ sudo apt -y install vim

$ ls /usr/share/vim/vim74/colors
blue.vim  default.vim  desert.vim  evening.vim  koehler.vim  ...等 19 種
# 可選擇自己喜歡的顏色風格

$ vi ~/.vimrc
colorscheme koehler
```


## 或者可以使用預設的 vi, 取消 Ubuntu 難用的兼容模式...

```vim
# .vimrc
set nocompatible
set backspace=2
```



# 安裝 git

- 2018/06/19
- [git 官方查看自己要的版本 (Branch: master那邊)](https://github.com/git/git)

> Docker Image : ubuntu:16.04, 安裝 `非 apt預設版本的 git`

```sh
# 進入 Docker Container 後
$ apt update
$ apt install -y git
$ git --version
git version 2.7.4
# ↑ 2018/06 都已經出到 2.18rc 了, 2.7版 有點老舊...

$ apt remove -y git
# 所以把它砍了, 自己來編譯~~~
```

所以改抓 `tarball` 自行編譯

```sh
$ cd /opt
$ apt -y update
$ apt -y install wget
$ wget https://github.com/git/git/archive/v2.14.4.tar.gz

# 編譯時會用到的東西 (200多 MB  公司網路速度超慢... ㄇㄉ~)
$ apt install -y make autoconf gcc zlib1g-dev tcl-dev libssl-dev gettext

$ tar zxf v2.14.4.tar.gz
$ cd git-2.14.4/

$ make configure
GIT_VERSION = 2.14.4
    GEN configure

$ ./configure --prefix=/usr/local
# 注意看看有沒有 error 等錯誤字眼

$ make
$ make prefix=/usr/local install
$ git --version
git version 2.14.4  # 成功!

# 完成後
$ cd ..
$ rm v2.14.4.tar.gz
```

# Install python3
- 2018/06/19
- [How do I install Python 3.6 using apt-get?](https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get)

> Docker Image : ubuntu:16.04(預設裏頭沒有 python), 自行安裝 `python3`

```sh
# 同上範例的 git, 安裝 gcc, zlib1g-dev 那堆編譯的東西...

$ wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
$ tar zxf Python-3.6.1.tgz
$ cd Python-3.6.1

$ ./configure --enable-optimizations
$ make # 要等一陣子~~
$ make install  # 乾~~ 這個等更久

$ python3 --version
Python 3.6.1

$ which python3
/usr/local/bin/python3

$ which pip3
/usr/local/bin/pip3
```

# SSH Server

- 2018/11/28

```sh
apt install -y openssh-server
```

# Intsll Python3.7

- 2019/05/16
- [Installing The Latest Python 3.7 On Ubuntu 16.04 / 18.04](https://websiteforstudents.com/installing-the-latest-python-3-7-on-ubuntu-16-04-18-04/)

```sh
### dependencies
$# apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget

###
$# wget https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tar.xz

###
$# tar -xf Python-3.7.1.tar.xz
$# cd Python-3.7.1
$# ./configure --enable-optimizations --prefix=/usr/local

### 開始編譯
$# make -j 2
# -j: 使用的核心數

$# make altinstall

$# python3.7 --version
```


# PostgreSQL - 9.5

- 2019/01/28
- [學習資源](https://www.youtube.com/playlist?list=PLliocbKHJNws0zsx5Akn1DVoPznFYYGA9)


```bash
$# apt install -y postgresql

$# psql --version
psql (PostgreSQL) 9.5.14
```


# Install nmap

- 強大的駭客軟體

```sh
$# apt-get -y update
$# apt-get install -y nmap

### Port 掃描
$# nmap 127.0.0.1

Starting Nmap 7.01 ( https://nmap.org ) at 2019-01-28 02:41 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000030s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
631/tcp  open  ipp
5432/tcp open  postgresql

Nmap done: 1 IP address (1 host up) scanned in 1.66 seconds
```


# certbot

- 2018/11/28
- letsencrypt

1. 安裝
```sh
$# apt-get -y install software-properties-common
$# add-apt-repository ppa:certbot/certbot
$# apt-get -y update
$# apt-get -y install certbot
```

2. 設定檔
```sh
# cli.ini
$# vim cli.ini
text = True
domains = <YOURDOMAIN.com>
email = <MAIL@YOURMAIL>
renew-by-default
agree-tos
rsa-key-size = 4096
logs-dir = ./certbot-logs
work-dir = ./certbot-work
```

3. 使用
```sh
$# certbot certonly -a manual -c cli.ini
# 然後就會出現下面那些訊息 ~~~
Saving debug log to /tmp/certbot/logs/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Starting new HTTPS connection (1): acme-v02.api.letsencrypt.org

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing to share your email address with the Electronic Frontier
Foundation, a founding partner of the Let's Encrypt project and the non-profit
organization that develops Certbot? We'd like to send you email about our work
encrypting the web, EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y   ### (這邊應該可以選 N 吧!? LetsEncrypt 會寄信來給你)
Starting new HTTPS connection (1): supporters.eff.org
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for blog.tonychoucc.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y   ###

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Create a file containing just this data:

YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54.XhNzercNM71QC5uqJcE-hl2NF7dvfFUEHboBKQN06u8	    # 這邊叫做 AA

And make it available on your web server at this URL:

http://blog.tonychoucc.com/.well-known/acme-challenge/YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54	# 這邊叫做 BB

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue         # 先別按 Enter 啊!!!
# (此 Terminal 先擱置著)
### 這邊是 Terminal 1
```

```sh
### 這是 Web Hosting 那邊的程式碼目錄的 Terminal
mkdir acme-challenge
touch acme-challenge/YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54	# 把 BB 後半部複製過來
echo 'YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54.XhNzercNM71QC5uqJcE-hl2NF7dvfFUEHboBKQN06u8' > acme-challenge/YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54	        # 把 AA 丟到 BB 裏頭

### 這邊是 CI 時要做的事情(寫再 gitlab-ci 裏頭的)
mkdir -p public/.well-known/acme-challenge/
cp -R acme-challenge public/.well-known/
```

以上完成之後, 把專案 push 上去吧~  如果沒發生錯誤的話

「http://blog.tonychoucc.com/.well-known/acme-challenge/YCam9UkUdCLK8-s9BB-S_luJvMciik42HjtWd5cne54」應該就可以看到

AA 那堆字了

```sh
### 回到 Terminal 1
# Enter 給他按下去!!
Waiting for verification...
Resetting dropped connection: acme-v02.api.letsencrypt.org
Resetting dropped connection: acme-v02.api.letsencrypt.org
Cleaning up challenges
Non-standard path(s), might not work with crontab installed by your operating system package manager

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:  # Congratulations! 驗證成功~
   /etc/letsencrypt/live/blog.tonychoucc.com/fullchain.pem      # fullchain 在這, 這是 CC
   Your key file has been saved at:
   /etc/letsencrypt/live/blog.tonychoucc.com/privkey.pem        # Private Key 在這, 這是 DD
   Your cert will expire on 2019-04-16. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let''s Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

 - We were unable to subscribe you the EFF mailing list because your
   e-mail address appears to be invalid. You can try again later by
   visiting https://act.eff.org.

$#
```

後續再到 Gitlab / Pages, 修改你的 Domain

把 上述的 CC 及 DD 分別 copy-paste 到 Certificate (PEM) 及 Key (PEM)

即可完成手動認證~
