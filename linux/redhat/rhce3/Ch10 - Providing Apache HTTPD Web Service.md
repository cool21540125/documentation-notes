# Ch10 - Providing Apache HTTPD Web Service

1. httpd
2. 設定檔
3. 進階議題
4. 備註

## 1. httpd

- [`/rhce3/attach/WebServer.xml`](https://www.draw.io/)

```sh
$# yum install -y httpd
```

## 2. 設定檔

- 主設定檔: `/etc/httpd/conf/httpd.conf`
- 自訂設定檔目錄: `/etc/httpd/conf.d/*.conf`

```sh
# 主要設定檔
$# vim /etc/httpd/conf/httpd.conf
### 內容如下 ###
ServerRoot              "/etc/httpd"            # httpd 組態檔起始位置
ServerName              qoo.tonychoucc.com      # ※ HostName
DocumentRoot            "/var/www/html"         # ※ httpd 取得靜態檔案的目錄, 此目錄應有 x 權限, 並且 httpd 對檔案具備 r 權限
Alias       /manual     /usr/share/httpd/manual # ※ <Directory "/usr/share/httpd/manual"></Directory> 所指向的檔案的別名, ex: http://localhost/manual
Listen                  80                      # 所有介面等候 「80/TCP」; 也可設定 「Listen 1.2.3.4:80」等候單一介面請求
User                    apache                  # 可執行 httpd daemon 的 User
Group                   apache                  # 可執行 httpd daemon 的 Group
LogLevel                warn                    # 就... log level
AddDefaultCharset       UTF-8                   # 針對 text/plain 及 text/html 增加「charset 到 Content-Type header」
ServerAdmin             root@localhost          # 網站出錯時, 可供聯繫的管道
ErrorLog                "logs/error_log"        # (軟連結)以 ServerRoot 為前置目錄, 並連結到 「/var/log/httpd/error_log」
Include                 conf.modules.d/*.conf   # 外掛模組
IncludeOptional         conf.d/*.conf           # (同 Include)

<Directory />                                   # 指向 DocumentRoot
    AllowOverride   none                        # 不參考 .htaccess
    Require         all denied                  # 不提供此目錄 (回傳「HTTP/1.1 403 Forbidden」)
</Directory>

<Directory "/var/www/html">                     #
    Options         Indexes FollowSymLinks      # Index(建議拿掉): 若對不存在的URL請求時, 會取得對應URL下的檔案清單); FollowSymLinks: 可用軟連結連到 DocumentRoot 以外的 dir
    AllowOverride   None                        # 不參考 .htaccess
    Require         all granted                 # 允許存取此目錄(若以絕對路徑允許DocumentRoot以外的路徑, 會有安全性隱憂)
</Directory>

<IfModule dir_module>                           # 模組路徑被載入後, ... 不知該怎麼說 -.-
    DirectoryIndex  index.html                  #
</IfModule>

<Files ".ht*">
    Require         all denied                  # 拒絕提供 security-sensitive檔案, ex: .htaccess 及 .htpasswd
</Files>

<IfModule log_config_module>
    LogFormat   "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat   "%h %l %u %t \"%r\" %>s %b" common
    CustomLog           "logs/access_log" combined      # Log檔路徑     Log格式

    <IfModule logio_module>
        LogFormat   "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"  %I %O" combinedio
    </IfModule>
</IfModule>
### 內容如上 ###
```


## 3. 進階議題

### 3-1. Virtual Hosts

```sh
$# vim /etc/httpd/conf.d/vhost.conf

# 第1個
<VirtualHost *:80>                          #1
    DocumentRoot    /srv/demo/www           #2
    ServerName      demo.tonychoucc.com     #3
</VirtualHost>

<Directory /srv/demo/www>                   #4
    Require all granted
</Directory>


# 第2個
<VirtualHost *:80>                          #1
    DocumentRoot    /srv/web/www            #2
    ServerName      web.tonychoucc.com      #3
</VirtualHost>

<Directory /srv/web/www>                    #4
    Require all granted
</Directory>

#1 常見為「*:80」; ex: 「192.168.124.222:80」 => 只允許 192.168.124.222:80 介面的網路流量
#2 此虛擬目錄的跟目錄路徑
#3 此虛擬目錄的 FQDN (得事先設定好環境解析)
#4 本電腦內的絕對路徑位置
```


### 3-2. WSGI

```sh
### wsgi 與 httpd 互動套件
$# yum install -y mod_wsgi


### WSGI application
$# mkdir -p /srv/webapp/www/webapp.py
# ---------- 內容如下 ----------
#!/usr/bin/python
import time
def application (environ, start_response):
  response_body = 'UNIX EPOCH time is now: %s\n' % time.time()
  status = '200 OK'
  response_headers = [('Content-Type', 'text/plain'),
                      ('Content-Length', '1'),
                      ('Content-Length', str(len(response_body)))]
  start_response(status, response_headers)
  return [response_body]
# ---------- 內容如上 ----------


### httpd 設定檔
$# vim /etc/httpd/conf.d/vhost.conf
# ---------- 內容如下 ----------
<VirtualHost *:80>
    ServerName      webapp.example.com                 # 如果用 Local 端瀏覽器作測試的話, 記得改你的 /etc/hosts
    WSGIScriptAlias /   /srv/webapp/www/webapp.py   # http://ServerName/ →就表示對「/」作請求
</VirtualHost>
<Directory /srv/webapp/www>
    require all granted
</Directory>
# ---------- 內容如上 ----------


# SELinux 問題
$# restorecon -RFv /srv/webapp
restorecon reset /srv/webapp context unconfined_u:object_r:var_t:s0->system_u:object_r:var_t:s0
restorecon reset /srv/webapp/www context unconfined_u:object_r:var_t:s0->system_u:object_r:httpd_sys_content_t:s0
restorecon reset /srv/webapp/www/webapp.py context unconfined_u:object_r:var_t:s0->system_u:object_r:httpd_sys_content_t:s0
#                                                                                                    ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
# SELinux 為 httpd_sys_content_t
```




### 3-3. Database 連線問題

SELinux 問題:

- Web Server 與 Database Server
    - 在不同電腦
        - `httpd_can_network_connect_db = 1`
    - 使用非標準 Port
        - `httpd_can_network_connect = 1`


## 4. 備註

Windows 10 怎麼玩?

選擇其一套裝軟體:

- wamp
- xampp
- AppServer

以上大致上就是 `Apache + MySQL + PHP`

### 關於註解

非常重要的備註: httpd 的設定檔裡面, 同一行裏頭, 不能有註解 ex:

```sh
# 註解1
key1    value1

key2    value2      # 註解2
```

則服務會掛掉!!, 同一行「key2    value2」, 頂多就設成這樣, 後面別再加註解

