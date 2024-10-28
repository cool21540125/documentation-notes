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
rvm system          # 切回系統預設版本

# M1 Issue - https://github.com/rvm/rvm/issues/5252
rvm install 3.2.2 --with-openssl-dir=$(brew --prefix)/opt/openssl@3
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
