# Routing 路由

- 2018/06/05

```

   192.168.8.0      192.168.16.0        192.168.24.0
    ↓               ↓                   ↓
        Router A             Router B
        ↓                    ↓
 -------X--------------------X--------
    |              |               |
    O              O               O
    電腦A          電腦B            電腦C

```

# 網路相關 CLI

## 觀察主機路由: `route`

```bash
$ route  # route -n: 主機名稱 以 IP 顯示
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker_gwbridge
172.21.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-d27f48aadef3
192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 eth0

# Destination     Gateway    Genmask      Flags              Metric     Ref    Use Iface
# 目的 Network    0.0.0.0      mask         ↓                    ?       ?      Interface
#                   或                    U: 路由是啟動的
#                   *                     G: 需透過 外部主機(Gateway) 來 轉發封包
#                 直接藉由 Iface 發送      H: 該路由為 Host, 而非 Network (目標為Host, 非Network)
#                                         !: 此路由不會被接受(用來抵擋不安全的網域)
```

## `traceroute`

路由路徑追蹤工具, 找出 icmp 封包到 目的主機 的路徑(中途節點, 可能因為安全性考量, 而無法回應)

```sh
# traceroute -[IT]
# -I : 使用 ICMP
# -T : 使用 TCP
# -U : (default) UDP
# -m max_ttl : (default 30) 可自行修改  max hops

### 範例
$# traceroute www.yahoo.com
traceroute to www.yahoo.com (98.137.246.8), 30 hops max, 60 byte packets
 1  172.253.71.139 (172.253.71.139)  7.514 ms 172.253.71.117 (172.253.71.117)  12.276 ms 209.85.249.95 (209.85.249.95)  8.593 ms
 2  74.125.243.186 (74.125.243.186)  8.529 ms 108.170.245.100 (108.170.245.100)  95.182 ms 108.170.245.102 (108.170.245.102)  7.533 ms
 3  * * *
 4  ae-7.pat1.gqb.yahoo.com (216.115.96.45)  11.395 ms  11.435 ms ae-7.pat2.gqb.yahoo.com (216.115.101.109)  11.568 ms
 5  et-0-0-0.msr1.gq1.yahoo.com (66.196.67.97)  11.253 ms et-1-0-0.msr1.gq1.yahoo.com (66.196.67.101)  11.065 ms et-18-1-0.msr2.gq1.yahoo.com (66.196.67.115)  12.619 ms
 6  et-0-0-0.clr2-a-gdc.gq1.yahoo.com (67.195.37.73)  11.188 ms  11.539 ms et-1-0-0.clr2-a-gdc.gq1.yahoo.com (67.195.37.97)  11.521 ms
 7  et-18-6.bas2-2-flk.gq1.yahoo.com (98.137.120.27)  11.674 ms et-16-6.bas1-2-flk.gq1.yahoo.com (98.137.120.6)  11.803 ms  11.440 ms
 8  media-router-fp2.prod1.media.vip.gq1.yahoo.com (98.137.246.8)  11.326 ms  11.618 ms  11.293 ms
 # 每一行, 稱之為一個 TTL, 預設 30 個 TTL 若無法抵達目的地, 則視為 unreachable
 # 每個 TTL 預設會做 3 次 probe(探測), 每次探測的時間代表匝道之間的 TIME EXCEEDED(往返時間)
 # 傳統上, 5 秒內無法回應的話會回傳 *
 # 現代, 因防火牆被廣泛使用 及 一堆我還不懂的原因, 匝道可能因為安全性考量, 而不揭露目前位置, 取而代之只顯示 *
 # 若出現 !H, !N, !P  分別代表 (host, network, protocol  unreachable), 當然還有其他... 這邊不贅述
```

## `dnsdomainname`

```sh
$# dnsdomainname
tony.com

# 而 DNS Domain 建議作法是設在(如果不用 DNS 的話...)
# /etc/hosts
# xxx.xxx.xxx.xxx   os7.tony.com    os7    XXXXX    .....
# IP                FQDN            HOST1  HOST2    ...
# 外加
$# hostnamectl set-hostname os7
```

## `hostname`

```sh
# 可查 Domain
$# hostname
os7

# 可查 FQDN
$# hostname -f
os7.tony.com
```

## `mail`

```sh
$# mail -s "README" tony@tony.com
(信件內容~~~)
.           # ← 表示結束 or 按「Ctrl + D」

EOT
```

## `dig`

```sh
# dig 指令工具所屬的套件
$# yum install -y bind-utils
# CentOS7 應該有預設安裝好了吧...

$# dig @[Name Server] [FQDN 或 Domain] [TYPE]

$# dig www.pchome.com.tw

; <<<>> DiG 9.9.4-RedHat-9.9.4-72.el7 <<<>> www.pchome.com.tw
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<<- opcode: QUERY, status: NOERROR, id: 5419
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1280
;; QUESTION SECTION:
;www.pchome.com.tw.             IN      A                       # 提出的查詢問題

;; ANSWER SECTION:
www.pchome.com.tw.      300     IN      A       210.59.230.39   # 查詢到的回答

;; Query time: 25 msec
;; SERVER: 192.168.2.115#53(192.168.2.115)                      # 本地使用的 DNS
;; WHEN: Mon Dec 24 14:06:44 CST 2018
;; MSG SIZE  rcvd: 62
```

# socat

```bash
###
socat TCP-LISTEN:2375,reuseaddr,fork UNIX-CONNECT:/var/run/docker.sock
```
