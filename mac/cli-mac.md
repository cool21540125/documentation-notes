

```zsh
### TIMEFMT 設定 time 評估資源好用的輸出
TIMEFMT+='  max RSS %M'
time xxx
#YOUR_COMMAND  1.63s user 1.20s system 47% cpu 6.012 total  max RSS 385852
#user time : 1.2s
#sys  time : 47%
#total     : 6.012s
#增加 Memory Usage


### 查詢檔案 & 資料夾大小
du -hd0 .
du -hd1 .
du -hd2 .  # (應該是不會用到啦....)
```


# monitoring 相關

```zsh
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


# ACL

- 2020/10/26
- [Set default directory and file permissions](https://discussions.apple.com/thread/4805409)

macbook 至今依舊沒有 Linux 上的 `setfacl` 功能,  可用底下方式代替

```zsh
chmod -R +a "group:GroupName allow read,write,append,readattr,writeattr,readextattr,writeextattr" /Path-To-Shared-Directory

chmod -R +a "group:tony allow read,write,append,readattr,writeattr,readextattr,writeextattr" /var/log
chmod  -R +a 'tony allow write,delete,file_inherit,directory_inherit,add_subdirectory' /var/log
```