[bgsave](https://redis.io/commands/bgsave)

> Save the DB in background.

執行後, 基本上會馬上看到 "OK" 字樣. 然後開始執行背景備份作頁. 但若目前已有其他進程正在執行備份, 則會拿到 error

如果使用 背景正在執行 *AOF rewrite*, `BGSAVE SCHEDULE`, 則也會馬上看到 "OK", 並於適當時間自動執行

Redis Client 可使用 `lastsave` 來查詢運行結果

> v3.2.2+ 增加了 SCHEDULE option.
