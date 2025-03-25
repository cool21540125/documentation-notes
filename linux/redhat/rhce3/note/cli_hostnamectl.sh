#!/bin/bash
exit 0
#
# 網路上會看到有一些阿貓阿狗的文章, 會講說用 `hostname` 來設定
#     但是此設定可能因為啟用不同的 cmcli connection 而變動
#     比較正確的作法是使用 `hostnamectl`
#
# hostnamectl 會依序查詢:
#   1. /etc/hostname
#   2. 藉由 DNS 解析查詢
#
# -------------------------------------------------------------

### ==================== 修改 hostname ====================
hostnamectl set-hostname NEWHOSTNAME

### ==================== 查詢 hostname ====================
# 顯示 or 暫時修改 主機名稱(會因為使用的 nmcli 連線而改變)
hostnamectl
#  Static hostname: tonynb
#       Icon name: computer-laptop
#           Chassis: laptop
#       Machine ID: 6e935c5d22124158bd0a6ebf9e086b24
#           Boot ID: 3262e51d23a9478dbc268f562556a74c
#  Operating System: CentOS Linux 7 (Core)
#       CPE OS Name: cpe:/o:centos:centos:7
#            Kernel: Linux 3.10.0-514.el7.x86_64
#       Architecture: x86-64

### 查看 hostname 狀態 (可列出更多資訊)
hostnamectl status
