
# Redis Cluster INFO

- [redis INFO](https://redis.io/commands/INFO)

> info server
```bash
$# redis-cli -c info server
# Server
redis_version:6.0.10
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:1c3aed2f9fd88f03
redis_mode:cluster
os:Linux 5.4.94-1.el7.elrepo.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:8.3.0
process_id:1
run_id:24b6e860c7d85c2c745dfb40a7b462abeb2bb24d
tcp_port:6379
uptime_in_seconds:106425
uptime_in_days:1
hz:10
configured_hz:10
lru_clock:12007502
executable:/data/redis-server
config_file:/etc/redis.conf
io_threads_active:0
```

> info clients
```bash
$# redis-cli -c info clients
# Clients
connected_clients:3
client_recent_max_input_buffer:8
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
```

> info memory
```bash
$# redis-cli -c info memory
# Memory
used_memory:3578976
used_memory_human:3.41M
used_memory_rss:20115456
used_memory_rss_human:19.18M
used_memory_peak:3619944
used_memory_peak_human:3.45M
used_memory_peak_perc:98.87%
used_memory_overhead:2621528
used_memory_startup:1474952
used_memory_dataset:957448
used_memory_dataset_perc:45.51%
allocator_allocated:3661592
allocator_active:4059136
allocator_resident:6463488
total_system_memory:4129058816
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
mem_fragmentation_ratio:5.65
mem_fragmentation_bytes:16557504
mem_not_counted_for_evict:2406
mem_replication_backlog:1048576
mem_clients_slaves:20512
mem_clients_normal:41016
mem_aof_buffer:2560
mem_allocator:jemalloc-5.1.0
active_defrag_running:0
lazyfree_pending_objects:0
```

> info persistence
```bash
$# redis-cli -c info persistence
# Persistence
loading:0
rdb_changes_since_last_save:5
rdb_bgsave_in_progress:0
rdb_last_save_time:1622513815
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:2560000
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0
aof_current_size:19479588
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
total_connections_received:55
total_commands_processed:2667357
instantaneous_ops_per_sec:0
total_net_input_bytes:200489073
total_net_output_bytes:246494065
instantaneous_input_kbps:0.05
instantaneous_output_kbps:0.05
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
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
total_reads_processed:2667251
total_writes_processed:6034512
io_threaded_reads_processed:0
io_threaded_writes_processed:0
```

> info replication
```bash
### Master 範例
$# redis-cli -c info replication
# Replication
role:master         ## Node 為 master/slave
connected_slaves:1  ## 連到此 Master 的 replicas 數量 (slave 值為 0)
slave0:ip=172.16.30.13,port=6380,state=online,offset=153001,lag=1  # 此 Master 的 slave 是誰 (slave 無此 key)
master_replid:357c3750678266026e7977e3ca6aa79e76d5af67   ## Redis Server 的 `replication ID`
master_replid2:0000000000000000000000000000000000000000  ## (PSYNC 使用) failover 之後的 `secondary replication ID`
master_repl_offset:153001  ## The server's current replication offset
second_repl_offset:-1      ## The offset up to which replication IDs are accepted
repl_backlog_active:1      ## Flag indicating replication backlog is active
repl_backlog_size:1048576        ## Total size in bytes of the replication backlog buffer
repl_backlog_first_byte_offset:1 ## The master offset of the replication backlog buffer
repl_backlog_histlen:153001      ## Size in bytes of the data in the replication backlog buffer

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
used_cpu_sys:136.859269
used_cpu_user:115.160189
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
$# redis-cli -c info cluster
# Cluster
cluster_enabled:1
```

> info modules
```bash
### Redis6+ 才有 (此範例沒有任何外掛模組)
$# redis-cli -c info modules
# Modules
```

> info keyspace
```bash
$# redis-cli -c info keyspace
# Keyspace
db0:keys=643,expires=0,avg_ttl=0
```

> info errorstats
```bash
### 此範例目前沒東西
$# redis-cli -c info errorstats
```

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

> `client list [TYPE normal|master|replica|pubsub]`
```bash
$# redis-cli -c client list
id=4 addr=172.16.30.13:42061 fd=17 name= age=126690 idle=0 flags=S db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=replconf user=default
id=12 addr=172.16.30.8:41692 fd=21 name= age=25373 idle=22708 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20504 events=r cmd=del user=default
id=14 addr=172.16.30.9:53376 fd=22 name= age=25283 idle=25283 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=set user=default
id=53 addr=127.0.0.1:47476 fd=23 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=26 qbuf-free=32742 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default
```