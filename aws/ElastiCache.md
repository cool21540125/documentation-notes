
# ElastiCache - Redis

- 分成 2 種模式:
    - Redis Replication (with cluster disabled)
        - Nodes(or Cache):
            - Primary Node : 1 個. 用來做讀寫
            - Replica Nodes : 0~5 個. 用來作 Read 及 Secondary(等 Primary 掛了來繼位)
        - 這樣子的一整組 Redis, 稱之為一個 Shard, 每個 Shard 都有一份完整的 data
        - Scaling 方面, 可作:
            - Horizontal Scaling
            - Vertical Scaling
                - 底層會使用新的 Node Group, 因此須又修改 Connection Endpoint
    - Redis Cluster (with cluster enabled)
        - data partitioned across shards
        - 如果是這種模式的話, 則可配置 ASG
            - 但只有支援 **Target Tracking Policies** 及 **Scheduled Scaling Policies**
            - scaling & monitoring 指標:
                - `CPUUtilization`
                - `SwapUsage`
                - `FreeableMemory`
                - `ElastiCachePrimaryEngineCPUUtilization`
                - `DatabaseMemoryUsagePercentage`
                - `CurrConnections`
        - 基本上同 Redis Replication, 不過可以將 0~65535 的 Slots 交給不同的 Shards 做儲存
            - 每個 Shard 裏頭, 一樣可以有多個 Nodes
        - Redis Cluster 最多可以有 500 Nodes
            - if Replicas=0, 則可有 500 Shards
                - 因為一個 Shard 裏頭, 只有 1 Master
            - if Replicas=1, 則可有 250 Shards
                - 因為一個 Shard 裏頭, 包含 1 Master + 1 Slave
            - if Replicas=5, 則可有 83 Shards
                - 因為一個 Shard 裏頭, 包含 1 Master + 5 Slaves


# ElastiCache - Memcached

- 這東西沒有 backup 機制...

用到再來學=.=
