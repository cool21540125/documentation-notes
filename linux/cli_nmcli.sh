#!/bin/bash
exit 0

### =============================================================== 安裝 nmcli ===============================================================

sudo apt install network-manager -y
sudo systemctl start network-manager
sudo systemctl enable network-manager

### =============================================================== nmcli 基本查詢用法 ===============================================================

###
nmcli con show

###
nmcli dev status

###
