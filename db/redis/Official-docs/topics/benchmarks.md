[How fast is Redis?](https://redis.io/topics/benchmarks)

Redis 可使用 `redis-benchmark utility` 來模擬客戶端, 短時間內大量塞資料 (類似 Apache 的 `ab utility`)

```bash
redis-benchmark -h ${HOST} -p ${PORT} -c ${Number_of_clients} ${Number_of_total_requests}
#  -d <size>          Data size of SET/GET value in bytes (default 2)
#  --dbnum <db>       SELECT the specified db number (default 0)
#  -k <boolean>       1=keep alive 0=reconnect (default 1)
#  -r <keyspacelen>   說明超大一包... 遇到再說
#  -P <numreq>        Pipeline <numreq> requests. Default 1 (no pipeline).
#  -q                 Quiet. Just show query/sec values
#  -l                 Loop. Run the tests forever

### Notebook - 1 Core VM 實測結果
$# redis-benchmark -q -n 100000
PING_INLINE: 44903.46 requests per second
PING_BULK: 45454.54 requests per second
SET: 45065.34 requests per second
GET: 45330.91 requests per second
INCR: 45065.34 requests per second
LPUSH: 44682.75 requests per second
RPUSH: 44762.76 requests per second
LPOP: 44984.25 requests per second
RPOP: 44984.25 requests per second
SADD: 45187.53 requests per second
HSET: 43725.41 requests per second
SPOP: 44464.20 requests per second
LPUSH (needed to benchmark LRANGE): 44984.25 requests per second
LRANGE_100 (first 100 elements): 32175.03 requests per second
LRANGE_300 (first 300 elements): 18191.74 requests per second
LRANGE_500 (first 450 elements): 13232.76 requests per second
LRANGE_600 (first 600 elements): 10430.79 requests per second
MSET (10 keys): 41425.02 requests per second
# 上面要讓他跑個大約一分鐘


```

