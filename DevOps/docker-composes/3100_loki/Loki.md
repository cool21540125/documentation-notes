- 首次學習 Loki

  - https://killercoda.com/grafana-labs/course/loki/loki-quickstart

- 以下兩者好像是相同的?
  - snappy compressed protocol buffer messages
  - log proto

```bash
wget https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/loki-config.yaml -O loki-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/alloy-local-config.yaml -O alloy-local-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/main/examples/getting-started/docker-compose.yaml -O docker-compose.yaml

docker compose up -d
# HealthCheck: http://localhost:3101/ready
# HealthCheck: http://localhost:3102/ready
# Alloy Web : http://localhost:12345 (整個就很像 Prometheus)
# Grafana Web : http://localhost:3000
#   Data sources 已有 Loki
#     使用 LogQL 查詢 - https://grafana.com/docs/grafana/latest/datasources/loki/query-editor/

docker ps
```

```promQL
sum by(container) (rate({container="evaluate-loki-flog-1"} | json | status=`404` [$__auto]))
```

# Loki Architecture

- Distributor
  - 接收 log HTTP request
- Ingester
  - 從 distributor 取得 log data, 寫入到 storage
- Loki 發送 Logs 到 Grafana 可以有底下方式
  - Primary
    - Grafana Alloy
      - 使用 Alloy 來將 Logs 丟到 Loki 算是最容易的方式
      - 此為 OpenTelemetry Collector
      - 支援 native pipelines for OTEL / Prometheus / Loki / ...
  - Specialized
    - OTEL Collector
      - Grafana Loki 3.0+ 已與 OpenTelemetry Collector 做更深度的整合
    - Promtail
      - Promtail 是用來將 Logs 發送到 Loki 的 Agent (適用於 Host-Based)
      - system journal / local log files / kubernetes pods / ...
      - Promtail 類似於 Prometheus Service Discovery 自動註冊 Targets
      - 其實 Promtail 也已經整合到 Grafana Alloy 了
  - 3rd party clients
    - Docker driver
    - Fluent Bit
    - Fluentd
    - Logstash
    - Grafana Alloy

# Notes

- Loki query editor 有 2 種模式:
  - Builder mode
  - Code mode
