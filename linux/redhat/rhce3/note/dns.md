# unbound DNS

- 2018/12/03

### DNS dump cache

```sh
# 列出別人利用我這台DNS查詢的快取記錄
$# unbound-control dump_cache

# 把快取在本機(我這台DNS)的紀錄給清除
$# unbound-control flush google.com.tw
```

### DNS Return Code

| Code     | Description                                                                                                     |
| -------- | --------------------------------------------------------------------------------------------------------------- |
| SERVFAIL | (常見)DNS Server 無法與 要查詢的名稱權威伺服器 進行通信; NS Query 時遇到問題                                    |
| NXDOMAIN | queried name 不在 zone 內; 找不到資源紀錄;                                                                      |
| REFUSED  | 因 DNS 政策限制, NS 無法執行 client DNS request OR client 無權使用 `recursive query` 及 `zone transfer request` |

## 1. 名詞解釋

DNS 區域保存的資料, 稱為 `資源紀錄 (Resource records, RRs)`

- DNS(Domain Name Server) : 網際網路通訊協定名稱, 也稱 NS
- hint (root) : 頂層 DNS「.」 啦!! 紀錄 「.」的 zone 的類型, 稱為 `hint 類型`
- TLD (Top Level Domain) : 頂層領域 「.」 這個 DNS 啦
- gTLD : 一般最上層領域名稱
- ccTLD : 國碼最上層領域名稱
- DNS resolution : IP -> Domain Name
- DNS resolution : Domain Name -> IP

* RR 格式: `Domain [TTL]   IN  [RR type]   value`

```sh
# DNS resource records 範例
owner-name          TTL     class       type    data
www.example.com     300     IN          A       192.168.1.10
```

| RR type | Description                        | Format                   | Example                                                                                              |
| ------- | ---------------------------------- | ------------------------ | ---------------------------------------------------------------------------------------------------- |
| A       | IPv4                               | HOST TTL IN A IP4        | www.tonychoucc.com 3600 IN A 54.87.59.78                                                             |
| CNAME   | NS Alias (Canonical Name)          | ALIAS TTL IN CNAME HOST  | orz.tonychoucc.com 3600 IN CNAME www.tonychoucc.com                                                  |
| NS      | DNS Server(Name Server)            | 記錄我這台 DNS 的 DNS    | ns-670.awsdns-19.net.<br>ns-474.awsdns-59.com.<br>ns-1669.awsdns-16.co.uk.<br>ns-1080.awsdns-07.org. |
| SOA     | Due Date                           |                          | ns-1669.awsdns-16.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400                      |
| TXT     | Text records                       |                          |
| AAAA    | IPv6                               |                          |
| SRV     | service                            |                          |
| MX      | 郵件伺服器的主機                   | N HOST.XXX.DOMAIN        | google.com. 451 IN MX 10 aspmx.l.google.com.                                                         |
| PTR     | IP 對應的 Domain Name              | Reverse IP.in-addr.arpa. | 87.124.168.192 (IP 倒過來寫啦!)                                                                      |
| HINFO   | 主機使用的硬體和作業系統的參考資料 |                          |

```sh
$ dig tonychoucc.com
;; AUTHORITY SECTION:
tonychoucc.com.         3600    IN      SOA     ns-1669.awsdns-16.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400
#                                                      1                          2                    3  4    5    6      7
# ↑ 僅節錄部分
# 1. Master DNS Server 主機名稱, 也就是 「ns-1669.awsdns-16.co.uk.」為「tonychoucc.com」這個領域的主要 DNS Server
# 2. 管理員的 Email. 也就是 「awsdns-hostmaster@amazon.com.」(因為 @ 在 DB檔案中有特別意義, 所以被改成 .)
# 3. Serial(序號), 越大越新. master 作資源紀錄的異動版號的概念, 用來被 slave 求取資料時, 來判斷是否有變動過的判斷依據. ex: 2018122432, 表示此為 2018/12/24 第 32 次更新(同天最多 99 次). Serial 要小於 2^32
# 4. Refresh(更新頻率). 每隔 7200 秒, slave 會向 master 要求資料 && 更新, 但若要求到的資料, 發現它的 Serial 並沒有變大, 則不作更新
# 5. Retry(失敗重連時間). slave 對 master 每隔 7200 秒請求資料一次, 若連線失敗, 則每 900 秒重連
# 6. Expire(失效時間). 重新連線如果一直持續了 1209600 秒(14天@@), 則 slave 放棄對 master 重新連線的請求. (admin 早應該來處理了@@凸)
# 7. Min TTL(快取時間). DB 中的 zone file, 若沒給 TTL, 則遵循此 TTL.
```

