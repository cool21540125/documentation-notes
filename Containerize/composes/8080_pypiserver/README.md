
# 搭建 pypi-server by compose

- 2020/04/05
- [DockerHub-pypiserver](https://hub.docker.com/r/pypiserver/pypiserver)
- [pypiserver](https://pypiserver.readthedocs.io/en/latest/README.html)

## 架設 PyPI-Server

```bash
### 2020/04/05, stable 的最大版號為 1.3.2
$# docker pull pypiserver/pypiserver:latest

### docker-compose.yml 資料夾底下
$# ls
auth    docker-compose.yml
# auth/ 底下要放 pypi.htpasswd (上傳認證定義檔)


### PyPI-Server 經由 Nginx 預覽的認證 (nginx/auth/pypi.htpasswd)
$# touch nginx/auth/pypi.htaccess
$# htpasswd -sb nginx/auth/pypi.htpasswd user1 password1
# -s, (較不安全)的方式 (Nginx 認證似乎只能認這個, -B 會報錯)
# -b, 後面接著給 <file> <user> <password>


### PyPI-Server 上傳的認證檔
$# touch auth/pypi.htpasswd
$# htpasswd -Bb auth/pypi.htpasswd user01 password01  # 建立 user && password
# -B, 較為安全的加密方式 or 使用 -s, 為較不安全的加密方式
# -b, 後面接著給 <file> <user> <password>
# -c, 若一開始檔案不存在, 可用此來建立檔案

### 或使用
$# htpasswd -B .htaccess <some_username>
# 這樣可以互動式的輸入密碼

$# pypi-server -o -p 28888 -P ./.htaccess /var/private_pypi/packages
```

```bash
$# docker-compose up -d

# OR
$# docker run -d \
    --restart always \
    -p 33333:8080 \
    --name mypypi \
    pypiserver/pypiserver:latest \
    -P htpasswd packages
```




### Step3

```.pypirc
[distutils]
index-servers=
  mypypi

[mypypi]
repository:https://pypi.tonychoucc.com
username:user
password:123
# -------------------------------------------

```



## Client 上傳 && 下載 設定

```bash
### 設定這個以後, 將來下載(pip install XXX)的時候也會到這邊找
$# echo 'export PIP_EXTRA_INDEX_URL=http://localhost:28888/simple/' >> ~/.bash_profile

### 設定這個之後, 便可將檔案上傳上去
$# vim ~/.pypirc
[mypypi]
repository:https://pypi.tonychoucc.com
username:user
password:123

### 上傳
$# twine upload -r mypypi dist/*
Uploading distributions to http://127.0.0.1:28888
Uploading example_pkg-0.1.0-py3-none-any.whl
100%|█████████████████████████████████| 7.63k/7.63k [00:07<00:00, 1.05kB/s]

### 下載
$# pip install example-pkg-tonychoucc
Looking in indexes: https://pypi.org/simple, http://localhost:28888/simple/
Collecting example-pkg-tonychoucc
  Downloading http://localhost:28888/packages/example_pkg-0.1.0-py3-none-any.whl
Installing collected packages: example-pkg-tonychoucc
Successfully installed example-pkg-tonychoucc-0.0.3
```
