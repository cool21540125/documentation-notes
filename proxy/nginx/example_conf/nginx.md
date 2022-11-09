# Web Server - Nginx

- [官方 Beginner’s Guide](http://nginx.org/en/docs/beginners_guide.html)

```bash
# -g: 讓 Nginx 前台執行
$ nginx -g daemon off
# nginx Container 預設的啟動方式
```

```sh
$# uname -r
3.10.0-693.21.1 el7.x86_64

### 測試設定檔
$# nginx -t

### 重啟
$# nginx -s reload
```


# 組態的最基本寫法

組態檔的撰寫方式, 由一系列的 **directive** 所組成. 而此 **directive** 分為2類:
- `simple directive` : **分號結尾**
- `block directive`  : 會有一組 `{}` 把東西包起來, 而裡面可以含有 `simple directive` 及 `block directive`

最內層的 `block directive` 只會有2種：**http** 及 **event**, 而文件(.conf)內, 不在 `block directive` 裡面的稱為 `main context`

```conf
# 此範疇落於 main context
prop1   aaa
prop2   bbb

# event block directive
events {
    prop8   hhh
}

# http block directive
http {
    # http 內可有多個 server block directive
    server {
        prop3     ccc

        # server 內可有多個 location block directive
        location {
            prop4   ddd
        }

        # server 內可有多個 location block directive
        location {
            prop5   eee
        }
    }

    # http 內可有多個 server block directive
    server {
        prop6   fff
        location {
            prop7 ggg
        }
    }
}
```




# nginx variables

- [What's the difference of $host and $http_host in Nginx](https://stackoverflow.com/questions/15414810/whats-the-difference-of-host-and-http-host-in-nginx)

設定檔裡頭, server {} 區塊內

- $host : in this order of precedence: 
    - host name from the request line
    - host name from the 'Host' request header field
    - the server name matching a request
- $http_host : HTTP request header 'Host'; 本身會帶 port; `$http_host = $host:$port`
- $server_name : nginx vhost server name. 若有多個, 則取第一個

# 範例

## Static Content - 靜態資源服務

```ini
# 若此設定檔只有此 「server { ... }」, 則此同時稱為 default server
server {
    listen                  80;         # 若為 default server, 此行隱含了 「listen       80 default_server;」
    server_name             localhost;  # Request Http header 為 localhost 者, 套用此 server, 否則找 default server
    client_max_body_size    1024M;      # POST Request Body 的上限限制, 若超出此限制會出現 HTTP 413: Request entity too large

    location / {        # URL pattern: /
        root        /data/www;          # 存取 /data/www/...
    }

    location /hello {   # URL pattern: /hello
        index       index.html index.php;   # 若 index.html 不存在, 重導至 index.php
    }

    location /images/ {     # URL pattern: /images/
        root        /data;                  # 存取 /data/images/...
    }

    location /index {    # URL pattern: /index
        root        e:\wwwroot;         # 若 URL 符合此 location pattern, 則 RootDocument 為 e:\wwwroot
        index       index.html;         # 設定首頁
    }
}
```

- ex: `http://localhost/images/example.png`, 會存取 `/data/images/example.png`
- ex: `http://localhost/some/example.html`, 會存取 `/data/www/some/example.html`


## Proxy Server - 代理模式

### Proxy Server 範例1

- [nginx 基礎設定教學](https://blog.hellojcc.tw/2015/12/07/nginx-beginner-tutorial/)

```ini
server {
    listen          80;     # 把 proxy server 掛在 本地端 80 port
    server_name     _;      # external address

    location / {
        # Nginx設定為 "代理模式" , 代理本地 8000 port, 後便可透過 public network訪問 Flask web app了
        proxy_pass  http://127.0.0.1:8000;
    }
}
```

### Proxy Server 範例2

- [Nginx Beginner Guide](https://nginx.org/en/docs/beginners_guide.html)

```ini
# 代理伺服器 Proxy Server
server {
    location / {    # 其餘則導向 Proxied Server
        proxy_pass  http://localhost:8080;
    }

    # (與下者雷同), Regular Expression 使用 ~ 開頭
    location ~ \.(gif|jpg|png)$ {   # 若請求靜態文件, .gif, .jpg, .png, 從 /data/images/ 去找
        root        /data/images;
    }
    # (與上者雷同)
    # location /images/ { # URL pattern: /images/
    #     root /data;         # 存取 /data/images/...
    # }
}

# 被代理的伺服器 Proxied Server
server {
    listen      8080;           # Redirect 窗口
    root        /data/up1;      # 東西都放在 /data/up1/...

    location / {
        # do something...
    }
}
```


### 不管啥網頁, 都找首頁 範例3

```ini
# 被代理的伺服器 Proxied Server
server {
    listen      80;
    root        /usr/share/nginx/html;

    location / {
        try_files $uri $uri/ /index.html;
        # try_files 用處就像是, 在 SPA, 網址若有其他的 uri, 重新整理後會跳出 404
        # 設定這樣會嘗試去抓取本地的 index.html, 並且進入該 uri
        # 白話文就是, 讓重新整理變得正常
    }
}
```


## Load-Balance - 負載平衡模式
```ini
# 作 Load-balance 到兩個 Node
upstream test {
    server localhost:8080;
    server localhost:8081;
}

server {
    # 監聽 本地 80 port 的請求
    listen       80;
    server_name  localhost;

    location / {
        # 代理 localhost:8080
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host:$server_port;
    }
}
```


### weight
設定訪問比重(不同 Server, 效能不一樣)

```ini
upstream test {
    server 192.168.10.10:8080 weight=5;
    server 192.168.10.11:8080 weight=2;
}
```


### ip_hash
因為上述的 Load-balance, 會有 `登入後, 資料存在 session`, 再發送請求時, 跳到不同 Server的情況(需要重新登入阿), 所以`要限定同 Client, 訪問同 Server` → 製作 `ip_hash`

```ini
upstream test {
    # ip_hash 會用 IPv4 的前 24 bits / 整個 IPv6 做 hash, 確保同一個客戶請求始終發到同一台Server
    ip_hash;
    server 192.168.10.10:8080 weight=9; # 訪問比重
    server 192.168.10.11:8081 weight=1; # 訪問比重
}
```






## 靜態圖片代理

1. 建立資源

```sh
mkdir -p /data/images
# 裡面放些圖片吧~
# Permission, owner(nginx) 0755
# firewall
# SELinux
```

2. a 設定檔 (靜態網頁)
```sh
### /etc/nginx/conf.d/vhost.conf
server {
    server_name     img.youwillneverknow.com;
    location /images/ {
        root            /data;
        autoindex       on;         # 未指定資源可以 list dir
    }
}
```

2. b 設定檔 (圖片 regex)
```sh
### /etc/nginx/conf.d/vhost.conf
server {
    listen          80;
    server_name     img.youwillneverknow.com;
    location ~ \.(gif|jpg|png)$ {
        root        /data/images/;
    }
}
```

3. DNS resloution

img.youwillneverknow.com    A   <IP4>

4. URL

* http://img.youwillneverknow.com/images/
* http://img.youwillneverknow.com/free.png

最後面得要有「/」 才能 list


# other

```conf
### 回傳 Client IP
location /ip {
    default_type text/plain;
    return 200 $remote_addr;
}
```


## 使用變數

```conf
location / {
    root web;
    set $file index.html;

    index $file;
}
```


## Note

Ubuntu 上面的 nginx 用戶為 `www-data`