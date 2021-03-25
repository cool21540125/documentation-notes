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