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
