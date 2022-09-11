


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


# 