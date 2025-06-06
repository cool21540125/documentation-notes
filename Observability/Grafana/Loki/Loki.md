# Grafana Loki

- Distributor
  - 接收 log HTTP request
- Ingester
  - 從 distributor 取得 log data, 寫入到 storage
- logs 以 `Snappy compressed protocol buffer messages, log Proto` 的形式, 推送到 Loki 的 `HTTP API Endpoint`, 也就是 Distributors, 經處理後再送給 Ingesters
- Loki 不像其他傳統的 log system, Loki stores logs as streams of log entries (高度壓縮的 string)
- 有許多種方式可將 logs 發送到 Loki, 基本上分成 3 categories:
  - Primary category
    - Grafana Alloy (Grafana 建議使用此方式來做 ingesting logs into Loki)
      - 使用 Alloy 來將 Logs 丟到 Loki 算是最容易的方式
      - 此為 OpenTelemetry Collector
      - 支援 native pipelines for OTEL / Prometheus / Loki / ...
  - Specialized category
    - OTEL Collector
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
  - 3rd party clients
    - Docker driver
    - Fluent Bit
    - Fluentd
    - Logstash
    - Grafana Alloy

# Reference

- [Loki labs 學習網站](https://killercoda.com/grafana-labs/course/loki/loki-quickstart)
- [Loki basic config](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/loki-config.yaml)
- [Loki alloy setting](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/alloy-local-config.yaml)
- [Loki 的 docker compose](https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/docker-compose.yaml)

![Grafana Loki 官網 Loki 架構圖](./../img/loki_architecture_components.svg)
