
# CentOS7 安裝備註

我的使用環境如下

```sh
$ uname -a
Linux tonynb 3.10.0-514.el7.x86_64 \#1 SMP Tue Nov 22 16:42:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

$ hostnamectl
   Static hostname: tonynb
         Icon name: computer-laptop
           Chassis: laptop
        Machine ID: 6e935c5d22124158bd0a6ebf9e086b24
           Boot ID: 3262e51d23a9478dbc268f562556a74c
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-514.el7.x86_64
      Architecture: x86-64

$ cat /etc/centos-release
CentOS Linux release 7.5.1804 (Core)

$ rpm --query centos-release
centos-release-7-5.1804.4.el7.centos.x86_64
```

- RHEL (RedHat Enterprise Linux) :
- EPEL (Extra Packages for Enterprise Linux) : 幾乎都是 RedHat 的實驗品... 正式 Server 別裝這些...



## Linux的軟體管理員 - yum

> 解決 rpm安裝時, 套件相依性的問題

```sh
# 查本地已經安裝的 Linex Kernels
$ yum list kernel

# 移除本地已安裝的套件 && Dependcies
$# yum remove httpd

# 查線上可安裝的群組套件
$ yum group list # 或 yum grouplist

# 可用關鍵字來查詢線上 群組套件名稱, 群組套件說明
$ yum groups info "Server with GUI"

# 增加 「yum repo 檔」 到 /etc/yum.repo.d/xxx.repo
$# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

## 列出 系統可用的 yum套件庫
$ yum repolist
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.isu.edu.tw
 * elrepo: dfw.mirror.rackspace.com
 * epel: ftp.cuhk.edu.hk
 * extras: ftp.isu.edu.tw
 * updates: ftp.isu.edu.tw
repo id                         repo name                                        status
base/7/x86_64                   CentOS-7 - Base                                   9,591
code                            Visual Studio Code                                   29
docker-ce-stable/x86_64         Docker CE Stable - x86_64                            13
epel/x86_64                     Extra Packages for Enterprise Linux 7 - x86_64   12,382
extras/7/x86_64                 CentOS-7 - Extras                                   392
google-chrome                   google-chrome                                         3
mysql-tools-community/x86_64    MySQL Tools Community                                59
mysql57-community/x86_64        MySQL 5.7 Community Server                          247
updates/7/x86_64                CentOS-7 - Updates                                1,962
repolist: 24,950
# -------------------------------------------------------------------------------------

### yum list - 列出 (遠端)YUM Server 上的「所有」套件資訊, 套件名稱, 版本...
# 列出 YUM Server 的 packages
$# yum list available 
$# yum list
$# yum list 'http*'
# 可查有哪些東西(但是得給完全相同的名字才能查(可用regex))


### yum search - 可用關鍵字來查詢 (套件名稱, 套件說明) (比 yum list 好用)
$# yum search all 'web server'


### yum info - 查線上套件安裝資訊 (必須是完整名稱)
$# yum info httpd


### yum provides - 
# 到 YUM Server 查 安裝在哪個位置的工具叫啥 or 該工具相關的套件
$ yum provides /var/www/html
$ yum provides semanage



$# yum --disablerepo="*" --enablerepo="rsawaroha" list available

$ yum install <套件名稱>

$ yum update <套件名稱>

$ yum remove <套件名稱>

$ yum searcn <套件名稱>
# 搜尋 YUM Server上的特定套件
```


## Linux安裝軟體方式 - 原始碼編譯 && 安裝

1. 取得原始碼
  - 大多為 `tar.gz`, 可用 `tar zxvf`解開
2. 觀看 README 與 INSTALL
  - README: 軟體的介紹
  - INSTALL: 編譯與安裝的方法及步驟
3. 設定組態
  - 使用 `./configure`, 並給予必要參數及選項
  - 產生 `Makefile`編譯腳本
4. 編譯與安裝
  - 使用 `make`進行編譯
  - 無誤後, 使用 `sudo make install`開始安裝


