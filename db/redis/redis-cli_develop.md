

```bash
REDIS_PASSWORD=

### 看 redis 連線狀況
redis-cli -a {REDIS_PASSWORD} --stat

### 列出所有 'server-*' 的 keys
redis-cli -a {REDIS_PASSWORD} keys server-*

### 以原始樣式顯示資料
$# redis-cli set age 30        # OK
$# redis-cli get age           # "30"
$# redis-cli incr age          # (integer) 31    ← 若為 stdout 才會有 (integer) 方便辨識
$# redis-cli --raw incr age    # 32              ← ((以原始樣式顯示資料))
$# redis-cli --no-raw get age  # (integer) 33    ← 強制使用 readable 的樣式來輸出
$# redis-cli info keyspace     # 列出有儲存資料的 DB
```