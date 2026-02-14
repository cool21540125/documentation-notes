# Observability

![dNaiuoB](./img/dNaiuoB.png)
https://event.ithome.com.tw/itplus/upload-slide/2024/8/21/3e747970-b99c-40bd-aea7-538817e7ebcf.pdf

- 2019/05, 由 `OpenTracing(CNCF專案)` 與 `OpenCensus(Google開源專案)` 兩大社區宣佈合併 => `OpenTelemetry, OTel`
  - OTel 目的: 提供一個開源的 Observability 的 pluggable 框架
  - OTel 把 Logs/Metrics/Trace 加上 Baggage (在 Span 中傳遞的上下文資訊), 稱為 Signal
  - OTel 專注於資料的 `collection / processing / export`. OTel 本身不負責 資料的儲存
  - OTel 使用官方定義的傳輸協定, OTLP(OpenTelemetry Protocol)
  - metrics / logs / traces / events / profiles

> `metrics 及 traces` can be correlated via `exemplars`, and metrics attributes can be enriched via `Baggage` and `Context`.
> 
> 未知的未知(unknown unknowns) : 不存在該指標
> 
> 已知的未知(known unknowns) : Something you are aware but do not know, 可以理解為, 一個已存在的指標, 直到查詢時才知道 its value

- Metrics
  - 最重要的 Metrics 的 4 個切入點: `traffic / errors / saturation / latency`
  - 最基本的監控類型. metric 往往與 time 有關聯, 然而並非 metrics == time series
  - metrics 往往都是 聚合(aggregated) 了某些特定指標, 因而會遺失了特定資訊 (例如聚合了 ResponseTime, 則遺失了每個 Response 挾帶的細節)
    - 這部分得由 logs 來補齊
- Metric 與 TimeSeries
  - Metric, ex:
    - node_memory_MemFree_bytes
  - TimeSeries, ex:
    - node_memory_MemFree_bytes{instance="server1.example.com"}
    - node_memory_MemFree_bytes{instance="server2.example.com"}
  - 因此, 對於每個 Metric, 都可以有成百上千個的 TimeSeries
    - 從 OOP 的角度理解的話, metric 其實是個 base class. 而有非常多的 time series 繼承 metric
      - class Metric: pass
      - class TimeSeriesA(Metric): pass
      - class TimeSeriesB(Metric): pass
      - class TimeSeriesC(Metric): pass
    - 而這些 TimeSeries 與 TimeSeries 之間的差異則在於他們的 metadata, 也就是 labels
- Traces
  - traces 是整個 observability signal 最不失真的指標, 然而往往是最難實踐以及最晚導入到系統的
  - application trace 可以被視為是, 一種自訂 stack trace, 並且只關心自家團隊所寫的 Code path 的所有步驟(流程)
    - 每個 trace 都有 1~N 個 Spans 所構成.
  - tracing 算得上是最昂貴的監控(App 要產生 trace, 必然會有額外開銷)

# Observability solutions / Monitoring System

- Alloy
  - Grafana 開源, Written in Go
  - 適用於蒐集 Metrics / Logs / Traces
- Cortex
  - 分散式資料儲存的服務 (如果東西都已經上雲了的話, 不會需要用到 Cortex)
  - Coretex 跟 Thanos 互為替代品
- Filebeat
  - 由 Elastic 開源的 Collector. Written in Go
  - 適用於蒐集 metrics / logs / network packet data
  - 較適合用於 Elastic Stack
  - 依賴於 elastic/beats (也就是 libbeat), 相關連的產品有底下這堆:
    - Auditbeat / Filebeat / Heartbeat / Metricbeat / Packetbeat / Winlogbeat / Osquerybeat
- Fluentd
  - 開源的 Log Collector, 適合複雜的 Log Pipeline
- Fluent Bit
  - FluentBit 為 Fluentd 的子專案, 專注在高效能 & 低資源佔用, 講究輕量化.
  - FluentBit 支援 metrics / logs, 也支援 OTel, 適合 Embeded / Kubernetes
- Logstash
  - 由 Elastic 開源的 Collector. Written in Java
  - 適合用於複雜的過濾機制
    - 適用於蒐集 Logs / Events
  - 較適合用於 Elastic Stack
- jaeger
  - 聚焦在分散式系統的請求專宗. 聚焦在 tracing
