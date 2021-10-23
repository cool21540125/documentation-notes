# Docker Logging

- [Configure logging drivers](https://docs.docker.com/config/containers/logging/configure/)
- [How to clear the logs properly for a Docker container?](https://stackoverflow.com/questions/42510002/how-to-clear-the-logs-properly-for-a-docker-container)
- 2021/01/25

關於 docker logging, 預設為 `json-file` **logging driver** (若後續要接其他像是 logstash 等等需要用到 log parse 的軟體的話, 這是推薦的方式)

若無, 可自行配置 docker daemon 採用 `local` **logging driver** (因為是 binary, 有效率 && 節省空間 && 預設會採用 log-rotation)

- 可供選擇的 [Supported logging drivers](https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers)
  - [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/)
  - [Local File logging driver](https://docs.docker.com/config/containers/logging/local/)
  - 若要串接 Logstash, 可參考 [Graylog Extended Format logging driver](https://docs.docker.com/config/containers/logging/gelf/)
  - 串接 AWS, 可參考 [Amazon CloudWatch Logs logging driver](https://docs.docker.com/config/containers/logging/awslogs/)
  - 串接 GCP, 可參考 [Google Cloud Logging driver](https://docs.docker.com/config/containers/logging/gcplogs/)
  - 若覺得不夠用的話, 可參考 [Use a logging driver plugin](https://docs.docker.com/config/containers/logging/plugins/)

```js
// docker daemon config
{
    "log-driver": "local",
}
```

```js
// docker daemon config
{
  "log-driver": "json-file",  // default is json-file
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer",
    // Logging mode
    "mode": "non-blocking",  // default is blocking
    "max-buffer-size": "4m",  // default is 1m
  }
}
```

IMPORTANT: 以運行的 Container, 並不會套用新的配置, 此配置只會套用到新的 Container

NOTE: 改完 docker daemon config, 記得重啟: `systemctl restart docker`

此外, 也可在 Runtime 期間, 個別指定 loggin driver

> docker run -it `--log-driver <DriverType>` container


## Log messages from container to log driver

Container 把 log 交付給 log driver, 有 2 種方式:

- (default)direct, blocking delivery from container to driver
- non-blocking delivery : 把 log 儲存在 *per-container ring buffer*, 以供 driver consumption
  - 優點: 可防止因 *logging back pressure* 導致的 App blocking. 當 STDERR 或 STDOUT streams block 的時候, 可能導致 App 意外終止.
  - 需注意: 但如果交付 log 的 buffer 滿了的話, 最舊的 log 會被丟棄. (但此方式比 blocking log writing 還要可取)

> docker run -it `--log-opt mode=non-blocking max-buffer-size=4m` container


## 版本問題

- Docker Engine 19.03(含) 以前, `docker logs` 僅能作用於:
  - `local`
  - `json-file`
  - `journald`
- Docker Engine 20.10, 追加了:
  - `dual logging`