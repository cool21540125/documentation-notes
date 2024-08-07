[INFO](https://redis.io/commands/info)


> info server
```bash
$# redis-cli -c info server
# Server
redis_version:6.0.10  ## RedisServer version
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:1c3aed2f9fd88f03
redis_mode:cluster  ## standalone / sentinel / cluster
os:Linux 5.4.94-1.el7.elrepo.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:8.3.0
process_id:1
run_id:24b6e860c7d85c2c745dfb40a7b462abeb2bb24d
tcp_port:6379             ## RedisServer 運行所在的 Port
uptime_in_seconds:106425  ## RedisServer 連續運作時間(秒)
uptime_in_days:1          ## RedisServer 連續運作天數
hz:10                     ## The server's current frequency setting (看不懂在說啥...)
configured_hz:10          ## The server's configured frequency setting (看不懂在說啥...)
lru_clock:12007502
executable:/data/redis-server  ## Server executable 路徑 (可能檔案被砍了, 因而將來找不到這檔按, 但查出來配置依舊)
config_file:/etc/redis.conf
io_threads_active:0
```

> info clients
```bash
$# redis-cli -c info clients
# Clients
connected_clients:3  ## 當前 Replicas 以外的 Redis Clients 連線數量
client_recent_max_input_buffer:8
client_recent_max_output_buffer:0
blocked_clients:0  ## Clients pending 的 blocking call (BLPOP, BRPOP, BRPOPLPUSH, BLMOVE, BZPOPMIN, BZPOPMAX) 數量
tracking_clients:0
clients_in_timeout_table:0
```

> info memory
```bash
$# redis-cli -c info memory
# Memory
used_memory:3578976
used_memory_human:3.41M  ## Redis 從 Allocator 獲配的內存大小
used_memory_rss:20115456
used_memory_rss_human:19.18M  ## OS 看到的, Redis 獲配的內存大小(即 `resident set size`). 結果同 top、ps 看到的大小
used_memory_peak:3619944  ## 
used_memory_peak_human:3.45M
used_memory_peak_perc:98.87%
used_memory_overhead:2621528
used_memory_startup:1474952
used_memory_dataset:957448
used_memory_dataset_perc:45.51%
allocator_allocated:3661592
allocator_active:4059136
allocator_resident:6463488
total_system_memory:4129058816  ## Redis Host 所擁有的記憶體總數
total_system_memory_human:3.85G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.11
allocator_frag_bytes:397544
allocator_rss_ratio:1.59
allocator_rss_bytes:2404352
rss_overhead_ratio:3.11
rss_overhead_bytes:13651968
mem_fragmentation_ratio:5.65  ## `used_memory_rss / used_memory` 的比率. 正常來說此值應略大於1. 若過高, 存在記憶體碎片化. 若過低, 表示 OS 收回了部分內存, 會出現明顯 lag
mem_fragmentation_bytes:16557504
mem_not_counted_for_evict:2406
mem_replication_backlog:1048576
mem_clients_slaves:20512
mem_clients_normal:41016
mem_aof_buffer:2560
mem_allocator:jemalloc-5.1.0  ## (編譯安裝時選擇的)Memory allocator
active_defrag_running:0
lazyfree_pending_objects:0
```

> info persistence
```bash
$# redis-cli -c info persistence
# Persistence
loading:0  ## 1 or 0, 用來判斷是否正在 loading dump file
rdb_changes_since_last_save:5
rdb_bgsave_in_progress:0  ## 1 or 0, 用來判斷是否正在執行 RDB save
rdb_last_save_time:1622513815  ## 最近一次 RDB save 成功的 Timestamp
rdb_last_bgsave_status:ok  ## 最近一次 RDB save 的操作狀態
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:2560000
aof_enabled:1  ## AOF logging 是否有被啟用
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0
aof_current_size:19479588  ## AOF 目前的檔案大小
aof_base_size:19475925
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0
```

> info stats
```bash
$# redis-cli -c info stats
# Stats
total_connections_received:55  ## 被 RedisServer 接受的連線總數
total_commands_processed:2667357  ## RedisServer 處理的 commands 數量
instantaneous_ops_per_sec:0  ## 每秒執行的命令數
total_net_input_bytes:200489073  ## Read from Network 的 bytes
total_net_output_bytes:246494065  ## Write to Network 的 bytes
instantaneous_input_kbps:0.05  ## Read from Network 的 KB/sec
instantaneous_output_kbps:0.05  ## Write to Network 的 KB/sec
rejected_connections:0  ## 因 maxclients limit 而被拒絕的連線數
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0  ## 觸發 key expiration 的事件總數
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:0
evicted_keys:0
keyspace_hits:0  ## 在 main dictionary 裏頭, 成功找到 key 的次數
keyspace_misses:0  ## 在 main dictionary 裏頭, 找不到 keys(查無此 key) 的次數
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:2353
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_reads_processed:2667251  ## 已被處理的 read event 總數
total_writes_processed:6034512  ## 已被處理的 write event 總數
io_threaded_reads_processed:0  ## main && I/O threads 處理的 read event 總數 
io_threaded_writes_processed:0  ## main && I/O threads 處理的 write event 總數
```

> info replication
```bash
### Master 範例
$# redis-cli -c info replication
# Replication
role:master         ## Node 為 master/slave
connected_slaves:1  ## 此 Master 的 replicas 數量 (slave 值為 0)
slave0:ip=172.16.30.13,port=6380,state=online,offset=153001,lag=1  # 此 Master 的 slave 是誰 (slave 無此 key)
master_replid:357c3750678266026e7977e3ca6aa79e76d5af67  ## Redis Server 的 `replication ID`
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:153001  ## RedisServer 目前的 replication offset
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576        ## Replication backlog buffer 的大小(bytes)
repl_backlog_first_byte_offset:1
repl_backlog_histlen:153001

### Slave 範例
$# redis-cli -c info replication
# Replication
role:slave          ## Node 為 master/slave(若此為 slave, 則可能它會是另一個 chained replication 的 master)
master_host:172.16.30.14  ## Master 位置
master_port:6380          ## Master 位置
master_link_status:up         ## 與 Master 連接狀態 (up/down)
master_last_io_seconds_ago:0  ## 自前與 Master 互動後的經過秒數
master_sync_in_progress:0     ## Indicate the master is syncing to the replica
slave_repl_offset:4675213
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:2c9557c38d080b27d8a1fdc850192151b67fd9e9
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:4675213
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:3626638
repl_backlog_histlen:1048576
```

> info cpu
```bash
$# redis-cli -c info cpu
# CPU
used_cpu_sys:136.859269   ## System mode 消耗 CPU 的累積秒數
used_cpu_user:115.160189  ## User mode 消耗 CPU 的累積秒數
used_cpu_sys_children:0.007441
used_cpu_user_children:0.006229
```

> info commandstats
```bash
$# redis-cli -c info commandstats
# Commandstats
cmdstat_replconf:calls=106465,usec=207493,usec_per_call=1.95
cmdstat_cluster:calls=8,usec=963,usec_per_call=120.38
cmdstat_psync:calls=1,usec=1248,usec_per_call=1248.00
cmdstat_get:calls=1,usec=4,usec_per_call=4.00
cmdstat_set:calls=4,usec=93,usec_per_call=23.25
cmdstat_ping:calls=1,usec=1,usec_per_call=1.00
cmdstat_del:calls=1,usec=8,usec_per_call=8.00
cmdstat_info:calls=26,usec=1474,usec_per_call=56.69
cmdstat_command:calls=2,usec=1589,usec_per_call=794.50
cmdstat_client:calls=3,usec=8,usec_per_call=2.67
```

> info cluster
```bash


### (這比較詳細)
$# redis-cli cluster info
# 很神奇的是, 這兩個指令看起來 87% 相似
```


# [CLUSTER INFO](https://redis.io/commands/cluster-info)

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


> info modules
```bash
### Redis6+ 才有 (此範例沒有任何外掛模組)
$# redis-cli -c info modules
# Modules
```

> info keyspace (Redis 2.8.0+)
```bash
$# redis-cli -c info keyspace
# Keyspace - DB 的相關統計. (Note: Redis 預設有 15 個 DB)
db0:keys=643,expires=0,avg_ttl=0
```

> info modules
```bash
$# redis-cli info modules

```

> info errorstats
```bash
### 此範例目前沒東西
$# redis-cli -c info errorstats
errorstat_ERR:count=13951
errorstat_WRONGTYPE:count=4422
```



# [Client List](https://redis.io/commands/client-list)

> 2.4.0+
> 
> `client list [TYPE normal|master|replica|pubsub]`

```bash
$# redis-cli -c client list
id=4 addr=172.16.30.13:42061 fd=17 name= age=126690 idle=0 flags=S db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=replconf user=default
id=12 addr=172.16.30.8:41692 fd=21 name= age=25373 idle=22708 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20504 events=r cmd=del user=default
id=14 addr=172.16.30.9:53376 fd=22 name= age=25283 idle=25283 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=set user=default
id=53 addr=127.0.0.1:47476 fd=23 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=26 qbuf-free=32742 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default
# addr: Redis Client 的 host:port
# age: 此連線的 total duration (秒)
# name: Client 的 CLIENT SETNAME (基本上它就是 connection name 啦)
# idle: 此連線的 idle time (秒)
# qbuf: query buffer length (0 表示 「無 pending」 的查詢)
# qbuf-free: free space of the query buffer (0 表示 buffer 已滿)
# cmd: 最近一次執行的動作
```


# [CLUSTER NODES](https://redis.io/commands/cluster-nodes)

> Since 3.0.0
> 
> 時間複雜度為 `O(N)`, N 為 Cluster Nodes 數量
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


# [CONFIG GET parameter](https://redis.io/commands/config-get)

> Since 2.0.0+

- 可使用 `CONFIG GET` 來取得 RedisServer running config.
    - 直到 v2.6+, 才支援用此指令獲取全部配置(舊版本會有些配置無法用此方式取得)
    - 相對的, 可使用 `CONFIG SET` 來作動態配置
- CONFIG GET takes a single argument, which is a glob-style pattern.
- 

```bash
### config get 用起來像這樣
redis> config get *max-*-entries*
1) "hash-max-zipmap-entries"
2) "512"
3) "list-max-ziplist-entries"
4) "512"
5) "set-max-intset-entries"
6) "512"
```

而如果像是:

```conf
save 900 1
save 300 10
# dataset 變更 1 次,  900 秒後作 save
#   &&
# dataset 變更 10 次, 300 秒後作 save
```

則, `config get save` 會得到 **"900 1 300 10"**


## Security 方面

WARNING: redis 官方建議, 禁止遠端使用 config 命令, [參考這邊](https://redis.io/topics/security#disabling-of-specific-commands)

可在配置檔裡頭, 顯示的將此指令 DISABLE

```conf
rename-command CONFIG ""
```
