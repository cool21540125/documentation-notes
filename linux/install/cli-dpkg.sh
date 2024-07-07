#!/bin/bash
exit 0
# ------------------------------------------------------

### 查看 CPU 架構 (amd/arm)
dpkg --print-architecture
#amd64


### 查詢安裝了哪些 deb pkgs
dpkg -l | grep XXX


### 安裝 deb 套件
dpkg -i -E XXX.deb
# -E : 忽略同版本安裝


### 特定套件所安裝的所有檔案, ex: python
dpkg -L python


### 某資料夾底下有多少個 installed package
dpkg -S /usr


### 移除已安裝套件
dpkg -r $DEB_INSTALLED_PKG


### 