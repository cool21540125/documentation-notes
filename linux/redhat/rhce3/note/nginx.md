# Nginx

1. 安裝
2. 設定檔
3. firewall && service
4. Virtual Hosts
5. Static Files
6. WSGI


## 1. 安裝

```sh
$# curl http://nginx.org/keys/nginx_signing.key > nginx_signing.key
$# rpm --import nginx_signing.key

$# vim /etc/yum.repos.d/nginx.repo
### 內容如下 ###
[nginx]
name=Nginx Repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=1
enabled=1
### 內容如上 ###

$# yum install -y nginx

$# nginx -v
nginx version: nginx/1.14.1
```

## 2. 設定檔

### 2-1. Nginx 設定檔基本寫法

- [Web Server - Nginx](https://github.com/cool21540125/documentation-notes/blob/master/network/web%20server/nginx.md)
- [WSGI Server - uwsgi](https://github.com/cool21540125/documentation-notes/blob/master/python/appServer/uwsgi.md)

### 2-2. Nginx 結構

```sh
$# ll /etc/nginx/
/etc/
    /nginx/
        /conf.d/                                    # 設定副檔目錄
        /fastcgi_params                             # ?
        /koi-utf                                    # ?
        /koi-win                                    # ?
        /mime.types                                 # (不是很懂, 但我猜應該是 Nginx 可以幫忙作反代理的靜態文檔)
        /modules                                    # 外掛模組
        /nginx.conf                                 # 設定主檔
        /scgi_params                                # (不是很懂, 但我覺得地位有點類似 mod_cgi)
        /uwsgi_params                               # (不是很懂, 但我覺得地位有點類似 mod_wsgi)
        /win-utf                                    # ?
        # ---- 下面兩個是 Ubuntu 的玩法 ----
        /sites-available/*.conf                     # 設定副檔也可以放這邊
        /sites-enabled/*.conf                       # 透過軟連結的方式, 連結到 available, 而設定主檔有自動 include enabled 這個資料夾
```

### 2-3. Nginx 設定主檔

```sh
$# vim /etc/nginx/nginx.conf
### ------------ 內容如下 ------------
user  nginx;                                        # 服務的使用者
worker_processes  1;                                # 可設成 auto, 建議設定成 CPU 核心數量
error_log  /var/log/nginx/error.log warn;           # Error Log 紀錄位置 及其 Log-Level
pid        /var/run/nginx.pid;                      # 就 pid

events {
    worker_connections  1024;                       # 每個 worker_process 可建立的連線數(包含 proxied servers 之間的連線, 不僅限於 client 端的連線)
}

http {
    include       /etc/nginx/mime.types;            # 套用 mime 別名檔
    default_type  application/octet-stream;         # (不懂)

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"'; # 此 log_format 取名為 main

    access_log  /var/log/nginx/access.log  main;    # Access Log, 套用 main 格式
    sendfile        on;                             # 使用 Linux 底層的 aio...(不懂的話就別動它)
    #tcp_nopush     on;                             # sendfile on 的話才能用, 至於它幹嘛我不知道
    keepalive_timeout  65;                          # 連線建立的持續時間
    #gzip  on;                                      # 壓縮 response (假如CPU強大且網路流量相對吃緊的話, 值得這麼作)
    include /etc/nginx/conf.d/*.conf;               # 引入設定副檔 or 目錄 (Ubuntu 和 CentOS 使用時要注意這邊~)
}
### ------------ 內容如上 ------------
```


### 組態配置完後

```sh
# 測試組態有沒有設定錯誤
nginx -t

# 組態重新載入(比服務重啟更加溫和)
nginx -s reload
```


## 3. firewall && service

```sh
firewall-cmd --add-service=http
systemctl start nginx

echo '127.0.0.1     www1.pome.com   www2.pome.com   www3.pome.com   app.pome.com' >> /etc/hosts
```

## 4. Virtual Hosts

```sh
### 設定檔 (與 Apache 比較)
$# vim /etc/nginx/conf.d/vhost.conf
# ---------- 內容如下 ----------
server {
    listen          80;
    server_name     www1.pome.com;
    location / {    # URL 資源點
        root        /srv/www1/www;  # 實體位置
    }
}

server {
    listen          80;
    server_name     www2.pome.com;
    location / {
        root        /srv/www2/www;
        index       qoo.html;   # 修改預設首頁為此 (預設為 index.html)
    }
}
# Note: Nginx  設定檔裡面, 同一行可以有註解~
# Note: Apache 設定檔裡面, 同一行設定檔又有註解, 他會死給你看
# ---------- 內容如上 ----------

### 建立資源
$# mkdir -p /srv/www1/www
$# mkdir -p /srv/www2/www
$# echo 'www1.pome.com'             > /srv/www1/www/index.html
$# echo 'www2.pome.com qoo.html'    > /srv/www2/www/qoo.html
$# echo 'www2.pome.com index.html'  > /srv/www2/www/index.html

### SELinux
$# ll -Z /srv/www1/www
$# semanage fcontext -a -t httpd_sys_content_t '/srv/.*/www(/.*)?'  # 設定標籤(可不執行)
# ↑ CentOS7 預設 「/srv/*/www」 的 SELinux content 為 httpd_sys_content_t
$# restorecon -RF /srv # 重新貼標
$# ll -Z /srv/www1/www

### 測試 && 重新開始
$# nginx -t                 # 測試組態有無「語法上的錯誤」
$# nginx -s reload          # 緩啟動
$# curl http://www1.pome.com
$# curl http://www2.pome.com
```

### SELinux 重要觀念

`/srv/*/www` 這裡頭, 已經被 SELinux 認知為合法的 `靜態網頁檔案` 的存放處, 所以可不執行設定標籤, 直接執行重新貼標即可

重貼標籤前後 `var_r` -> `httpd_sys_content_t`

## 5. Static Files

```sh
### 資源
$# mkdir -p /srv/static
$# wget .... -O /srv/static/demo.png        (放張圖片在裏頭)

### nginx 設定檔
$# vim /etc/nginx/conf.d/static.conf
server {
    listen  80;
    server_name     www3.pome.com;
    location / {
        root        /srv/static;
    }
}

### SELinux 問題
$# semanage fcontext -a -t httpd_sys_content_t '/srv/static(/.*)?'
$# restorecon -RF /srv

### Testing
$# nginx -s reload
$# curl http://www3.pome.com/demo.png

### 練功:
# 如果圖片放在 「/data/img/demo.png」
# 然後透過 「http://pictures.pome.com/images」 就可以看到圖片
# 如何作組態方面的設定

# 如果會作, 表示 設定檔裡的 location 與 root 與 index 的設定, 你應該是懂了~
# 如果不會, 表示 你是個白癡
```


## 6. WSGI

```sh
### Python-Django
$# easy_install pip
$# pip install django==1.11
$# cd /opt
$# django-admin startproject webapp
$# vim /opt/webapp/webapp/settings.py
ALLOWED_HOSTS = ['app.pome.com']
# ↑ 瀏覽器透過 URL = app.pome.com 進入 nginx 請求
# nginx 在將此請求導向 uwsgi, uwsgi 封裝了 django(wdgi)
# django 會檢查 request header
# 因此需要允許此 request 進入

### TEST
$# firewall-cmd --add-port=8000/tcp
$# python /opt/webapp/manage.py runserver 0.0.0.0:8000
# 「app.pome.com:8000」

### uwsgi
$# yum groupinstall -y "Development Tools"
$# yum install -y python-devel
$# pip install uwsgi

$# vim /opt/uwsgi_webapp.ini
# ↓↓↓↓↓↓ uwsgi 組態 ↓↓↓↓↓↓
[uwsgi]
master = true
processes=2
threads=4
gid = nginx                         # run 起來的 socket, 是屬於 root nginx (分別為 uid gid)
socket = /run/app.sock              # IPC Socket Path
chdir = /opt/webapp/                # django project path
wsgi-file = webapp/wsgi.py          # WSGI app path
vacuum = true                       # uwsgi 中斷時, 自動清除 socket
buffer-size = 32768	                # (我不懂)
logto = /var/log/uwsgi_access.log
# ↑↑↑↑↑↑ uwsgi 組態 ↑↑↑↑↑↑

### nginx
$# vim /etc/nginx/conf.d/app.conf
# ↓↓↓↓↓↓ nginx 組態 ↓↓↓↓↓↓
upstream dj {
    server  unix:/run/app.sock; # 作 IPC
}
server {
    listen              80;
    server_name         app.pome.com;
    charset             utf-8;
    access_log          /var/log/nginx/wsgi.log         main;
    error_log           /var/log/nginx/wsgi_err.log     warn;
    location / {
        include         uwsgi_params;
        uwsgi_pass      dj;
    }
}
# ↑↑↑↑↑↑ nginx 組態 ↑↑↑↑↑↑

$# nginx -t
$# nginx -s reload

### run uwsgi
$# uwsgi /opt/uwsgi_webapp.ini

### SELinux (RedHat 建議, 不要在生產環境使用此方式)
$# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
$# semodule -i my-nginx.pp

$# curl app.pome.com
```


### uwsgi + SELinux

上面的 uwsgi + SELinux 解法, 官方好像不建議使用在生產環境!

* https://uwsgi-docs.readthedocs.io/en/latest/Snippets.html
* https://github.com/reinow/sepwebapp
