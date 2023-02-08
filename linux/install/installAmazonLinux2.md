


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
