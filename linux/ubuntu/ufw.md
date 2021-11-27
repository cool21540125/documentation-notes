# ufw - Uncomplicated Firewall

- 2019/07/19

```bash
### 看防火牆狀態
$# ufw status verbose

### 開啟 443/TCP
$# ufw allow 443/tcp

### 開啟 53/TCP && 53/UDP
$# ufw allow 53

### 允許特定 IP 連接 22 port
$# ufw allow from 192.168.1.10 to any port 22

### 允許特定網段存取 Samba 服務
$# ufw allow from 192.168.2.0/24 to any app Samba

### 列出 service 對照 port 詳情
$# ufw app list
```
