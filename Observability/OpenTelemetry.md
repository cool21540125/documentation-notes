# OpenTelemetry, OTel/o11y

- otlp
  - OpenTelemetry 的 Protocol, 用於傳輸 traces / metrics / logs
  - 支援 gRPC(4317 port) / HTTP(4318 port)


# OpenTelemetry overview

- OpenTelemetry 的 Sementic Conventions, 用於實作 Otel 回應屬性常見的 Keys
  - https://opentelemetry.io/docs/specs/semconv/

![OTel](./img/OTel.jpg)


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
  - 降低成本 : 移除無用的 telemetry / tail-based sampling(不是很懂)
  - 安全性 : 移除機敏資訊
  - 自訂 telemetry 流動方式 : batch / retry / memory limit

## 3. OpenTelemetry - Exporter

- 這裡有各種 OTel Exporters : https://github.com/open-telemetry/opentelemetry-collector/tree/main/exporter

# OpenTelemetry 環境變數

- [OpenTelemetry 官網的各種 Environment variables](https://opentelemetry.io/docs/languages/sdk-configuration/otlp-exporter/)

```bash
export OTEL_METRICS_EXPORTER="none"  # [none, otlp, console] OTel signals 發送到哪邊
export OTEL_LOGS_EXPORTER="none"     # [none, otlp, console] OTel signals 發送到哪邊
export OTEL_TRACES_EXPORTER="otlp"   # [none, otlp, console] OTel signals 發送到哪邊

### 設定 OTel 環境變數, 要我們的 OTel App 直接將 signal 傳給 OTel Collector
export OTEL_COLLECTOR_HOST=localhost

export OTEL_EXPORTER_OTLP_INSECURE=true  # 使用 http 而非 https

## 打算把 App signals 傳送到 OTel Collector 的 gRPC/HTTP (告知 OTel Collector 的 Endpoint)
export OTEL_EXPORTER_OTLP_ENDPOINT="YOUR_OTEL_COLLECTOR_HOST:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_ENDPOINT="YOUR_OTEL_COLLECTOR_HOST:4318"  # http 的 OTel Collector 端點

##
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"  # (default)
export OTEL_EXPORTER_OTLP_PROTOCOL="http/json"      # 
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"           # 

export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點

```
