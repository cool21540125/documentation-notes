#!/bin/bash
exit 0
# ------------------------------------------------------------------------------

### 列出 brew 已安裝套件
brew list


### 升級套件
brew upgrade xxx
# ex: 升級 python3.10
# brew upgrade python3.10
# 但不確定能否正常就是了!!


### 安裝 xxx
brew install xxx


### 查看所有的 current taps
brew tap
#aws/tap
#hashicorp/tap
#homebrew/cask
#homebrew/core
#homebrew/services
# https://stackoverflow.com/questions/34408147/what-does-brew-tap-mean


### 增加 && 刪除 brew tap
brew tap ${TAP_NAME}
brew untap ${TAP_NAME}

###