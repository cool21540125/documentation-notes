#!/bin/bash
exit 0
# list open files. 在 Linux 底下, 所有東西都是 file, 因而可以查看底下的東西:
#   file / dir / fs / dev / nfs / pipeline / tcp socket / udp socket / unix socket / ...
#
# $ lsof [-aUu] [+d]
# -a: 多項資料需要同時成立才列出
# -U: 僅列出 Unix-like socket
# -u <user>: 列出該使用者相關程序所開啟的檔案
# +d <dir name>: 該目錄下, 已經被開啟的檔案
# ---------------------------------------------------------------------------------------------------

### 列出佔用 port 的 process 相關程序
sudo lsof -i -P -n | grep 12.34.56.78

### (不知道怎解釋)
lsof -i
#COMMAND     PID      USER   FD   TYPE             DEVICE SIZE/OFF   NODE NAME
#loginwind   379      XXXX    5u  IPv4 0xe0c9803933b2e87c      0t0    UDP *:*
#Google      591      XXXX   82u  IPv4 0x11884c2d6e1408bc      0t0    UDP *:*
#python3    3705      XXXX   17u  IPv4            3383170      0t0    TCP *:commplex-main (LISTEN)
#python3    3705      XXXX   19u  IPv4            3387478      0t0    TCP vm-220:39544->vm-220:6379 (ESTABLISHED)
#python3    3705      XXXX   23u  IPv4            3387483      0t0    TCP vm-220:52422->vm-220:postgres (ESTABLISHED)
#python3    3705      XXXX   24u  IPv4            3387486      0t0    TCP vm-220:39548->vm-220:6379 (ESTABLISHED)
#python3    3705      XXXX   25u  IPv4            3387488      0t0    TCP vm-220:39550->vm-220:6379 (ESTABLISHED)
#python3    3705      XXXX   26u  IPv4            3387489      0t0    TCP vm-220:52428->vm-220:postgres (ESTABLISHED)
#python3    3705      XXXX   27u  IPv4            3387490      0t0    TCP vm-220:52430->vm-220:postgres (ESTABLISHED)

###
