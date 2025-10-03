#!/bin/zsh
exit 0
# https://rvm.io/rvm/cli
# --------------------------------------------------

rvm --version
#rvm 1.29.12 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]

### 列出目前的可安裝版本
rvm list known

### 移除 ruby version
rvm remove 3.2.2

### 切換版本
rvm use 3.2.2
rvm 3.2.2
rvm 3.2.2 --default # 設定為預設版本

### ========================= rvm 安裝其他版本的 ruby =========================
# 常見 Apple chip issue: https://github.com/rvm/rvm/issues/5252
# 簡單說明, 就是 Apple chip 預設的 openssl 版本過舊, RVM 可能找不到 Homebrew 安裝的 OpenSSL, 或找到錯誤版本...
rvm install 3.2.2 --with-openssl-dir=$(brew --prefix)/opt/openssl@3
rvm install 3.4.1 --with-openssl-dir=$(brew --prefix openssl@3)

## 移除特定版本
rvm uninstall 2.3.2

### 列出已經安裝了哪些 ruby version
rvm list
rvm list rubies
rvm list default

###
rvm gemdir
#$HOME/.rvm/gems/ruby-3.2.2

### 進入目前版本的 ruby gemdir
cd $(rvm gemdir)
