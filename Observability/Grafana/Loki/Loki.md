# Grafana Loki

- Distributor
  - 接收 log HTTP request
- Ingester
  - 從 distributor 取得 log data, 寫入到 storage
- Compactor
  - 資料壓縮 / 索引去重及合併 / 資料去重 / 保留期管理 / 查詢加速
- Ruler
  - Loki 的 自動查詢 & 告警管理員, 定期掃 log 是否有異常, 並用 API 控制及動態調整規則
- Querier
  - Loki 的查詢引擎, LogQL 會去尻的目標
- logs 以 `Snappy compressed protocol buffer messages, log Proto` 的形式, 推送到 Loki 的 `HTTP API Endpoint`, 也就是 Distributors, 經處理後再送給 Ingesters
- Loki 不像其他傳統的 log system, Loki stores logs as streams of log entries (高度壓縮的 string)
- 有許多種方式可將 logs 發送到 Loki, 初學者的話, 最基本有 3 categories:
  - `Grafana Alloy` (符合 OTel 規範), 此為 `Grafana Agent(即將 DEPRECATED)` 的繼承人
  - Specialized category
    - 使用 `OTel Collector`
      - Grafana Loki 3.0+ 已與 OpenTelemetry Collector 做更深度的整合
    - Loki Agent (有很多種實作)
      - Promtail (LTS 將於 2026/03 附近到期, 不久後將 EOF, 將來請改用 Grafana Alloy)
        - promtail 是個會從 source read logs 的 agent, 使用像是 Prometheus 的 SD 來找到 targets
        - Promtail 是用來將 Logs 發送到 Loki 的 Agent (適用於 Host-Based)
        - system journal / local log files / kubernetes pods / ...
        - Promtail 類似於 Prometheus Service Discovery 自動註冊 Targets
        - 其實 Promtail 也已經整合到 Grafana Alloy 了
      - Fluentd
        - 開源的 data collector, 用來統一資料蒐集和消費
      - Fluentd Bit
        - E2E Observability Pipeline, 較適用於 Cloud 及 Containerized Env
        - 輕量快速的 scalable logging/metrics/traces processor & forwarder
      - Docker driver
      - Logstash
  - 3rd party clients (使用 Loki-compatible clients)
    - Fluent Bit
    - Fluentd
    - Logstash
- logproto

# Reference

- [Loki labs 學習網站](https://killercoda.com/grafana-labs/course/loki/loki-quickstart)
- [Loki basic config](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/loki-config.yaml)
- [Loki alloy setting](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/alloy-local-config.yaml)
- [Loki 的 docker compose](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/docker-compose.yaml)

![Grafana Loki 官網 Loki 架構圖](./../img/loki_architecture_components.svg)
