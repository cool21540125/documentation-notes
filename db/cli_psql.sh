#!/bin/env psql
exit 0
#
# https://www.postgresql.org/docs/current/app-psql.html
#
# 設定免密碼連線 vim $HOME/.pgpass (600)
#   DB_HOST:DB_PORT:DB_NAME:USERNAME:PASSWORD
#
# --------------------------------------------------------------

### Login
DB_USER=postgres
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=postgres
psql -U $DB_USER -h $DB_HOST -p $DB_PORT $DB_NAME
# -W, 迫使 psql 詢問密碼 (似乎可以忽略 .pgpass)

### 切換 DB
\c DB_NAME

### 列出 DBs
\l

### 列出 SCHEMAs
\dn

### 列出 TABLEs
\dt

### 列出 Database ROLEs (可能隨著版本演進, 早期兩者不同, 但目前用途似乎一樣了)
\dgS+
\duS+
# + 則包含 description 欄位 (這張表: pg_catalog.pg_user)
# S 包含 System ROLE

### 列出 ROLEs 對於 Schema/Table 具備了哪些權限
\dp
\z
# 預設只有 user created 才會顯示, 可加上 S 來列出 system objects (但資訊會很亂)

### 列出 table schema
\dt $TABLE # + 則包含 description 欄位

### 列出 FUNCTIONs
\df

### 列出 VIEWs
\dv

### 列出 CONFIGs
\dconfig+ # + 則包含 DataType (但是會亂到爆炸)

### 列出 default access privilege settings
\ddp
SELECT * FROM pg_roles WHERE rolname = 'app_role'
# 可藉由 `ALTER DEFAULT PRIVILEGES` 做修改

### 修改密碼
\password $USER

### 切換 ROLE (可用來測試權限)
SET ROLE $EXISTED_ROLE
