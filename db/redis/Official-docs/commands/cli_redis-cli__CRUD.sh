#!/bin/bash
exit 0
# ----------------------------------------------------------

# =====================================================================================================
# Basic CRUD
# =====================================================================================================

### 看 redis 連線狀況
redis-cli -a __REDIS_AUTO_PASSWORD__ --stat

### 列出所有 'server-*' 的 keys
redis-cli -a __REDIS_AUTO_PASSWORD__ keys server-*

### 以原始樣式顯示資料
redis-cli set age 30       # OK
redis-cli get age          # "30"
redis-cli incr age         # (integer) 31    ← 若為 stdout 才會有 (integer) 方便辨識
redis-cli --raw incr age   # 32              ← ((以原始樣式顯示資料))
redis-cli --no-raw get age # (integer) 33    ← 強制使用 readable 的樣式來輸出
redis-cli info keyspace    # 列出有儲存資料的 DB


### 連線到遠端 Redis/Valkey

redis-cli -h __REDIS_HOST__ -p __REDIS_PORT__

info clients