


```bash
### 利用 port 查出 pid
netstat -anv -p tcp | grep "Proto\|*.80"
#Proto Recv-Q Send-Q  Local Address          Foreign Address        (state)     rhiwat shiwat    pid   epid  state    options
#tcp46      0      0  *.80                   *.*                    LISTEN      131072 131072  92386      0 0x0080 0x0000000e
# pid 為 92386 的 process 監聽了 *.80 (TCP4 & TCP^)


### 利用 pid 查出 process 的 cmdline
ps ax | grep ${PID}
#  PID   TT  STAT      TIME COMMAND
#92386   ??  S      0:00.01 /usr/sbin/httpd -D FOREGROUND


### 可查詢到 該名稱服務對應到的 PID, PPID
ps -ef | grep httpd


###
sudo kill -9 XXXX
```


## stop httpd

原本誤以為 httpd 是個使用 CLI 或是 brew services 的方式啟動, 但排查後並非如此... (程序 kill -9 以後還是會復活)

```bash
### 查詢後發現, httpd 的 master process 是由 PID 1 帶起來的
$# ps -ef | grep httpd
    0 14343     1   0 10:31AM ??         0:00.39 /usr/sbin/httpd -D FOREGROUND
   70 14363 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
   70 14370 14343   0 10:31AM ??         0:00.01 /usr/sbin/httpd -D FOREGROUND
   70 14371 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
   70 14372 14343   0 10:31AM ??         0:00.00 /usr/sbin/httpd -D FOREGROUND
  502 14536 14246   0 10:31AM ttys004    0:00.00 grep httpd


### 而 PID 1 在 mac 裡頭是 launchd (不可能去砍它)
$# ps -ef | head -n 2
  UID   PID  PPID   C STIME   TTY           TIME CMD
    0     1     0   0  7Sep22 ??       242:52.69 /sbin/launchd


### 排查後得知是由 apachectl 來做啟動
$# sudo apachectl stop
# 如此一來就可正常關閉 httpd
```