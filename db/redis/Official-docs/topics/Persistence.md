
[Redis Persistence](https://redis.io/topics/persistence)

Redis 提供了下述資料持久化方案:

- RDB(Redis Database): 每隔一段時間執行 point-in-time snapshots
- AOF(Append Only File): Server 每執行一次資料變更, 都會以 append 的方式寫入到 log, 並且在將來重啟時載入(來作還原). 
    - 如果這個 log 變得過於龐大, Redis 也會在背景重寫日誌
- No Persistence: 不作持久性保存資料(如果 Server 重啟後, 資料就通通沒了~)
- RDB+AOF: 結合 AOF & RDB

上述的重點在於, RDB 以及 AOF 之間的權衡關係.


## RDB v.s. AOF

RDB:

- Pros
    - RDB is a very compact single-file point-in-time representation of your Redis data
    - RDB files 非常適合拿來做備份. 由於他是一個單獨的壓縮文件(compact file), 易於在 data-center 之間作傳輸
    - RDB maximizes Redis performances since the only work the Redis parent process needs to do in order to persist is forking a child that will do all the rest. The parent instance will never perform disk I/O or alike.
    - 相較於 AOF, 服務重啟更加快速
    - On replicas, RDB 提供了 [Partial resynchronizations after restarts and failovers](https://redis.io/topics/replication#partial-resynchronizations-after-restarts-and-failovers)
- Cons
    - 因為備份時間並非隨時, 而是定期, 所以可能在備份間格之間發生異常, 此段時間的資料則無從追蹤
    - RDB 會使用 system call: `fork()`, 來讓子進程能在執行持久化的作業, 可能會很耗時, 進而導致短時間內停止對 Redis Client 服務
    - 相對的, AOF 也會用到 `fork()`, 但是可調整 重寫日誌的頻率(rewrite log), 來抵銷 durability 所造成的影響

AOF:

- Pros
    - 使用 `AOF Redis` 能有更好的 durable (備份的頻率更高)
    - 預設 每秒一次 背景執行 `fsync policy`
        - main thread will try hard to perform writes when no fsync is in progress
        - 因此, 理論上, 最多會損失大約 1 秒的資料
    - AOF log 只做 append, 所以不會有 seek 耗損.
        - 即使將來若遇到 log ends with an half-written command, `redis-check-aof tool` 也可輕易修復
    - AOF 會在背景不斷地修改它的 AOF file
        - 假設某個 key 經過不斷變更, AOF file 只會留存最新一筆(用來還原用, 過程不重要), 避免檔案過於龐大
    - AOF 包含了所有操作的 log, 
        - 假設不小心使用了 `FLUSHALL` 把東西砍光了, 只需要把最新的 AOF file(`FLUSHALL` 那一行砍掉), 重啟 Redis 就可重建
- Cons
    - 相同 dataset 的情況下, AOF 通常會比 RDB files 還要龐大
    - AOF 可能在使用了不同的 `aof policy` 以後, 速度會比 RDB 還要慢
        - 基本上, 如果把 fsync 設定為每秒一次, 性能也是不需要擔心的
        - 如果使用 `fsync no`, 則 AOF 速度幾乎等同於 RDB
        -  Still RDB is able to provide more guarantees about the maximum latency even in the case of an huge write load.
    - 官方在測試時, 發生過罕見的 AOF 錯誤, 但是現實生活上, 並未接收過實際的錯誤情境


## 官方建議的策略

- 在長久的未來, Redis 官方有計畫會將 RDB+AOF 兩者合併為一個持久性方案
- Redis 官方建議同時使用 RDB+AOF
- 如果可以容忍幾分鐘的資料遺失, 可單純使用 RDB
- 官方不建議單獨使用 AOF 來作為持久方案, 因為
    - 定期執行 RDB 有助於重啟 速度較快
    - AOF engine 可能會有某些 event of bugs 的情境


# Snapshotting 實作

- 預設 Redis 儲存 dataset 的 snapshots 到 Disk 上, 檔名為 `dump.rdb`(binary file)
    - 也可以自行配置讓 Redis, ex: N秒以內做了M次的資料異動, 就儲存 dataset
    - 當然也可自行使用 `SAVE` or `BGSAVE` 來自動儲存
    - ex: `save 60 1000`
        - 此範例就是讓 Redis, 當 60 秒以內有 1000 個 keys 變動的話, 自動 dump dataset 到 disk
        - 此策略就稱之為 `snapshotting`

作業流程為:

1. Parent process fork Child process
2. child 開始把 dataset 寫入到 temproary RDB file
3. child 完成 new RDB file 的寫入後, 這份 RDB file 就會取代原本舊有的 RDB file

This method allows Redis to benefit from copy-on-write(COW) semantics.


## Append-only file 實作

- `Snapshotting` 並不是非常的 durable.
- 如果有些 AP 對於 durable 非常的講就, 要求 *full durability*, 則 `Snapshotting` 並非是個很好的選擇.
- AOF 是 Redis `fully-durable` 的替代策略 (自從 Redis1.1+ 就存在了)
- 配置方式是: `appendonly yes`
    - 一旦設定了以後, 每當 Redis 接收到異動的 command, 都會把這操作 append 到 `AOF`
        - 之後如果重啟 Redis, Redis 啟動後會 re-play `AOF` 來 rebuild the state
- 自從 Redis2.4+, Redis 會在背景自動去觸發 `BGREWRITEAOF`, 會自動把 AOF 檔案, 相同 key 不斷修改的過程, 優化為最終值(方便將來重建)
    - Redis2.2(含)以前, 這動作必須自己來
- 可自行配置 Redis 如何 `fsync` data on disk:
    - `appendfsync always`            : 最慢 & 最安全.
        - 每執行完 *一批來自 multiple clients 或 pipline 的 commands*, 都會 append to AOF
        - so it means a single write and a single fsync (before sending the replies).
        - 雖說實務上他很慢, 但它支援了 `group commit`, 如果存在許多平行寫入, Redis 會嘗試使用 single fsync operation
    - `appendfsync everysec`(Default) : 
        - 每秒 `fsync`. 災難發生的時候, 可容忍遺失 1 秒鐘的資料
    - `appendfsync no`                : 永遠不做 `fsync`. 
        - just put your data in the hands of the Operating System
- 運作方式:
    1. Redis forks (現在有 child && parent process)
    2. child 開始寫入 new AOF 到 temporary file
    3. parent 蒐集 in-memory buffer 內部的變動, 同時, 將變動的部分, 寫入到舊的 AOF. 
        - 此時如果 rewriting 失敗了的話是安全的
    4. 當 child 完成 rewriting, parent 會收到 signal, 並將 in-memory buffer append 到 child 產出的 temporary file
    5. Now Redis atomically renames the old file into the new one, and starts appending new data into the new file.

但是實際上, 可能發生 AOF 寫入中, 發生磁碟異常(損壞, 滿了, ...), 導致 AOF file 損壞(最後一筆格式跑掉了)


#### Case I. if my AOF gets truncated?

```bash
### Redis Server 可能看到這樣的 log (AOF log 被截斷)
* Reading RDB preamble from AOF file...
* Reading the remaining AOF tail...
# !!! Warning: short read while loading the AOF file !!!
# !!! Truncating the AOF at offset 439 !!!
# AOF loaded anyway because aof-load-truncated is enabled
```

這種情況, 可參考 `redis-check-aof --fix` && 遇到再來研究了


#### Case II. if my AOF gets corrupted?

```bash
### 若發生這種情況, 情境就複雜許多. Server 可能會在重啟後, 看到下面這樣的 log (無法正常啟用), 因為 AOF 損壞
* Reading the remaining AOF tail...
# Bad file format reading the append only file: make a backup of your AOF file, then use ./redis-check-aof --fix <filename>
```

這種情況, 可參考 `redis-check-aof utility`, 但要留意, 這功能可能會讓從損毀後的 AOF log 被遺棄, 因而導致資料遺失

遇到再來研究了


#### Switch RDB to AOF

遇到再來看...


## Interactions between AOF and RDB persistence

- 若為 Redis2.4+, 務必避免 RDB 正在執行 snapshotting 的時候, 右同時去執行 AOF rewrite.
    - 或者將 save 改為使用 `bgsave`, 來避免 Redis 2 個 background processes 同時運行 heavy disk I/O
- 若正在運行 snapshotting && Redis Client 直接操作使用 `BGREWRITEAOF`, 可看到 "OK".
    - 則會在 snapshotting 完成後, 開始執行 rewrite
- 如果同時啟用 AOF && RDB, Redis 重啟後的重建, 則會使用 AOF 來重建 dataset (因為它較為完整)


## Backing up Redis data

Redis is very data backup friendly since you can copy RDB files while the database is running


## Disaster recovery

災難復原 與 備份 基本相同. 備份策略可考慮使用 s3, 或是單純 scp 到遠端 Server.
