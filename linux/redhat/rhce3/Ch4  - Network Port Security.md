# Ch4  - Network Port Security

1. Firewalld
2. Rich Rules
3. Masquerade && Forwarding
4. SELinux port

```sh
# 為了節省後面的時間, 先執行安裝...
yum install -y httpd
```

## 1. Firewalld

RHEL7(CentOS7) 的防火牆機制: `firewalld.service` 用來管理 `host-level` firewalls

- OS6: 舊機制 iptables, ip6tables, ebtables
- OS7: 新機制 firewalld
- Ubuntu : ufw

```sh
### 為了避免OS7 不小心啟動 OS6 的防火牆機制 (會與 firewalld 發生衝突), 把他們 mask 掉
systemctl mask iptables
systemctl mask ip6tables
systemctl mask ebtables
```

Zone Name | 白話文概念
--------- | ----------
trusted   | 不管殺小, 都可以自由進出
home      | 除了 `ssh`, `mdns`, `ipp-client`, `samba-client`, `dhcpv6-client` 以外, 都會阻擋
internal  | (同 home)  <--(這我就不懂會啥要弄出 home 和 internal 了....orz)
work      | 除了 `ssh`,         `ipp-client`,                 `dhcpv6-client` 以外, 都會阻擋
public    | 除了 `ssh`,                                       `dhcpv6-client` 以外, 都會阻擋 ; **預設的 `default zone`**
external  | 除了 `ssh`,                                                       以外, 都會阻擋 ; ipv4 出去的封包, 會作 `masqueraded`
dmz       | 除了 `ssh`,                                                       以外, 都會阻擋
block     | 拒絕一切, 會發好人卡
drop      | 拒絕一切, 已讀不回


## 2. Rich Rules

### 2-1. 設定方式

```sh
### root
# 法一
$# firewall-cmd --add-rich-rule=''

# 法二
$# firewall-config
# 強烈建議用圖形話介面來設定
```

### 2-2. 自行範例

請依照下列說明, 來設定 `rich rule`

- `classroom zone`, `reject` 所有來自 `192.168.0.11` 的請求
- `swrd zone` 只允許 `ftp服務`, 每分鐘作2次請求
- `swrd zone` 設定: 接受來自 `192.168.1.0/24` 訪問 `7900-7905 tcp port` 的請求
- `swrd zone` 針對 `192.168.124.0/24` 來的 `http` 請求, 作成Log(notice), prefix="NEW HTTP ", 每秒僅作3次.

## 3. Masquerade && Forwarding

* [/rhce3/attach/NAT.xml](https://www.draw.io/)
* NAT = router + IP 轉譯
* NAT 會修改 `封包 IP header` 上的 `source` && `destination`

## 4. SELinux port

### 語法

```sh
# 查看
$# semanage port -l | grep http

# 新增
$# semanage port -a -t http_port_t -p tcp 82

# 修改
$# semanage port -m -t gopher_port_t -p tcp 82
# 將 tcp 82 port, 由 http_port_t 改為 gopher_port_t

# 移除
$# semanage port -d -t http_port_t -p tcp 82
```

### 範例1 : Web Service 使用非標準 82 Port + SELinux

```sh
### server
$# yum install -y httpd
$# echo '看到的是白癡 ; 看不到的是智障' > /var/www/html/index.html
$# systemctl start httpd
$# firewall-cmd --add-service=http

### desktop
$# curl http://192.168.124.118

### server
$# vim /etc/httpd/conf/httpd.conf
Listen 82       # Listen 80 → 82

$# setenforce 0
$# systemctl restart httpd
$# firewall-cmd --add-port=82/tcp

### desktop
$# curl http://192.168.124.118:82

### server
$# setenforce 1
$# semanage port -a -t http_port_t -p tcp 82
$# systemctl restart httpd
$# semanage port -l | grep http

### desktop
$# curl http://192.168.124.118:82
```

### 範例2: SSH Service 使用非標準 999 Port + SELinux

```sh
### server
$# vim /etc/ssh/sshd_config
# 仔細看第 15, 17 行!!
# 改用 999 Port
$# firewall-cmd --add-port=999/tcp
$# systemctl restart sshd

### desktop
$ ssh server22
$ ssh -p 999 server22

### server
$# semanage port -a -t ssh_port_t -p tcp 999

### desktop
$ ssh -p 999 server22
```

