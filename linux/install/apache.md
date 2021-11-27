# Apache

Apache伺服器在 CentOS的套件名稱為 httpd, 將關套件為 `hpptd` 及 `httpd-tools`

- httpd: 主要套件, 主要為 `設定檔`, `模組`, `執行檔`
- httpd-tools: 權限驗證功能的帳號密碼工具



## httpd套件的重要檔案與目錄

- 主要安裝目錄: `/etc/httpd/`
- 設定檔: `/etc/httpd/conf/httpd.conf` 所有和伺服器有關的設定值
- 附加設定檔放置目錄: `/etc/httpd/conf.d` 這裡頭的`.conf`都會被設定主檔`httpd.conf`引入 (為了模組化管理)
- 紀錄檔: `/etc/httpd/logs/` -> `/var/log/httpd`
- 模組目錄: `/etc/httpd/modules/` -> `/usr/lib64/httpd/modules` 編譯好的模組放在此內
- 網頁根目錄: `/var/www/html/` 
- 服務執行程式: `/usr/sbin/httpd` 安裝後, 成為系統服務


## 防火牆

- [How to remove access to a port using firewall on Centos7?](https://serverfault.com/questions/818996/how-to-remove-access-to-a-port-using-firewall-on-centos7)

```sh
# 永久讓防火牆允許網頁連線
$ firewall-cmd --add-service=http --permanent

# 允許通過 8000/tcp
$ firewall-cmd --zone=public --add-port=8000/tcp

# 查看有沒有開成功
$ firewall-cmd --zone=public --list-ports
```

> `/etc/httpd/conf/httpd.conf`中, 關於**模組載入方式**, 語法: `LoadModule 模組名稱 模組檔案`
```sh
# 固定語法     模組名稱           模組檔案
#---------- ----------------- -------------------------
#LoadModule auth_basic_module modules/mod_auth_basic.so

# 模組檔案放在 /etc/httpd/modules/
```


## 虛擬目錄

> Alias /icons/ "/var/www/icons" >> 
  為系統內某個目錄建立**外部公開別名**(又稱**虛擬目錄**). 如此一來, 可以藉由`http://www.yours.com.tw/icons/` 存取 `/var/www/icons/`
```sh
$ vi /etc/httpd/
# 1.設定外網可以存取的虛擬目錄 /data, 其真實檔案為本地的 /opt/docs
Alias /data /opt/docs
# 但要記得把 /opt/docs可存取權限, 授權給 apache使用者

# 2.加入可以存取的允許範圍
<Directory /opt/docs>
    Require all granted
</Directory>

$ mkdir /opt/docs
$ chmod -R 755 /opt/docs
$ echo Hello > /opt/docs/test.html
# 重新啟動服務後, 即可透過「localhost/data/test.html」存取
```


## php

```sh
$ sudo yum install -y php
```


## php設定檔

- `/etc/httpd/conf.modules.d/10-php.conf` 讀取php模組
- `/etc/httpd/conf.d/php.conf` php模組的設定值

```sh
# 改完 php 或 httpd 之後, 都給重啟 httpd 服務
$ sudo systemctl restart httpd
```