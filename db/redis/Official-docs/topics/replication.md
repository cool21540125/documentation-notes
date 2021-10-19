[Replication](https://redis.io/topics/replication)
[mysql – Error ‘Your password does not satisfy the current policy requirements’ or zero length mysql password](https://ahelpme.com/software/mysql/mysql-error-your-password-does-not-satisfy-the-current-policy-requirements-or-zero-length-mysql-password/)

先撇開 RedisCluster 及 RedisSentinel 不說, Redis replication 是最容易配置的主從複製.

工作機制:

1. Master 與 Replica 連接正常的情況下, 會因為底下的一些行為而發生 **Master keeps the replica updated by sending a stream of commands to the replica**, 用來作為主從之間的同步:
    - client writes, keys expired or evicted, any action that changing the master dataset
2. 若 Master 與 Replica 之間因網路問題斷開, Replica 會嘗試重新連線, 並嘗試 partial resynchronization
    - 會嘗試去取得把斷線時段的 the part of the stream of commands 
3. 若 *partial resynchronization* 無法進行時, Replica 會要求 *full resynchronization*

Redis 預設使用 `asynchronous replication`

Client 可使用 `WAIT` command 來請求 *Synchronous replication*
    - 但是 WAIT 只能確保其中幾個 Replicas (非全部) 有收到 copies.
    - 不保證 Redis instances 之間達到 `CP system`(這啥? 似乎是 *strong consistency*)
    - 故障轉移期間, 確認的寫入仍然可能遺失(取決於持久性配置)
        - 而 WAIT, 再故障事件以後, 讓這種情況大幅的下降了

關於 HA 與 failover, 可直接參考 **Sentinel** 或 **Redis Cluster**, 本文後續將持續深入 Redis basic replication

Redis replication 重要基本觀念(幹... 底下這些官方寫的有點不明所以):

- Redis uses asynchronous replication, with asynchronous replica-to-master acknowledges of the amount of data processed.
- 一主可以有多從(replicas)
- Replicas 也可以連結到其他的 Replicas 
    - Redis 4.0+, *all sub-replicas* 會收到來自 master 相同的 replication stream
- Master 處理 Replication 屬於 non-blocking 操作
    - 也就是說, Master 在面臨處理 queries 的同時, 也能處理來自 replicas 的 **initial synchronization** 或 **partial resynchronization**
- Replicas 處理 Replication 也屬於 non-blocking 操作.
- While the replica is performing the initial synchronization, it can handle queries using the old version of the dataset, assuming you configured Redis to do so in redis.conf. Otherwise, you can configure Redis replicas to return an error to clients if the replication stream is down. However, after the initial sync, the old dataset must be deleted and the new one must be loaded. The replica will block incoming connections during this brief window (that can be as long as many seconds for very large datasets).
    - Redis 4.0+, 可配置執行刪除 old dataset 時, 使用不同的 thread. 而讀取 new dataset 時, 會去 block replica && 發生於 main thread
- Replication can be used both for scalability, in order to have multiple replicas for read-only queries (for example, slow O(N) operations can be offloaded to replicas), or simply for improving data safety and high availability.
- 另一種加速 Replication 效能的方式, 也可以停止 Master 去寫入到 disk, 而是讓 slave 去執行.
    - 但是這種做法要特別留意, 萬一 Master 重啟後, 它會是全新的, Replicas 可能也會跟著同步... 資料就 G 了


## Safety of replication when master has persistence turned off

pass


## How Redis replication works

pass


## Replication ID explained

pass


## Diskless replication

pass


## Configuration

pass


## Read-only replica

- Redis2.6+, 多出了個 `replica-read-only` 的 option, 用來避免誤在 replica 執行寫入操作
- pass


## Setting a replica to authenticate to a master

- 如果 Master 有設置 `requirepass`, 則 replicas 也需要作些操作:
    - 使用 Redis-cli 動態配置: `config set masterauth <password>`
    - 寫入 Config 作用久配置: `masterauth <password>`


## Allow writes only with N attached replicas

pass


## How Redis replication deals with expires on keys

pass


## Configuring replication in Docker and NAT

pass


## The INFO and ROLE command

- 不論是 Master 或是 Replicas, 都可以使用 `INFO` cli 來作主從(或其他)的相關查詢. ex: `INFO replication`
- 另一個對電腦更友善的指令為 `ROLE`. 可查詢主從之間 replication 的 offset, 已連接的 replicas 等等


## Partial resynchronizations after restarts and failovers

pass


## Maxmemory on replicas

pass



# 其它

Replication 時, 發生錯誤

> Error 'Your password does not satisfy the current policy requirements' on query. Default database: ''.

參考這篇 https://ahelpme.com/software/mysql/mysql-error-your-password-does-not-satisfy-the-current-policy-requirements-or-zero-length-mysql-password/

