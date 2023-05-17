
### 須先確保主機所在網路, 該網段沒有在使用
docker network create --subnet 172.72.72.0/24 net_rediscluster

### 建立完成後的 join cluster
redis-cli --cluster create redis01:6001 redis02:6002 redis03:6003 redis04:6004 redis05:6005 redis06:6006 --cluster-replicas 1


### check
redis-cli -h redis01 -p 6001 cluster nodes