# DBApi 2.0

- 2021/04/30
- [PyMySQL vs MySQLdb](https://stackoverflow.com/questions/7224807/what-is-pymysql-and-how-does-it-differ-from-mysqldb-can-it-affect-django-deploy)


Python標準程式庫 **沒有內附 RDBMS 介面**, 而廣為使用的第三方模組 多半遵循 `Python Database API 2.0`標準 (PEP249)

鼎鼎大名的 SQLAlchemy 基本上就是使用這個第三方 Driver 來與 Database 互動

```py
from sqlalchemy import create_engine
engine = create_engine("sqlite+pysqlite:///:memory:", echo=True, future=True)
# 若沒有 pysqlite, 則 Python 會使用預設的 DBApi 來與 DB 互動; 而此情況, 使用的是較現代化的 SQlite API
# 此範例, 使用的是 In Memory DB: 「/:memory」
# create_engine.echo 會用來 log 所有的 DB 互動過程(它會 emit Python logger, 預設 log 到 stdo    ut)
```


```py
import <DBAPI相容性模組>

# conn 為 Connection 實例, 代表對 DB 的連線
conn = <DBAPI相容性模組>.connect(<必要參數>)

# Connection 的 4種方法
conn.close()       # Close Connection
conn.commit()      # Commit
conn.rollback()    # Rollback
c = conn.cursor()  # 取得 Cursor

c.DB方法()
c.DB屬性

# c.execute(<SQL Statement>)
c.execute( ... )
            ↑
        # 不建議使用 「'select * from tbl where col2={!r}'.format(x)」這類的寫法
        # => 慢 不安全(SQL Injection問題)
        # 改用「'select * from tbl where col2=?', (some_value,)」
```


## MySQL DB API Drivers

- [MySQL DB API Drivers](https://docs.djangoproject.com/en/3.2/ref/databases/#mysql-db-api-drivers)

- MySQLdb
    - Python3以上不支援此 Native Driver
    - 此 Type 為 libmysqlclient
- mysqlclient
    - 從 MySQLdb 抄過來的東西 (支援 Python3)
    - Django 官網建議用這個 Driver.
- MySQL Connector/Python
    - 此 Type 為 Native Driver
- MySQL 官方
    - Oracle 發行的 Pure Python Driver ; 此 Driver **不依賴** `Python標準函式庫以外的模組` 及 `MySQL client library`
    - [MySQL 官網](https://dev.mysql.com/downloads/connector/python/) 強烈建議 MySQL 5.5, 5.6, 5.7, 8.0 搭配使用 `MySQL Connector/Python 8.0`
    - `pip install mysql-connector-python` (這東西依賴於 [Microsoft Visual C++ 2015 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=52685))


## mysqlclient

- 2019/08/14
- https://stackoverflow.com/questions/51294268/pip-install-mysqlclient-returns-fatal-error-c1083-cannot-open-file-mysql-h

如果 windows 10 上出現 `pip install mysqlclient` 錯誤

1. https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient
2. 下載相關版本的 mysqlclient 套件
3. 使用相關 venv python
4. pip install "path/to/mysqlclient/mysqlclient-1.4.4-cp37-cp37m-win_amd64.whl" (以 python37 win10 X64 為例)

即可完成

----------

Django 有為 `MySQLdb` 及 `mysqlclient` 配置 adapter ; 而 `MySQL Connector/Python` 有自己的 adapter