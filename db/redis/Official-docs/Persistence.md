# Redis Persistence

- https://redis.io/topics/persistence

Redis 提供了不同範圍的 persistence 選項:

- RDB(Redis Database):
- AOF(Append Only File):
- No Persistence:
- RDB+AOF: 

上述的重點在於, RDB 以及 AOF 之間的權衡關係.


## RDB 優點


## RDB 缺點


## AOF 優點

- 使用 `AOF Redis` 能有更好的 durable
- 預設的 `fsync policy` 為 每秒一次
    - 它使用 background thread 來做處理
    - main thread will try hard to perform writes when no fsync is in progress
- AOF log 只做 append, 所以不會有 seek 耗損.
    - 即使將來若遇到 log ends with an half-written command, `redis-check-aof tool` 也可輕易修復
- AOF 會在背景不斷地修改它的 AOF file, 假設某個 key 經過不斷變更, AOF file 只會留存最新一筆(用來還原用, 過程不重要), 避免檔案過於龐大
- AOF 包含了所有操作的 log, 假設不小心使用了 `FLUSHALL` 把東西砍光了, 只需要把最新的 AOF file(`FLUSHALL` 那一行砍掉), 重啟 Redis 就可重建


## AOF 缺點

- 相同 dataset 的情況下, AOF 通常會比 RDB files 還要龐大
- AOF 可能在使用了不同的 `aof policy` 以後, 速度會比 RDB 還要慢
    - 如果使用 `fsync no`, 則 AOF 速度幾乎等同於 RDB


## Ok, so what should I use?


# Snapshotting

- 預設 Redis 儲存 dataset 的 snapshots 到 Disk 上, 檔名為 `dump.rdb`(binary file)
    - 也可以自行配置讓 Redis, ex: N秒以內做了M次的資料異動, 就儲存 dataset
    - 當然也可自行使用 `SAVE` or `BGSAVE` 來自動儲存
    - ex: `save 60 1000`
        - 此範例就是讓 Redis, 當 60 秒以內有 1000 個 keys 變動的話, 自動 dump dataset 到 disk
        - 此策略就稱之為 `snapshotting`

作業流程為:
- Redis forks.
    - 現在有 child & parent process
- child 開始把 dataset 寫入到 temproary RDB file
- child 完成 new RDB file 的寫入後, 這份 RDB file 就會取代原本舊有的 RDB file

這方法就是所謂的 `copy-on-write`


## Append-only file

- `Snapshotting` 並不是非常的 durable.
- 如果有些 AP 對於 durable 非常的講就, 要求 *full durability*, 則 `Snapshotting` 並非是個很好的選擇.
- `Append-only file` 是 Redis `fully-durable` 的替代策略 (自從 Redis1.1+ 就存在了)
- 配置方式是: `appendonly yes`
    - 一旦設定了以後, 每當 Redis 接收到異動的 command, 都會把這操作 append 到 `AOF`
        - 之後如果重啟 Redis, Redis 啟動後會 re-play `AOF` 來 rebuild the state
- 自從 Redis2.4+, Redis 會在背景自動去觸發 `BGREWRITEAOF`, 會自動把 AOF 檔案, 相同 key 不斷修改的過程, 優化為最終值(方便將來重建)
    - Redis2.2(含)以前, 這動作必須自己來
- 可自行配置 Redis 如何 `fsync` data on disk:
    - `appendfsync always`            : 最慢&最安全. 每次執行完 commands 都要附加到 AOF. it means a single write and a single fsync (before sending the replies).
        - 雖說很慢, 但它支援了 `group commit`, 如果存在平行寫入, Redis 會嘗試使用 single fsync operation
    - `appendfsync everysec`(Default) : 每秒 `fsync`. 災難發生的時候, 可容忍遺失 1 秒鐘的資料
    - `appendfsync no`                : 永遠不做 `fsync`. *just put your data in the hands of the Operating System*


## Interactions between AOF and RDB persistence


## Backing up Redis data


## Disaster recovery


