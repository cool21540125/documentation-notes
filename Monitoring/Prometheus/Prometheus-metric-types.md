在目前的 Prometheus 2.53 版當中, metric types 的概念只存在於 client, server 並無此概念


# Counter

- 只能夠 嚴格遞增 or 重設 的指標. 例如: *Total request count*
- 常見 PromQL Functions:
    - `rate(xxx_yyy_count[5m])`
        - `rate` 僅適用於計算 Counter 的變動 (無法適用於其餘 Metric Types)


# Gauge

- 隨著服務運行而變化(可增可減) 的指標, ex: CPU, Memory, Disk Usage, I/O, pods 數量, ...
- 常見 PromQL Functions:
    - `max_over_time`
    - `min_over_time`
    - `avg_over_time`


# Histogram

- histogram 有個 *base metric name*, 具備底下一系列的 time series during a scrap:
    - cumulative counters   : `<basename>_bucket{le"<upper inclusive bound>"}`
    - total sum             : `<basename>_sum`
    - count of events       : `<basename>_count` (等同於 `<basename>_bucket{le="+Inf"}`)
- 常見 PromQL Functions examples:
    - `http_request_duration_seconds_bucket{le="0.3"}`


# Summary

- summary 為 App Level 釋出的 metric (因此如果有 distributed instances 的話, 無法做出 summary 指標)
- summary 的特色之一是, 會針對 metric 的 label 給定 分位數(quantile)
    - 可用來判斷一段時間內, 特定指標的分佈狀況
    - 使用此類指標時, 無需耗用額外的 Prometheus Server Side 資源 (App Level 直接釋出 metrics)
    - streaming N-quantiles : `<basename>{quantile="N"}`
    - total sum             : `<basename>_sum`
    - count of events       : `<basename>_count`
- Summary 類型指標一般只適用於 獨立的監控指標
    - 不能再取得平均數 or 連結其他指標
- 常見 PromQL Functions examples:
    - ex: `prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.5"}`
