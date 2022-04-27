# Win10 的 WSL2 安裝清單

# Change default editor

```bash
### 變更預設的偏好 Editor
sudo update-alternatives --config editor
```

# Install Python3.9

Python 版本下載頁面: https://www.python.org/downloads/source/

```sh
add-apt-repository -y ppa:deadsnakes/ppa

### 相關套件
apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
apt-get install -y python3-pip

wget https://www.python.org/ftp/python/3.9.3/Python-3.9.3.tgz
tar -xf Python-3.9.3.tgz
cd Python-3.9.3

# 會做測試, 跑超久
# ./configure \
#     --enable-optimizations \
#     --enable-loadable-sqlite-extensions

./configure \
    --enable-loadable-sqlite-extensions

make && make install

### root 環境變數 (一般使用者可直接使用...)
echo 'PYTHON_HOME=/usr/local/bin' >> ~/.bash_profile
echo 'PATH=${PYTHON_HOME}:${PATH}' >> ~/.bash_profile
source ~/.bash_profile
```



# Install gvm

- 2022/04/01
- [Github-gvm](https://github.com/moovweb/gvm)
- [如何在 Windows 平台打造完美的 Go 開發環境 (WSL 2)](https://blog.miniasp.com/post/2020/07/27/Build-Golang-Dev-Box-in-Windows)

```bash
$# bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
$# source ~/.gvm/scripts/gvm

$# sudo apt-get update

$# sudo apt-get install binutils bison gcc make build-essential -y
## ↑ 若有問題, 則使用 ↓ 進行修復, 修復後再次執行 ↑
$# sudo sed -i -r -e 's/^(set -e)$/#\1/' /var/lib/dpkg/info/libc6\:amd64.postinst
$# sudo apt --fix-broken install -y

### 安裝特定版本
$# gvm install go1.17.8

### 列出可安裝的所有版本
$# gvm listall

### 列出已安裝版本
$# gvm list

### 切換版本
$# gvm use go1.17.8 --default
$# go version
go version go1.17.8 linux/amd64

# --default 可自行選擇是否作為預設

### 移除
$# chmod u+w -R ~/.gvm/
$# gvm implode
```
