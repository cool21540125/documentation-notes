# Ch14 - Limiting Network Communication with firewalld

1. Netfilter
2. firewalld 修改方式
3. firewalld
4. 指令

## 1. Netfilter

Linux 核心的一個子模組 `netfilter`, 它會 `檢查該系統所有的網路封包`, 包含 `incoming`, `outgoing`, `forwarded`.

- CentOS6 : 使用低階指令工具 `iptables` 及 `ip6tables` 來作網路流量的管控
- CentOS7 : 使用較為高階的服務 `firewalld` 來作網路流量的管控.

###### firewalld daemon 屬於 `firewalld package` 的東西
###### firewalld 屬於 **base** install, 但不包含在 `minimal` install 內.

## 2. firewalld 修改方式

1. 直接改組態 `/etc/firewalld/` 裡面的一堆東西... (完全不建議@@)
2. 使用 GUI 工具 : `firewall-config`
3. 使用 CLI 工具 : `firewall-cmd`

## 3. firewalld

### 3-1. 很多不知道怎麼分類的概念

- 防火牆架構 : `/rhce2/attach/Firewall.xml`

`firewalld` 將所有的網路流量分類為各種不同的 `zones`, 來達到 `簡化網路流量的管理`; 

前述的分類依據, ex: `不同來源IP`, `進入主機時所使用的網路介面`, `進入主機時所通行的 port`, ...

因此現在的管理方式(我不知道以前怎麼搞啦!), 則針對各種 `zones` 來制定 `網路流量的規則`

Zone Name | 白話文概念
--------- | ----------
trusted   | 不管殺小, 都可以自由進出
home      | 除了 `ssh`, `mdns`, `ipp-client`, `samba-client`, `dhcpv6-client` 以外, 都會阻擋
internal  | 和 home 一樣 (存在的必要性是什麼啊=口=...)
work      | 除了 `ssh`,         `ipp-client`,                 `dhcpv6-client` 以外, 都會阻擋
public    | 除了 `ssh`,                                       `dhcpv6-client` 以外, 都會阻擋 ; **預設的 `default zone`**
external  | 除了 `ssh`,                                                       以外, 都會阻擋 ; ipv4 出去的封包, 會作 `masqueraded`
dmz       | 除了 `ssh`,                                                       以外, 都會阻擋
block     | 拒絕一切, 會發好人卡
drop      | 拒絕一切, 已讀不回

###### 預設所有的 zones `允許所有的 outgoing traffic`
###### 預設所有的 zones `允許所有 因本地對外訪問後, 所得到的 response traffic`

進入主機的連線, 會依序檢查

1. 來源 IP
2. 進入哪個網路介面

### 3-2. 寫法

```sh
# 寫法 1
firewall-cmd --add-service=mysql --permanent
firewall-cmd --add-service=mysql

# 寫法 2 (防火牆會整個暖重啟)
firewall-cmd --add-service=mysql --permanent
firewall-cmd --reload
```


### 3-3. 實作

```sh
### 我這邊就不作 permanent 了喔!!
# 法1. 最單純的做法
firewall-cmd --add-service=mysql

# 法2. 在特定的 zone 作設定
firewall-cmd --add-source=192.168.124.101/24 --zone=work    # 以後從這 IP 來的連線, 一律歸 work zone 來管理
firewall-cmd --add-service=mysql --zone=work                # work zone, 允許存取 mysql 哦!!


### 遠端存取 mysql
mysql -ustudent -pstudent -h 192.168.124.118
# 除了 192.168.124.118 是套用 work zone(可存取mysql)
# 其他 ip 預設都是套用 default zone, 也就是 public zone(只有開放 ssh dhcpv6-client http samba nfs)
```



## 4. 指令

以 `firewall-cmd` 指令來講, 都是搭配底下一連串的子指令, ex:

```sh
firewall-cmd --<子指令key1> <子指令value1>
```

command | Description
------- | ---------------------------
查詢相關 | ***********************************
--get-default-zone | 查詢預設的 default zone
--get-zones | 查詢所有可用的 zones
--get-active-zones | 查目前所有有制訂規則的 zones 的設定資訊
--list-all | 
--list-all-zones | 
Service && Port | ***********************************
--add-service XXX | 
--add-port XXX | 
--remove-service XXX | 
--remove-port XXX | 
其它 | ***********************************
--permanent | enable 的概念(重開機後適用)
--reload | 重新載入防火牆設定, 套用 permanent 的設定

