# OpenTelemetry Useful

- OpenTelemetry Collector 視覺化配置
  - https://www.otelbin.io/

# OpenTelemetry, OTel/o11y

- otlp
  - OpenTelemetry 的 Protocol, 用於傳輸 traces / metrics / logs
  - 支援 gRPC(4317 port) / HTTP(4318 port)


# OpenTelemetry overview

- OpenTelemetry 的 Sementic Conventions, 用於實作 Otel 回應屬性常見的 Keys
  - https://opentelemetry.io/docs/specs/semconv/

# OpenTelemetry - 核心元件

## 1. OpenTelemetry - Receiver

- 這裡有各種 OTel Receivers : https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver
- 區分為 pull-based 及 push-based
  - `OTLPReceiver` ~ 此為 OTel 的 native format
  - ZipkinReceiver
  - StatsdReceiver
  - PrometheusReceiver
  - ...

## 2. OpenTelemetry - Processor

- Processor 的配置重點, 需要做底下考量:
  - 增加 telemetry quality : 欄位屬性新增及轉換 / 新舊版本整合的欄位轉換
  - 基於 compliance 及 governance : 把不同的 attributes 送到不同 backend
  - 降低成本 : 移除無用的 telemetry / tail-based sampling
  - 安全性 : 移除機敏資訊
  - 自訂 telemetry 流動方式 : batch / retry / memory limit

## 3. OpenTelemetry - Exporter

- 這裡有各種 OTel Exporters : https://github.com/open-telemetry/opentelemetry-collector/tree/main/exporter

# OpenTelemetry 環境變數

- [OpenTelemetry 官網的各種 Environment variables](https://opentelemetry.io/docs/languages/sdk-configuration/otlp-exporter/)

```bash

export OTEL_EXPORTER_OTLP_ENDPOINT="http://my_otel_collector_endpoint/"

export OTEL_TRACES_EXPORTER="otlp"

export OTEL_METRICS_EXPORTER="otlp"

export OTEL_LOGS_EXPORTER="otlp"

export OTEL_NODE_RESOURCE_DETECTORS="env,host,os"

export OTEL_RESOURCE_ATTRIBUTES="service.name=<name>,service.namespace=<namespace>,deployment.environment=<environment>"

export NODE_OPTIONS="--require @opentelemetry/auto-instrumentations-node/register"

```

# OpenTelemetry 重要名詞解釋

- 釐清 Tempo - Exemplar / Metrics / Trace
  - 用考試來舉例
    - Metric   - 班級成績摘要, 包含了全班平均, 最高, 最低, 中位數, ...
    - Exemplar - 其中一份考卷的成績, 考生姓名, 作答結果, 以及 traceID (用來追蹤這份考卷作答過程)
    - Trace    - 該份考卷作答的完整過程, 從考生進入教室, 作答, 交卷離開
  - 用餐廳來舉例
    - Metric   - 每天營收報表, 營業時間摘要, 來客數, ...
    - Exemplar - 當天發票紀錄其中一筆, 可以對應到 clientID, paymentID, orderID, traceID(用來看該筆消費全部過程)
    - Trace    - 其中一位客人進門, 點餐, 上菜, 用餐, 結帳, 離開 所有過程
- 釐清 OtelCollector 階段 - Sampler / SpanProcessor / Exporter
  - Sampler       - 決定哪些 Span 要被記錄與後送, 是在 建立 Span 當下 做決策
  - SpanProcessor - 負責 對已經決定要記錄的 Span 做處理. ex: batch / buffer / to exporter / ...
  - Exporter      - 把處理好的 Spans 送到 Collector / LTM / AMP / ...
- 釐清 Metrics 相關名詞 - Meter / Instrument / Measurement / Data Point / Metric
  - 速記方式:
    - Meter 建立 Instrument
    - Instrument 紀錄 Measurement
    - Measurement 聚成 Data points
    - Data points 彙成 Metric
  - 管理員（Meter）發給你儀器(Instrument), 每次紀錄寫一張小紙條(Measurement), 一堆小紙條統整成報告(Data point), 報告都投到一個大資料夾(Metric), 讓主管要看什麼就快翻什麼

