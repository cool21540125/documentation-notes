

```bash
### 
redis-cli

redis-cli -p 6001

redis-cli --cluster create \
    172.17.91.92:6001 \
    172.17.91.92:6002 \
    172.17.91.92:6003 \
    172.17.91.92:6004 \
    172.17.91.92:6005 \
    172.17.91.92:6006 \
--cluster-replicas 1
```


```bash

redis-cli -a 883K6Ec@N=pkbD9k --cluster check 127.0.0.1:6379

redis-cli -c
# -c, --cluster

AUTH 883K6Ec@N=pkbD9k

cluster nodes

cluster info
```

