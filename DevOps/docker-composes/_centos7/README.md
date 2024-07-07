
# 測試用 CentOS7 Container

```bash
docker rm --force -v os7

docker run -itd \
    --name=os7 \
    --restart=always \
    --privileged=true \
    centos:7
docker exec -it os7 bash

yum install -y epel-release
yum install -y iproute
yum install -y vim
yum install -y nginx
systemctl start nginx
systemctl enable nginx
yum install -y wget
yum install -y git
yum install -y net-tools
yum install -y telnet

cd ~
wget https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.xz
tar xJf node-v12.18.4-linux-x64.tar.xz

export PATH="/root/node-v12.18.4-linux-x64/bin:${PATH}"

npm install -g @angular/cli

ssh-keygen -C "tony@mac-os7-container" -f ~/.ssh/id_rsa -P ''
cat ~/.ssh/id_rsa.pub

mkdir ~/proj
cd ~/proj
git clone git@github.com:cool21540125/angular-map.git
cd angular-map
npm install
npm run prod
```

```bash
# Lan IP
hostname -I

vim /etc/nginx/conf.d/server.conf
#server {
#
#    listen 34200;
#    server_name localhost;
#    # if BACKEND_URI is using TLS/SSL with SNI, this is important!
#    proxy_ssl_server_name on;
#
#    location / {
#        root /root/proj/angular-map/dist;
#    }
#}
````

