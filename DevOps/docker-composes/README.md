
https://github.com/docker/awesome-compose



```yml
version: '3'

services:
    service1:
        extra_hosts:
            - "host1:172.16.33.101"
            - "host2:172.16.33.102"
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost"]
            interval: 1m30s
            timeout: 10s
            retries: 3
            start_period: 40s
```


## [healthcheck](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)

用來檢測 Container 的健康狀況

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 1m30s      # 每隔多久做一次連通測試, default: 30s
  timeout: 10s         # 幾秒鐘偵測不到視為 unhealthy, default: 30s
  retries: 3           # 失敗重啟的次數, default: 3
  start_period: 40s    # 容器啟動後 40 秒開始偵測, default: 0s
  #disable: true       # 此配置用來關閉繼承 Docker Image 預設的測試
```

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
