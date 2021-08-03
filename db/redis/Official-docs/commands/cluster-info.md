[CLUSTER INFO](https://redis.io/commands/cluster-info)

> 3.0.0+

```bash
$# redis-cli cluster info
cluster_state:ok  ## ok: 表示該節點可接受 query; fail: 表示有 slot 未被綁定到 node, 處於錯誤狀態、多數 masters 無法訪問此 node
cluster_slots_assigned:16384  ## 
cluster_slots_ok:16384  ## Slot 非為 FAIL 或 PFAIL 的數量
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6  ## 已加入 Cluster 的數量(包含 HANDSHAKE 的狀態)
cluster_size:3
cluster_current_epoch:6  ## The local Current Epoch variable. This is used in order to create unique increasing version numbers during fail overs.
cluster_my_epoch:2  ## The Config Epoch of the node we are talking with. This is the current configuration version assigned to this node.
cluster_stats_messages_sent:1483972
cluster_stats_messages_received:1483968
```