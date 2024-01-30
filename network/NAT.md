Network Address Translation, NAT - 網路位址轉換



為了解決 IPv4 位址空間不足的問題, 搞網路的領頭羊們提出了底下的標準:

1. NAT
2. Private Addressing (私有定址)
3. CIDR


# NAT

### NAT Server 功能區分

POSTROUTING         | PREROUTING
------------------- | ----------
Source NAT, SNAT    | Destination NAT, DNAT
外送                 | 內收
偽裝封包             | 轉發封包
改來源IP             | 改目標IP
對外請求, 隱藏內部IP  | 處理外來請求, 轉發給內部IP
ex: IP分享器         | ex: Web Server

NOTE: NAT 一定是個 Router


### NAT v.s. Proxy

compare | OSI        | description
------- | ---------- | -------------------------
NAT     | L2, L3, L4 | `封包過濾`, IP偽裝(SNAT)
Proxy   | L7         | 透過 Proxy 的服務程式提供網路代理的任務

NAT 比較接近底層, 通過 NAT 的封包要幹嘛用的, NAT 不會去理會; 而 Proxy 是透過 Daemon 來達成, 限制較多.


### 路由器 v.s. IP 分享器

NAT = router + IP 轉譯

NAT 會修改 `封包 IP header` 上的 `source` && `destination`


### Windows 10 1803 Hyper-V 預設切換:

```powershell
> ipconfig 預設切換
乙太網路卡 vEthernet (預設切換):

   連線特定 DNS 尾碼 . . . . . . . . :
   連結-本機 IPv6 位址 . . . . . . . : fe80::6d63:b9d7:b1eb:229a%18
   IPv4 位址 . . . . . . . . . . . . : 172.22.35.1
   子網路遮罩 . . . . . . . . . . . .: 255.255.255.240
```


# CIDR, Classless Inter-Domain Routing

> 用來規範分配 IP 位址的網路機構(IANA, 相關代理機構, ISP) 的辦法

- 協助定義 IP address
- CIDR 由 2 個部分組成: Base IP + Subnet Mask
   - Subnet Mask
      - `/0` : all IPs ; all octets can change


# Private Addressing

由 RFC 1918 規範, Private IP 範圍如下:

Class   | N of networks | Network                     | IP Range
------- | ------------- | --------------------------- | -------------------------------
A       | 1             | 10.0.0.0                    | 10.0.0.0 ~ 10.255.255.255
B       | 16            | 172.16.0.0 ~ 172.31.0.0     | 172.16.0.0 ~ 172.31.255.255
C       | 256           | 192.168.0.0 ~ 192.168.255.0 | 192.168.0.0 ~ 192.168.255.255
