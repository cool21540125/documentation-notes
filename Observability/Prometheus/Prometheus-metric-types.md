# Metric

- Prometheus 有 4 種 core metric types, 而這些 metric types,
  - 對於 client 才有區分意義
    - 而像是 `rate` 或是 `histogram_quantile` 等等特定的 `PromQL functions`, 僅能接受特定 metric types
      - 也就是說, 餵錯參數類型的話會噴錯
  - 對於 TSDB, 也就是 prometheus server, 則都是 timeseries data type (沒有區分意義)

## Counter

- 嚴格遞增的數據
- 基本上, 如果 Metric 是 `_total` 結尾的話, 那這個 Metric 的 data type 就是 counter
- ex: `http_requests_total{method="GET"}` = 1000
- 常見 PromQL Functions:
  - `rate(xxx_yyy_count[5m])`
    - `rate` 僅適用於計算 Counter 的變動 (無法適用於其餘 Metric Types)

## Gauge

- 隨時間變化的數據
  - ex: `server_cpu_usage_percent` = 75.5
  - ex: `prometheus_build_info` = 1
- 常見 PromQL Functions:
  - `max_over_time`
  - `min_over_time`
  - `avg_over_time`

## Histogram

- ex: `http_request_duration_seconds_bucket{le="0.5"}` = 800 (延遲時間 < 0.5 secs 的請求數)
- histogram 有個 _base metric name_, 具備底下一系列的 time series during a scrap:
  - cumulative counters : `<basename>_bucket{le"<upper inclusive bound>"}`
  - total sum : `<basename>_sum`
  - count of events : `<basename>_count` (等同於 `<basename>_bucket{le="+Inf"}`)
- 常見 PromQL Functions examples:
  - `http_request_duration_seconds_bucket{le="0.3"}`
- metric for `<histogramName>_count` 等同於 `<histogramName>_bucket{le="+Inf"}`, 此外, `<histogramName>_sum` metric 為 sum(all observed values)

## Summary

- ex: `http_request_duration_seconds{quantile="0.95"}` = 0.9 (95% 請求的延遲)
- summary 為 App Level 釋出的 metric (因此如果有 distributed instances 的話, 無法做出 summary 指標)
- summary 的特色之一是, 會針對 metric 的 label 給定 分位數(quantile)
  - 可用來判斷一段時間內, 特定指標的分佈狀況
  - 使用此類指標時, 無需耗用額外的 Prometheus Server Side 資源 (App Level 直接釋出 metrics)
  - streaming N-quantiles : `<basename>{quantile="N"}`
  - total sum : `<basename>_sum`
  - count of events : `<basename>_count`
- Summary 類型指標一般只適用於 獨立的監控指標
  - 不能再取得平均數 or 連結其他指標
- 常見 PromQL Functions examples:
  - ex: `prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.5"}`

# Time Series

- ex: `node_cpu_seconds_total` 是個 Metric
- ex: `node_cpu_seconds_total{cpu="0",instance="serverA"}` 是個 `TimeSeries`
