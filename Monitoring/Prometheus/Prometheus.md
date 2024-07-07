# Prometheus

- Prometheus server 對 agent 做 pull metrics. Agent 揭露 監控物件(target) 的方式如下:
    - 靜態檔案設定
    - 動態發現(Auto Discovery)
        - 目前有支援的系統(藉由自動發現, 取得監控物件):
            - Container Platform : K8s, Marathon
            - Cloud              : EC2, Azure, OpenStack
            - Service            : DNS, ZooKeeper, Consul
- target 狀態:
    - unknown : (一開始被加入時)
    - up      : 成功擷取
    - down    : 擷取失敗 (timeout, ...)
- Endpoints
    - '/metrics'
    - '/federate'
        - 讓 Prometheus 可以串 Prometheus
    - '/graph'
        - GUI 介面


# Prometheus - Metric Types

在目前的 Prometheus 2.53 版當中, metric types 的概念只存在於 client, server 並無此概念

- Counter
    - 隨著時間持續增長的指標, ex: 每隔 15 秒一筆
- Gauge (測量值)
    - 隨著服務運行而變化的指標, ex: CPU, Memory, Disk Usage, I/O, ...
- Histogram (進階)
    - 反映了 某個時間區間內 的 樣本個數, `le="上邊界"`
        - ex: `http_request_duration_seconds_bucket{le="0.3"}`
- Summary (進階)
    - 可用來判斷一段時間內, 特定指標的分佈狀況
        - ex: `prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.5"}`
    - 使用此類指標時, 無需耗用額外的 Server Side 資源 (Client 負擔較重?)
    - Summary 類型指標一般只適用於 獨立的監控指標
        - 不能再取得平均數 or 連結其他指標