[EXPIRE key seconds](https://redis.io/commands/expire)

> Set a timeout on key. After the timeout has expired, the key will automatically be deleted. A key with an associated timeout is often said to be volatile in Redis terminology.

- `timeout` 只會被 `DEL`, `SET`, `GETSET`, `*STORE` commands 給清除