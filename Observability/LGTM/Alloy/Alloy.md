# Grafana Alloy

![](./img/alloy_diagram_v2.svg)

- Grafana Alloy 是個開源的 OTeL Collector 發行版. 具備內建的 Prometheus pipelines, 支援 metrics/logs/traces/profiles
  - collect logs
  - transform logs
  - send logs
  - Alloy 其實是 Grafana 的 OTel Collector 的分支, 加強對於 Prometheus 和 Loki 的支援
  - Alloy 也是個 OTel Proxy, 可蒐集 metrics/logs/traces
    - 如果要使用 Grafana Stack, 使用 Alloy 整合度較高, 但相較於 OTel Collector 靈活性較低.
- 適用於觀測 App/Infra
- 可實現一連串的功能: collect, process, export telemetry signals
- 原生支援 telemetry signals, ex: Prometheus, OpenTelemetry, Loki, Pyroscope

# Alloy Configuration

```conf
### 寫法
"component_name" "custom_label" {
  arg1 = "val1"
  arg2 = sys.env("ENV_NAME")
  arg3 = component_name.custom_label.arg2.content
}

# 上面這一包, 稱之為一個 Component, 由 Arguments 及 Export 構成
#    Export 則由 component_name + custom_label 組成 (此為 Unique)
#    Arguments 則由 Key = value 組成
# arg2 與 arg3 都是動態參照的寫法
```
