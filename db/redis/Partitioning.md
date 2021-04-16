Partitioning: how to split data among multiple Redis instances.

- 2021/04/16


# Partitioning 基礎範例

Redis 實作 Sharding 的方式是 `Hash Partitioning`

ex: 機器有 6 台

CRC32(redis key) -> int number, 例如: 93024922

在將之取餘數: 93024922 % 6 = 4 (把這個 key 存到第4台)


# 各種實作

- `Client side partitioning`
    - Client 端直接判斷, 並將查詢直接送到正確的機器
- `Proxy assisted partitioning`
    - Client 詢問 Proxy, Proxy 再幫忙 forward request 到正確機器, 再回傳查詢結果給 Client
- `Query routing`
    - Client 隨便問一個 Server, Server 幫忙 redirect Client 到正確的機器去做查詢

**Redis Cluster is a mix between `query routing` and `client side partitioning`.**


# 缺點

- 因為是由 key 來做 partitioning, 可能面臨 value 大小不一, 導致資料分配不均的問題
- 若操作包含了 multiple keys, 不支援交易功能
- 維護資料成本↑. 需處理 RDB / AOF files 的 data backup & aggregate the persistence files across 節點/實例
- 若為 `Client side partitioning` 或 `Proxy assisted partitioning`, 不容易完成 增刪節點後的 Resharding


# Store or Cache

> Although partitioning in Redis is conceptually the same whether using Redis as a data store or as a cache, there is a significant limitation when using it as a data store. When Redis is used as a data store, a given key must always map to the same Redis instance. When Redis is used as a cache, if a given node is unavailable it is not a big problem if a different node is used, altering the key-instance map as we wish to improve the availability of the system (that is, the ability of the system to reply to our queries).

不是很懂原文的意思. 以 Redis 的角度來說, store & cache, 概念上是相同的. 但是 store 存在很大的使用限制

若作為 `cache`, 其中一個端點掛了, RedisCluster 大不了選擇另一台機器, 然後重新儲存
若作為 `store`, 特定的 key 總是會被 map 到相同的 Redis Instance, 如果這台 Redis Instance 掛了的話會怎樣?

- 若 Redis 用作 `cache`, consistent hashing using **scaleing up and down** is easy.
- 若 Redis 用作 `store`, **a fixed keys-to-nodes map is used, so the number of nodes must be fixed and cannot vary**. 