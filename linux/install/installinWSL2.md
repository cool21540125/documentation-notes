WSL2 安裝清單

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

PATH=/usr/local/bin:${PATH}
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


# Install golang

```bash
### 選擇版本
$# VERSION=1.17.9
$# wget https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz
$# sudo tar -xvf go$VERSION.linux-amd64.tar.gz
$# sudo mv go /usr/local
```

# Install podman

- 2022/04/28
- [Building from scratch](https://podman.io/getting-started/installation#building-from-scratch)

```bash
### 必須先安裝好 golang

$# apt-get install \
  btrfs-progs \
  git \
  golang-go \
  go-md2man \
  iptables \
  libassuan-dev \
  libbtrfs-dev \
  libc6-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libgpgme-dev \
  libgpg-error-dev \
  libprotobuf-dev \
  libprotobuf-c-dev \
  libseccomp-dev \
  libselinux1-dev \
  libsystemd-dev \
  pkg-config \
  runc \
  uidmap
#
# runc : (by golang) default OCI Runtime (起碼需要 > 1.0.0)
# crun : (by pure C) much faster OCI Runtime
# conmon : monitor OCI Runtimes
# 

$# git clone https://github.com/containers/podman.git
$# cd podman

### 選擇要編譯安裝的版本
$# VERSION=v3.4.7
$# git checkout $VERSION

### 確保目前 golang 符合最低要求的版本
$# go version
$# head -n 3 go.mod | tail -n 1

###
$# sudo apt-get install -y libapparmor-dev

###
$# sudo mkdir -p /etc/containers
$# sudo curl -L -o /etc/containers/registries.conf https://src.fedoraproject.org/rpms/containers-common/raw/main/f/registries.conf
$# sudo curl -L -o /etc/containers/policy.json https://src.fedoraproject.org/rpms/containers-common/raw/main/f/default-policy.json

###
$# make BUILDTAGS=""
# ↑
# ↓ 視情況使用囉
$# make BUILDTAGS="selinux seccomp"

$# sudo make install PREFIX=/usr
```


# Install dig

```bash

```