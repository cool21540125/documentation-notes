
# 發布擴充功能

- 2018/08/01
- [Setuptools Integration](https://click.palletsprojects.com/en/7.x/setuptools/)
- [Python Package User Guide](https://packaging.python.org/tutorials/)
- [Python Package Project Structure](https://packaging.python.org/tutorials/packaging-projects/)


# 重要概念

- Distribution : 如果你打算把一個 python 專案 publish 出去, 則此專案稱之為一個 distribution
    - 它通常會被封裝成 `xx.whl` 或 `xx.tar.gz`
- pure         : 若發行出去的 distribution, 完全使用 python 撰寫, 稱之為 pure; 反之 nonpure, 底層會依賴 C 實作的腳本 or 其他
- universal    : 如果 Distribution 符合下列條件, 則稱之為 universal
    - Distribution 是 pure
    - 適用於 python2 && python3
    - 無需使用像是 `2to3` 的轉換
- distutils    :
    - Python 3.10 以標記為 DEPRECATED 並將在 3.12 時移除 distutils
    - 用來 封裝 && 發布 Python 程式 && 擴充功能
    - 此為 python standard library (請別直接使用它)
    - 替代方案, 請使用 `pip install setuptools wheel twine`
        - `setuptools` && `wheels` 代替 內建的 `distutils`
        - `twine` 用來作 套件上傳
- setuptools   : (3rd lib) 用來替代 `distutils`
- wheels       : (3rd lib) 先把它理解成跟 setuptools 差不多的東西.
- eggs         : (不要鳥他) 這個是 wheels 的前身
- sdist        : 
- twine        : (3rd lib) 用來上傳套件到 Python Repository
- setup.py     : 如果要讓 Python 套件發行出去, 需要定義這個東西. 這裡面包含了三個部分:
    - Distribution 的 Metadata
    - 存在於 Distribution 裡頭的其他檔案資訊
    - 依賴性的資訊


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



# 打包套件

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
