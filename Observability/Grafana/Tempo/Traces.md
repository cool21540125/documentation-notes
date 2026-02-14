# Observability - Traces

- OpenTelemetry 規範 traces 的定義:
  - Resource Attributes : 描述產生 telemetry 的實體
  - Span Attributes     : 描述特定操作的細節
- Grafana Tempo 對於 traces 的定義:
  - **Intrinsics** 是 Grafana Tempo 內建的 span 欄位, 包含:
    - name
    - duration
    - kind
      - Client
      - Server - 通常隱含分散式系統 root span 的 span kind 為 client
      - Producer
      - Consumer
      - Internal (default)
    - status
      - OK        : 異常發生後, 自行標記為 OK
      - Error     : 異常
      - Undefined : (default)
- OpenTelemetry 定義的 Resource attributes
  - instrumentation.name
  - instrumentation.version

- Span intrinsics
  - name
    - ex: `{ name = "GET /:endpoint" }` 
  - duration
    - ex: `{ duration > 2s }`
  - status
  - kind
- Span attributes
  - `{ span.http.status_code = 200 }`
  - `{ .http.method = "GET" && .http.status = 200 }`
- Resource attributes
  - `{ resource.service.name = "frontend" }`
  - `{ resource.namespace = "prod" }`


## Spans

### [Attribute](https://opentelemetry.io/docs/specs/otel/common/#attribute)

- OpenTelemetry Attributes 分為 4 types:
  - span attributes
  - resource attributes
  - event attributes
  - link attributes

## Span Event

如果所要記錄的 Span 本身時間點至關重要就用 Span Event, 否則記錄到 Span Attribute 就好

## Span Link

Span Link 用來釐清 Spans 之間的因果 / 用來關聯異步服務 Traces 之間的 Link

## Span Status

### [Span Kind](https://opentelemetry.io/docs/concepts/signals/traces/#span-kind)

- SpanKind 分成底下的類別:

