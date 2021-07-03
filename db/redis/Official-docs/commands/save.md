[save](https://redis.io/commands/save)

> The SAVE commands performs a synchronous save of the dataset producing a point in time snapshot of all the data inside the Redis instance, in the form of an RDB file.

將目前 Redis 的所有資料, 作一份 snapshot, 並將之寫入到 RDB file

IMPORTANT: `save` 執行下去以後, 會 BLOCK 所有的 clients.

因為 `save` 會 block all clients, 所已取代的做法可參考 `bgsave`.

WARNING: 如果有去設定 避免 Redis 去建立 background saving child, 則會發生 fork system call 的錯誤.

若 `save` 正常運行以後, 最終可以看到 `OK` 的回傳結果