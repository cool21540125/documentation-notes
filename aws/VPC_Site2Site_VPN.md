
# [VPC Site-to-Site VPN](](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html))

- 此處的 VPN 指的是 On-Premise network 與 VPC 之間的 network connection
- *Site-to-Site VPN* 支援了 **Internet Protocol security (IPsec) VPN connections**
    - 需要留意的是, 即使連線過程皆為 encrypted, 但仍會有 Security Issue!!
- Virtual Private Gateway, VPG 或 VGW
    - AWS 對於 VPN connection 需要有個 VPN concentrator
    - 在想建立 Site-to-Site VPN 的 VPC 上頭 create && attach VPG
    - UNKNOWN 弄個 ASN(Autonomous System Number)
- Customer Gateway, CGW
    - Data Center 上頭, 弄個 (軟體 or 硬體) customer gateway (用來做 VPN connection)
- 實作上需注意, AWS 那邊需要 enable *Route Propagation* for VPG
    - 如此一來, Virtual Private Gateway 與 subnet 之間才會有 route table
- 目前不支援 IPv6 && 不支援 *Path MTU Discovery*
- Charge: 依照 VPN connection per hour 以及 EC2 network traffic out 來收費
- AWS VPN CloudHub (多個 VPN Connection 的擴展)
    - 如果企業有多個機房需要做 VPN Connection, 用此方式可降低成本
        - 放置 VGW 的 VPC 需要做底下的配置:
            - `setup dynamic routing` 及 `configure route tables`
    - 企業的各個機房, AA, BB, CC, 已完成與 AWS VGW 的 VPN Connection 以後
        - 將來 AA, BB, CC 之間也能做 VPN Connection 了
    - 此時 VPC 內的 VGW 便實現了 **VPN CloudHub**


# 配置 Site-to-Site VPN

> Console > VPC >
> 1. Create Customer gateway (for On-Premise)
> 2. Virtual Private Gateway > Create virtual private gateway
> 3. Site-to-site VPN Connections > Create VPN connection
>

- Create/Config 企業端的 *Customer Gateways*
- Create/Config AWS 上頭的 *Virtual Private Gateways*
- 使用 *Site-to-Site VPN Connections*, 並將上面兩者 connect
    - 可選擇 *Virtual Private Gateway* 或 *Transit Gateway*
    - 配置 Routing && IPv4(CIDR)
    - 最後再 Create VPN connection

```mermaid
flowchart LR
cg["Customer Gateway"]
vpg["Virtual Private Gateway"]

subgraph IDC
    machine <--> cg
end
subgraph VPC
    vpg <--> ps["Private Subnet"]
end
cg <--> vpg
```
