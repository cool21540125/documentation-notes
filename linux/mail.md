

```sh
$ echo $USER
tony

$ mail              # 使用 mail 來收信
No mail for tony

$ ls /var/spool/mail    # 依照不同使用者, 指向不同檔案
root  rpc  tony  tony2

$ echo $MAIL        # 收信的檔案路徑變數
/var/spool/mail/tony
```