# alembic

alembic && sqlalchemy(SQA) 用法


## basic

- 2019/08/14
- https://michaelheap.com/alembic-python-migrations-quick-start/

```bash
### 虛擬環境底下
$# pip install mysqlclient      # 若無法解決, 參考 DBApi 那篇
$# pip install alembic

$# alembic init alembic  # 產生 alembic dir, 作為託管 SQL 版本的基地
# 產生如下
/alembic
    /__pycache__
    /env.py
    /README
    /script.py.mako
    /versions
/alembic.ini

$# vim alembic.ini
# 修改裏頭的 sqlalchemy.url 部分, 定義好 DB 連線

$# alembic revision -m "init" --autogenerate
# 會產生
/alembic/versions/68ff4441380d_meaningful_operation_name.py
# 裡面的 upgrade && downgrade, 一定要能夠做反向操作!!

$# alembic upgrade head    # 升到最新
$# alembic upgrade +1
$# alembic downgrade -1
$# alembic downgrade base  # 降至最初始版本

### 查看 DB 版本
$# alembic current
```


## alembic migration 語法紀錄

- alembic==1.0.11
- SQLAlchemy==1.3.8

```python
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

### 更改欄位名稱
op.alter_column(table_name='git_system_hook', column_name='colunmA', new_column_name='columnA', schema='admin')

### Create Table
op.create_table('monitor_info',
    sa.Column('id', postgresql.UUID(), server_default=sa.text('gen_random_uuid()'), nullable=False, comment='PK'),
    sa.Column('monitor_id', sa.String(length=8), nullable=False),
    sa.Column('monitor_name', sa.String(length=32), nullable=False, comment='監測點名稱'),
    sa.PrimaryKeyConstraint('id'), 
    schema='monitoring'
)

### Create Index
op.create_index(op.f('idx_monitor_id'), table_name='monitor_info', columns=['monitor_id'], unique=True, schema='monitoring')
```

## sqlalchemy 語法紀錄

```python

```
