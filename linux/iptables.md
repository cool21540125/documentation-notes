# iptables

- `iptables` 會透過 `getsockopt/setsockopt` 等 IPC 方式與 Kernel 進行溝通

```bash
### 清除 iptables 規則
iptables -F  # 清除所有
iptables -X  # 清除所有 udf chain
iptables -Z  # 所有 chain 的計數及流量統計歸零
```


```bash
### 開放 3306 port
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

### 移除
iptables -D INPUT -p tcp --dport 3306 -j ACCEPT

### 只針對特定 IP 開 3306 port
iptables -A INPUT -p tcp -s Your_IP --dport 3306 -j ACCEPT
iptables -D INPUT -p tcp -s 211.75.132.253 --dport 22 -j ACCEPT
iptables -I INPUT -p tcp -s 211.75.132.253 --dport 22 -j ACCEPT
```

