#!/bin/bash
exit 0
# ---------------------------------------------------


### 查看是否 port 已被佔用
sudo netstat -pna | grep 5001
# -p: 列出 PID 及 program name
# -n: 不要解析名稱
# -a: 列出 listening & non-listening sockets


##
sudo netstat -tulnp | grep :80
Proto  Recv-Q  Send-Q  Local Address  Foreign Address  State   PID/Program name
tcp         0       0  0.0.0.0:80     0.0.0.0:*        LISTEN  23988/nginx: master
# 因為在建立 nginx docker image時, 已經在 Dockerfile 定義好了「EXPOSR 80」