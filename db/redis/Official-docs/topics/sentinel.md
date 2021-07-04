[Redis Sentinel Documentation](https://redis.io/topics/sentinel)

Redis 的 HA 方案之一. 它同時也處理了底下的大方向的任務:

- Monitoring: Sentinel 定時監控 Master 與 Replicas 是否如期運行
- Notification: 萬一 Master/Replica 發生問題, 可透過 API 通知 admin 來作因應
- Automatic failover: 萬一 Master 未如期正常運行, Sentinel 會執行 failover process, 指派 Replica 晉升為 Master
    - 後續 Master 若正常了, Sentinel 會請它安分地當個 Replica
- Configuration provider: Sentinel 充當 Redis Client 操作 Redis Server 的權威來源. Client 連接到 Sentinel, Sentinel 告知前往哪邊作 Redis 操作

- Redis2.8+, 改寫了原本使用的 `Sentinel`, 改版後稱之為 `Sentinel 2`
    - Redis2.6 以前使用的 `Sentinel 1`, 已不建議使用
- 若使用哨兵模式, Sentinel 預設會訪問 Server & Replicas 的 `TCP/26379`

```bash
### 運行 Sentinel 的方式
redis-sentinel /path/to/sentinel.conf
# 或
redis-server /path/to/sentinel.conf --sentinel
```

至於 Sentinel 怎麼 Deploy, Configure, Tune, Monitoring, 有需要再來學
