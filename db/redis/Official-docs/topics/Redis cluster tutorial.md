# [Redis cluster tutorial](https://redis.io/topics/cluster-tutorial)

- [Redis Cluster Specification](https://redis.io/topics/cluster-spec)
- 2021/03/04

# Redis cluster tutorial

## Redis Cluster 101

> *Redis Cluster* provides a way to run a Redis installation where `data is automatically sharded across multiple Redis nodes`.

> *Redis Cluster* also provides some degree of availability during partitions, that is in practical terms the `ability to continue the operations when some nodes fail or are not able to communicate`.

也就是說, *Redis Cluster* 本身處理了 分片 && 高可用


## Redis Cluster TCP ports

每個 *Redis Cluster node* 起碼都需要 2 個 TCP ports:

- Clients 使用的 Port, 又稱為 `command port`, 預設 `6379 port`
- Clusters 之間使用 *binary protocol* 來互相溝通的 channel, 又稱為 `cluster bus port`, 預設 `16379 port`
    - failure detection
    - configuration update
    - failover authorization
    - 其它


## Redis Cluster and Docker

官方寫說必須使用 `host networking mode`, 但不知為啥使用 `bridge` 也可以使用 =.=

看來有必要再讀一次 [Networking overview](https://docs.docker.com/network/)


## Redis Cluster data sharding

> Redis Cluster does not use consistent hashing, but a different form of sharding where every key is conceptually part of what we call a `hash slot`.
↑ 看不懂

*Redis Cluster* 裡頭一共有 16384 個 `hash slots`, and to compute what is the hash slot of a given key, we simply take the CRC16 of the key modulo 16384.
↑ 也看不懂

*Redis Cluster* 的每個 node 都負責 `hash slots` 的一部分集合. ex: 一個 3 nodes 的 Cluster
- Node A `hash slots`: 0 ~ 5000
- Node B `hash slots`: 5001 ~ 10000
- Node C `hash slots`: 10001 ~ 16383


```bash
### 可能的指令, 但沒確認過
redis-cli -p 6379 cluster addslots {0..5461}
redis-cli -p 6380 cluster addslots {5462..10922}
redis-cli -p 6381 cluster addslots {10923..16383}
```


## Redis Cluster master-slave model


## Redis Cluster consistency guarantees


# Redis Cluster configuration parameters


# Creating and using a Redis Cluster

運行一個 Cluster, 最起碼需要 3 nodes, 但強烈建議使用 6 nodes, 來建立 3主3從

運行 `redis-server` 以後, 可看到底下這個

```bash
1:M 04 Mar 2021 08:52:03.827 * No cluster configuration found, I\'m 7ba45516b36b92d4b9bd7b02482fd90ee3272e87
# 這個 NODE ID 不會變動, 就算服務重啟也是
# (但它到底能幹嘛阿.... 沒辦法用來 create cluster 阿....)
# 若在 Container, 服務重啟依舊不變, 若把 Container 移除後重建, 此 ID 會改變
```

若使用 redis5+, 可透過 `redis-cli` 來建立 Cluster, 但若 3 or 4, 則必須使用 ruby 寫的外掛工具: `redis-trib.rb`, 遇到再來研究了

```bash
redis-cli --cluster create \
    127.0.0.1:7000 \
    127.0.0.1:7001 \
    127.0.0.1:7002 \
    127.0.0.1:7003 \
    127.0.0.1:7004 \
    127.0.0.1:7005 \
    --cluster-replicas 1
```

## Creating the cluster


## Creating a Redis Cluster using the create-cluster script


## Playing with the cluster


## Resharding the cluster


## A more interesting example application


## Manual failover


## Adding a new node


## Adding a new node as a replica


## Removing a node


## Replicas migration


## Upgrading nodes in a Redis Cluster


## Migrating to Redis Cluster


# [Redis cluster tutorial](https://redis.io/topics/cluster-tutorial)

## Redis Cluster TCP ports

- *Redis Cluster* 同時需要有 2 個 ports:
    - Client port, 6379, 正規的 Redis TCP port
    - Cluster port, 16379, 端點之間作為 communication channel 的 binary proocol, 供 Cluster bus 使用
        - cluster bus 使用了 binary protocol 作為 nodes 之間的資料交換, 有助於減少 資料帶寬 及 處理時間


## Redis Cluster and Docker

(嚴重懷疑這部分文檔是不是已經過時了)

- 官網寫說不支援 NAT 及 需要做 IP/Port remapped 的環境, 但我們是可以正常使用的
- 此外, 官方建議使用 `host` networking mode


## Redis Cluster data sharding

- Redis Cluster 的機制使用的是, 概念上來說, 每個 key 都是 我們稱之為 `hash slot` 的一部份. (並不使用 `consistent hashing`)
- There are `16384 hash slots` in Redis Cluster, 為了要計算給定密鑰的 hash slot, 需要 take the CRC16 of the key modulo 16384.
- 每個 Redis Cluster Node 負責了 a subset of the hash slots, 因此可能會像底下這樣:
    - Node A 包含了 0 - 5500 的 hash slots
    - Node B 包含了 5501 - 11000 的 hash slots
    - Node C 包含了 11001 - 16383 的 hash slots

> Redis Cluster supports multiple key operations as long as all the keys involved into a single command execution (or whole transaction, or Lua script execution) all belong to the same hash slot. The user can force multiple keys to be part of the same hash slot by using a concept called hash tags. 
> Hash tags are documented in the Redis Cluster specification, but the gist is that if there is a substring between {} brackets in a key, only what is inside the string is hashed, so for example this{foo}key and another{foo}key are guaranteed to be in the same hash slot, and can be used together in a command with multiple keys as arguments.


## Redis Cluster master-slave model

為了提升 Cluster 的可用性, Redis Cluster 使用了 master-slave model, 來讓每個 `hash slot` 有 1~N 個 replicas


## Redis Cluster consistency guarantees

- *Redis Cluster* 無法保證 *strong consistency*
    - 因為 Redis Cluster 使用了 `asynchronous replication`, replication 流程如下:
        - Client 寫資料到 *master B*
        - *master B* 回應 client OK
        - *master B* propagates the write to slaves
    - performance 及 consistency 兩者之間得自行作權衡
- *Redis Cluster* 引入了 `WAIT`, 提供了 `synchronous writes`
    - 但也無法保證能達到 *strong consistency*
        - 因為有可能其中一個沒有作到 write 的 slave 晉升成為了 master

> 三主三從: A, B, C, A1, B1, C1. 以及一個 Client Z1
> After a partition occurs, 有可能將他們區分成: A, C, A1, B1, C1 ;另一邊則為: B, Z1
> 若此時發生 足夠時間的延遲, 使得 B1 被推選為 master, 則 Z1 寫入到 B 的資料將會被丟失
> Z1 能夠發送給 B 的寫入量, 有個 `maximum window`: 若發生了足夠時間的延遲, 多數方推舉出新的 master, 則此時少數方的 master 將會停止接受寫入
> 這個至關重要的時間, Redis Cluster 在配置時稱之為 `node timeout`. 若超過這時間, master 將被視為 failing


# Redis Cluster configuration parameters

# Creating and using a Redis Cluster


## Creating the cluster

## Creating a Redis Cluster using the create-cluster script

## Playing with the cluster

## Writing an example app with redis-rb-cluster

## Resharding the cluster

## Scripting a resharding operation

## A more interesting example application

## Testing the failover

## Manual failover

## Adding a new node

## Adding a new node as a replica

## Removing a node

## Replicas migration

## Upgrading nodes in a Redis Cluster


## Migrating to Redis Cluster