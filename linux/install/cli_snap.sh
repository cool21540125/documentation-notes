#!/bin/bash
exit 0
# ---------------------------------------------

####################### snap Basic #######################

### 查看 snap 安裝了啥 (同 yum list installed 的概念)
snap list
snap info $PKG

### Install
sudo snap install PKG # --channel=latest 可省略
sudo snap install PKG --channel=latest/edge

# 用來聲明, PKG 將來就由 XXX channel 做追蹤管控

### Uninstall
sudo snap remove PKG

### switch & refresh
sudo snap switch --channel=XXX PKG
sudo snap refresh --channel=XXX PKG
