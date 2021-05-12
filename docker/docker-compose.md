docker-compose.yml



## [healthcheck](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)

用來檢測 Container 的健康狀況

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 1m30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

- `interval`, `timeout`, `start_period` 被指定為 持續時間
- `test` directive 必須是 String 或 List
  - 若為 List, 第一個項目必須是 `NONE`, `CMD`, `CMD-SHELL`
  - 若為 String, 則等價於指定為 `CMD-SHELL`
    - `CMD-SHELL` 使用的是 `/bin/sh`


## [volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes)

compose v3+, 使用 `volumes` 取代了舊版的 `volumes_from`

- Short Syntax, `[SOURCE:]TARGET[:MODE]`
  - SOURCE, 可以是 *host path* 或 *volume name*
  - MODE, 預設為 `rw`. 也可改為 `ro`
- Long Syntax