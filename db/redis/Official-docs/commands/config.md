[Redis configuration](https://redis.io/topics/config)

- [Redis 6.0 - conf](https://raw.githubusercontent.com/redis/redis/6.0/redis.conf)
- [Redis 5.0 - conf](https://raw.githubusercontent.com/redis/redis/5.0/redis.conf)
- [Redis 4.0 - conf](https://raw.githubusercontent.com/redis/redis/4.0/redis.conf)
- [Redis 3.2 - conf](https://raw.githubusercontent.com/redis/redis/3.2/redis.conf)

------------------------------

- Redis runtime, 可以藉由 `CONFIG SET` 來做動態組態調整, 但建議在配置檔裡面禁用
- Redis 2.8+, 也可使用 `CONFIG REWRITE`, 可把目前 runtime 的配置, 寫回到 redis.conf

如果純粹想拿 Redis 用來作為 cache, 則建議可使用像是以下配置:

```bash
maxmemory 2mb
maxmemory-policy allkeys-lru
```

這種情況下, 並不需要使用像是 `EXPIRE` 的指令來讓 key 到期自動消滅.

只要 Redis 答到 2MB 的內存限制, 就會使用 *approximated LRU algorithm* 來 evicte(驅逐) 所有的 keys