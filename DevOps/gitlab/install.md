
# Gitlab in Docker

- 2019/05/16
- [Docker install GitLab](https://docs.gitlab.com/omnibus/docker/)
- [CentOS7 install GitLab](https://about.gitlab.com/install/#centos-7)

運行 GitLab Docker image 有多種方式

- Docker Engine 運行 image
- Cluster 中, 安裝 GitLab
- Docker-compose 安裝 GitLab

# 法1. CentOS

- 2019/05/17
- 不知為啥... 今年1月一直卡, 現在不知不覺就可以使用了

```bash
sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld

sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

### 會執行一陣子
sudo EXTERNAL_URL="https://gitlab.example.com" yum install -y gitlab-ce
# URL 可自行修改

```

設定完成之後, 得做 reconfigure

```bash
### re-run Container
$# docker restart gitlab
# 這個似乎會有問題... 發現 port mapping... 都不見了

### 強制移除 Container
$# docker rm gitlab --force
# 記得東西還在 /srv/gitlab
```

###### HTTP Response 422 : Bad Cookie 問題... 清空 storage 即可
