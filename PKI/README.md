# PKI 基礎架構 - 觀念 && 實作

- 2020/04/12 (使用版本: *OpenSSL 1.0.2k-fips  26 Jan 2017*)
- [金鑰與憑證的管理](http://ijecorp.blogspot.com/2014/03/openssl.html)
- [OpenSSL官網](https://www.openssl.org/)
- [實作取得CA_Bundle](https://ephrain.net/maclinux-%E7%94%A8-openssl-%E4%B8%8B%E8%BC%89-https-%E7%B6%B2%E7%AB%99%E6%86%91%E8%AD%89%EF%BC%8C%E8%A7%A3%E6%B1%BA-curl-%E6%8A%B1%E6%80%A8-self-signed-certificate-%E7%9A%84%E5%95%8F%E9%A1%8C/)
- [使用 Openssl 建立憑證](https://raix852.github.io/2016/06/20/use-openssl-generate-certificate/)

- https 依賴 ssl, ssl 依賴 `數位憑證`
- `數位憑證` 可以自簽 or 送給第三方公正機關簽署, 之後安裝到自己的網站


*****************************************************************************

# 自建 CA Server && 簽署公司內部使用

```bash
## 產生 私鑰 && 憑證(要四處發行的)

### CA Server, 產生 CA private key
$# openssl genrsa -aes256 -out myrootCA.key 4096
# 產生 myrootCA.key
# 若設定了 [-des3, -aes256], 將來使用此 private key, 都會要求輸入 passphases (比較安全)
# 鳥哥網站則是使用 -aes128 (差在哪我就不知道了)
# 2020/04 的現在, -aes256 是比較安全的 (最近關於 Zoom 的新聞有爆出來)

### CA Server, 產生 CA certificate
$# CA_DOMAIN=os7vm.com
$# openssl req -x509 -new -nodes -key myrootCA.key -sha256 -days 36500 -out myrootCA.crt -subj "/C=TW/ST=Taiwan/L=TaichungCity/O=SelfCA/OU=swrd/CN=${CA_DOMAIN}"
# 產生 myrootCA.crt
# req: PKCS#10 certificate request and certificate generating utility
# -x509: 產生 self signed certificate, 而非 CSR
# -new: 產生一個 certificate request; 若沒與 -key 一同出現, 則會根據 config 產生一個新的 RSA private key
# -nodes: if this option is specified then if a private key is created it will not be encrypted.
# -key OOO: 指定要用哪個 private key 來簽發此 憑證
# -sha256: (未知... 多一層加密吧?)
# -days OOO: self signed certificate 有效天數. Default 30 days
# -out OOO: 產出的 憑證 名稱
# -subj: 省略後續的 inter-active input

## APP Server - 自己製作一份憑證簽署請求(CSR), 請 CA Server 幫忙簽署

### APP Server, 產生 APP Server private key
$# APP_DOMAIN=os7vm.com
$# openssl genrsa -out ${APP_DOMAIN}.key 2048
# 產生 {APP_DOMAIN}.key
# 之所以用 {APP_DOMAIN}, 只是想表達 {APP_DOMAIN} 這組(命名上方便識別)

### APP Server, 產生 certificat sign request (CSR)
$# openssl req -new -key ${APP_DOMAIN}.key -subj "/C=TW/ST=Taiwan/L=TaichungCity/O=tonychoucc.com/OU=swrd/CN=${APP_DOMAIN}"  -sha256  -out ${APP_DOMAIN}.csr
# 產生 {APP_DOMAIN}.csr (憑證簽署請求)

## CA Server 收到 CSR 之後(收完錢以後), 幫忙製作 APP Server Certificate

### CA Server, 使用 CA private key && CA certificate, 來簽署 CSR
$# DAYS=3650
$# openssl x509 -req -in ${APP_DOMAIN}.csr -CA myrootCA.crt -CAkey myrootCA.key -CAcreateserial -out ${APP_DOMAIN}.crt -days ${DAYS} -sha256
# 產生 {APP_DOMAIN}.crt
# -CAcreateserial: 需與 -CA 一同使用, 產生 CA serial number file

$# ll
-rw-r--r--.  1 root root  3311  4月 12 00:12 myrootCA.key   # CA Server Private Key
-rw-r--r--.  1 root root  2021  4月 12 00:15 myrootCA.crt   # CA Server Certificate (把它散播出去~)
-rw-r--r--.  1 root root  1017  4月 12 01:08 os7vm.com.csr  # APP Server CSR  (APP Server 給的)
-rw-r--r--.  1 root root  1566  4月 12 01:09 os7vm.com.crt  # APP Server Certificate (要給 APP Server 的)
-rw-r--r--.  1 root root    17  4月 12 01:09 myrootCA.srl   # CA serial number file

## 收到 CA Server 簽署後的憑證以後, 開始安裝

### APP Server, 公/私金鑰安裝到 Nginx
$# ll
-rw-r--r--.  1 root root  1679  4月 12 01:08 os7vm.com.key  # APP Server Private Key
-rw-r--r--.  1 root root  1017  4月 12 01:08 os7vm.com.csr  # APP Server CSR  (現在這個暫時沒用了~)
-rw-r--r--.  1 root root  1566  4月 12 01:09 os7vm.com.crt  # APP Server Certificate

$# cp ./os7vm.com.crt /etc/pki/tls/certs/.
$# cp ./os7vm.com.key /etc/pki/tls/private/.

$# vim /etc/nginx/conf.d/os7vm.conf
# ------------- 內容摘要如下 -------------
server {
    if ($host = os7vm.com) {
            return 301 https://$host$request_uri;
    }
}
server {
    listen 443 ssl;
    server_name os7vm.com;
    root /STATIC_FILE_PATH;

    ssl_certificate "/etc/pki/tls/certs/os7vm.com.crt";
    ssl_certificate_key "/etc/pki/tls/private/os7vm.com.key";

    location / {
    }
}
# ------------- 內容摘要如上 -------------

$# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

$# nginx -s reload

## 往後, 區網內的 Client, 要讓系統信任 CA Server 簽發的憑證(os7vm.com.crt)
# 所以要先拿到 myrootCA.crt

### 底下步驟開始安裝 CA Server 憑證
$# cp myrootCA.crt /etc/pki/ca-trust/source/anchors/.
$# update-ca-trust

### 如此一來, 不需要加上 -k, 作業系統就自動信任 os7vm.com 囉~
$# curl -I https://os7vm.com
HTTP/1.1 200 OK
Server: nginx/1.16.1
Date: Sat, 11 Apr 2020 17:38:00 GMT
Content-Type: text/html
Content-Length: 4833
Last-Modified: Fri, 16 May 2014 15:12:48 GMT
Connection: keep-alive
ETag: "53762af0-12e1"
Accept-Ranges: bytes
```

*****************************************************************************

# letsencrypt

- 2018/11/20
- [SSL For Free](https://www.sslforfree.com/)
- [使用須知-限額](https://letsencrypt.org/zh-tw/docs/rate-limits/)

Example: 以 Apache 為例

1. DNS 設好 A 紀錄

Name   | Type | Value       | TTL
------ | ---- | ----------- | ---
`FQDN` | A    | (PUBLIC IP) | 60

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
    10. https://YOUR_FQDN   新鮮的 https 出爐~

*****************************************************************************

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

1. DNS  - A record (或使用 /etc/hosts)
2. hostnamectl set-hostname (這好像可以不要用...)
3. 設定 VirtualHost `/etc/httpd/conf.d/vhost.conf`
4. https `yum install mod_ssl`

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

```sh
$# certbot --apache
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Starting new HTTPS connection (1): acme-v02.api.letsencrypt.org

Which names would you like to activate HTTPS for?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: demo.youwillneverknow.com
2: www.youwillneverknow.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel):
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for demo.youwillneverknow.com
http-01 challenge for www.youwillneverknow.com
Waiting for verification...
Cleaning up challenges
Created an SSL vhost at /etc/httpd/conf.d/vhost-le-ssl.conf
Deploying Certificate to VirtualHost /etc/httpd/conf.d/vhost-le-ssl.conf
Created an SSL vhost at /etc/httpd/conf.d/vhost-le-ssl.conf
Deploying Certificate to VirtualHost /etc/httpd/conf.d/vhost-le-ssl.conf

Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: No redirect - Make no further changes to the webserver configuration.
2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
new sites, or if you're confident your site works on HTTPS. You can undo this
change by editing your web server's configuration.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 1

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations! You have successfully enabled https://demo.youwillneverknow.com and
https://www.youwillneverknow.com

You should test your configuration at:
https://www.ssllabs.com/ssltest/analyze.html?d=demo.youwillneverknow.com
https://www.ssllabs.com/ssltest/analyze.html?d=www.youwillneverknow.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/demo.youwillneverknow.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/demo.youwillneverknow.com/privkey.pem
   Your cert will expire on 2019-02-24. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot again
   with the "certonly" option. To non-interactively renew *all* of
   your certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

成功!!

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


# certbot 指令備註

```bash
### 2020/04/17 的版本
certbot --version
certbot 1.3.0

$# certbot -h all
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
usage:
  certbot [SUBCOMMAND] [options] [-d DOMAIN] [-d DOMAIN] ...

Certbot can obtain and install HTTPS/TLS/SSL certificates.  By default,
it will attempt to use a webserver both for obtaining and installing the
certificate. The most common SUBCOMMANDS and flags are:

obtain, install, and renew certificates:
    (default) run   Obtain & install a certificate in your current webserver
    certonly        Obtain or renew a certificate, but do not install it
    renew           Renew all previously obtained certificates that are near expiry
    enhance         Add security enhancements to your existing configuration
   -d DOMAINS       Comma-separated list of domains to obtain a certificate for

  (the certbot apache plugin is not installed)
  --standalone      Run a standalone webserver for authentication
  --nginx           Use the Nginx plugin for authentication & installation
  --webroot         Place files in a server''s webroot folder for authentication
  --manual          Obtain certificates interactively, or using shell script hooks

   -n               Run non-interactively
  --test-cert       Obtain a test certificate from a staging server
  --dry-run         Test "renew" or "certonly" without saving any certificates to disk

manage certificates:
    certificates    Display information about certificates you have from Certbot
    revoke          Revoke a certificate (supply --cert-name or --cert-path)
    delete          Delete a certificate (supply --cert-name)

manage your account:
    register        Create an ACME account
    unregister      Deactivate an ACME account
    update_account  Update an ACME account
  --agree-tos       Agree to the ACME server''s Subscriber Agreement
   -m EMAIL         Email address for important account notifications

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG_FILE, --config CONFIG_FILE
                        path to config file (default: /etc/letsencrypt/cli.ini
                        and ~/.config/letsencrypt/cli.ini)
  -v, --verbose         This flag can be used multiple times to incrementally
                        increase the verbosity of output, e.g. -vvv. (default:
                        -2)
  --max-log-backups MAX_LOG_BACKUPS
                        Specifies the maximum number of backup logs that
                        should be kept by Certbot''s built in log rotation.
                        Setting this flag to 0 disables log rotation entirely,
                        causing Certbot to always append to the same log file.
                        (default: 1000)
  -n, --non-interactive, --noninteractive
                        Run without ever asking for user input. This may
                        require additional command line flags; the client will
                        try to explain which ones are required if it finds one
                        missing (default: False)
  --force-interactive   Force Certbot to be interactive even if it detects
                        it''s not being run in a terminal. This flag cannot be
                        used with the renew subcommand. (default: False)
  -d DOMAIN, --domains DOMAIN, --domain DOMAIN
                        Domain names to apply. For multiple domains you can
                        use multiple -d flags or enter a comma separated list
                        of domains as a parameter. The first domain provided
                        will be the subject CN of the certificate, and all
                        domains will be Subject Alternative Names on the
                        certificate. The first domain will also be used in
                        some software user interfaces and as the file paths
                        for the certificate and related material unless
                        otherwise specified or you already have a certificate
                        with the same name. In the case of a name collision it
                        will append a number like 0001 to the file path name.
                        (default: Ask)
  --eab-kid EAB_KID     Key Identifier for External Account Binding (default:
                        None)
  --eab-hmac-key EAB_HMAC_KEY
                        HMAC key for External Account Binding (default: None)
  --cert-name CERTNAME  Certificate name to apply. This name is used by
                        Certbot for housekeeping and in file paths; it doesn''t
                        affect the content of the certificate itself. To see
                        certificate names, run 'certbot certificates'. When
                        creating a new certificate, specifies the new
                        certificate''s name. (default: the first provided
                        domain or the name of an existing certificate on your
                        system for the same domains)
  --dry-run             Perform a test run of the client, obtaining test
                        (invalid) certificates but not saving them to disk.
                        This can currently only be used with the 'certonly'
                        and 'renew' subcommands. Note: Although --dry-run
                        tries to avoid making any persistent changes on a
                        system, it is not completely side-effect free: if used
                        with webserver authenticator plugins like apache and
                        nginx, it makes and then reverts temporary config
                        changes in order to obtain test certificates, and
                        reloads webservers to deploy and then roll back those
                        changes. It also calls --pre-hook and --post-hook
                        commands if they are defined because they may be
                        necessary to accurately simulate renewal. --deploy-
                        hook commands are not called. (default: False)
  --debug-challenges    After setting up challenges, wait for user input
                        before submitting to CA (default: False)
  --preferred-challenges PREF_CHALLS
                        A sorted, comma delimited list of the preferred
                        challenge to use during authorization with the most
                        preferred challenge listed first (Eg, "dns" or
                        "http,dns"). Not all plugins support all challenges.
                        See https://certbot.eff.org/docs/using.html#plugins
                        for details. ACME Challenges are versioned, but if you
                        pick "http" rather than "http-01", Certbot will select
                        the latest version automatically. (default: [])
  --user-agent USER_AGENT
                        Set a custom user agent string for the client. User
                        agent strings allow the CA to collect high level
                        statistics about success rates by OS, plugin and use
                        case, and to know when to deprecate support for past
                        Python versions and flags. If you wish to hide this
                        information from the Let''s Encrypt server, set this to
                        "". (default: CertbotACMEClient/1.3.0 (certbot; Amazon
                        Linux 2) Authenticator/XXX Installer/YYY (SUBCOMMAND;
                        flags: FLAGS) Py/2.7.16). The flags encoded in the
                        user agent are: --duplicate, --force-renew, --allow-
                        subset-of-names, -n, and whether any hooks are set.
  --user-agent-comment USER_AGENT_COMMENT
                        Add a comment to the default user agent string. May be
                        used when repackaging Certbot or calling it from
                        another tool to allow additional statistical data to
                        be collected. Ignored if --user-agent is set.
                        (Example: Foo-Wrapper/1.0) (default: None)

automation:
  Flags for automating execution & other tweaks

  --keep-until-expiring, --keep, --reinstall
                        If the requested certificate matches an existing
                        certificate, always keep the existing one until it is
                        due for renewal (for the 'run' subcommand this means
                        reinstall the existing certificate). (default: Ask)
  --expand              If an existing certificate is a strict subset of the
                        requested names, always expand and replace it with the
                        additional names. (default: Ask)
  --version             show program''s version number and exit
  --force-renewal, --renew-by-default
                        If a certificate already exists for the requested
                        domains, renew it now, regardless of whether it is
                        near expiry. (Often --keep-until-expiring is more
                        appropriate). Also implies --expand. (default: False)
  --renew-with-new-domains
                        If a certificate already exists for the requested
                        certificate name but does not match the requested
                        domains, renew it now, regardless of whether it is
                        near expiry. (default: False)
  --reuse-key           When renewing, use the same private key as the
                        existing certificate. (default: False)
  --allow-subset-of-names
                        When performing domain validation, do not consider it
                        a failure if authorizations can not be obtained for a
                        strict subset of the requested domains. This may be
                        useful for allowing renewals for multiple domains to
                        succeed even if some domains no longer point at this
                        system. This option cannot be used with --csr.
                        (default: False)
  --agree-tos           Agree to the ACME Subscriber Agreement (default: Ask)
  --duplicate           Allow making a certificate lineage that duplicates an
                        existing one (both can be renewed in parallel)
                        (default: False)
  --os-packages-only    (certbot-auto only) install OS package dependencies
                        and then stop (default: False)
  --no-self-upgrade     (certbot-auto only) prevent the certbot-auto script
                        from upgrading itself to newer released versions
                        (default: Upgrade automatically)
  --no-bootstrap        (certbot-auto only) prevent the certbot-auto script
                        from installing OS-level dependencies (default: Prompt
                        to install OS-wide dependencies, but exit if the user
                        says 'No')
  --no-permissions-check
                        (certbot-auto only) skip the check on the file system
                        permissions of the certbot-auto script (default:
                        False)
  -q, --quiet           Silence all output except errors. Useful for
                        automation via cron. Implies --non-interactive.
                        (default: False)

security:
  Security parameters & server settings

  --rsa-key-size N      Size of the RSA key. (default: 2048)
  --must-staple         Adds the OCSP Must Staple extension to the
                        certificate. Autoconfigures OCSP Stapling for
                        supported setups (Apache version >= 2.3.3 ). (default:
                        False)
  --redirect            Automatically redirect all HTTP traffic to HTTPS for
                        the newly authenticated vhost. (default: Ask)
  --no-redirect         Do not automatically redirect all HTTP traffic to
                        HTTPS for the newly authenticated vhost. (default:
                        Ask)
  --hsts                Add the Strict-Transport-Security header to every HTTP
                        response. Forcing browser to always use SSL for the
                        domain. Defends against SSL Stripping. (default: None)
  --uir                 Add the "Content-Security-Policy: upgrade-insecure-
                        requests" header to every HTTP response. Forcing the
                        browser to use https:// for every http:// resource.
                        (default: None)
  --staple-ocsp         Enables OCSP Stapling. A valid OCSP response is
                        stapled to the certificate that the server offers
                        during TLS. (default: None)
  --strict-permissions  Require that all configuration files are owned by the
                        current user; only needed if your config is somewhere
                        unsafe like /tmp/ (default: False)
  --auto-hsts           Gradually increasing max-age value for HTTP Strict
                        Transport Security security header (default: False)

testing:
  The following flags are meant for testing and integration purposes only.

  --test-cert, --staging
                        Use the staging server to obtain or revoke test
                        (invalid) certificates; equivalent to --server https
                        ://acme-staging-v02.api.letsencrypt.org/directory
                        (default: False)
  --debug               Show tracebacks in case of errors, and allow certbot-
                        auto execution on experimental platforms (default:
                        False)
  --no-verify-ssl       Disable verification of the ACME server''s certificate.
                        (default: False)
  --http-01-port HTTP01_PORT
                        Port used in the http-01 challenge. This only affects
                        the port Certbot listens on. A conforming ACME server
                        will still attempt to connect on port 80. (default:
                        80)
  --http-01-address HTTP01_ADDRESS
                        The address the server listens to during http-01
                        challenge. (default: )
  --https-port HTTPS_PORT
                        Port used to serve HTTPS. This affects which port
                        Nginx will listen on after a LE certificate is
                        installed. (default: 443)
  --break-my-certs      Be willing to replace or renew valid certificates with
                        invalid (testing/staging) certificates (default:
                        False)

paths:
  Flags for changing execution paths & servers

  --cert-path CERT_PATH
                        Path to where certificate is saved (with auth --csr),
                        installed from, or revoked. (default: None)
  --key-path KEY_PATH   Path to private key for certificate installation or
                        revocation (if account key is missing) (default: None)
  --fullchain-path FULLCHAIN_PATH
                        Accompanying path to a full certificate chain
                        (certificate plus chain). (default: None)
  --chain-path CHAIN_PATH
                        Accompanying path to a certificate chain. (default:
                        None)
  --config-dir CONFIG_DIR
                        Configuration directory. (default: /etc/letsencrypt)
  --work-dir WORK_DIR   Working directory. (default: /var/lib/letsencrypt)
  --logs-dir LOGS_DIR   Logs directory. (default: /var/log/letsencrypt)
  --server SERVER       ACME Directory Resource URI. (default:
                        https://acme-v02.api.letsencrypt.org/directory)

manage:
  Various subcommands and flags are available for managing your
  certificates:

  certificates          List certificates managed by Certbot
  delete                Clean up all files related to a certificate
  renew                 Renew all certificates (or one specified with --cert-
                        name)
  revoke                Revoke a certificate specified with --cert-path or
                        --cert-name
  update_symlinks       Recreate symlinks in your /etc/letsencrypt/live/
                        directory

run:
  Options for obtaining & installing certificates

certonly:
  Options for modifying how a certificate is obtained

  --csr CSR             Path to a Certificate Signing Request (CSR) in DER or
                        PEM format. Currently --csr only works with the
                        'certonly' subcommand. (default: None)

renew:
  The 'renew' subcommand will attempt to renew all certificates (or more
  precisely, certificate lineages) you have previously obtained if they are
  close to expiry, and print a summary of the results. By default, 'renew'
  will reuse the options used to create obtain or most recently successfully
  renew each certificate lineage. You can try it with `--dry-run` first. For
  more fine-grained control, you can renew individual lineages with the
  `certonly` subcommand. Hooks are available to run commands before and
  after renewal; see https://certbot.eff.org/docs/using.html#renewal for
  more information on these.

  --pre-hook PRE_HOOK   Command to be run in a shell before obtaining any
                        certificates. Intended primarily for renewal, where it
                        can be used to temporarily shut down a webserver that
                        might conflict with the standalone plugin. This will
                        only be called if a certificate is actually to be
                        obtained/renewed. When renewing several certificates
                        that have identical pre-hooks, only the first will be
                        executed. (default: None)
  --post-hook POST_HOOK
                        Command to be run in a shell after attempting to
                        obtain/renew certificates. Can be used to deploy
                        renewed certificates, or to restart any servers that
                        were stopped by --pre-hook. This is only run if an
                        attempt was made to obtain/renew a certificate. If
                        multiple renewed certificates have identical post-
                        hooks, only one will be run. (default: None)
  --deploy-hook DEPLOY_HOOK
                        Command to be run in a shell once for each
                        successfully issued certificate. For this command, the
                        shell variable $RENEWED_LINEAGE will point to the
                        config live subdirectory (for example,
                        "/etc/letsencrypt/live/example.com") containing the
                        new certificates and keys; the shell variable
                        $RENEWED_DOMAINS will contain a space-delimited list
                        of renewed certificate domains (for example,
                        "example.com www.example.com" (default: None)
  --disable-hook-validation
                        Ordinarily the commands specified for --pre-hook
                        /--post-hook/--deploy-hook will be checked for
                        validity, to see if the programs being run are in the
                        $PATH, so that mistakes can be caught early, even when
                        the hooks aren''t being run just yet. The validation is
                        rather simplistic and fails if you use more advanced
                        shell constructs, so you can use this switch to
                        disable it. (default: False)
  --no-directory-hooks  Disable running executables found in Certbot''s hook
                        directories during renewal. (default: False)
  --disable-renew-updates
                        Disable automatic updates to your server configuration
                        that would otherwise be done by the selected installer
                        plugin, and triggered when the user executes "certbot
                        renew", regardless of if the certificate is renewed.
                        This setting does not apply to important TLS
                        configuration updates. (default: False)
  --no-autorenew        Disable auto renewal of certificates. (default: True)

certificates:
  List certificates managed by Certbot

delete:
  Options for deleting a certificate

revoke:
  Options for revocation of certificates

  --reason {unspecified,keycompromise,affiliationchanged,superseded,cessationofoperation}
                        Specify reason for revoking certificate. (default:
                        unspecified)
  --delete-after-revoke
                        Delete certificates after revoking them, along with
                        all previous and later versions of those certificates.
                        (default: None)
  --no-delete-after-revoke
                        Do not delete certificates after revoking them. This
                        option should be used with caution because the 'renew'
                        subcommand will attempt to renew undeleted revoked
                        certificates. (default: None)

register:
  Options for account registration

  --register-unsafely-without-email
                        Specifying this flag enables registering an account
                        with no email address. This is strongly discouraged,
                        because in the event of key loss or account compromise
                        you will irrevocably lose access to your account. You
                        will also be unable to receive notice about impending
                        expiration or revocation of your certificates. Updates
                        to the Subscriber Agreement will still affect you, and
                        will be effective 14 days after posting an update to
                        the web site. (default: False)
  -m EMAIL, --email EMAIL
                        Email used for registration and recovery contact. Use
                        comma to register multiple emails, ex:
                        u1@example.com,u2@example.com. (default: Ask).
  --eff-email           Share your e-mail address with EFF (default: None)
  --no-eff-email        Don''t share your e-mail address with EFF (default:
                        None)

update_account:
  Options for account modification

unregister:
  Options for account deactivation.

  --account ACCOUNT_ID  Account ID to use (default: None)

install:
  Options for modifying how a certificate is deployed

rollback:
  Options for rolling back server configuration changes

  --checkpoints N       Revert configuration N number of checkpoints.
                        (default: 1)

plugins:
  Options for the "plugins" subcommand

  --init                Initialize plugins. (default: False)
  --prepare             Initialize and prepare plugins. (default: False)
  --authenticators      Limit to authenticator plugins only. (default: None)
  --installers          Limit to installer plugins only. (default: None)

update_symlinks:
  Recreates certificate and key symlinks in /etc/letsencrypt/live, if you
  changed them by hand or edited a renewal configuration file

enhance:
  Helps to harden the TLS configuration by adding security enhancements to
  already existing configuration.

plugins:
  Plugin Selection: Certbot client supports an extensible plugins
  architecture. See 'certbot plugins' for a list of all installed plugins
  and their names. You can force a particular plugin by setting options
  provided below. Running --help <plugin_name> will list flags specific to
  that plugin.

  --configurator CONFIGURATOR
                        Name of the plugin that is both an authenticator and
                        an installer. Should not be used together with
                        --authenticator or --installer. (default: Ask)
  -a AUTHENTICATOR, --authenticator AUTHENTICATOR
                        Authenticator plugin name. (default: None)
  -i INSTALLER, --installer INSTALLER
                        Installer plugin name (also used to find domains).
                        (default: None)
  --apache              Obtain and install certificates using Apache (default:
                        False)
  --nginx               Obtain and install certificates using Nginx (default:
                        False)
  --standalone          Obtain certificates using a "standalone" webserver.
                        (default: False)
  --manual              Provide laborious manual instructions for obtaining a
                        certificate (default: False)
  --webroot             Obtain certificates by placing files in a webroot
                        directory. (default: False)
  --dns-cloudflare      Obtain certificates using a DNS TXT record (if you are
                        using Cloudflare for DNS). (default: False)
  --dns-cloudxns        Obtain certificates using a DNS TXT record (if you are
                        using CloudXNS for DNS). (default: False)
  --dns-digitalocean    Obtain certificates using a DNS TXT record (if you are
                        using DigitalOcean for DNS). (default: False)
  --dns-dnsimple        Obtain certificates using a DNS TXT record (if you are
                        using DNSimple for DNS). (default: False)
  --dns-dnsmadeeasy     Obtain certificates using a DNS TXT record (if you are
                        using DNS Made Easy for DNS). (default: False)
  --dns-gehirn          Obtain certificates using a DNS TXT record (if you are
                        using Gehirn Infrastructure Service for DNS).
                        (default: False)
  --dns-google          Obtain certificates using a DNS TXT record (if you are
                        using Google Cloud DNS). (default: False)
  --dns-linode          Obtain certificates using a DNS TXT record (if you are
                        using Linode for DNS). (default: False)
  --dns-luadns          Obtain certificates using a DNS TXT record (if you are
                        using LuaDNS for DNS). (default: False)
  --dns-nsone           Obtain certificates using a DNS TXT record (if you are
                        using NS1 for DNS). (default: False)
  --dns-ovh             Obtain certificates using a DNS TXT record (if you are
                        using OVH for DNS). (default: False)
  --dns-rfc2136         Obtain certificates using a DNS TXT record (if you are
                        using BIND for DNS). (default: False)
  --dns-route53         Obtain certificates using a DNS TXT record (if you are
                        using Route53 for DNS). (default: False)
  --dns-sakuracloud     Obtain certificates using a DNS TXT record (if you are
                        using Sakura Cloud for DNS). (default: False)

manual:
  Authenticate through manual configuration or custom shell scripts. When
  using shell scripts, an authenticator script must be provided. The
  environment variables available to this script depend on the type of
  challenge. $CERTBOT_DOMAIN will always contain the domain being
  authenticated. For HTTP-01 and DNS-01, $CERTBOT_VALIDATION is the
  validation string, and $CERTBOT_TOKEN is the filename of the resource
  requested when performing an HTTP-01 challenge. An additional cleanup
  script can also be provided and can use the additional variable
  $CERTBOT_AUTH_OUTPUT which contains the stdout output from the auth
  script.

  --manual-auth-hook MANUAL_AUTH_HOOK
                        Path or command to execute for the authentication
                        script (default: None)
  --manual-cleanup-hook MANUAL_CLEANUP_HOOK
                        Path or command to execute for the cleanup script
                        (default: None)
  --manual-public-ip-logging-ok
                        Automatically allows public IP logging (default: Ask)

nginx:
  Nginx Web Server plugin

  --nginx-server-root NGINX_SERVER_ROOT
                        Nginx server root directory. (default: /etc/nginx)
  --nginx-ctl NGINX_CTL
                        Path to the 'nginx' binary, used for 'configtest' and
                        retrieving nginx version number. (default: nginx)

null:
  Null Installer

standalone:
  Spin up a temporary webserver

webroot:
  Place files in webroot directory

  --webroot-path WEBROOT_PATH, -w WEBROOT_PATH
                        public_html / webroot path. This can be specified
                        multiple times to handle different domains; each
                        domain will have the webroot path that preceded it.
                        For instance: `-w /var/www/example -d example.com -d
                        www.example.com -w /var/www/thing -d thing.net -d
                        m.thing.net` (default: Ask)
  --webroot-map WEBROOT_MAP
                        JSON dictionary mapping domains to webroot paths; this
                        implies -d for each entry. You may need to escape this
                        from your shell. E.g.: --webroot-map
                        '{"eg1.is,m.eg1.is":"/www/eg1/", "eg2.is":"/www/eg2"}'
                        This option is merged with, but takes precedence over,
                        -w / -d entries. At present, if you put webroot-map in
                        a config file, it needs to be on a single line, like:
                        webroot-map = {"example.com":"/var/www"}. (default:
                        {})
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

### 刪除不要的域名
$# certbot delete
# or
$# certbot delete --cert-name host.domain.com


$# certbot certonly \
    --agree-tos \
    --manual-public-ip-logging-ok \
    --manual \
    --preferred-challenges=http \
    --manual-auth-hook /var/dayu/sh/certbot-auth.sh \
    --dry-run \
    --test-cert \
    -d 543346.com \
    -d www.543346.com \
    --register-unsafely-without-email \
    --keep-until-expiring
```


# 其他備註

- https 依賴 ssl, ssl 依賴 `數位憑證`
- `數位憑證` 可以自簽 or 送給第三方公正機關簽署, 之後安裝到自己的網站