###### CNAME 指向 `A 記錄` or 指向 `不屬於自己的Domain, 但額外加 TXT 紀錄`

###### SOA : 如果有很多台 DNS Server 共同管理一個 Domain 時, 較佳的方式是採用 master/slave 的方式. 這樣做的話, 就得宣告被管理的 zone file 是如何進行傳輸, 此時就需要 SOA record 了.

###### MX : 通常 一個特定的 Domain, 都會設定一個 MX, 也就是 寄信給這個 Domain 的信件, 都會送到這台 EMail Server 主機裏頭.

###### PTR: 把 ip 倒過來寫, 然後後面緊接著加上「.in-addr.arpa.」

### DNS Server 細部設定

- 架設 `DNS`, 需要 `上層 DNS` 的授權才可以成為合法的 `DNS` (否則只能自己玩)
- `DNS` 查詢時, 若 DB 內找不到, 會前往 `root(.)` 或 `forwarders(ex:168.95.1.1)` 查詢

## 環境 - 3 台 VM

- `192.168.124.222/24` : KDC, DNS
- `192.168.124.118/24` : server (提供服務)
- `192.168.124.129/24` : desktop (使用服務)

```sh
### KDC
nmcli con add con-name demo type ethernet ifname eth0 autoconnect yes
nmcli con mod eth0 autoconnect no
nmcli con mod demo ipv4.addresses 192.168.124.222/24 ipv4.gateway 192.168.124.254 ipv4.method manual
nmcli con mod demo ipv4.dns 192.168.2.115
nmcli con mod demo +ipv4.dns 192.168.2.116
nmcli con mod demo +ipv4.dns 192.168.2.117
nmcli con up demo

### server
nmcli con add con-name demo type ethernet ifname eth0 autoconnect yes
nmcli con mod eth0 autoconnect no
nmcli con mod demo ipv4.addresses 192.168.124.118/24 ipv4.gateway 192.168.124.254 ipv4.method manual
nmcli con mod demo ipv4.dns 192.168.2.115
nmcli con mod demo +ipv4.dns 192.168.2.116
nmcli con mod demo +ipv4.dns 192.168.2.117
nmcli con up demo

### desktop
nmcli con add con-name demo type ethernet ifname eth0 autoconnect yes
nmcli con mod eth0 autoconnect no
nmcli con mod demo ipv4.addresses 192.168.124.129/24 ipv4.gateway 192.168.124.254 ipv4.method manual
nmcli con mod demo ipv4.dns 192.168.124.222
#nmcli con mod demo ipv4.dns 192.168.2.115
#nmcli con mod demo +ipv4.dns 192.168.2.116
#nmcli con mod demo +ipv4.dns 192.168.2.117
nmcli con up demo

# 另一組連線(Default Switch 作 NAT 使用)
nmcli con add con-name nat type ethernet ifname eth0
nmcli con mod nat ipv4.addresses 172.22.35.4/28 ipv4.gateway 172.22.35.1 ipv4.method manual
nmcli con mod nat ipv4.dns  172.22.35.1
nmcli con mod demo autoconnect no
nmcli con up nat
```

## DNS