## EPEL(Extra Packages for Enterprise Linux)
> Linux在安裝許多軟體的時候(ex: yum install ...), 會有軟體相依性的問題, 若發現相依軟體尚未被安裝, yum會自己去`本地 repository`裡頭找有記載的`遠端 repository`去下載相依套件. 而 EPEL就是專門 for CentOS的套件庫, 裡頭有許多CentOS的核心套件. <br>查看補充說明:
[What is EPEL](https://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/)
```sh
$ sudo yum install -y epel
```



## Linux的軟體管理員 - rpm

### - rpm vs dpkg

distribution 代表 | 軟體管理機制 | 使用指令 | 線上升級機制(指令)
--- | --- | --- | ---
Red Hat/Fedora | RPM | rpm, rpmbuild | YUM (yum)
Debian/Ubuntu | DPKG | dpkg | APT (apt-get)


### - rpm vs srpm

檔案格式 | 檔名格式 | 直接安裝與否 | 內含程式類型 | 可否修改參數並編譯
--- | --- | --- | --- | ---
RPM | xxx.rpm | 可 | 已編譯 | 不可
SRPM | xxx.src.rpm | 不可 | 未編譯之原始碼 | 可

rpm套件管理的語法: `rpm -<options> <xxx.rpm>`


### - options

options     | description
----------- | ------------
-i          | 安裝套件
-v          | 安裝時, 顯示細部的安裝資訊
-h          | 安裝時, 顯示安裝進度
-e          | 移除套件
-U          | 更新套件
-q          | 查詢套件資訊
-qa         | - 已安裝套件清單
-qi         | - 特定套件安裝資訊
-ql         | - 套件安裝了哪些東西
-qf         | - 某個東西是被哪個套件安裝的 (與 -ql相反)

```sh
# 可以反查某個檔案被哪個套件所安裝
$ rpm -qf /etc/fstab
setup-2.8.71-7.el7.noarch

##### 底下是範例程式及說明 #####
setup-2.8.71-4.el7.noarch   <---安裝包
  套件名稱: setup
  版本: 2.8.71
  修訂: 4, 修正 bug錯誤第4版
  適用發行版: el7, RedHat Enterprise Linux 7
  適用平台: noarch
```


### - sub options
sub options | description
----------- | ------------
--test      | 僅測試模擬安裝過程, 不會真正安裝`(移除時, 可嘗試用此搭配)`
--nodeps    | 忽略安裝前的相依性檢查
--force     | 強制安裝(若已安裝, 會覆蓋掉前次安裝)


### 常用選項
options     | description
----------- | ------------
-Uvh        | if 未安裝, then 直接安裝<br />if 安裝過舊版, then 版本升級
-Fvh        | if 未安裝, then 不動作<br />if 安裝過舊版, then 版本升級
-ivh        | 最常用的安裝方式, 安裝時, 顯示安裝資訊



# Install kafka

- 2022/01/11
- [How to install and configure a Kafka cluster with ZooKeeper](https://sleeplessbeastie.eu/2021/10/25/how-to-install-and-configure-a-kafka-cluster-with-zookeeper/)

```bash
### 建置 kafka 專用用戶
groupadd -g 809 kafka
adduser -r --shell /sbin/nologin -g 809 -d /data/kafka -u 809 kafka

cd /usr/local/src
wget https://archive.apache.org/dist/kafka/2.6.0/kafka_2.13-2.6.0.tgz
### 自行前往 https://kafka.apache.org/downloads 抓想要的版本
tar -zxf kafka_2.13-2.6.0.tgz -C /usr/local/bin/
chown -R kafka:kafka /usr/local/bin/kafka_2.13-2.6.0

### Data dir
sudo -u kafka mkdir /data/kafka
cd /data/kafka
sudo -u kafka mkdir kafka_data zookeeper_data config

### id
hostname -s | sed "s/.*\([^0-9]\)//g"  | sudo -u kafka tee /data/kafka/zookeeper_data/myid

### 配置 - zookeeper.properties
sudo -u kafka cat <<EOF | sudo -u kafka tee /data/kafka/config/zookeeper.properties
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/kafka/zookeeper_data
clientPort=2181
server.1=kafka01:2888:3888
server.2=kafka02:2888:3888
server.3=kafka03:2888:3888
EOF

### 配置 - kafka - server.properties
sudo -u kafka cat <<EOF | sudo -u kafka tee /data/kafka/config/server.properties
############################# Server Basics #############################
                                                                                                                                         
# The id of the broker. This must be set to a unique integer for each broker.                                 
broker.id=$(hostname -s | sed "s/.*\([^0-9]\)//g")                                                                                                                              
                                                                    
############################# Socket Server Settings #############################
                                                                    
# The address the socket server listens on. It will get the value returned from                                                          
# java.net.InetAddress.getCanonicalHostName() if not configured.                                                                         
#   FORMAT:                                                                                                                              
#     listeners = listener_name://host_name:port                                                                                                                                                                                                                                  
#   EXAMPLE:                                                                                                                             
#     listeners = PLAINTEXT://your.host.name:9092                                                                                        
listeners=PLAINTEXT://:9092                                                                                                                                                                                                                                                      
                                                                                                                                         
# Hostname and port the broker will advertise to producers and consumers. If not set,                                           
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
advertised.listeners=PLAINTEXT://$(hostname -f):9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600
                                                                                                                                                                                                                                                                         

############################# Log Basics #############################

# A comma separated list of directories under which to store log files
log.dirs=/data/kafka/kafka_data

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=6

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824
# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=localhost:2181

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=18000


############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0
EOF

### systemd - zookeeper.service
cat <<EOF | tee /usr/lib/systemd/system/zookeeper.service
[Unit]
Description=ZooKeeper Service
After=network-online.target 
Requires=network-online.target

[Service]
Type=simple

Restart=on-failure

User=kafka
Group=kafka

ExecStart=/usr/local/bin/kafka_2.13-2.6.0/bin/zookeeper-server-start.sh /data/kafka/config/zookeeper.properties
ExecStop=/usr/local/bin/kafka_2.13-2.6.0/bin/zookeeper-server-stop.sh /data/kafka/config/zookeeper.properties
WorkingDirectory=/data/kafka

[Install]
WantedBy=multi-user.target
EOF

### systemd - kafka
cat <<EOF | tee /usr/lib/systemd/system/kafka.service
[Unit]
Description=kafka Service
After=network-online.target 
Requires=network-online.target

[Service]

Type=simple
Restart=on-failure

User=kafka
Group=kafka

ExecStart=/usr/local/bin/kafka_2.13-2.6.0/bin/kafka-server-start.sh /data/kafka/config/server.properties
ExecStop=/usr/local/bin/kafka_2.13-2.6.0/bin/kafka-server-stop.sh /data/kafka/config/server.properties
WorkingDirectory=/data/kafka

[Install]
WantedBy=multi-user.target
EOF
```


↓ Old

- [看這邊](../../other/kafka.md)



# Install DotNet Core

- 2019/01/03
- https://dotnet.microsoft.com/download/linux-package-manager/centos/sdk-current

```sh
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
yum install dotnet-sdk-2.2

dotnet --version
```


# Install Ansible

- 2021/06/20
- [Installing Ansible on RHEL, CentOS, or Fedora](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-rhel-centos-or-fedora)

```bash
yum install -y epel-release
yum install -y ansible
```


# Install Ansible Tower

- 2019/01/12
- [Ansible tar file](https://releases.ansible.com/ansible-tower/setup-bundle/)
- 2G+ RAM (建議 4G+)
- 20G Disk
- 64 bits os


```sh
### 1. Download && Install
$# wget https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-3.0.3-1.el7.tar.gz
$# tar -zxf ansible-tower-setup-bundle-3.0.3-1.el7.tar.gz
$# cd ansible-tower-setup-bundle-3.0.3-1.el7/

$# vim inventory
### 先設定好 inventory 裏頭的 3 組密碼

$# ./setup.sh   # 會檢查 Disk, RAM ...
# 好像會偷偷幫你安裝 PostgreSQL, redis, httpd...
# ~~~ 會安裝一陣子~~~

The setup process completed successfully.   # ← successfully
Setup log saved to /var/log/tower/setup-2019-01-12-17:53:43.log
You have new mail in /var/spool/mail/root
# 安裝完後, 要看到上面的訊息才算 OK


### 2. Setup 安裝完後, 就可透過網頁看到 Ansible Tower 的管理頁面了~
# 2-1. 改密碼~
$# tower-manage changepassword admin
Changing password for user 'admin'
Password:
Password (again):
Password changed successfully for user 'admin'

# 2-2. 然後就可以登入網頁
# 因為是個人, 所以選擇申請個人版(只能管理 10 nodes 以下)
# 且無法使用 LDAP
# 填妥收信後, 就可以收到 Licenses 了~

### 3. PKI
$# ssh-keygen -f tower_rsa
$# ssh-copy-id -i ~/.ssh/tower_rsa.pub <RemoteUser>@<RemoteIP>
$# ssh -i ~/.ssh/tower_rsa <RemoteUser>@<RemoteIP>
# 將來便可使用 Public Key 方式連線
```


# Install Google Chrome

- 2017/11/25
- [老灰鴨的筆記本](http://oldgrayduck.blogspot.tw/2016/04/linuxcentos-7-google-chrome.html)

1. repo
```
$ sudo touch /etc/yum.repos.d/google-chrome.repo

[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
```

2. Install
```
sudo yum -y install google-chrome-stable
```



# Install Docker CE

- 2021/01/29
- [Official Docker](https://docs.docker.com/engine/installation/linux/docker-ce/centos/#install-using-the-//repository)


```sh
### root
# 安裝
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker
systemctl enable docker

# 完成
docker version
```


# Install Docker-compose

- 2021/02/04
- [Install Docker Compose](https://docs.docker.com/compose/install/)

```sh
VERSION=1.29.2
curl -L "https://github.com/docker/compose/releases/download/$VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
cat <<"EOT" > /etc/profile.d/usr_local_bin.sh
export PATH=/usr/local/bin:${PATH}
EOT
source /etc/profile

docker-compose --version
```


## Docker-machine
- [Install Docker Machine](https://docs.docker.com/machine/install-machine/)
- 2020/04/01

```sh
### 安裝 docker machine
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine

$ docker-machine version
docker-machine version 0.16.0, build 702c267f

### docker - bash completion
$# mkdir -p /usr/local/etc/bash_completion.d/
$# vim /usr/local/etc/bash_completion.d/docker-machine-prompt.bash
# 內容如下 ----------------------------------
base=https://raw.githubusercontent.com/docker/machine/v0.16.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done
# 內容如上 ----------------------------------

### 執行安裝
$# source /usr/local/etc/bash_completion.d/docker-machine-prompt.bash

# enable the docker-machine shell prompt
$# vim ~/.bashrc
# 內容如下 ----------------------------------
PS1='[\u@\h \W$(__docker_machine_ps1)]\$ '
# 內容如上 ----------------------------------
```


# Install Podman

- 2021/09/25

```bash
### EPEL 裏頭就有
$# yum install podman -y

### 預設來說, podman 一般使用者就可以使用了
# 如果遇到問題, 在使用下面方式處理
$# cat /proc/sys/user/max_user_namespaces
0
$# sudo sysctl user.max_user_namespaces=15000
user.max_user_namespaces = 15000
$# cat /proc/sys/user/max_user_namespaces
15000
$# sudo usermod --add-subuids 200000-201000 --add-subgids 200000-201000 $USER
$# grep tony /etc/subuid /etc/subgid
/etc/subuid:tony:200000:1001
/etc/subgid:tony:200000:1001
```

```bash
### Usage
podman pod list

###
$ podman version
Version:            1.6.4
RemoteAPI Version:  1
Go Version:         go1.12.12
OS/Arch:            linux/amd64
```


# Install bridge-utils

```bash
yum install bridge-utils -y

### Usage
$# brctl show
bridge name   bridge id           STP enabled   interfaces
docker0       8000.02428b91c08f   no
```


# Install mlocate

```bash
### locate - command not found
yum install -y mlocate
updatedb
```


# Install bash_completion

 - 2020/04/08
 - [How to Install and Enable Bash Auto Completion in CentOS/RHEL](https://www.tecmint.com/install-locate-command-to-find-files-in-centos/)

```bash
$# yum install -y bash-completion bash-completion-extras
$# locate bash_completion.sh   # 如果出現 locate command not found, 參考底下解法
$# source /etc/profile.d/bash_completion.sh
```


# Install ELK - elasticsearch

- 2019/01/12

### 1. 使用 yum 安裝

```sh
$# rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
$# vim /etc/yum.repos.d/elasticsearch.repo
###### 內容如下 ######
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
###### 內容如上 ######

$# yum install elasticsearch
```

### 2. 使用 rpm 安裝

```sh
### Download
$# wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.rpm

### Install
$# rpm -ivh elasticsearch-6.5.4.rpm
warning: elasticsearch-6.5.4.rpm: Header V4 RSA/SHA512 Signature, key ID d88e42b4: NOKEY
Preparing...                          ################################# [100%]
Creating elasticsearch group... OK
Creating elasticsearch user... OK
Updating / installing...
   1:elasticsearch-0:6.5.4-1          ################################# [100%]
### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
 sudo systemctl daemon-reload
 sudo systemctl enable elasticsearch.service
### You can start elasticsearch service by executing
 sudo systemctl start elasticsearch.service
Created elasticsearch keystore in /etc/elasticsearch

$# systemctl start elasticsearch
$# systemctl enable elasticsearch
$# systemctl status elasticsearch
```


# Install ELK - kibana

- 2019/01/24
- [Install Kibana with RPM](https://www.elastic.co/guide/en/kibana/current/rpm.html)

```sh
$# rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

$# vim /etc/yum.repos.d/kibana.repo
###### 內容如下 ######
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
###### 內容如上 ######

$# yum install kibana
```

# Install ELK - logstash

- [Install Logstash](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html)

```sh
$# rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

$# vim /etc/yum.repos.d/logstash.repo
###### 內容如下 ######
[logstash-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
###### 內容如上 ######

$# yum install -y logstash
```

# Install ELK - metricbeat

- [Install Metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/6.5/setup-repositories.html)
- [各種 Logstash 之下的 Beats](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-elastic-stack.html)

```sh
$# rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

$# vim /etc/yum.repos.d/elastic.repo
###### 內容如下 ######
[elastic-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
###### 內容如上 ######

$# yum install -y metricbeat

### enalbe
$# systemctl enable metricbeat
$# chkconfig --add metricbeat
```

# Install ELK - Filebeat

- [Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html)

```sh
### public signing key
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elastic.repo <<EOF

[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum install -y filebeat

systemctl start filebeat
systemctl enable filebeat
systemctl status filebeat

### 配置主檔
vim /etc/filebeat/filebeat.yml
```

# Install MySQL Community 8.0

- 2020/12/31

```sh
rpm -ivh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
yum -y install mysql-community-server

systemctl start mysqld
grep 'password' /var/log/mysqld.log
# 取得 root 密碼

mysql -uroot -p
# root 密碼

# 因為最一開始有密碼政策, 所以底下的密碼需要設的比較複雜一點才能過~
ALTER USER 'root'@'localhost' IDENTIFIED BY '<new password>';
```


# Install MySQL Community 5.7

- 2018/09/14
- [Official MySQL](https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/)

1. 安裝 MySQL

```sh
### 1. 編寫 yum repo 檔
cat <<"EOT" > /etc/yum.repos.d/mysql-community.repo
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://repo.mysql.com/RPM-GPG-KEY-mysql
EOT

### 2. Check Repo && Install
yum repolist | grep mysql
# mysql57-community/x86_64     MySQL 5.7 Community Server      287

yum install -y mysql-community-server

### 3. 啟動 && 設定 root 密碼~
systemctl start mysqld
systemctl enable mysqld
systemctl status mysqld

grep 'temporary password' /var/log/mysqld.log
### ↑ 如果沒有的話, 透過底下方式找預設密碼~
journalctl -u mysqld > /tmp/mysql_init_log
grep 'password' /tmp/mysql_init_log

mysql -uroot -p
# 前面取得的密碼登入
```

2. 更改密碼~

```sql
--;# 登入 MySQL 後, 立馬改密碼
ALTER USER 'root'@'localhost' IDENTIFIED BY '<聽說智障都直接複製貼上>';
FLUSH PRIVILEGES;
--;# 自己看看要不要移除 密碼政策
-- uninstall plugin validate_password;

--;# 建立 User
CREATE USER 'tony'@'%' IDENTIFIED BY '<password>';
GRANT ALL ON *.* TO 'tony'@'%';

-- Example
create user 'demo'@'localhost' identified by '00';
grant all on *.* to 'demo'@'localhost';
```


# Install MongoDB CE

- 2017/11/26
- [Official MongoDB](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)

```sh

### ↓ 自行替換底下的版本!!!! (ex: 把 4.4 改成 5.0 或是 3.6 之類的)
cat <<"EOT" > /etc/yum.repos.d/mongodb-org-4.4.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOT


### Check Repo && Install
yum repolist | grep mongo
# mongodb-org-3.4/7       MongoDB Repository        90
# ↑ 已經配置好的 MongoDB Repository

### Install~~~
yum install -y mongodb-org

# 啟動~
systemctl start mongod.service
systemctl enable mongod.service
systemctl status mongod.service

mongod --version

ps auxw | grep -v grep | grep mongod
# mongod  8562  1.1  1.0 972408 41188 ?      Sl  20:43  0:01 /usr/bin/mongod -f /etc/mongod.conf
# ↑ 已經啟動了~                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ systemctl 預設的啟動方式
```


# Install Percona-Backup MongoDB

- 2021/08/19

可直接下載 Binary 或是透過 yum 的方式, 底下僅列出 Binary 的作法(簡單許多)

不然如果透過 yum 安裝的話, 會再安裝 `percona-release` 的 CLI <-- 功能雖強大, 但使用複雜度較高


### 法1. 直接安裝 binary

- [不同版本的 percona-Backup Binary 下載頁](https://www.percona.com/downloads/percona-backup-mongodb/)

```bash
wget https://downloads.percona.com/downloads/percona-backup-mongodb/percona-backup-mongodb-1.5.0/binary/redhat/7/x86_64/percona-backup-mongodb-1.5.0-1.el7.x86_64.rpm
yum localinstall percona-backup-mongodb-1.5.0-1.el7.x86_64.rpm -y
# ↑ 安裝了 3 個 CLI, 安置在 /bin/xxx

mkdir -p /data/mongodbbackup
chown -R pbm.pbm /data/mongodbbackup/
```


### 法2. 使用 yum

- [Installing Percona Backup for MongoDB](https://www.percona.com/doc/percona-backup-mongodb/installation.html#install-pbm-on-red-hat-enterprise-linux-and-centos)

```bash

```


# Install Visual Studio Code

- 2018/09/14
- [Official vscode](https://code.visualstudio.com/docs/setup/linux)

```sh
# 1. 編寫 Yum Repo
$# vim /etc/yum.repos.d/vscode.repo
###### 內容如下 ######
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
###### 內容如上 ######

# 2. Check Repo && Install
$# yum repolist | grep code
code        Visual Studio Code       44

$# yum -y install code
```


# Install Redis

- 2017/11/26 (2018/05/15, 2018/09/02 update)
- [Official Redis](https://redis.io/download)
- [cc not found 解法1](https://stackoverflow.com/questions/35634795/no-acceptable-c-compiler-found-in-path-while-installing-the-c-compiler)
- [cc not found 解法2](https://unix.stackexchange.com/questions/287913/cc-command-not-found-when-compiling-a-pam-module-on-centos?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
- [jemalloc not found 的解法](https://www.cnblogs.com/oxspirt/p/11392437.html)
- [Linode - Install and Configure Redis on CentOS 7](https://www.linode.com/docs/databases/redis/install-and-configure-redis-on-centos-7/)

```sh
# 安裝 Redis
$ sudo yum install epel-release
$ sudo yum install redis
$ sudo systemctl start redis
```


# Install Git (CentOS7 default repo -> git v-1.8 太舊了~~)
- 2017/11/26
- [How To Install Git on CentOS 7](https://blacksaildivision.com/git-latest-version-centos)
- [Choose a version](https://github.com/git/git/releases) ( 以2.14.3版為例 )
- [Choose a version 有時候Github會掛掉...](https://mirrors.edge.kernel.org/pub/software/scm/git/)

1. Dependancy
```sh
# 所需套件
$# yum install -y autoconf libcurl-devel expat-devel gcc kernel-headers openssl-devel perl-devel zlib-devel gettext-devel
# 上頭的 gettext-devel 會安裝 git 1.8.3
# 其實可以不安裝它... 只是最後, git 會被安裝在 /usr/local/bin/git
# root 環境變數裡面沒有它, 所以 root 要再設個軟連結~

### https://mirrors.edge.kernel.org/pub/software/scm/git/

# 下載 (v2.14.3)
$ wget https://github.com/git/git/archive/v2.14.3.tar.gz

# (v2.14.5)
$ wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.14.5.tar.gz
# (v2.19)
$ wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.19.1.tar.gz

# Install (v2.14.3)
$ tar zxf v2.14.3.tar.gz
$ cd git-2.14.3/
$ make clean
$ make configure
GIT_VERSION = 2.14.3
    GEN configure

$ ./configure --prefix=/usr/local
$ make
$# make install

$ git --version
git version 2.14.3
# DONE

# Install (v2.19)
$ mkdir git2.19
$ tar zxf git-2.19.1.tar.gz
$ cd git-2.19.1
$ make configure
GIT_VERSION = 2.19.1
    GEN configure

$ ./configure --prefix=/usr/local
$# make && make install
```

一般使用者可使用 git 了!!

但是 root 找不到 git, 解法如下:

```sh
$# git
bash: git: command not found...

$# echo $PATH
/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

$# ln -s /usr/local/bin/git /usr/local/sbin/git
#         ^^^^^ 可以連到這裡        ^^^^^ 藉由這裡

$# which git
/usr/local/sbin/git

$# git --version
git version 2.14.3
```





# Install net-tools

- 2017/11/26
- [centos7 最小化安装無網路服務](http://www.cnblogs.com/cocoajin/p/4064547.html)

```bash
$ ifconfig
bash: ifconfig: command not found

### Install
yum install -y net-tools

$ ifconfig
success!
```



# Install VLC

- 2017/11/26
- [How to Install EPEL on CentOS 7](https://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/)
- [How To Install VLC On CentOS 7](https://www.unixmen.com/install-vlc-centos-7/)
- [install vlc on CentOS7](https://stackoverflow.com/questions/29443096/how-to-install-vlc-on-centos7-from-terminal)

1. Install EPEL
```
$ wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo rpm -ivh epel-release-latest-7.noarch.rpm
```

2. Install
```
$ sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

$ sudo yum install vlc

$ vlc --V
VLC media player 2.2.5.1 Umbrella (revision 2.2.5-70-gaeea04d843)
vlc: unknown option or missing mandatory argument `-V'
Try `vlc --help' for more information
```



# Install teamviewer

- 2018/02/07
- [Install TeamViewer on CentOS 7 / RHEL 7](https://community.teamviewer.com/t5/Knowledge-Base/How-to-install-TeamViewer-Host-for-Linux/ta-p/6318?_ga=2.2833328.1279667713.1518017393-1552891207.1518017393)

```sh
$ wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

$ sudo yum install /tmp/epel-release-latest-7.noarch.rpm

$ wget https://download.teamviewer.com/download/linux/teamviewer.i686.rpm       # 32bits
$ wget https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm     # 64bits

$ sudo yum install teamviewer_13.0.6634.i686.rpm
# 不知道未啥... 我的無法安裝x86_64... 只好安裝這個32位元的

$ uname -m
x86_64
```



# Install 7zip
- 2017/11/26
- [e Learning](http://elearning.wsldp.com/pcmagazine/extract-7zip-centos-7/)

1. Dependancy && Install
```
$ sudo yum install -y epel-release

$ sudo yum install -y p7zip
```

2. Unzip
```
$ 7za x <fileName>
<password>
```



# Install Nginx

- 2018/03/19
- [Official](http://nginx.org/en/linux_packages.html#stable)
- [參考這邊](https://dotblogs.com.tw/grayyin/2017/05/18/183117)

```sh
# 1. 匯入 GPG-Key
curl http://nginx.org/keys/nginx_signing.key > nginx_signing.key
rpm --import nginx_signing.key

# 2. 建立 Yum Repo
cat <<"EOT" > /etc/yum.repos.d/nginx.repo
[nginx]
name=Nginx Repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=1
enabled=1
EOT

###### 內容如上 ######

### 3. Repolist && Install
yum repolist | grep nginx
# nginx/x86_64      Nginx Repo         108

yum install -y nginx

systemctl start nginx
systemctl enable nginx
systemctl status nginx

nginx -t

nginx -v
#nginx version: nginx/1.20.2
```

## Colorize nginx

- [Gist: vim-nginx-conf-highlight.sh](https://gist.github.com/ralavay/c4c7750795ccfd72c2db)

```bash
### 讓 vim 開啟 Nginx 配置有顏色~
# Download syntax highlight

mkdir -p ~/.vim/syntax/
wget https://www.vim.org/scripts/download_script.php?src_id=19394 --no-check-certificate -O ~/.vim/syntax/nginx.vim

# Set location of Nginx config file
cat > ~/.vim/filetype.vim <<EOF
au BufRead,BufNewFile /etc/nginx/*,/etc/nginx/conf.d/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
EOF

```


# Install tcping

- 2019/08/16
- 用來檢測域名可否正常訪問

```bash
$# vim /etc/yum.repos.d/tcping.repo
[tcping]
name=tcping repo
baseurl=https://download-ib01.fedoraproject.org/pub/epel/7/$basearch/
gpgcheck=0
enabled=1

$# yum repolist | grep tcping
tcping/x86_64            tcping repo                                      13,341

$# yum install -y tcping

### usage
$# tcping -t 5 www.google.com 80
www.google.com port 80 open.
```


# Install conntrack

```bash
$# yum install conntrack-tools

### Usage
$# conntrack -L
# 可以從 Kernel 來查看所有的 Connections
```

# Install Apache

- 2018/02/27
- [安裝Apache, MySQL, PHP](https://www.phpini.com/linux/redhat-centos-7-setup-apache-mariadb-php)

```sh
$ sudo yum install -y httpd

$ sudo systemctl start httpd
$ sudo systemctl enable httpd

$ httpd -v
Server version: Apache/2.4.6 (CentOS)
Server built:   Oct 19 2017 20:39:16
```
進入瀏覽器, 「localhost」就可以看到網頁了~


# Install Postgresql

- 2019/05/16
- [How to install PostgreSQL 11 on CentOS7](https://tecadmin.net/install-postgresql-11-on-centos/)

```sh
### 安裝 Postgresql 11
$# rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
$# yum install -y postgresql11-server

### init db
$# /usr/pgsql-11/bin/postgresql-11-setup initdb

### start
$# systemctl start postgresql-11.service
$# systemctl status postgresql-11.service

### Log in
$# psql -h <host> -p <port> -U <username> -W <password> <database>
```

```sql
-- 登入後的 Shell
DB=# \dn+
                          List of schemas
  Name   |  Owner   |  Access privileges   |      Description
---------+----------+----------------------+------------------------
 public  | postgres | postgres=UC/postgres+| standard public schema
         |          | =UC/postgres         |

DB=# \t
```


# Install Postgre-Client

- 2020/05/05
- [How to Install PostgreSQL on CentOS 7](https://www.hostinger.com/tutorials/how-to-install-postgresql-on-centos-7/)

僅安裝 psql client

```bash
$# yum install postgresql-contrib
# 安裝到 /bin/psql

$# psql --version
psql (PostgreSQL) 9.2.24

$# psql
```



# Install Python3

- 2022/01/04
- [官方Python下載](https://www.python.org/downloads/)

```sh
### 必要套件
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
# libffi-devel 專門給 python3.7+ 使用

### 為了要安裝「python-pip」
yum -y install epel-release

### 安裝 pip
yum install -y python-pip

### 下載 Python
VERSION=3.9.9
# ↑ 指定好要編譯安裝的版本

yum install -y wget
cd /usr/local/src
wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
# 自行到官網看看要抓哪一版~

tar zxf Python-$VERSION.tgz
cd Python-$VERSION
./configure \
  --enable-loadable-sqlite-extensions
# --enable-optimizations: 使用穩定優化的方式(會花比較久), 但是 python3.8+ 使用的話, 需要使用 8.1+ 的 gcc
# --enable-loadable-sqlite-extensions  使用 SQLite
# --prefix=/usr/local/bin/python 者指定要 compile install 到哪邊
# ※※※ 預設會安裝在 /usr/local/bin 底下, 想改路徑請使用 --prefix=/ANOTHER/PYTHON/PATH

### 環境變數
echo 'PYTHON_HOME=/usr/local/bin' >> ~/.bashrc
echo 'export PATH=${PYTHON_HOME}:${PATH}' >> ~/.bashrc
source ~/.bashrc
# 必須要先能找到 python3, 底下 make 才能成功

### 開始 Compile
make && make install
# -j 2: 使用Core

python3 --version
```


# Install Scala 2.13

- 2021/01/11


```bash
### 此非官方建議安裝方式, 自己純手動安裝的~
# 前往 Scala2 官網 https://www.scala-lang.org/download/scala2.html
# 挑許自己的版本
$# wget https://downloads.lightbend.com/scala/2.13.7/scala-2.13.7.rpm
$# yum install -y scala-2.13.7.rpm

$# scala --version
Scala code runner version 2.13.7 -- Copyright 2002-2021, LAMP/EPFL and Lightbend, Inc.

$# which scala
/bin/scala
```


# Install Java 11

- 2022/01/11
- [How to Install OpenJDK 11 on CentOS 7](https://sysadminxpert.com/install-openjdk-11-on-centos-7/)

```bash
### 安裝 JRE
$# yum install -y java-11-openjdk

$# which java
/bin/java

$# java --version
openjdk 11.0.13 2021-10-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.13+8-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.13+8-LTS, mixed mode, sharing)

### 安裝 JDK
$# yum install -y java-11-openjdk-devel

$# javac --version
javac 11.0.13
```


# Install Java 8

- 2021/12/27
- https://www.server-world.info/en/note?os=CentOS_7&p=jdk8&f=2

```bash
$# yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y

$# java -version
openjdk version "1.8.0_302"
OpenJDK Runtime Environment (build 1.8.0_302-b08)
OpenJDK 64-Bit Server VM (build 25.302-b08, mixed mode)

$# javac -version
javac 1.8.0_302
```


# Install SpringBoot

- 2021/10/04

```bash

```


# Install jdk1.8

- 2018/03/21
- [Official Orical jdk](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

兩種方法:

1. 拔掉 OpenJDK => OracleJRE,JDK
2. 純安裝(用環境變數來抓)

## 1. 連同 openjdk-JRE 一起拔掉, 換成 Oracle jdk

- [How to remove OpenJDK and install Oracle JDK](https://support.cafex.com/hc/en-us/articles/200874471-How-to-remove-OpenJDK-and-install-Oracle-JDK)

```sh
### rpm ================================
$# rpm -qa | grep jdk
# ↑ 慢慢移掉...

### 下載 rpm
$# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.rpm
# ↑ 到官方網址, 勾選同意 license 之後, 取代要下載的網址(版本更新的話)

### 安裝
$# rpm -ivh jdk-8u201-linux-x64.rpm

### tar ball ===========================
#下載 tarball
$# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz
# ↑ 到官方網址, 勾選同意 license 之後, 取代要下載的網址(版本更新的話)

$# tar -zxf jdk-8u201-linux-x64.tar.gz
$# mv jdk1.8.0_201/ ~/.
$# echo 'export JAVA_HOME=/root/jdk1.8.0_201' >> /etc/bashrc
$# echo 'export PATH=${JAVA_HOME}/bin:${PATH}' >> /etc/bashrc

$# java -version
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

$# javac -version
javac 1.8.0_191
```


## 2. 單純安裝其他版本(不動 JRE)

```sh
$ echo $PATH
/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/tony/.local/bin:/home/tony/bin

$ java -version
openjdk version "1.8.0_161"
OpenJDK Runtime Environment (build 1.8.0_161-b14)
OpenJDK 64-Bit Server VM (build 25.161-b14, mixed mode)
# 安裝之前~

$ wget https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz
# ↑ 無法直接使用... 網頁上需要點選 Accept License 才能下載XD 發Q~

$ mkdir ~/bin
$ tar -zxf jdk-8u191-linux-x64.tar.gz
$ mv jdk1.8.0_191/ ~/bin
$ echo 'export jdk_HOME="$HOME/bin/jdk1.8.0_191"' >> ~/.bashrc
$ echo 'export PATH=$jdk_HOME/bin:$PATH' >> ~/.bashrc

# 重起 terminal後
$ which java
~/bin/jdk1.8.0_191/bin/java

$ which javac
~/bin/jdk1.8.0_191/bin/javac

$ java -version
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

$ javac -version
javac 1.8.0_191
```


# Install KVM

- 2018/04/22
- [Install KVM Hypervisor](https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/)
- CentOS用的 VirtualBox....

```sh
# 檢測 CPU是否支援 硬體虛擬化
$ grep -E '(vmx|svm)' /proc/cpuinfo
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch invpcid_single intel_pt tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
# (會出現很多東西, 上面只是其中一項, 但我不知道這是啥), 看起來, 如果不是啥都沒有的話, 那應該就有支援 虛擬化了!!

$ sudo yum install -y qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer bridge-utils

$ lsmod | grep kvm
kvm_intel             174250  0
kvm                   570658  1 kvm_intel
irqbypass              13503  1 kvm

$ sudo systemctl start libvirtd

# 開始使用^O^
$ sudo virt-manager
```



# Install VirtualBox

- 2018/08/19
- [官網](https://www.virtualbox.org/wiki/Linux_Downloads)
- [RPM Resource libSDL-1.2.so.0](https://rpmfind.net/linux/rpm2html/search.php?query=libSDL-1.2.so.0()(64bit))

```sh
# 授權
$ wget https://www.virtualbox.org/download/oracle_vbox.asc
$ sudo rpm --import oracle_vbox.asc

# VirtualBox 相依套件
$ wget https://rpmfind.net/linux/centos/7.5.1804/os/x86_64/Packages/SDL-1.2.15-14.el7.x86_64.rpm
$ sudo rpm -Uvh SDL-1.2.15-14.el7.x86_64.rpm

# 抓主檔 && 安裝
$ wget https://download.virtualbox.org/virtualbox/5.2.18/VirtualBox-5.2-5.2.18_124319_el7-1.x86_64.rpm
$ sudo rpm -Uvh VirtualBox-5.2-5.2.18_124319_el7-1.x86_64.rpm
正在準備…                       ################################# [100%]
Updating / installing...
   1:VirtualBox-5.2-5.2.18_124319_el7-################################# [100%]

Creating group 'vboxusers'. VM users must be member of that group!

$ systemctl status vboxautostart-service
```



# Install `Development Tools`(gcc, make)

- 2018/06/16
- [bash - make command not found](https://stackoverflow.com/questions/21700755/bash-make-command-not-found)
- [cc: Command not found](https://unix.stackexchange.com/questions/287913/cc-command-not-found-when-compiling-a-pam-module-on-centos?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)

發生 `bash make command not found` ==> 無法編譯 tarball 阿~~~

```sh
# 不知道這是不是一個好的解法... 一口氣安裝超級大一包
$ sudo yum groupinstall "Development Tools"

# Note : "Development Tools" => yum CentOS
# Note : "build-essential" => apt Ubuntu
```



# Install unrar

- [Linux rar](https://www.phpini.com/linux/linux-extract-rar-file)
- 2018/06/16

```sh
$ sudo yum install unrar

$ unrar e <file.rar>    # 解壓縮到當前目錄
$ unrar l <file.rar>    # 列出壓縮黨內的目錄
$ unrar t <file.rar>    # 測試壓縮檔是否完整
# 有密碼的話, 後面在接著輸入
```



# Install Node.js

- 2018/09/14
- [官網](https://nodejs.org/en/)

```sh
$ wget https://nodejs.org/dist/v10.7.0/node-v10.7.0-linux-x64.tar.xz        # 10.7
$ wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz        # 8.11
$ wget https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.xz      # 12.18

$ tar xJf node-v10.7.0-linux-x64.tar.xz     # 解壓縮xz 10.7
$ tar xJf node-v8.11.3-linux-x64.tar.xz     # 解壓縮xz 8.11

$ cd node-v10.7.0-linux-x64/
$ cd node-v8.11.3-linux-x64/

$ mkdir ~/bin
$ ln -s /home/tony/Downloads/node-v8.11.3-linux-x64/bin/node ~/bin/node # v8.11
#         ^^^^^ 可以連到這裡                                      ^^^^^ 藉由這裡

$ node --version
v8.11.3
```



# Install PhantomJS

- [Install PhantomJS on CentOS](https://www.bonusbits.com/wiki/HowTo:Install_PhantomJS_on_CentOS)

```sh
$ sudo yum install fontconfig freetype freetype-devel fontconfig-devel libstdc++

$ wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2

$ sudo mkdir -p /opt/phantomjs

$ tar jxf phantomjs-1.9.8-linux-x86_64.tar.bz2

$ rm phantomjs-1.9.8-linux-x86_64.tar.bz2
$ sudo mv phantomjs-1.9.8-linux-x86_64/* /opt/phantomjs/
$ rmdir phantomjs-1.9.8-linux-x86_64/
$ ln -s /opt/phantomjs/bin/phantomjs ~/bin/phantomjs
#         ^^^^^ 可以連到這裡             ^^^^^ 藉由這裡
```



# Install golang

- 2018/09/14

```sh
# Download && untar
$ wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz

$ tar -C ~/. -xzf go1.11.linux-amd64.tar.gz

$ echo "export PATH=/home/${USER}/go/bin:\$PATH" >> ~/.bashrc

$ go version
go version go1.11 linux/amd64
```



# Install Jenkins

```bash
### LTS 安裝方式
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum update
yum install jenkins java-11-openjdk-devel
systemctl daemon-reload
```

設定主檔 `/etc/sysconfig/jenkins`

```bash
systemctl start jenkins
systemctl enable jenkins
systemctl status jenkins
```


# Install supervisor

- 2019/05/02

```sh
$# yum install -y supervisor
$# systemctl start supervisord

$# vim /etc/supervisord.conf
# 裏頭的 [unix_http_server] 段, chown 改成 0777 會比較好做事情... 但安全性就不曉得了@_@
```


# Install chromedriver

```bash
### selenium 用
echo "Installing Chromedriver..."
wget https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/local/bin
```


# Install psmisc(fuser)

- 2019/07/19

```bash
### 這個套件包含了 fuser
$# yum install -y psmisc
```

# Install Zabbix-Server 4.0

- 2020/12/05
- [官網](https://www.zabbix.com/download?zabbix=4.0&os_distribution=centos&os_version=7&db=mysql&ws=apache)
- [官網](https://www.zabbix.com/documentation/4.0/manual/installation/install_from_packages/rhel_centos)
- [How to Install Zabbix Server 4.0 on CentOS 7](https://computingforgeeks.com/how-to-install-zabbix-server-4-0-on-centos-7/)
- [How To Install Zabbix Server 3.4 on CentOS/RHEL 7/6](https://tecadmin.net/install-zabbix-network-monitoring-on-centos-rhel-and-fedora/)
- http://localhost/zabbix

Zabbix, 只是個統稱, 它包含了底下三個元件:

- database
- zabbix-server
  - database(mysql/postgres)
  - monitor GUI(php, apache)
- front-end


### Part 1. 安裝

```bash
### 安裝
rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
# ↑↓ 不知道差在哪.... 4.0-1 及 4.0-2.....
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
yum clean all

yum install -y zabbix-get zabbix-agent zabbix-server-mysql zabbix-web-mysql 

yum install -y mariadb-server  # 或是使用 Oracle MySQL, 但要留意會有一點點點點點點點不同@@!

systemctl start zabbix-server
```

### Part2. DB 部分

```bash
systemctl start mariadb
mysql
# Mariadb 預設可無密碼登入 root
```

```sql
--#; 編碼必須是 utf8 && 定序必為 utf8_bin
CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES on zabbix.* to zabbix@localhost IDENTIFIED BY 'zabbix';
```

```bash
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql zabbix
# 建立 zabbix server 存資料的地方 && 倒 schema 進去
```

### Part 3. 組態

```bash
cat /etc/zabbix/zabbix_server.conf
sed -i 's/# DBPassword=/DBPassword=UGf!i_Jg%ao29&7J/' /etc/zabbix/zabbix_server.conf
# ↑ 設定密碼
```

### Part 4. 前端

```bash
cat /etc/httpd/conf.d/zabbix.conf
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Taipei/' /etc/httpd/conf.d/zabbix.conf
# 修改預設時區
```

### Part 5. 啟動

```bash
### mysql 部分 (安裝完後)
mysql> CREATE DATABASE zabbix CHARACTER SET UTF8;
mysql> CREATE USER zabbix@localhost IDENTIFIED BY 'GtKpcWmD88tN4Vye';
mysql> GRANT ALL PRIVILEGES on zabbix.* to zabbix@localhost IDENTIFIED BY 'password';
mysql> FLUSH PRIVILEGES;
$# zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uroot -p zabbix
$# zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uroot -p zabbix
# 建立 zabbix server 存資料的地方 && 倒 schema 進去

$# vim /etc/zabbix/zabbix_server.conf
# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  DBHost=localhost
  DBName=zabbix
  DBUser=zabbix
  DBPassword=password
# ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

$# systemctl start zabbix-server
```


# Install zabbix-proxy 4.0

前置步驟幾乎同 zabbix-server, 略

```bash
yum install -y zabbix-proxy-mysql
```

```sql
create database zabbix_proxy character set utf8 collate utf8_bin;
GRANT ALL PRIVILEGES on zabbix_proxy.* to zabbix@localhost IDENTIFIED BY 'zabbix';
```

```bash
zcat /usr/share/doc/zabbix-proxy-mysql-*/schema.sql.gz | mysql zabbix_proxy
### ↑ 初始化 DB

sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_proxy.conf
# 修改組態
```


# Install zabbix-agent 4.0

- 2020/12/25
- [ZabbixOfficial-zabbix-packages](https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/)

```bash
$# VERSION=4.0.31
$# rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-agent-${VERSION}-1.el7.x86_64.rpm

### Config
$# vim /etc/zabbix/zabbix_agentd.conf
# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
#Server=[zabbix server ip]
#Hostname=[ Hostname of client system ]

Server=192.168.2.158,192.168.1.200  # ← 誰可以監控我
Hostname=vm157                      # ← 我這台 Agent 叫啥
# ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

$# systemctl start zabbix-agent

### 防火牆, SELinux...
```


# Install php72 && php-fpm 7.2

```bash
$# yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
$# yum-config-manager --enable remi-php72

### 安裝 php72 和 php 好像有一些步一樣@@凸??
$# yum install php php-fpm php-mysql -y

$# yum list installed | grep php
#php.x86_64                       7.2.34-6.el7.remi            @remi-php72
#php-cli.x86_64                   7.2.34-6.el7.remi            @remi-php72
#php-common.x86_64                7.2.34-6.el7.remi            @remi-php72
#php-fpm.x86_64                   7.2.34-6.el7.remi            @remi-php72
#php-json.x86_64                  7.2.34-6.el7.remi            @remi-php72
#php-mysqlnd.x86_64               7.2.34-6.el7.remi            @remi-php72
#php-pdo.x86_64                   7.2.34-6.el7.remi            @remi-php72

$# php -v
PHP 7.2.34 (cli) (built: Jun 28 2021 11:21:49) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
```


# Install zabbix-server 5.0

- [Download and install Zabbix](https://www.zabbix.com/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=nginx)
- 2021/08/03

此步驟會安裝 zabbix-server 5.0.x && zabbix-web-nginx

```bash
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all

yum install zabbix-server-mysql -y
yum install centos-release-scl -y

yum-config-manager --enable zabbix-frontend
# ↑ 這個動作會把 /etc/yum.repo.d/zabbix.repo 的 [zabbix-frontend] 的 enabled=0 改成 1

### 開始安裝前端
yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl
# 會安裝 zabbix-nginx-conf-scl && zabbix-web-mysql-scl 5.0.x
# 以及相依賴的 rh-php72-OOO && rh-nginx116-OOO

### 修改 php-fpm 配置
vim /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
# 1. listen.acl_users = apache,nginx
# 2. php_value[date.timezone] = Asia/Taipei
### ↑ 修改上面 2 個配置

### 進入 mysql -----------------------------
# 底下使用的是 Oracle MySQL 5.7
# Part1. User

# Part2. DB
CREATE DATABASE zabbix CHARACTER set utf8 COLLATE utf8_bin;
CREATE USER zabbix@'%' IDENTIFIED BY 'zabbix';
GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@'%';
FLUSH PRIVILEGES;
quit;

# 倒資料~
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix zabbix -p  # 如果有密碼的話再 -p

### ↓ 去裡面配置 mysql 相關資訊
vim /etc/zabbix/zabbix_server.conf

### 法一, 使用 zabbix-server 外掛的 Nginx
#systemctl start rh-nginx116-nginx 
#systemctl enable rh-nginx116-nginx 

### 法二, 自行維護 Nginx
cp /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf /etc/nginx/conf.d/zabbix.conf

### 啟動 php-fpm
systemctl start rh-php72-php-fpm
systemctl enable rh-php72-php-fpm
systemctl start zabbix-server
systemctl enable zabbix-server
```


# Install Zabbix-Percona

- [Installing Percona Server for MySQL on Red Hat Enterprise Linux and CentOS](https://www.percona.com/doc/percona-server/LATEST/installation/yum_repo.html)
- [Percona Monitoring Plugins for Zabbix](https://www.percona.com/doc/percona-monitoring-plugins/LATEST/zabbix/index.html)

### Step1. Install

```bash
### percona yum.repo
yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm

### Install
yum install percona-zabbix-templates

mkdir -p /etc/zabbix/agent_bin
mkdir -p /etc/zabbix/zabbix_agent.d
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agent.d/
cp /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh /etc/zabbix/agent_bin/
cp /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php /etc/zabbix/agent_bin/
```

### Step2. Config

```bash
### 依照 MySQL 連線資訊做配置
vim /etc/zabbix/agent_bin/get_mysql_stats_wrapper.sh
vim /etc/zabbix/agent_bin/ss_get_mysql_stats.php
```


# Install squid

- 2019/12/30

```bash
### Proxy 伺服器
yum install -y squid

systemctl start squid
```


# Install snapd

- 2022/01/04
- https://snapcraft.io/install/jsonnet/rhel

```bashrc
yum install -y snapd

systemctl start snapd
systemctl enable snapd
systemctl status snapd

# To enable classic snap support, enter the following to create a symbolic link between /var/lib/snapd/snap and /snap:
ln -s /var/lib/snapd/snap /snap
# ↑ 不知道這在幹嘛的...
```


# Install jsonnet

- 2022/01/04
- https://snapcraft.io/install/jsonnet/rhel

```bashrc
### 先安裝好 snapd
$# snap install jsonnet
# ↑ 沒辦法帶 -y... QAQ

### logout && login
$# which jsonnet
/var/lib/snapd/snap/bin/jsonnet
```


# Install Redis GUI

- 2019/08/06
- [Win 及 Mac 似乎要 License, 但 Linux 似乎不用...?](https://github.com/uglide/RedisDesktopManager)
- [How to install RedisDesktopManager on CentOS](https://snapcraft.io/install/redis-desktop-manager/centos#install)
- [Redis Desktop Manager - Quick Start](http://docs.redisdesktop.com/en/latest/quick-start/)

```bash
### 必須先安裝好 snapd
$# snap install redis-desktop-manager

### 如果發生下面的錯誤訊息 ----
error: cannot perform the following tasks:
- Download snap "core" (7396) from channel "stable" (Get https://fastly-global.cdn.snapcraft.io/download-origin/fastly/99T7MUlRhtI3U0QFgl5mXXESAiSwt776_7396.snap?token=1567663200_c1175619102aaa846a99bebd0325ea39d4555194: x509: certificate has expired or is not yet valid)
# ---------------------------
# 作時間校正後, 即可安裝. 參考 https://stackoverflow.com/questions/55234385/how-to-ignore-certificates-check-in-snap-on-ubuntu

### 時間校正
$# systemctl start chronyd
$# chronyc sources -v
# 以上是透過 time server 作校時, 視情況用手動
```


# Install k8s

- 2021/03/08
- [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

```bash
### 下面我有改過... 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

### SELinux 問題... 為了開發方便...... 斟酌使用
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# 不懂 --disableexcludes 在幹嘛
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

kubelet --version
Kubernetes v1.20.4
```


# Install iptables

```bash
yum install iptables-services -y

systemctl stop firewalld
systemctl disable firewalld
# iptables 無法 & 不應 與 firewalld 共同啟用
systemctl start iptables
systemctl enable iptables
systemctl status iptables

```


# Install ip CLI

- 2020/11/02

```bash
### bash: ip: command not found
$# yum install -y epel-release
$# yum install -y iproute
```


# Install htpasswd

- 2020/04/10

為了能夠使用 htpasswd CLI

```bash
$# yum install -y httpd-tools
```


# Install nmap

- 2021/01/30

```bash
yum install -y nmap
```


# Install acme.sh

- 2021/08/31
- [How to install](https://github.com/acmesh-official/acme.sh/wiki/How-to-install)
- 建議安裝以前, 先安裝 `socat`

```bash
### 官方建議安裝在 root 底下, 但沒有必要
$ MAIL=cool21540125@gmail.com
$ curl https://get.acme.sh | sh -s email=${MAIL}
### ↑ 先安裝完 scoat 再來弄這個
```


# Install socat

```bash
yum install socat
```

# Install sysstat

```bash
### 裏頭含有常用的監控工具
$# yum install -y sysstat
# The iostat command reports CPU utilization and I/O statistics for disks.
# The tapestat command reports statistics for tapes connected to the system.
# The mpstat command reports global and per-processor statistics.
# The pidstat command reports statistics for Linux tasks (processes).
# The nfsiostat-sysstat command reports I/O statistics for network file systems.
# The cifsiostat command reports I/O statistics for CIFS file systems.
```


# Install nfs-utils

```bash
### 許多 NFS 的 CLI
$# yum install -y nfs-utils
```


# Install dos2unix

這東西常被我誤認成 `doc2unix`... =.=

```bash
yum install -y dos2unix
```


# Install RabbitMQ

- [Install on Older Distributions (CentOS 7, RHEL 7) Using PackageCloud Yum Repository](https://www.rabbitmq.com/install-rpm.html#yum-legacy)

```bash
## primary RabbitMQ signing key
$# rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
## modern Erlang repository
$# rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey
## RabbitMQ server repository
$# rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey


$# vim /etc/yum.repos.d/rabbitmq.repo
####################################### 內容如下 #######################################
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

##
## RabbitMQ server
##

[rabbitmq_server]
name=rabbitmq_server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_server-source]
name=rabbitmq_server-source
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
####################################### 內容如上 #######################################

## 2021/10/13 的今天, 安裝的版本如下:
$# yum install socat logrotate -y
## socat-1.7.3.2-2.el7.x86_64

$# yum install erlang rabbitmq-server -y
# rabbitmq-server-3.9.7-1.el7.noarch
# erlang-23.3.4.7-1.el7.x86_64

$# systemctl start rabbitmq-server
$# systemctl enable rabbitmq-server
$# systemctl status rabbitmq-server
```


# Install gcc

- 2022/01/04
- [[Centos7] 升級gcc/gcc-c++ 由5.8版升級到9.3版](http://n.sfs.tw/content/index/14840)

還沒 k 文件, 改天補上

需要升級 `gcc` 的情境之一像是, 編譯安裝 python3.8+ 以上時, 如果指定要 `--enable-optimizations`, 會被告知需要 gcc 8.1+ 以上版本才行

```bash
### CentOS7 已有內建的 gcc
$# gcc --version
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 但是這個版本是 2015 年的老舊東西了~

### Update gcc
待補充
```


# Install jsonnet


```bash
### 目前沒找到已經編譯好的 jsonnet, 所以自行到 github 來處理了 ~_~
cd /usr/local/src
git clone https://github.com/google/jsonnet.git
cd jsonnet
git checkout v0.18.0

# ↓ 比需先裝好 GCC 才能處理 (而且版本還不能太舊)
make

cp jsonnet /usr/local/bin/
jsonnet --version
# Jsonnet commandline interpreter v0.18.0
### ---------------------------------------------

### ↓ Example Usage for CLI
jsonnet -e "{Description: 'jsonnet 把字串變成 json 了'}"

### ↓ Example Usage for file
cat <<EOF > /tmp/demo.jsonnet
local Flavor(spicy) = {
  ingredients: ['番茄醬', '沙拉',],
  [if spicy then '加辣']: '多到爆',
};
{
  Food1: Flavor(true),
  'Food2': Flavor(false),
}
EOF
jsonnet /tmp/demo.jsonnet
```


# 語言套件

- 2018/10/04


```sh
# 想要輸入中文的話, 裝這些吧
$# yum install ibus* cjk*
```


# 備註

- $basearch : x86_64 (位元架構)
- $releasever : CentOS7 的 7 (大版本號)
