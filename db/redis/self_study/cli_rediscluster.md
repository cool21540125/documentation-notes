
## Help

```bash
redis-cli help

redis-cli --help

redis-cli --cluster help
```


## Usage

```bash
### Create RedisCluster
redis-cli --cluster create \
   192.168.194.5:6381 \
   192.168.194.5:6382 \
   192.168.194.5:6383 \
   192.168.194.5:6384 \
   192.168.194.5:6385 \
   192.168.194.5:6386 \
   --cluster-replicas 1

### Add Node to Master
redis-cli -p 6381 --cluster \
   add-node 192.168.194.5:6391 \
   192.168.194.5:6383

### Add Node to Slave
redis-cli -p 6381 --cluster \
   add-node 192.168.194.5:6392 \
   192.168.194.5:6383 --cluster-slave
# 加入者放前, 已存在節點放後  ((把節點加入已存在的 RedisCluster))

### Remove Node
redis-cli -p 6381 --cluster \
   del-node 192.168.194.5:6392 \
   b107979c2658642642ec85eadd92ec30cee05ea8
# HOST:PORT NODE_ID  <- 其實都是指同一個 Redis Instance

### 查看 Cluster 資訊
redis-cli -c -p 6381 cluster info
redis-cli -c -p 6381 cluster nodes

### Check
docker exec jinli_redis6379 redis-cli -c cluster info         | grep 'cluster_my_epoch\|cluster_state'
docker exec jinli_redis6380 redis-cli -c -p 6380 cluster info | grep 'cluster_my_epoch\|cluster_state'
```


```bash
redis-cli -a 883K6Ec@N=pkbD9k --cluster check 127.0.0.1:6379

redis-cli -c
# -c, --cluster

AUTH 883K6Ec@N=pkbD9k

cluster nodes

cluster info


### create cluster
redis-cli --cluster create redis01:6001 redis02:6002 redis03:6003 redis04:6004 redis05:6005 redis06:6006 --cluster-replicas 1

### 建立 cluster 以後的檢查
redis-cli -h redis01 -p 6001 cluster nodes
```

