

### 查看是否 port 已被佔用
sudo netstat -pna | grep 5001
# -p: 列出 PID 及 program name
# -n: 不要解析名稱
# -a: 列出 listening & non-listening sockets


### 列出佔用 port 的 process 相關程序
sudo lsof -i -P -n | grep 5001


### 