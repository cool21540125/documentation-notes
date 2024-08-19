#!/bin/bash
exit 0
# arp 是 L3 網路層的東西
# 用來查訊 IP 對應的 Mac 的快取紀錄
# Address Resolution Protocol (ARP) 與 Reverse ARP(RARP)
#
# 用途:
#   Host 設有 default gateway (RouterIP 啦)
#   跨網段傳輸時, Host 詢問 arp cache, 是否有 gateway 的 Mac
#   若無, 則使用 arp broadcast 詢問 gateway mac
#   若有, 則連帶 Source Mac, 再次封裝 destination Mac, 丟給 gateway 轉送封包
#
# -------------------------------------------------------------------------------------------

### 顯示所有 Network Interface 快取列表
arp -a

arp -n
#Address HWtype HWaddress Flags Mask Iface
#192.168.0.103 ether 70:85:c2:09:95:c6 C eth0
#192.168.0.1 ether ec:ad:e0:b0:fb:b8 C eth0

### 移除快取
sudo arp -d $IP # 移除特定快取
sudo arp -da    # 移除所有快取 (Windows 使用 arp -d *)

### 手動設定快取(沒事別這樣幹)
arp -s $IP $MAC                        # 儲存至快取(手動設定的話可能會設錯, or 對方換 ip)
arp -s 192.168.1.100 01:00:2D:23:A1:0E # Example: 建立靜態 ARP, 把該 IP 對應的 Mac, 加入 ARP Table
