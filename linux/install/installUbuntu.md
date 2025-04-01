install xxx on Ubuntu

# misc

```bash
### 更改預設 desktop, music等資料夾
vim ~/.config/user-dirs.dirs
```

# Install ps

```bash
# ps command not found
apt install -y procps
```

# Install ss

```bash
# ss command not found
apt-get install -y iproute2
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

## MongoDB 設定檔修改

| parameter | default  |
| --------- | -------- |
| dbpath    | /data/db |
| logpath   | (Null)   |
| bind_ip   | 0.0.0.0  |
| port      | 27017    |

### mongo.cfg 範例

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
### Amazon Ubuntu24.04
apt update

apt install docker.io

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

### Macbook(M1) install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-kubectl-binary-with-curl-on-macos
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
curl -LO "https://dl.k8s.io/release/v1.30.5/bin/darwin/arm64/kubectl"  # 指定版本

chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl

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

# Install sshd

Install ssh server

```bash
### Ubuntu18.04 沒有內建 ssh-server
apt install openssh-server -y

systemctl start sshd
systemctl enable sshd
systemctl status sshd
```

# Install collectd

```bash
### collectd protocol. 用來搜集 logs 使用的一種協定
apt-get install collectd -y
```

# Install CloudWatch Unified Agent

- [Verifying the signature of the CloudWatch agent package](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/verify-CloudWatch-Agent-Package-Signature.html)

```bash
### ========================= 可省略的驗證步驟 =========================
### AWS Public Key
wget https://amazoncloudwatch-agent.s3.amazonaws.com/assets/amazon-cloudwatch-agent.gpg


gpg --import amazon-cloudwatch-agent.gpg
# key: D58167303B789C72
# ~/.gnupg/secring.gpg

### 依照 PUBLIC KEY 產出的 finger print
gpg --fingerprint D58167303B789C72
# 9376 16F3 450B 7D80 6CBD  9725 D581 6730 3B78 9C72
# 務必與官網比對, 如果指紋不一樣, 表示此 Public 為 偽造
# ------------------ 若為偽造, 不要再繼續往下做了 ------------------


### 下載 deb
# Global 下載路徑(很慢)
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb # x86_64
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb # arm

# Regional 下載路徑
wget https://amazoncloudwatch-agent-us-west-2.s3.us-west-2.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb


### 下載 deb.sig
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb.sig


### 驗證 deb 及 sig 檔案, 並與稍早 import 的 public key 比對
gpg --verify amazon-cloudwatch-agent.deb.sig amazon-cloudwatch-agent.deb


### ========================= Install =========================
### 下載 deb (上面下載過了的話則可免)
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
# Config Path: /opt/aws/amazon-cloudwatch-agent/etc/
# Main Config: /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
```

# Install squid

- https://ubuntu.com/server/docs/how-to-install-a-squid-server
- 使用 CodeBuild proxy server - squid - https://docs.aws.amazon.com/codebuild/latest/userguide/use-proxy-server-transparent-components.html

```bash
### Install
sudo apt install squid


###
```

# Install SSM Agent on EC2

- https://docs.aws.amazon.com/systems-manager/latest/userguide/agent-install-ubuntu-64-snap.html
- https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent-status-and-restart.html
- EC2 Ubuntu install SSM Agent / EC2 install SSM Agent

```bash
### 安裝 SSM Agent
sudo snap install amazon-ssm-agent --classic

sudo snap start amazon-ssm-agent # 自帶 enable

snap list amazon-ssm-agent
systemctl status snap.amazon-ssm-agent.amazon-ssm-agent

sudo snap stop amazon-ssm-agent



### 刪除 SSM Agent
sudo dpkg -r amazon-ssm-agent
```

# Install ifconfig

> ifconfig: command not found

```bash
apt install net-tools
```

# Install neo4j

https://neo4j.com/docs/operations-manual/current/installation/linux/debian/

```bash
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/neotechnology.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/neotechnology.gpg] https://debian.neo4j.com stable 5' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
echo 'deb [signed-by=/etc/apt/keyrings/neotechnology.gpg] https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
sudo apt-get update

apt list -a neo4j

sudo add-apt-repository universe

sudo apt-get install neo4j=1:5.25.1

sudo vim /etc/neo4j/neo4j.conf
#server.default_listen_address=0.0.0.0

sudo systemctl start neo4j
sudo systemctl enable neo4j
systemctl status neo4j
```

# Install CloudWatch Agent

# Install golang

```bash
# 24.04 已經無須再安裝額外的 repo 可直接安裝
sudo apt update
sudo apt install golang-go
```

# Install nvm

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm --version

nvm install 22
```
