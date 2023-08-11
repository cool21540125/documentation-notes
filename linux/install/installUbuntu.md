
install xxx on Ubuntu


# dpkg intro

- 早期(2017/03) 學 Ubuntu的筆記

- dpkg 為 Debian-based 系統管理增刪建立套件的相關指令

```sh
# 顯示所有已安裝套件
$ dpkg -l

# 安裝了哪些相關套件, ex: python
$ dpkg -l | grep python

# 特定套件所安裝的所有檔案, ex: python
$ dpkg -L python

# 某資料夾底下有多少個 installed package
$ dpkg -S /usr

# 更改預設 desktop, music等資料夾
$ gedit ~/.config/user-dirs.dirs
```


# Install MongoDB

- 2018/06/23

```sh
# 安裝:
# 版本可能會改變...(到官方網站看最新版本)
$ wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.2.tgz

# 執行解壓縮
$ tar -xf mongodb-linux-x86_64-ubuntu1604-3.4.2.tgz

# 建立資料庫儲存的目錄
$ sudo mkdir /data

# 進入解壓縮後的monboDB資料夾
$ cd /data
$ cd mongodb-linux-x86_64-ubuntu1604-3.4.2

# (無安裝)啟動MongoDB
$ sudo ./mongod
# 如果看到... 
# 2017-03-20T19:28:31.684+0800 I NETWORK  [thread1] waiting for connections on port 27017
# 表示已經成功啟動MongoDB

# 安裝檔案 (目前位於:MongoDB的安裝資料夾裡頭的bin)
$ cd bin
$ sudo ./mongod --logpath=/data/mongo.log --fork
# (出現下列，表示啟用成功)
sudo: unable to resolve host tony
about to fork child process, waiting until server is ready for connections.
forked process: 2822
child process started successfully, parent exiting

# 查看是否有MongoDB在背執行
$ ps -aux | grep mongo
$ netstat -nao | grep 27017
```


## MongoDB設定檔修改

parameter | default
--------- | -------------------
dbpath    | /data/db
logpath   | (Null)
bind_ip   | 0.0.0.0
port      | 27017


### mongo.cfg範例

```cfg
bind_ip = 127.0.0.1
port = 10000
dbpath = data/db
logpath = data/mongod.log
logappend = true
journal = true
```


# Install JDBC Driver
- [安裝 MySQL JDBC](http://stackoverflow.com/questions/18128966/where-is-the-mysql-jdbc-jar-file-in-ubuntu)

```sh
$ sudo apt-get install libmysql-java

# 如此一來, /usr/share/java/mysql.jar
# 就會出現了!
```


# Install docker

```bash
### Set up repository
# $# apt-get remove docker docker-engine docker.io containerd runc
$# apt-get update
$# apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

### official GPG key
$# mkdir -p /etc/apt/keyrings
$# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

### Set up repository
$# echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

### install docker latest
$# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 如果要安裝特定版本, 參考:
#    https://docs.docker.com/engine/install/ubuntu/

$# systemctl start docker
$# systemctl enable docker
```


# Install kubectl

```bash
### download && check
apt-get install -y curl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
#kubectl: OK
```


# Install k8s / Install kubernetes

- 2023/08
- ![Install Kubernetes](./installK8s.md)

```bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl


### Google Cloud public signkey && k8s repo
curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

mkdir -p /etc/apt/keyrings
sudo apt-get install -y kubeadm kubectl
sudo apt-mark hold kubeadm kubectl
```


# 
