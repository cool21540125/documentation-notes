# Observability - Traces

## Spans

### [Attribute](https://opentelemetry.io/docs/specs/otel/common/#attribute)

- OpenTelemetry Attributes 分為 4 types:
  - span attributes
  - resource attributes
  - event attributes
  - link attributes


### [Span Kind](https://opentelemetry.io/docs/concepts/signals/traces/#span-kind)

- SpanKind 分成底下的類別:
  - Client
  - Server - 通常隱含分散式系統 root span 的 span kind 為 client
  - Producer
  - Consumer
  - Internal (default)
