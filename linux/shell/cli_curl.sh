#!/bin/bash
exit 0
# https://gist.github.com/subfuzion/08c5d85437d5d4f00e58
#
#curl -X -d '<Body>' <Verb >'<Protocol>://<Host>:<Port>/<Path>?<Query_String>'
# -H : 預設的 Content-Type: application/x-www-form-urlencoded
# -d : Request Body (Key1=Value1&Key2=Value2)
# -L : 若 URL 經由 3XX 作重導, 則自動導向該頁面
# -X <VERB> : Request Method (GET, POST, PUT, HEAD, DELETE, ...)
# -O : 把爬下來的東西寫入到檔案系統
# -I : 僅擷取 HTTP-head
# -i : 包含 HTTP-header
# -k : 允許不安全的 https(未經過)
# -s : (silent) 不顯示進度及錯誤訊息
# -4 : 使用 IPv4 位址作解析
# -6 : 使用 IPv6 位址作解析
# -v : 列出詳細資訊(Debug使用居多)
#
# --------------------------------------------------------------------------------

### 偽造 X-Forwarded-For
curl --header "X-Forwarded-For: 9.4.8.7" http://demo.tonychoucc.com
# 做一層假的代理

### 藉由 Unix Socket(而非 TCP Socket) 的方式做連線
curl --unix-socket /PATH/TO/docker.sock http://localhost/version

### 若域名有做 load balance, 此方式可強制訪問特定一台
DOMAIN=tonychoucc.com
IP=1.2.3.4
curl -sv --resolve www.${DOMAIN}:${IP} https://www.${DOMAIN}/checked

### 取得 MyIP
curl ifconfig.me # 可能拿到 IPv6
dig @resolver1.opendns.com -t A -4 myip.opendns.com +short
wget -t 2 -T 10 -qO- http://ipv4.icanhazip.com
wget -t 2 -T 10 -qO- http://ip1.dynupdate.no-ip.com

###
