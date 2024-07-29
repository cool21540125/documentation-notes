squid - HTTP Cache Proxy Server

- 2019/12/30
- https://dywang.csie.cyut.edu.tw/dywang/linuxserver/node138.html


Linux 代理伺服器的軟體, ex: `squid`, `v2ray`, ...

小型環境不值得架設 Proxy!!! 

- `/etc/squid/squid.conf` : squid設定主檔
- `/etc/squid/mime.conf` : 設定 squid 所支援的 Internet 上面的檔案格式(mime)
- `/usr/sbin/squid` : squid 主程式
- `/var/spool/squid` : squid 快取目錄
- `/usr/lib64/squid/` : squid 額外控制模組, ex: 密碼認證等

預設如下:

* 3128 TCP port (可能還有 3130 UDP port)
* 只給 localhost
* 快取 Disk 100M
* 快取 RAM 8M
* 使用 squid 這個 User


## Install

```bash
yum install -y squid

systemctl start squid

firewall-cmd --add-port 3128/tcp
```


# Ports

- 3128(TCP): 進行監聽 && 傳送資料
- 3130(UDP): 與鄰近 Proxy 相互溝通彼此的快取資料庫功能 (與用戶無關)


## Structure

```bash
/etc/
    /squid/
        /squid.conf         # squid 於 Internet 上支援的格式
        /mime.conf          # squid 設定主檔
/usr/
    /lib64/squid/           # squid 額外模組, ex: 認證相關
    /sbin/squid             # squid 主程式
/var/
    /spool/squid            # squid 預設快取目錄
```


# 設定主檔 (僅節錄)

**順序很重要**

```bash
# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing should be allowed
acl localnet src 10.0.0.0/8     # 允許訪問此 Proxy Server 的 Private IP
acl localnet src 172.16.0.0/12  # 允許訪問此 Proxy Server 的 Private IP (v4 網段)
acl localnet src 192.168.0.0/16 # 允許訪問此 Proxy Server 的 Private IP (v4 網段)
acl localnet src fc00::/7       # 允許訪問此 Proxy Server 的 Private IP (v6 網段) local private network range
acl localnet src fe80::/10      # 允許訪問此 Proxy Server 的 Private IP (v6 網段) link-local (directly plugged) machines
acl externat src 94.188.22.67   # 允許訪問此 Proxy Server 的 Public IP


### 定義 SSL Ports && 常用標準 Ports
acl SSL_ports port 443      # 可取得資料的 port (連線加密用)
acl Safe_ports port 80      # http
acl Safe_ports port 21      # ftp
acl Safe_ports port 443     # https

acl CONNECT method CONNECT

#
# Recommended minimum Access Permission configuration:
#
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

### 底下, 簡言之, 只有本機能管理
# Only allow cachemgr access from localhost
http_access allow localhost manager  # 允許 localhost 進行管理功能
http_access deny manager             # 拒絕 其他管理來源

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet              # 放行內部網路的使用
http_access allow localhost             # 放行本機的使用
http_access deny all                    # 此外, 拒絕其他

http_port 3128                          # 預設監聽 3128 port

#cache_dir ufs /var/spool/squid 100 16 256
#              ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑                快取目錄位置
#                               ↑↑↑            預設 100 MB 快取
#                                   ↑↑         第一層目錄設定 16 個目錄
#                                      ↑↑↑     第二層目錄設定 256 個目錄

coredump_dir /var/spool/squid           # 預設快取目錄

#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern .       0   20% 4320
```



# squid - transparent caching (透明快取)

實作方式:

- Policy based routing
- Smart switching
- Use Squid Box as a Gateway
