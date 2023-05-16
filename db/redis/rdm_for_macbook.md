# Redis Desktop Manager for Macbook

- 2020/10/01
- [在 macOS 上 Build Redis Desktop Manager(RDM)](https://blog.yowko.com/build-redis-desktop-manager-on-mac/)
- [RDM-Quick Install-Build on OS X](http://docs.redisdesktop.com/en/latest/install/)


## 環境

- Macbook pro 13, 2019
- Catalina 10.15.7
- Xcode 12.0.1 (12A7300)
- Qt stable 5.15.1 (`brew info qt5`)
- Qt Creator 4.13.1
- Python 3.8.5
- openssl 1.1
- cmake 3.18.3


## 相依

1. 安裝 XCode (App Store)
2. 安裝 homebrew
3. 安裝 git
4. 安裝 qt (`brew install qt`)
5. 安裝 qt-creator (`brew cask install qt-creator`)
8. 安裝 python3
6. 安裝 openssl (`brew install openssl`)
7. 安裝 cmake (`brew install cmake`)


## 編譯

```zsh
### Clone 自己要的版本
$# VERSION_OR_TAG=2020.3
$# git clone --recursive https://github.com/uglide/RedisDesktopManager.git -b $VERSION_OR_TAG rdm && cd ./rdm

$# 
```
