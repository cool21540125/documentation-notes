
# Install python by tar ball
- 2018/02/23
```sh
$ wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tar.xz

$ tar xf Python-3.5.2.tar.xz

# 編譯及安裝
$ ./configure --prefix=/opt/python352
$ make
$ sudo make install

# 改變擁有者
$ sudo chown -R tonynb:tonynb /opt/python352

# 建立呼叫指令
$ mkdir ~/bin
$ ln -s /opt/python352/bin/python3.5 ~/bin/py

# 環境變數
$ echo 'alias py="/opt/python352/bin/python3.5"' >> ~/.bashrc
# or
$ echo 'export python_home=~/bin/' >> ~/.bashrc
$ echo 'export PATH=$python_home:$PATH' >> ~/.bashrc

```


```sh
$ pip install --upgrade setuptools
```




---
Python中, 任何資料夾內如果有包含`__init__.py`的話, 這個資料夾就被視為是一個`package`, 如此一來就可以被 import


---

# shebang
```py
#! /usr/bin/python
# coding: utf-8

```


# 函式範例
```py
>>> a = 1
>>> type(a)
<class 'int'>
>>>
>>> isinstance(a, int)
True

>>> dict.fromkeys('hello', 2)
{'h': 2, 'e': 2, 'l': 2, 'o': 2}

>>>
```

# configureParser

- configureParser.py
```py
import configparser

# 讀取外部組態檔
def getConfig(iniPath):
    config = configparser.ConfigParser()
    config.read(iniPath)
    dbhost = config.get('Section_A', 'sql_dbhost')
    user = config.get('Section_A', 'sql_id')
    passwd = config.get('Section_A', 'sql_pd')
    return dbhost, user, passwd
#

def mainFunction():
    iniPath = './house.ini'
    dbhost, user, passwd = getConfig(iniPath)
#
```

- house.ini
```ini
[Section_A]
sql_dbhost=localhost
sql_pport=3306
sql_id=tony
sql_pd=12345687


[Section_B]
# 放其他的...
```

# 環境變數

```py
import os
os.environ['PATH']
```

```python
### 順序: arguments -> *args -> default -> **kwargs
def display_info(a, b, *args, name='Tony', **kwargs):
    return [a, b, args, name, kwargs]

display_info(1, 2, 3, lastname='Chou', job='Programmer')
# [1, 2, (3,), 'Tony', {'lastname': 'Chou', 'job': 'Programmer'}]


###
a = (1,2,3,4,5,6)
print(*a)   # 1 2 3 4 5 6
print(a)    # (1, 2, 3, 4, 5, 6)


### dictionary unpacking
def display_name(first, last):
    print(f'{first} {last}')

names={'first': 'chou', 'last': 'tony'}
display_name(**names)
​# chou tony
​

###

```
