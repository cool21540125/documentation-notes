# Win10 的 WSL2 安裝清單

## Change default editor

```bash
### 變更預設的偏好 Editor
sudo update-alternatives --config editor
```

## Install Python3.9

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