```sh
$# yum install -y unbound

### Cache DNS
$# vim /etc/unbound/unbound.conf
# 1 開放給所有介面查詢
interface: 0.0.0.0
# 2 允許作 recursive query 的客戶端
access-control: 172.25.0.0/24 allow
# 3
domain-insecure: "example.com"
# 4
forward-zone:
    name: "."
    forward-addr: 172.25.254.254
#

# Check Config
$# unbound-checkconf
unbound-checkconf: no errors in /etc/unbound/unbound.conf

$# systemctl start unbound
$# systemctl enable unbound

# 防火牆
$# firewall-cmd --add-service=dns
$# firewall-cmd --add-service=dns --permanent
```

## 設定

- [How to Install and Configure ‘Cache Only DNS Server’ with ‘Unbound’ in RHEL/CentOS 7](https://www.tecmint.com/setup-dns-cache-server-in-centos-7/)

```sh
$# vim /etc/unbound/unbound.conf
server:
        # 本機 DNS 等候查詢的介面
        interface: 192.168.124.222

        # (我不知道確切用途...)
        do-ip4: yes
        do-udp: yes
        do-tcp: yes

        # 允許查詢的來源
        access-control: 0.0.0.0/0 allow

        # 感覺有點重要, 但我還不會用
        chroot: ""
        username: "unbound"
        directory: "/etc/unbound"

        # 查詢 Log
        logfile: /var/log/unbound

        # 安全性考量吧
        hide-identity: yes
        hide-version: yes

        # 不曉得...
        domain-insecure: swrd

        # Resource Record
        local-data: 'server22.swrd.     IN A            192.168.124.118'
        local-data: 'desktop22.swrd.    IN A            192.168.124.129'
        local-data: 'kdc.swrd.          IN A            192.168.124.222'
        local-data: 'tony.swrd.         IN A            192.168.124.101'
        local-data: 'tonynb.            IN A            192.168.124.133'
        local-data: 'desktop22.         IN CNAME        desktop22.swrd.'


forward-zone:
        name: "."
        forward-addr: 192.168.124.254
        # 快取 DNS 指向的 gw
```

## 重啟

```sh
systemctl restart unbound
systemctl status unbound
```

## 測試

```sh
### dig
$# dig @192.168.124.222 google.com.tw
; <<<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<<>> @192.168.124.222 google.com.tw
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<<- opcode: QUERY, status: SERVFAIL, id: 6119
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;google.com.tw.                 IN      A

;; Query time: 278 msec
;; SERVER: 192.168.124.222#53(192.168.124.222)
;; WHEN: Mon Dec 03 23:43:32 CST 2018
;; MSG SIZE  rcvd: 42

### drill
$# drill @192.168.124.222 google.com.tw
;; ->>HEADER<<<- opcode: QUERY, rcode: SERVFAIL, id: 13057
;; flags: qr rd ra ; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;; google.com.tw.       IN      A

;; ANSWER SECTION:

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 0 msec
;; SERVER: 192.168.124.222
;; WHEN: Mon Dec  3 23:45:31 2018
;; MSG SIZE  rcvd: 31

$# unbound-control status
version: 1.6.6
verbosity: 1
threads: 4
modules: 3 [ ipsecmod validator iterator ]
uptime: 70 seconds
options: reuseport control(ssl)
unbound (pid 57259) is running...

$# unbound-control dump_cache
START_RRSET_CACHE
;rrset 96 1 0 5 0
google.com.tw.  96      IN      A       172.217.24.3
END_RRSET_CACHE
START_MSG_CACHE
END_MSG_CACHE
EOF

### 查看是否是被 unbound cache server 來作 forwarders
$# unbound-control lookup google.com.tw
The following name servers are used for lookup of google.com.tw.
forwarding request:
Delegation with 0 names, of which 0 can be examined to query further addresses.
It provides 3 IP addresses.
192.168.2.115           rto 13 msec, ttl 766, ping 1 var 3 rtt 50, tA 0, tAAAA 0, tother 0, EDNS 0 probed.
192.168.2.116           rto 13 msec, ttl 766, ping 1 var 3 rtt 50, tA 0, tAAAA 0, tother 0, EDNS 0 probed.
192.168.2.117           rto 18 msec, ttl 766, ping 2 var 4 rtt 50, tA 0, tAAAA 0, tother 0, EDNS 0 probed.
```

# OLD

## 環境

Host 架設 2 台 VM

```sh
### Host
$ ipconfig
乙太網路卡 vEthernet (預設切換):

   連線特定 DNS 尾碼 . . . . . . . . :
   連結-本機 IPv6 位址 . . . . . . . : fe80::6d63:b9d7:b1eb:229a%20
   IPv4 位址 . . . . . . . . . . . . : 172.22.35.1
   子網路遮罩 . . . . . . . . . . . .: 255.255.255.240
   預設閘道 . . . . . . . . . . . . .:

### VM1(DNS Server) - 網路環境使用 預設切換 作 NAT (CentOS7.0)
# 網路環境如下
$# nmcli con show iamdns | grep 'ipv4\|IP4'
ipv4.method:                            manual
ipv4.dns:                               192.168.2.115, 192.168.2.116, 192.168.2.117
ipv4.addresses:                         { ip = 172.22.35.5/28, gw = 172.22.35.1 }
IP4.ADDRESS[1]:                         ip = 172.22.35.5/28, gw = 172.22.35.1
IP4.DNS[1]:                             192.168.2.115
IP4.DNS[2]:                             192.168.2.116
IP4.DNS[3]:                             192.168.2.117
# 「iamdns Connection」所使用的 DNS 為 Host 所使用的 Connection 設定的 Gateway 所指定的 DNS

### VM2(DNS Client) - 網路環境使用 預設切換 作 NAT (CentOS7.5)
$# nmcli con show useDNS5 | grep 'ipv4\|IP4'
ipv4.method:                            manual
ipv4.dns:                               172.22.35.5,192.168.2.115,192.168.2.116
ipv4.addresses:                         172.22.35.10/28
ipv4.gateway:                           172.22.35.1
IP4.ADDRESS[1]:                         172.22.35.10/28
IP4.GATEWAY:                            172.22.35.1
IP4.DNS[1]:                             172.22.35.5
IP4.DNS[2]:                             192.168.2.115
IP4.DNS[3]:                             192.168.2.116
# 「useDNS10 Connection」所使用的 DNS 為 VM1 這個 DNS
```

## 使用 bind (非 unbound)

```sh
yum install bind bind-chroot bind-utils bind-libs
# bind : DNS主程式
# bind-chroot : bind 安全性隔離套件
# bind-utils : Client 搜尋 DomainName 的指令(dig 等指令工具)
```

## 樹目錄

```sh
/etc/
    /hosts                      # 最早的 hostname IP 對應檔
    /named.conf                 # bind 的設定主檔
    /named.rfc1912.zones        # DNS Server 的管轄網域定義檔 ## 註3
    /nsswitch.conf              # `/etc/hosts` 或 `/etc/resolv.conf` 的順序. ## 註1
    /resolv.conf                # ISP 的 DNS Server IP記錄處
    /sysconfig/                 #
        /named                      #
/usr/
    /sbin/
        /named                  # 系統服務執行檔
/var/
    /log/
        /named.log                  # DNS Log
    /named/                     # 管轄網域的資源紀錄
        /chroot/                    # 安裝了 bind-chroot 套件了的 name server(bind套件) 安全機制
            /etc/                       #
                /named/                     # 同 /etc/named/
                /pki/
            /var/                       #
                /named/                     #
        /named.localhost            #
        /named.ca                   #
        /named.loopback             #
        /named.tony                 # 自訂的 RR ## 註2
    /run/
        /named                  #
## 註1
#    「hosts: files dns myhostname」→ 先用 /etc/hosts 再用 /etc/resolv.conf, 最後看 myhostname(這啥...)
#    不要直接改它!! 早期 Linux 版本直接改 OK, 比較新的版本會藉由 `systemd-resolved` 來管控它. 因而它只是個軟連結
#    systemd-resolve --status 可查詢 systemd-resolved 使用情況, 進而研判 /etc/resolv.conf 的身世
## 註2 : 要在 /etc/named.rfc1912.zones 定義一個 zone 區塊, file 指名「file "named.tony"」 且為 root:named 擁有
## 註3 : 裡頭定義許多 `zone block`(參考 /var/named/named.xxx)
```

- 如果使用 DHCP 自動取得 IP, 取得的資料, 會去複寫 `/etc/resolv.conf`(原本就設定好了, 還是會被蓋掉)
  - 若不想要這事情發生, 必須到 `/etc/sysconfig/network-scripts/ifcfg-CONN` 增加 `PEERDNS=no`, 並 restart network
- `bind` 因使用了 `/etc` 與 `/var/named` 來放置資源紀錄, 且 `named service` 對外開放, 因而產生安全性隱憂
  - 使用 `bind-chroot` 套件, 將 `bind` 的根目錄由 `/` → `/var/named/chroot`, 故:
    - `/etc` → `/var/named/chroot/etc`
    - `/var/named` → `/var/named/chroot/var/named`
-

## 啟用

```sh
### root
# 設定檔寫完後, 記得先檢查
named-checkconf

# 啟用 DNS
firewall-cmd --add-service=dns
firewall-cmd --add-service=dns --permanent

systemctl start named
systemctl enable named
systemctl status named
```

## dig 指令工具

```sh
$ dig [options] FQDN [@server]
# 若不以 /etc/resolv.conf 指定的 DNS查詢時, 可自行指定 DNS
# 常用的 options為:
# +trace  : 從 root 開始追蹤
# -t type :
# -x      : DNS 反解 IP

# 使用 Default DNS 查詢 google.com 對應的 IP
$ dig google.com

# 使用 168.95.1.1 這台 DNS 查詢 google.com 對應的 IP
$ dig @168.95.1.1 google.com

# 使用 Default DNS 查詢 google.com 對應的 DNS
$ dig google.com ns
```

# Domain

> `man hostname` : 別用 `hostname` or `dnsdomainname` 來改變 FQDN.
> 更改 `FQDN` 較佳的方式, 去編輯 `/etc/hosts` : `127.0.0.1  www.tonychoucc.com www`

- [How to set the fully qualified hostname on CentOS 7.0?](https://unix.stackexchange.com/questions/239920/how-to-set-the-fully-qualified-hostname-on-centos-7-0)

```sh
#
$ dnsdomainname
example.com

```

# 其它

```sh
### 公司內部查詢 下層 DNS
$# dig -t A pwmisad.portwell.com.tw

; <<<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<<>> -t A pwmisad.portwell.com.tw
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 25991
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1280
;; QUESTION SECTION:
;pwmisad.portwell.com.tw.       IN      A

;; ANSWER SECTION:
pwmisad.portwell.com.tw. 3600   IN      A       192.168.2.115

;; Query time: 2 msec
;; SERVER: 192.168.2.115#53(192.168.2.115)
;; WHEN: Thu Dec 06 11:51:01 CST 2018
;; MSG SIZE  rcvd: 68

### 公司內部查詢 上層 DNS
$# dig -t A portwell.com.tw

; <<<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<<>> -t A portwell.com.tw
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 60945
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1280
;; QUESTION SECTION:
;portwell.com.tw.               IN      A

;; ANSWER SECTION:
portwell.com.tw.        600     IN      A       192.168.2.115
portwell.com.tw.        600     IN      A       192.168.2.117
portwell.com.tw.        600     IN      A       192.168.2.116

;; Query time: 2 msec
;; SERVER: 192.168.2.115#53(192.168.2.115)
;; WHEN: Thu Dec 06 11:51:06 CST 2018
;; MSG SIZE  rcvd: 92


### 公司外部查詢
$# host -a wellwell.com.tw
Trying "wellwell.com.tw"
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 17385
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;wellwell.com.tw.       IN  ANY

;; ANSWER SECTION:
wellwell.com.tw.    3600    IN  NS  ns1.wellwell.com.tw.
wellwell.com.tw.    3600    IN  NS  ns2.wellwell.com.tw.

Received 69 bytes from 2001:b000:169::1#53 in 25 ms


### 公司內部查詢
$ host -a wellwell.com.tw
Trying "wellwell.com.tw"
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 57660
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 13, AUTHORITY: 0, ADDITIONAL: 9    # aa : 本地權威答覆

;; QUESTION SECTION:
;wellwell.com.tw.       IN  ANY

;; ANSWER SECTION:
wellwell.com.tw.    600     IN  A   192.168.2.116                           # 內部 DNS
wellwell.com.tw.    600     IN  A   192.168.2.115                           # 內部 DNS
wellwell.com.tw.    600     IN  A   192.168.2.117                           # 內部 DNS
wellwell.com.tw.    3600    IN  NS  wellwelldc1.wellwell.com.tw.            # NameServer
wellwell.com.tw.    3600    IN  NS  wellwell-8c2d1a.wellwell.com.tw.
wellwell.com.tw.    3600    IN  NS  pwmisad.portwell.com.tw.
wellwell.com.tw.    3600    IN  NS  chunghomx.wellwell.com.tw.
wellwell.com.tw.    3600    IN  SOA pwmisad.portwell.com.tw. alwin.wellwell.com.tw. 904628 900 600 86400 3600   # Start Of Authority
wellwell.com.tw.    3600    IN  MX  15 ex11.wellwell.com.tw.                # Mail Server 主機
wellwell.com.tw.    3600    IN  MX  20 smtp.wellwell.com.tw.
wellwell.com.tw.    3600    IN  MX  10 ex10.wellwell.com.tw.
wellwell.com.tw.    3600    IN  MX  30 portmail.wellwell.com.tw.
wellwell.com.tw.    3600    IN  MX  40 ex1.wellwell.com.tw.

;; ADDITIONAL SECTION:
wellwelldc1.wellwell.com.tw. 3600 IN    A   192.168.2.117
wellwell-8c2d1a.wellwell.com.tw. 3600 IN A  192.168.2.116
pwmisad.portwell.com.tw. 3600   IN  A   192.168.2.115
chunghomx.wellwell.com.tw. 3600 IN  A   192.168.2.116
ex11.wellwell.com.tw.   1200    IN  A   192.168.2.58
smtp.wellwell.com.tw.   3600    IN  A   192.168.2.56
ex10.wellwell.com.tw.   1200    IN  A   192.168.2.59
portmail.wellwell.com.tw. 3600  IN  A   192.168.2.235
ex1.wellwell.com.tw.    1200    IN  A   192.168.2.56

Received 477 bytes from 192.168.2.115#53 in 0 ms
```

```sh
# dig [options] FQDN [@server]
$ dig wellwell.com.tw

; <<<>> DiG 9.9.4-RedHat-9.9.4-61.el7_5.1 <<<>> wellwell.com.tw
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 43113
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:                   # 提出的問題
; EDNS: version: 0, flags:; udp: 1280
;; QUESTION SECTION:
;wellwell.com.tw.               IN      A

;; ANSWER SECTION:                      # 主要的回答
wellwell.com.tw.        600     IN      A       192.168.2.116
wellwell.com.tw.        600     IN      A       192.168.2.115
wellwell.com.tw.        600     IN      A       192.168.2.117

;; Query time: 1 msec
;; SERVER: 192.168.2.115#53(192.168.2.115)
;; WHEN: 五 10月 05 14:15:15 CST 2018
;; MSG SIZE  rcvd: 92
```

```sh
$# host google.com.tw
google.com.tw has address 216.58.200.227                        # IPv4
google.com.tw has IPv6 address 2404:6800:4012:1::2003           # IPv6
google.com.tw mail is handled by 10 aspmx.l.google.com.         # MX
google.com.tw mail is handled by 40 alt3.aspmx.l.google.com.
google.com.tw mail is handled by 50 alt4.aspmx.l.google.com.
google.com.tw mail is handled by 20 alt1.aspmx.l.google.com.
google.com.tw mail is handled by 30 alt2.aspmx.l.google.com.
#             ↑↑↑↑ 此為 MX

$#
```
