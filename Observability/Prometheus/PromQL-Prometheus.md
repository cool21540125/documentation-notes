# PromQL

- PromQL expression 查詢以後的查詢結果, 只會有底下這些的 types:
  - instant vector
    - ex: `http_requests_total{job="api"}`, 則可得到底下這些:
      - `http_requests_total{job="api", instance="server1"} 150`
      - `http_requests_total{job="api", instance="server2"} 200`
  - range vector
    - ex: `http_requests_total{job="api"}[5m]`, 則可得到底下這些:
      - `http_requests_total{job="api", instance="server1"} [150@15:00, 151@15:01, 152@15:02]`
      - `http_requests_total{job="api", instance="server2"} [200@15:00, 201@15:01, 202@15:02]`
    - range vector 可用的 units for a duration:
      - ms / s / m / h / d / w / y
    - `range vector` 與 `instant vector` 最直觀的差異在於, 是否有 `[]`
  - scalar
  - string (至今似乎還未採用, 僅保留)

# Useful

```
// 取得前 30 大的 Timeseries metric (衡量 Cost)
topk(30, count by (__name__, job)({__name__=~".+"}))

// 
```

# Prometheus itself

- `prometheus_sd_http_failures_total` : Prometheus 會去紀錄 main config 裡頭的 targets(並快取), 將來如果 targets list 出問題, 此指摽就會 ++
- `up{job="JOB_NAME"}` : 是否有探測到 JOB_NAME
- `prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.5"}` :
- `prometheus_engine_query_log_enabled` : Prometheus 是否紀錄到 query_log_file
- `prometheus_http_request_duration_seconds_bucket{handler="/metrics"}` : 對於特定 endpoint 的 request time span
- `histogram_quantile(0.9, prometheus_http_request_duration_seconds_bucket{handler="/graph"})` : 前 90% 用戶的 請求響應時間
- `histogram_quantile(0.9, rate(prometheus_http_request_duration_seconds_bucket{handler="/graph"}[5m]))` : 過去 5 分鐘, 前 90% 用戶的 avg 請求響應時間

# Node Exporter

https://github.com/prometheus/node_exporter

- `rate(node_cpu_seconds_total{mode="system"}[1m])` : 過去 1 分鐘, 每秒平均 System Time CPU time 佔比
- `node_filesystem_avail_bytes` : FS available bytes
- `rate(node_network_receive_bytes_total[1m])` : 過去 1 分鐘, 每秒平均 Network receive bytes
- `go_gc_duration_seconds{quantile="0.25"}` : GC 前 25% 呼叫的 summary

# cAdvisor

https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md

- `sum(rate(container_cpu_usage_seconds_total[1m])) BY (instance, name)` : 過去 1 分鐘, avg CPU usage per container (幾乎等同於 docker stats)
- `container_memory_working_set_bytes{name!=""}/1024^2` : Container 對於 Memory 的使用量 (幾乎等同於 docker stats) (MiB)
- `machine_memory_bytes/1024^2` : docker host total memory MiB
- `container_memory_working_set_bytes{name!=""}/machine_memory_bytes`
- `rate(container_cpu_usage_seconds_total{name!=""}[1m])` : 過去 1 分鐘, per CPU usage
- `container_start_time_seconds{name!=""}` : container 啟動當下的 timestamp
- `rate(container_network_transmit_bytes_total[1m])` :
- `rate(container_network_receive_bytes_total[1m])` :
- `container_memory_usage_bytes{name!=""}` : Memory 當下用量 (bytes)

---

- `container_memory_usage_bytes = container_memory_rss + container_memory_cache + container_memory_kernel_usage`
  - container_memory_rss 排除了 cache (結果比較貼近 `docker stats` 看到的 Memory 消耗)
- `container_memory_working_set_bytes = container_memory_usage_bytes - total_inactive_file` (這啥?)
