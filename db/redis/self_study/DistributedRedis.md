- [Creating Redis Cluster](https://iamvishalkhare.medium.com/create-a-redis-cluster-faa89c5a6bb4)
- [Horizontal scaling in/out techniques for redis cluster](https://iamvishalkhare.medium.com/horizontal-scaling-in-out-techniques-for-redis-cluster-dcd75c696c86)
- [Connecting to redis cluster using Java/Python clients](https://iamvishalkhare.medium.com/connecting-to-redis-cluster-using-java-python-clients-a7c4fa8a4a17)

有 2 種方式可用來建置 分散是的 Redis:

- Redis Sentinel: 若速度並非主要考量, 此方案是個不錯的小型 HA 方案
- Redis Cluster: 提供了 HA + Clustering 解決方案


比較簡單的方式可透過 `create-cluster` 來建立 Redis Cluster

底下示範較為手動的方式:

```conf
### redis.conf
port 6001
# ↓ 使用了 Cluster Mode
cluster-enabled yes
# ↓ 不應該人為操作(Cluster 自動產生)
cluster-config-file nodes.conf
# ↓ 每隔多久產生上述的 cluster-config-file
cluster-node-timeout 5000
appendonly yes
```

```bash
./redis-server redis.conf
```

每個 Node members 之間, 是透過 ID 來作識別, 而非 IP, Port. 此 ID 稱為 **Node ID**

```bash
./redis-cli --cluster create \
    127.0.0.1:6001 \
    127.0.0.1:6002 \
    127.0.0.1:6003 \
    127.0.0.1:6004 \
    127.0.0.1:6005 \
    127.0.0.1:6006 \
    --cluster-replicas 1
```

`--cluster-replicas 1` 聲明了 每個 Master 需要 1 個 Slave

```bash
### 登入 Cluster
./redis-cli -c -p PORT
#-c: 使用 cluster mode
```


# Scaling

```bash
### 加入一個新的 Master Node 到 Cluster
./redis-cli --cluster add-node 127.0.0.1:6007 127.0.0.1:6001
# 第一個 IP:Port 為 新加入的節點
# 第二個 IP:Port 為 原 Cluster 隨意一個 Node

./redis-cli --cluster check 127.0.0.1:6379
```

Redis Cluster 加入 Node 以後, 需要執行 resharding

resharding 意味著, 要從一堆 Nodes 移動 *hash slots* 到 另一堆 Nodes

```bash
./redis-cli --cluster reshard 127.0.0.1:6001
```



# Connecting to redis cluster using Python

```bash
pip install redis-py-cluster
```

```py
from rediscluster import RedisCluster

startup_nodes = [{"host": "127.0.0.1", "port": "6001"}]

# py3, decode_responses=True
rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True)

rc.set("foo", "bar")
```