# PKI 基礎架構 - 觀念 && 實作

- 2020/04/12 (使用版本: _OpenSSL 1.0.2k-fips 26 Jan 2017_)
- [金鑰與憑證的管理](http://ijecorp.blogspot.com/2014/03/openssl.html)
- [OpenSSL 官網](https://www.openssl.org/)
- [實作取得 CA_Bundle](https://ephrain.net/maclinux-%E7%94%A8-openssl-%E4%B8%8B%E8%BC%89-https-%E7%B6%B2%E7%AB%99%E6%86%91%E8%AD%89%EF%BC%8C%E8%A7%A3%E6%B1%BA-curl-%E6%8A%B1%E6%80%A8-self-signed-certificate-%E7%9A%84%E5%95%8F%E9%A1%8C/)
- [使用 Openssl 建立憑證](https://raix852.github.io/2016/06/20/use-openssl-generate-certificate/)
- [SSL/TLS and PKI History](https://www.feistyduck.com/ssl-tls-and-pki-history/)

---

# 自建 CA Server && 簽署公司內部使用

```bash
ls -l
#-rw-r--r--.  1 root root  3311  4月 12 00:12 ${CA_DOMAIN}.key  # CA Server Private Key
#-rw-r--r--.  1 root root  2021  4月 12 00:15 ${CA_DOMAIN}.crt  # CA Server Certificate (把它散播出去~)
#-rw-r--r--.  1 root root  1017  4月 12 01:08 os7vm.com.csr     # APP Server CSR  (APP Server 給的)
#-rw-r--r--.  1 root root  1566  4月 12 01:09 os7vm.com.crt     # APP Server Certificate (要給 APP Server 的)
#-rw-r--r--.  1 root root    17  4月 12 01:09 ${CA_DOMAIN}.srl  # CA serial number file


### APP Server, 公/私金鑰安裝到 Nginx
ls -l
#-rw-r--r--.  1 root root  1679  4月 12 01:08 os7vm.com.key  # APP Server Private Key
#-rw-r--r--.  1 root root  1017  4月 12 01:08 os7vm.com.csr  # APP Server CSR  (現在這個暫時沒用了~)
#-rw-r--r--.  1 root root  1566  4月 12 01:09 os7vm.com.crt  # APP Server Certificate

cp ./os7vm.com.crt /etc/pki/tls/certs/.
cp ./os7vm.com.key /etc/pki/tls/private/.

#vim /etc/nginx/conf.d/os7vm.conf
# ------------- 內容摘要如下 -------------
#server {
#    if ($host = os7vm.com) {
#            return 301 https://$host$request_uri;
#    }
#}
#server {
#    listen 443 ssl;
#    server_name os7vm.com;
#    root /STATIC_FILE_PATH;
#
#    ssl_certificate "/etc/pki/tls/certs/os7vm.com.crt";
#    ssl_certificate_key "/etc/pki/tls/private/os7vm.com.key";
#
#    location / {
#    }
#}
# ------------- 內容摘要如上 -------------

nginx -t
nginx -s reload

## 往後, 區網內的 Client, 要讓系統信任 CA Server 簽發的憑證(os7vm.com.crt)
# 所以要先拿到 ${CA_DOMAIN}.crt

### 底下步驟開始安裝 CA Server 憑證
cp ${CA_DOMAIN}.crt /etc/pki/ca-trust/source/anchors/.
update-ca-trust

### 如此一來, 不需要加上 -k, 作業系統就自動信任 os7vm.com 囉~
curl -I https://os7vm.com
#HTTP/1.1 200 OK
#Server: nginx/1.16.1
#Date: Sat, 11 Apr 2020 17:38:00 GMT
#Content-Type: text/html
#Content-Length: 4833
#Last-Modified: Fri, 16 May 2014 15:12:48 GMT
#Connection: keep-alive
#ETag: "53762af0-12e1"
#Accept-Ranges: bytes
```

## openssl 其他指令備註

- TODO: 2020/04/28 研究 ↓
- https://www.postgresql.org/docs/11/ssl-tcp.html
- [Https 雜七雜八](https://hackmd.io/Gbub0_EJS9eaeghyvuBj0g#PFX%E3%80%81P12)
- [Navicat-SSL 設定](https://www2.navicat.com/manual/online_manual/en/navicat/mac_manual/SSLSettings.html)
- [永久試用(破解啦)](https://github.com/cool21540125/navicat-keygen-tools)
- [建立安全 SSL 连接 PostgreSQL 数据库服务器](https://blog.csdn.net/zhu4674548/article/details/71248365)

```bash
### 依序產生私鑰(aa.key)(不使用passphase), 再用它來產生CSR(aa.crt)
$# openssl genrsa -out aa.key 2048
$# openssl req -new -key aa.key -out aa.crt

### 同時生成私鑰, 並立即使用它來簽屬CSR (下面這行幾乎等於上面兩行, 但需要使用passphase才行)
$# openssl req -newkey rsa:2048 -keyout cc.key -out cc.crt

### 若私鑰有設定passphase, 此方式可把它移除
$# openssl rsa -in aa.key -out qq.key

# 驗證憑證簽屬請求 (CA 收到CSR 後, 為了避免CSR 中途有被串改過, 保險一點需要驗證)
$# openssl req -in req.pem -text -verify -noout
# -noout: 不要把 CERTIFICATE REQUEST 那一段印出來
# 第一行可看到驗證結果
# verify OK         <- 驗證成功
# verify failure    <- 驗證失敗

### 使用 $(KEY), 產生 CSR
$# openssl req $(UTF8) -new -key $(KEY) -out $(CSR)

### 使用 $(KEY), 產生 CRT
$# openssl req $(UTF8) -new -key $(KEY) -out $(CRT) -x509 -days $(DAYS) $(EXTRA_FLAGS)
```

---

# letsencrypt

- 2018/11/20
- [SSL For Free](https://www.sslforfree.com/)
- [使用須知-限額](https://letsencrypt.org/zh-tw/docs/rate-limits/)

Example: 以 Apache 為例

1. DNS 設好 A 紀錄

| Name   | Type | Value       | TTL |
| ------ | ---- | ----------- | --- |
| `FQDN` | A    | (PUBLIC IP) | 60  |

2. 啟動你的 Web Server, 開防火牆, Permission, SELinux(if Enforcing)
3. 修改你的 `/etc/hosts` (假設為 `demo`)
4. 前往 [SSL For Free](https://www.sslforfree.com/), 填寫 FQDN (`demo.DOMAIN`)
5. Manual Verification
   1. Download File (檔案裏頭一堆看不懂的 `HASH`), 假設該檔名為 Zr2Q7
   2. 放到 Web Server 站台的 {DocumentRoot}/.well-known/acme-challenge/Zr2Q7
   3. 啟動你的 Web Server
   4. 開防火牆, 權限, SELinux(if Enforcing)
   5. 瀏覽器進入你的 Web Server (http://YOUR_FQDN/.well-known/acme-challenge/Zr2Q7), 應該能看到一堆 `HASH`
   6. 點選 `Download SSL Certificate`
      1. 將 Certificate 存成 `xxx.crt`
      2. 將 Private Key 存成 `yyy.key`
      3. 將 CA Bundle 存成 zzz.crt (不知道啥場合用得到它...)
   7. yum install -y mod_ssl
   8. 編輯 `/etc/httpd/conf.d/ssl.conf`
      1. SSLCertificateFile 設定為 `xxx.crt` 的完整路徑
      2. SSLCertificateKeyFile 設定為 `yyy.key` 的完整路徑
   9. 重啟 httpd
   10. https://YOUR_FQDN 新鮮的 https 出爐~

---

# Certbot

## 1. Apache Letsencrypt

- 2018/11/26
- https://certbot.eff.org/lets-encrypt/centosrhel7-apache

### 1. 安裝

```sh
yum -y install yum-utils
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install -y python2-certbot-apache
```

### 2. 設定 apache && hostname && domain

1. DNS - A record (或使用 /etc/hosts)
2. 設定 VirtualHost `/etc/httpd/conf.d/vhost.conf`
3. https `yum install mod_ssl`

### 3. vhost

#### 3-1. apahce config

```conf
### Virtual Host
<VirtualHost *:80>
    DocumentRoot    /srv/demo/www
    ServerName      demo.youwillneverknow.com
    ErrorLog        "logs/demo_error_log"
    CustomLog       "logs/demo_access_log" combined
</VirtualHost>
<Directory /srv/demo/www>
    Require all granted
</Directory>

<VirtualHost *:80>
    DocumentRoot    /srv/www/www
    ServerName      www.youwillneverknow.com
    ErrorLog        "logs/www_error_log"
    CustomLog       "logs/www_access_log" combined
</VirtualHost>
<Directory /srv/www/www>
    Require all granted
</Directory>
```

#### 3-2. html

```sh
mkdir -p /srv/{demo,www}/www
chmod 2774 -p /srv
chown -R apache /srv

# 在兩資料夾內建立各自的 html
# restart httpd
```

#### 3-3. security

1. SELinux
2. firewall
3. Authentication (read && access for apache)

### 4. 設定 letsencrypt


### 5. Auto-encrypt

```sh
### 純測試
certbot renew --dry-run

### 手動執行 auto-renew encrypt
certbot renew
```

寫到 crontab 吧~

## 2. Nginx Letsencrypt

### 1. 安裝

```sh
yum -y install yum-utils
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install -y python2-certbot-nginx
```

### 2. config

```conf
server {
    listen          80;
    root            /data/www;
    server_name     www.youwillneverknow.com;
    location / {
    }
}


server {
    listen          80;
    server_name     demo.youwillneverknow.com;
    root            /data/demo;
    location / {
    }
}

```

### 3. 資源

```sh
mkdir -p /data/{www,demo}
# Permission
# Owner(nginx)
# 0755
# firewall
# SELinux
# 放資源
```

### 4. letsencrypt

```sh
$# certbot --nginx
# 然後就很簡單了
```

```bash
### nginx 配置

```

### 5. auto encrypt

```sh
certbot renew --dry-run     # 玩假的
certbot renew               # 玩真的

crontab -e
0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
```

## 3. Hugo + Letsencrypt on Gitlab

- 哪天心血來潮再來寫

# ssl

```bash
### 產生自我簽署憑證
$# openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
# -config /etc/pki/tls/openssl.cnf 依照組態方式
# -days 3650 十年
# -keyout private/logstash-forwarder.key 私鑰放這
# -out certs/logstash-forwarder.crt 簽署好的憑證放這
```


# 其他備註

- https 依賴 ssl, ssl 依賴 `數位憑證`
- `數位憑證` 可以自簽 or 送給第三方公正機關簽署, 之後安裝到自己的網站
