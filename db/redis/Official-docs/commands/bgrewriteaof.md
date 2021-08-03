[BGREWRITEAOF](https://redis.io/commands/bgrewriteaof)

Redis2.4+, AOF rewrite 會被 Redis 自動觸發執行. 而此指令 `BGREWRITEAOF` 可用於任何時候手動執行

用來執行 AOF rewrite process. rewrite 會對當前 AOF 用最佳化的方式重寫一份

若此指令執行失敗, 不會發生任何資料的遺失. 舊有的 AOF 將維持不變 (執行下去就對了, 不要怕)

- 如果當下正在執行 snapshot, 則執行 `bgrewriteaof` 會被排程到 saving to RDB file 完成後
    - 但執行 `BGREWRITEAOF` 當下, 一樣會先看到正面的回應訊息
    - 可使用 `INFO Persistence` 來查詢 AOF 及 RDB 的執行狀況
- 如果執行 `BGREWRITEAOF` 的當下, 