# [INFO](https://redis.io/commands/INFO)

```bash
# 查看 Server 相關資訊
redis-cli -c -p 7691 info server
redis-cli -c -p 7693 info server

# 
redis-cli -c -p 7691 info clients
redis-cli -c -p 7693 info clients

redis-cli -c -p 7691 info persistence
redis-cli -c -p 7693 info persistence

redis-cli -c -p 7691 info stats
redis-cli -c -p 7693 info stats

redis-cli -c -p 7691 info commandstats
redis-cli -c -p 7693 info commandstats

redis-cli -c -p 7691 info all > 7691
redis-cli -c -p 7693 info all > 7693





```