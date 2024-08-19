# Pcap Filter

- 用來作為各種 network filter 的 syntax rule
- https://www.kaitotek.com/resources/documentation/concepts/packet-filter/pcap-filter-syntax#examples-basic_and_common_scenarios

```conf
### 所有 ip
ip

### 所有與 myhost 有關的 host
host myhost

### 與此 IPs 有關的 ip
ip host 192.168.1.1 and host 192.168.2.2

### 限於特定 IP 並且排除特定 IP
ip host 192.168.1.1 and not host 192.168.2.2

### 特定 IPs 的特定 port
ip host 192.168.1.1. and host 192.168.2.2 and tcp and port 80

### 限於特定 IPs 的 all UDP
ip and udp and (host 192.168.1.1 and (host 192.168.2.2) or (host 192.168.3.3)) and (udp[0:2] & 1 = 0)


###
host domain.com and port 443
```
