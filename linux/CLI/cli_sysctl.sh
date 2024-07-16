#!/bin/bash
exit 0
### sysctl 
# 用來 access kernel 變數
# ----------------------------------------------------

### 修改 Kernel Variable
sysctl -w net.ipv4.ip_forward=1                  # 寫入 Memory
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf # 寫入 Disk


### live reload
sysctl -p
# 只會 reload /etc/sysctl.conf


### live reload
sysctl --system
# 會 reload 底下這些
# /run/sysctl.d/*.conf
# /etc/sysctl.d/*.conf
# /usr/local/lib/sysctl.d/*.conf
# /usr/lib/sysctl.d/*.conf
# /lib/sysctl.d/*.conf
# /etc/sysctl.conf


### 