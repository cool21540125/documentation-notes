# locate

通常會與 `updatedb` 一起使用

locate 依據 「已建立的資料庫 /var/lib/mlocate/」, 找出要查的關鍵字 ; `updatedb`(此指令下下去, 可能要等一下子) 根據 `/etc/updatedb.conf` 設定去搜尋磁碟內的檔名, 並更新 `/var/lib/mlocate` 內的資料庫檔案

```sh
$# locate [-ir] keywork
# -i : 忽略大小寫
# -r : 可用 regex 查找

$# locate -l 5 passwd    # 「-l 5」找出所有與 passwd 相關的檔名, 僅輸出 5 個
/etc/passwd
/etc/passwd-
/etc/pam.d/passwd
/etc/security/opasswd
/opt/anaconda3/pkgs/openssl-1.0.2l-h077ae2c_5/ssl/man/man1/passwd.1
```