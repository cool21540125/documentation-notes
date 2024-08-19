#!/bin/bash
exit 0
### ipsec CLI 是個操組 IKE daemon 的 wrapper (請不要直接操作 starter)
# 老實說, 這是啥現在還沒搞得很清楚...
# ------------------------------------------------------------------------------------------------------------------------------

ipsec --version
#Linux Libreswan 4.5 (XFRM) on 4.15.0-118-generic

### 顯示各種連線名稱的狀態資訊
sudo ipsec status

sudo ipsec status $NAME
