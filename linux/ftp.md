# FTP

- 2018/12/24

## Connection

FTP 連線使用 2 個 port

- 20 port : 負責檔案傳輸工作
- 21 port : 負責建立 TCP 連線


## ftp server

```sh
$# yum install -y vsftpd
$# systemctl start vsftpd
$# firewall-cmd --add-service=ftp
```

```sh
/etc/
    /vsftpd/                # vsftpd 設定目錄
        /user_list              # 禁止登入名單
        /vsftpd.conf            # vsftpd 設定主檔
/usr
    /sbin/
        /vsftpd             # vsftpd 服務執行檔
/var/
    /ftp/                   # anonymous 登入後的根目錄
```

## ftp client

```sh
# 使用目前使用者身分, ftp登入遠端機器
$ ftp 192.168.124.95
Connected to 192.168.124.95 (192.168.124.95).
220 (vsFTPd 3.0.2)
Name (192.168.124.95:tony2):
```

## Security

FTP 使用明碼傳輸, 且登入遠端後, 可以使用 cd 來切換目錄, 增加許多不必要的風險, 因此有必要作 `禁錮本機帳號`, 來避免任意切換目錄

```sh
$# /etc/vsftpd/vsftpd.conf
chroot_local_user=YES
allow_writeable_chroot=YES
# 以上兩者都需要啟用

$# setenforce 0
# 此外還會有 SELinux 卡住 =..= 但是我懶得去查怎麼啟用了, 所以先馬虎過關(將來用到再研究)

$# systemctl restart vsftpd
```

## 其他進階應用

```sh
# 允許 anonymous 上傳檔案
$# /etc/vsftpd/vsftpd.conf
anonymous_enables=YES
anon_upload_enable=YES

# SELinux
$# setsebool allow_ftpd_full_access on
$# setsebool -P allow_ftpd_full_access on
```



