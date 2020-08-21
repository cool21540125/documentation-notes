# 發布擴充功能

- 2018/08/01

- python standard library 內含 **distutils** (用來封裝 && 發布 python 程式 && 擴充功能) (但別用它)
  - distutils 用來 封裝 && 發布 Python 程式 && 擴充功能
  - 請使用 **setuptools** && **wheels** 代替 內建的 distutils
  - 然後搭配 **twine** 來幫你的套件上傳
  - 總之 `pip install setuptools wheel twine`


`wheels` 前身為 `eggs`


# 搭建私有 pypi server

1. 建立空專案 demo_privatepypi, 裡頭建立 packages 資料夾
2. 專案裡頭建立 python 虛擬環境, 並安裝 `pip install pypiserver`
3. 運行 `pypi-server -p 8999 ./packages &`

因為以上建立的 pypi server 不安全, 所以下面啟用驗證

1. `create .htpasswd`
2. `htpasswd -b -m -c .htpasswd myuser mypassword`
3. `pypi-server -p 8999 -P ./.htpasswd ./packages &`

後續要使用的話...

- 會有信任問題 `pip install --extra-index-url http://localhost:8999/ PACKAGE`
- `pip install --extra-index-url http://localhost:8999/ --trusted-host localhost PACKAGE`





打包套件

```bash
$# ls
dist/  # 裡面是空的, 等下建置套件時, 就會有東西了
README.rst
setup.py  # 裡面定義了 待發布套件 的 定義 && 建置方式 && 說明
garbage-tools/  # 裏頭就是等下我要開發的套件
    main.py
    __init__.py

### Step1. 在本地建置 wheel 檔
$# python setup.py bdist_wheel

### 上傳套件到 PyPI-Server
$# twine upload -r pypi dist/*
```



# 必要檔案解說

### setup.py

```py
from setuptools import setup, find_packages

with open("README.rst", "r") as ff:
    long_description = ff.read()

setup(
    name="garbage-pytools",  # 可隨意打, 等下建置之後, 套件的名稱
    version="0.1.0",
    author="Tony Chou",
    author_email="cool21540125@gmail.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/cool21540125/garbage-pytools",  # 定義套件位置
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
```
