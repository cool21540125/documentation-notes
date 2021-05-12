# SQA





## Unix Domain Connections

- 2020/11/06
- [UnixDomainCOnnections](https://docs.sqlalchemy.org/en/13/dialects/postgresql.html#unix-domain-connections)


```py
CONN = "postgresql+psycopg2://user:password@/dbname?host=/var/lib/postgresql"
#                                          ^^^
# 可省略 host 部分, 取而代之的是使用 Unix 內部的 Unix Socket 連線
```
