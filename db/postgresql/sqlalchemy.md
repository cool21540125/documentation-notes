# sqlalchemy

- 2021/01/31
- v1.4.31

Since sqa 1.4+, sql 分成 2 類的 API: `Core` & `ORM`

```
------------------------------------------------------------------
| SQLAlchemy ORM                                                 |
| -------------------------------------------------------------- |
| |                  Object Relationsl Mapper(ORM)             | |
| -------------------------------------------------------------- |
------------------------------------------------------------------
------------------------------------------------------------------
| SQLAlchemy Core                                                |
| ---------------- ------------------ -------------------------- |
| | Schema/Types | | SQL Expression | |         Engine         | |
| |              | |    Language    | |                        | |
| ---------------- ------------------ -------------------------- |
|                                     -------------- ----------- |
|                                     | Connection | | Dialect | |
|                                     |   Pooling  | |         | |
|                                     -------------- ----------- |
------------------------------------------------------------------
                                      --------------------------
                                      |          DBAPI         |
                                      --------------------------
```

- ORM, Object Related Model
    - 架構在 Core 之上, 提供了一個額外的 configuration layer 用來作 py class model 與 DB table 的 mapping && 物件永久性機制(Session)
    - 主要互動物件為 `Session`
    - 使用 ORM 時, Engine 由 Session 來管理. Session 基本上與 Engine 的 Connection 幾乎相同
        - 但 Session 與 Connection 的 execution pattern(執行模式) 不相同
- Core : 底層 DB 基礎架構的 toolkit, 管理連線 && 針對 SQL stmt 與 DB 做互動
    - Engine
        - SQA 起點, 用來維持與 DB 的 connection pool. 主要互動物件為 `Connection` && `Result`


## Data Types

SQLAlchemy  | Python             | SQL
----------- | ------------------ | ----------------------
Boolean     | bool               | BOOLEAN or SMALLINT
Interval    | datetime.timedelta | INTERVAL or DATE
Date        | datetime.date      | DATE
DateTime    | datetime.datetime  | DATETIME
Time        | datetime.time      | DATETIME
Enum        | str                | ENUM or VARCHAR
Float       | float OR Decimal   | FLOAT or REAL
Numeric     | decimal.Decimal    | NUMERIC or DECIMAL
Text        | str                | CLOB or TEXT
Integer     | int                | INTEGER
BigInteger  | int                | BIGINT


## Database MetaData

### Table 操作 (py 同步到 DB)

```py
### Table 操作
from sqlalchemy import MetaData
from sqlalchemy import Table, Column, Integer, String
from sqlalchemy.orm import declarative_base

engine = create_engine(SQLALCHEMY_DATABASE_URL)  # 先連到 DB

### Method1. 較少使用
mo = MetaData()
ut = Table(
    "user_account",
    mo,
    Column('id', Integer, primary_key=True),
    Column('name', String(32))
)
# 上面這段會將此 ut 註冊到 mo 裡頭, 可用 mo.tables 查看

### 建立 Table 方式
mo.create_all(engine)

### -------------------------------------------
### Method2. 較常用
Base = declarative_base()
class ut(Base):
    __tablename__ = 'user_account'
    id = Column(Integer, primary_key=True)
    name = Column(String(32))
# 上面這段會將此 ut 註冊到 Base.metadata 裡頭, 可用 Base.metadata.tables 查看

### 建立 Table 方式
Base.metadata.create_all(engine)

### -------------------------------------------
### 取得 table 所有 Columns
ut.c

### 取得 name Column
ut.c.id

### 取得 PK 
ut.primary_key
```

### Table 操作 (DB 同步到 py)

```py
from sqlalchemy import Table
from sqlalchemy import MetaData

engine = create_engine(SQLALCHEMY_DATABASE_URL)
mo = MetaData()

### t 為 <class 'sqlalchemy.sql.schema.Table'>
t = Table("table_that_already_in_db", mo, autoload_with=engine)
# 若真要產生 py, 參考 alembic 吧...
```


## Unix Domain Connections

- 2020/11/06
- [UnixDomainConnections](https://docs.sqlalchemy.org/en/13/dialects/postgresql.html#unix-domain-connections)


```py
CONN = "postgresql+psycopg2://user:password@/dbname?host=/var/lib/postgresql"
#       ^^^^^^^^^^ ^^^^^^^^                ^^
#        dialect  + driver                 host
# 可省略 host 部分, 取而代之的是使用 Unix 內部的 Unix Socket 連線
# dialect, 翻譯為 方言, 但其實就只是聲明哪種 DB 而已...
# driver 的部份省略則使用預設
```
