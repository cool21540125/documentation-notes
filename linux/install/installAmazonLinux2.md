


# Install docker

```bash
$# yum install -y docker
$# 
$# VERSION=1.29.2
$# curl -L "https://github.com/docker/compose/releases/download/$VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```


# Install Amazon ECS container agent

- 2022/09/03
- [Installing the Amazon ECS container agent on an Amazon Linux 2 EC2 instance](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html#ecs-agent-install-al2)
    - 如果想要使用 `EC2 Launch Type 的 ECS`, 機器上面需要安裝 **ECS agent** 或稱 **Container Agent**
    - 這篇講解各種 AMI 配置及安裝方式 (當然包含煩人的 IAM)
        - 除非一開始 EC2 就直接使用 `Amazon ECS-optimized AMI` (否則都要來設定 ~"~)
    - 如果 EC2 有使用 user data 來做 docker 以及 ECS, 需要留意一個 Issue!!
        - 兩者都依賴於 `cloud-init`, 因此會形成 deadlock, 所以需要加入底下這行:
            - `systemctl enable --now --no-block ecs.service`

```bash
### 非 Amazon ECS-optimized AMI 自行安裝 ECS agent (Container Agent) 來作為 EC2 launch type 的 capacity provider
$# sudo amazon-linux-extras disable docker
$# sudo amazon-linux-extras install -y ecs
$# sudo systemctl enable --now ecs

### 檢查 ECS agent 是否 running
$# curl -s http://localhost:51678/v1/metadata | python -mjson.tool
```


# Install ansible

- 2022/09/06

```bash
$# sudo amazon-linux-extras install ansible2 -y

$# ansible --version
ansible 2.9.23
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/ec2-user/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.18 (default, May 25 2022, 14:30:51) [GCC 7.3.1 20180712 (Red Hat 7.3.1-15)]

$# 
```


# Install stress

壓測工具

```bash
### Install
$# sudo amazon-linux-extras install epel -y
$# sudo yum install stress -y

### Usage
$# stress -c 4
# 讓 4 個 CPU 飆到 100%

### 配置 250M
$# stress --vm 1 --vm-bytes 250M --vm-hang 1
```


# Install kubernetes (install k8s)

- 2023/02/07
- [Install K8s v1.25 on AWS Amazon Linux 2](https://blog.devgenius.io/install-k8s-v1-25-on-amazon-linux-2-e2a717444736)
- 使用 kubeadm
    - 建立 Contral Plane: `kubeadm init ...`
    - 加入 Cluster: `kubeadm join ...`

```bash
### yum repo
$# cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF


### 處理 SELinux
$# setenforce 0
$# sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' 


### install
$# yum install -y kubelet-1.25.0-0 kubeadm-1.25.0-0 kubectl-1.25.0-0 --disableexcludes=kubernetes


### Start kubeadm
$# systemctl enable --now kubelet


### 安裝 Container runtime
# cri-o : https://github.com/cri-o/cri-o/releases?q=&expanded=true
$# wget https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.25.0.tar.gz
$# tar -zxf cri-o.amd64.v1.25.0.tar.gz
$# cd cri-o
$# ./install
# 目前出現底下錯誤(僅節錄錯誤部分)
# install: failed to access ‘/usr/local/share/oci-umount/oci-umount.d’: No such file or directory
# install: failed to access ‘/etc/crio’: No such file or directory
# install: failed to access ‘/etc/crio/crio.conf.d’: No such file or directory
# install: failed to access ‘/usr/local/lib/systemd/system’: No such file or directory
# ++ command -v runc
#


### Create Control Plane
$# 
```


# Install CloudWatch Agent - DEPRECATED

- 2023/03/14
- 建議使用 CloudWatch unified agent

```bash
### 建議使用 unified agent
yum install amazon-cloudwatch-agent -y

### 啟動 CloudWatch Agent 的時候, 需要 agent config (Schema definition)

## ====== 法1. 使用 wizard 來生成 agent config
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# 上述詢問後生成的檔案位置
vim /opt/aws/amazon-cloudwatch-agent/bin/config.json
# IMPORTANT: 若要把 config 寫入 SSM, 需要先給 CloudWatchAgentAdminPolicy
# 若不使用 SSM, 則給 CloudWatchAgentServerPolicy

### ====== 法3. 客製化配置
vim /opt/aws/amazon-cloudwatch-agent/doc/amazon-cloudwatch-agent-schema.json
# 暫時不鳥這個=..=
# 很多東西都要手動自己來...

### 先建出底下結構... CloudWatch agent 啟動時需要這個
mkdir -p /usr/share/collectd/ && touch mkdir /usr/share/collectd/types.db

### 啟動 CloudWatch Agent (等同於 systemctl start + enable)

## ====== 法一. 使用 SSM 上的 agent config 啟動 CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c ssm:${Name_of_CloudWatch_Config_in_SSM_Parameter} -s

## ====== 法二. 使用 local 的 agent config 啟動 CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:${CloudWatch_Config_LocalFileName} -s

# 完成以後, CloudWatch logs && CloudWatch metrics 就能看到東西了
```


# Install CloudWatch Unified Agent

- 2023/03/14

```bash
$# 
```


# Install Nginx

- 2023/04/14

```bash
### Install Nginx
amazon-linux-extras install -y nginx1

systemctl start nginx
systemctl enable nginx

nginx -version
#nginx version: nginx/1.22.1  (2023/04/14)
```


# Install Nodejs

- https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
- 2023/04/14

```bash
### Install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts


### Install specific version
nvm install 16


### Show Version
node --version
#v16.20.0
```
