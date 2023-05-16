
# `List個別元素` 設定到期時間, 而非整個 key 到期

- 2018/06/26
- [expire an element in an array](https://stackoverflow.com/questions/7577923/redis-possible-to-expire-an-element-in-an-array-or-sorted-set)
- [Pattern for expiring set members](https://groups.google.com/forum/#!topic/redis-db/rXXMCLNkNSs)
- [Add ability to expire members of a set](https://github.com/antirez/redis/issues/135)
- [Zrangebyscore](http://www.runoob.com/redis/sorted-sets-zrangebyscore.html)
- [zadd](https://redis.io/commands/zadd)
- [ZREMRANGEBYSCORE](http://redisdoc.com/sorted_set/zremrangebyscore.html)


# 實作方向1

```sh
# 增加 3 個 field -> salary 這個 key
> ZADD salary 2500 jack                        # 測試資料
(integer) 0
> ZADD salary 5000 tom
(integer) 0
> ZADD salary 12000 peter
(integer) 0

> ZRANGE salary 0 -1     # 查看 salary 裏頭的 欄位
1) "jack"
2) "tom"
3) "peter"

# 無法使用「0 -1」 而是只能使用「-inf +inf」
> ZRANGEBYSCORE salary -inf +inf WITHSCORES    # 查看 salary 裏頭的 欄位 && 值
1) "jack"
2) "2500"
3) "tom"
4) "5000"
5) "peter"
6) "12000"

> ZRANGEBYSCORE salary 0 (5000 WITHSCORES    # 查看 salary < 5000 的員工 && 排序
1) "jack"
2) "2500"

> ZRANGEBYSCORE salary (5000 400000     # 查看 salary > 5000 && salary <= 40000
1) "peter"

# 假設公司經營不善, 打算把 salary > 10000 的員工開除
> ZREMRANGEBYSCORE salary 0 10000       # 把 [0, 10000] 之間的東西砍掉~
(integer) 2

> ZRANGE salary 0 -1
1) "peter"
```


# 實作方向2

```sh
# 增加資料到 alarm
$ SADD alarm 520
$ SADD alarm 530

# 抓 alarm 的資料
$ SMEMBERS alarm
1) "520"
2) "530"

# 刪除 alarm 的資料
$ SREM alarm 520
(integer) 1

$ SMEMBERS alarm
1) "530"
```

再搭配程式端去控制時間流程

```py
import threading
import time
import redis

redis_pool = redis.ConnectionPool(**redis_config)
r = redis.StrictRedis(connection_pool = redis_pool)
redis_config = {
    'host': 'localhost',
    'port': 6379,
    'db': 0,
    'decode_responses': True
}

code = '520'
alarm_last = 10  # 模擬 存續10秒鐘

def remove_alarm(code, alarm_last):
    time.sleep(alarm_last)
    r.srem('alarms', code)

r.sadd('alarms', code)
threading.Thread(target=remove_alarm, args=(code, alarm_last)).start()
```
