#!/bin/bash
exit 0
# -------------------------

### ================== Install nginx ==================
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
systemctl status nginx

### ================== Install golang ==================
sudo dnf install golang

### ================== Install MySQL ==================
# 2024/09
wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo dnf install mysql-community-client -y

### ================== Install docker ==================
sudo yum install -y docker
sudo systemctl start docker
docker --version
# 25.0.5

### (不知道為啥... docker compose command no found)
# https://serverfault.com/questions/1146596/how-to-install-docker-compose-on-al2023
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m) -o /usr/bin/docker-compose && sudo chmod 755 /usr/bin/docker-compose && docker-compose --version

### ================== Install nvm ==================
# https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# 隨時上網看最新版

source ~/.bashrc
nvm install 22

### ================== Install yq ==================
# https://github.com/mikefarah/yq - 查看版本
VERSION=v4.44.5
BINARY=yq_linux_amd64
BINARY=yq_linux_arm64
sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq
sudo chmod +x /usr/bin/yq

###
