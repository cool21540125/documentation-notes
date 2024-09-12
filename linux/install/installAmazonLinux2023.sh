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
# https://linux.how2shout.com/how-to-install-nvm-on-amazon-linux-2023/
sudo dnf update
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
nvm --version

###
