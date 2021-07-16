[CLUSTER NODES](https://redis.io/commands/cluster-nodes)

> Since 3.0.0

時間複雜度為 `O(N)`, N 為 Cluster Nodes 數量

> cluster nodes
```bash
$# redis-cli -c cluster nodes
9fa29418d431174b8a8531ad2adc1a6b69dba418 172.16.30.14:6379@16379 myself,slave 56990b4007de9f22a5b8351f8728d9d27bff1a61 0 1622628972000 7 connected
98f79553015ff3eae2d1cc8051b4c8a4370c1d5f 172.16.30.14:6380@16380 master - 0 1622628973000 8 connected 5461-10922
1b9a7af82e4c5229d98582ec1cae89eaa1661833 172.16.30.13:6380@16380 slave b1b855a130e32787e881fdd3a72ded4a18aa1f76 0 1622628973000 1 connected
b1b855a130e32787e881fdd3a72ded4a18aa1f76 172.16.30.12:6379@16379 master - 0 1622628974393 1 connected 0-5460
56990b4007de9f22a5b8351f8728d9d27bff1a61 172.16.30.12:6380@16380 master - 0 1622628973590 7 connected 10923-16383
f00ece239d8607fac3ff63cded338e12d3c57cf7 172.16.30.13:6379@16379 slave 98f79553015ff3eae2d1cc8051b4c8a4370c1d5f 0 1622628973388 8 connected
##                                                                flags
## 每一行的組成方式為:
## <id> <ip:port@cport> <flags> <master> <ping-sent> <pong-recv> <config-epoch> <link-state> <slot> <slot> ... <slot>
## <flags> 使用「,」分隔的 list, 可能是這些: myself, master, slave, fail?, fail, handshake, noaddr, noflags
##   - fail?: 節點處於 PFAIL 狀態(並非 FAIL), 無法 contacting 該 Node, 但邏輯上可 reachable
##   - fail:  節點處於 FAIL  狀態. 由於多個節點無法訪問, 因而從 PAFIL 提升為 FAIL
##   - handshake: Untrusted node, we are handshaking.
##   - noaddr: No address known for this node.
```
