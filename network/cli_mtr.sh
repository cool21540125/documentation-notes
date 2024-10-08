#!/bin/bash
exit 0
#
# mtr 為 traceroute 的強大替換工具, 用來檢查與節點的路由封包情況
# -n, 用 IP 來顯示(速度較快)
# -b, 同時顯示 IP 與 Domain
# -c XXX, 來指定發送封包的上限(預設為連續發送)
# -i XXX, 指定每次發送封包的時間間格
# -m XXX, 指定探測的節點上限
# --tcp, 用 TCP SYN 取代 ICMP
# --udp, 用 UDP     取代 ICMP
#
# ------------------------------------------------------------------------------------------------------------

# mtr

###
sudo mtr www.google.com
