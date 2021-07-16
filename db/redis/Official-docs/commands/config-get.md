[CONFIG GET parameter](https://redis.io/commands/config-get)

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


# Security 方面

redis 官方建議, 禁止遠端使用 config 命令, [參考這邊](https://redis.io/topics/security#disabling-of-specific-commands)

可在配置檔裡頭, 顯示的將此指令 DISABLE

```conf
rename-command CONFIG ""
```