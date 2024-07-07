# Exporter

- 類比
    - prometheus : 天眼
    - exporter : 各大角落的攝影機
- Prometheus 對於不同 Middleware 開發了許多 監控代理, ex:
    - Kafka exporter
    - MySQL server exporter
    - Apache exporter
    - Redis exporter
    - Node exporter
- 讓 Prometheus scraping metrics 的 AP
- Exporter 可視為是 Service 的 Sidecar

```mermaid
flowchart LR

Prometheus -- fetch '/metrics' --> Exporter;

subgraph ap
    Exporter -- fetch metrics --> Service;
end
```
