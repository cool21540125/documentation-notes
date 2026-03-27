#!/bin/bash
exit 0
#
# 用來檢測服務, 可直接連到某個 port 進行溝通; 另外還可啟動一個 port 來等待別人連線
#
#   $ nc [-u] [IP|host] [port]     # -u: 使用 UDP
#   $ nc -l [IP|host] [port]       # -l: 啟用一個 port 來監聽連線
# ---------------------------------------------------------------------------------------------------------------------

### ---------------------------------- Basic usage ----------------------------------
nc -z 127.0.0.1 7687 && echo "port open" || echo "port closed"
# 等同於做 telnet...


### ---------------------------------- 多個 Terminal 之間的玩法 ----------------------------------
## ------------ Terminal 1 ------------
nc -l localhost 22222

## ------------ Terminal 2 ------------
netstat -tulnp | grep nc
#Proto Recv-Q Send-Q Local Address   Foreign Address   State       PID/Program name
#tcp6  0      0      ::1:22222       :::*              LISTEN      31911/nc
#...(僅節錄部分)...

ss -tulnp | grep nc
#Netid  State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
#tcp    LISTEN     0      10      ::1:22222                :::*                   users:(("nc",pid=31911,fd=3))
#...(僅節錄部分)...

hi~
# ↑ 此時, Terminal 1 也會出現該訊息, 兩者可開始溝通了

### ----------------------------------  ----------------------------------