- Nagios
  - 老牌監控工具, 原名為 NetSaint
  - written by C
  - 主力在於 主機監控 && 網路監控
  - 資料儲存在 `Round Robin Database, RDD` (環狀資料庫)
    - RDD, 為時序資料庫
- Open-Falcon
  - 小米開放原始碼的監控工具
  - written by go
- pprof
  - Go 語言的效能分析工具. 專注於單一應用程式的效能剖析, 聚焦在 profiling.
- Pyroscope
  - 開源的 profiling 工具, 專注在性能分析
- Splunk
  - splunk 是早期的企業級,商業化,大一統 觀測解決方案
  - splunk 是一套以 收集/儲存/搜尋/分析 machine data 為核心的商業及 Observability 與 SIEM(威脅偵測與安全監控) 平台
  - splunk 包含但不限於 Dashboards / Alerting / Reporting
  - 早期以 logs 為主, 後來陸續整合了 metrics/traces
- Telegraf
  - Telegraf 是個開源的 Collect Agent
  - 由 InfluxData 開發, 用於處理 metrics / logs, 階級等同於 Observability 之中的 Collector
- Thanos
  - 分散式資料儲存的服務 (如果東西都已經上雲了的話, 不會需要用到 Thanos)
  - Thanos 跟 Cortex 互為替代品
- Zabbix
  - 老牌的 自成一體的 監控系統
- Zipkin
  - 分散式 tracing system
  - 2012 年由 Twitter 開源. 年代久遠, 但相對成熟, 有自成一體的 Collector / Storage / Dashboard
  - OTel 也支援 zipkin 格式
    - app 藉由 zipkin sdk 生成 traceID, 再由 OTel Collector 轉發到 zipkin 或其他 backend(ex: Tempo)

# Monitoring

- 監控範疇
  - Application Level - `Application Performance Management, APM`
    - Call Chain
    - Http Delay
    - Performance
    - Status
  - Middleware Level
    - Cache
    - Message
    - Service
    - DB
  - Infra Level
    - CPU
    - Memory
    - Network
      - 通常基於 `Simple Network Management Protocol, SNMP`
      - 網路效能監控: `Network Performance Monitor, NPM`
    - Storage
    - Disk I/O
    - Java Machine
      - `Java Management Extensions, JMX`
    - Server
      - 針對實體硬體的監控: `Intelligent Platform Management Interface, IPMI`
      - 由 Google 開放原始碼的 cAdvisor 可以取得 host 上所有 Container 的效能指標
        - 其他 Open Source 監控專案另有:
          - Zabbix
          - Open-Falcon
          - Prometheus
- 監控架構
  - 實現方式:
    - 資料取得
      - pull
      - push
      - pull + push
    - 資料傳輸
      - Socket
      - Http
    - 資料儲存
      - RDB
      - No-SQL
        - MongoDB
        - OpenTSDB
        - InfluxDB
          - 如果服務基本上都是 Cloud Native, 那就不要考慮 InfluxDB 了
  - 核心子系統
    - 資料擷取子系統 : extract, filter, process, store
    - 資料處理子系統 : analyze, display, warning, alert, notify, action

# Monitoring CLI Tools

![linux_perf_tools_full](./img/linux_perf_tools_full.png)

# Dashboard

- 製作 Monitoring Dashboard 的時候的一些應該注重的重點方向 (關注對象是誰來區分)
  - 底層架構的監控(硬體面) USE - https://brendangregg.com/usemethod.html
    - Utilization (資源利用率)
    - Saturation (泛指既定資源無法處理的額外工作的程度, 通常指的是 queued)
    - Errors (Error events 次數)
  - 客戶實際感受 RED - https://grafana.com/blog/2018/08/02/the-red-method-how-to-instrument-your-services/
    - Request rates (服務每秒請求數)
    - Error (請求之中失敗的次數)
    - Duration or Latency (請求所花費的時間)
  - Google SRE 監控重點 - https://sre.google/sre-book/monitoring-distributed-systems
    - Latency: the amount of time it takes to serve a request
      - 似乎只能在 `before_request` 及 `after_request` Middleware 之中計算
    - Traffic: volume of requests handled by the system
    - Errors: rate of failed requests
    - Saturation: how much of a resource is being consumed at a given time
