# System 相關

```zsh
### 查詢 Mac 系統資訊
system_profiler SPSoftwareDataType SPHardwareDataType

```

```zsh
### pmset 用來做 mac 的電源管理(Power Management)
# https://www.dssw.co.uk/reference/pmset/ 裡面有各種設定的 examples
pmset -g


### 讓 mac 不要進入 休眠
sudo pmset -b sleep 0; sudo pmset -b disablesleep 1
#Warning: Idle sleep timings for "AC Power" may not behave as expected.
#- Disk sleep should be non-zero whenever system sleep is non-zero.
# ---------------------------- 會噴出上面的警告 ----------------------------


### 讓 mac 啟用 休眠
sudo pmset -b sleep 5; sudo pmset -b disablesleep 0


### 週一到週六 08:30-22:00 不要 Sleep, 其餘時間 Sleep




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

# 設定 login shell

```sh
### 查詢 login shell
dscl . -read /Users/$USER UserShell
#UserShell: /bin/sh


### 設定 login shell
dscl . -change /Users/$USER UserShell /bin/sh /bin/bash
# (使用 sh 呼叫 bash 的概念)


### 查詢 login shell (again)
dscl . -read /Users/$USER UserShell
#UserShell: /bin/bash


### dscl 等同於 usermod

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

# Developer 相關

```zsh
### 查看 xcode project 的 Team ID
grep DEVELOPMENT_TEAM *.xcodeproj/*.pbxproj -m 1 | sed -E 's/^[[:space:]]+//'
#DEVELOPMENT_TEAM = ABCDE12345;

###
```

# 清除 mac 的 DNS cache, flush DNS

```zsh
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

# 額外屬性 (等同於 Linux 的隱藏屬性 lsattr/chattr)

```zsh
### 列出檔案的額外屬性
xattr -l $FILE
```
