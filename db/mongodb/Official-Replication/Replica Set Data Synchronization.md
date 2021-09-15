# [Replica Set Data Synchronization](https://docs.mongodb.com/v4.4/core/replica-set-sync/)

> In order to maintain up-to-date copies of the shared data set, secondary members of a replica set sync or replicate data from other members. MongoDB uses two forms of data synchronization: initial sync to populate new members with the full data set, and replication to apply ongoing changes to the entire data set.

- ReplicatSet 的 SECONDARY 會去跟其它 member 作: `sync data` OR `replicate data`
- MongoDB 使用 2 種 data synchronization 方式:
    - 對於新加入成員, 使用 initial sync
    - 對於已存在成員, 對於整個 data set, 採用 replication


