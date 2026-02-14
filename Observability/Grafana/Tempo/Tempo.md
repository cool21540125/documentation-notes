# Grafana Tempo

- Grafana Tempo ports:
  - 4317 - OTLP over gRPC
  - 4318 - OTLP over HTTP
  - 3100 - distributor cluster Tempo communication - Microservice deployment usage
  - 3200 - Tempo API for HTTP query
  - 9095 - Tempo main gRPC Server, grpc_listen_port - internal cluster communication

## Metrics-generator

Tempo 的 metrics-generator 可以啟用各種 processors 來從 trace spans 生成 spanmetrics

- **span_metrics processor** - 追蹤單一服務內部各個 span 的呼叫次數、延遲、錯誤率等指標
  - span_metrics 生成的 metrics: `spanmetrics`, 早期原始碼使用的是 `span_metrics`
    - span_metrics 生成的 metrics 的前綴長這樣: `traces_spanmetrics_`
  - 這些 spanmetrics 會按照 `service.name`, `span.name`, ... 等維度分組
    - 配置在: `metrics_generator.processor.span_metrics.dimensions`
  - **span-metrics processor** 會固定生成底下的 metrics:
    - `traces_spanmetrics_calls_total` Counter
      - 計算 span 呼叫總數
    - `traces_spanmetrics_latency` Histogram
      - 計算 span 延遲分布
      - 有預設的 `buckets: [...]`, 可藉由 `histogram_buckets: [...]` 覆寫
    - `traces_spanmetrics_size_total` Counter
      - 計算 span 大小 總和(bytes)
      - 不一定會生成, 需要額外配置
- **service_graphs processor** - 建立服務間的調用關係圖
  - spans 需要有 span.kind (CLIENT/SERVER) 配對
  - 藉由配置 peer_attributes 可指定如何識別 peer service
  - service_graphs 生成的 metrics:
    - traces_service_graph_request_total            # 服務間請求總數 (Counter)
    - traces_service_graph_request_failed_total     # 失敗請求數 (Counter)
    - traces_service_graph_request_*_seconds        # 延遲分佈 (Histogram)
      - traces_service_graph_request_server_seconds   # server side
      - traces_service_graph_request_client_seconds   # client side
    - traces_service_graph_unpaired_spans_total     # 無法配對的 spans (Counter)
    - traces_service_graph_dropped_spans_total      # 被丟棄的 spans (Counter)

```sh
## 查詢 Mimir (Prometheus 相容 API) 裡, 目前存在過的所有 metrics 名稱
curl -s 'http://localhost:9009/prometheus/api/v1/label/__name__/values' | jq
#{
#  "status": "success",
#  "data": [
#    "target_info",
#    "traces_service_graph_request_client_seconds_bucket",
#    "...(略)..."
#  ]
#}
# Grafana 查詢編輯器的 metric 下拉選單, 本質上就是在尻這 API

## 
curl -s 'http://localhost:3200/api/v2/search/tags' | jq

## 
```