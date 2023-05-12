
## stop httpd

原本誤以為 httpd 是個使用 CLI 或是 brew services 的方式啟動, 但排查後並非如此... (程序 kill -9 以後還是會復活)

```bash
### 查詢後發現, httpd 的 master process 是由 PID 1 帶起來的
ps -ef | grep httpd
#    0 14343     1   0 10:31AM ??         0:00.39 /usr/sbin/httpd -D FOREGROUND
#   70 14363 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
#   70 14370 14343   0 10:31AM ??         0:00.01 /usr/sbin/httpd -D FOREGROUND
#   70 14371 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
#   70 14372 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
#  502 14536 14246   0 10:31AM ttys004    0:00.00 grep httpd


### 而 PID 1 在 mac 裡頭是 launchd (不可能去砍它)
ps -ef | head -n 2
#  UID   PID  PPID   C STIME   TTY           TIME CMD
#    0     1     0   0  7Sep22 ??       242:52.69 /sbin/launchd


### 排查後得知是由 apachectl 來做啟動
sudo apachectl stop
# 如此一來就可正常關閉 httpd
```


# Firefox

- [](https://support.mozilla.org/bm/questions/799046)


touchpad 無法在 firefox 上頭正常使用的解法:

- new tab `about:config`
- 搜尋 `browser.gesture`
- 設定 browser.gesture.pinch.in Value = cmd_fullZoomReduce
- 設定 browser.gesture.pinch.in.shift Value = cmd_fullZoomReset
- 設定 browser.gesture.pinch.latched Value = false
- 設定 browser.gesture.pinch.out Value = cmd_fullZoomEnlarge
- 設定 browser.gesture.pinch.out.shift Value = cmd_fullZoomReset
