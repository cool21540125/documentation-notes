# Faro - 讓前端具備觀測

## Faro signals 與 Alloy Receiver

- 前端發送 Signals 到 Alloy 的選擇:
  - 藉由引入 `@grafana/faro-web-sdk`,                                       讓前端發送: `Faro format signals` 到 Alloy 的 `faro.receiver`
  - 藉由引入 `@grafana/faro-web-sdk` & `@grafana/faro-transport-otlp-http`, 讓前端發送: `OTLP format signals` 到 Alloy 的 `otelcol.receiver.otlp`