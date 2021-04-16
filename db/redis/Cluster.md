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