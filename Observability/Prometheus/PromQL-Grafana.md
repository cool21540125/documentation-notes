# Grafana PromQL

- `$__range`

```sql
###
rate(container_cpu_usage_seconds_total{name="demo"}[$__range]) > 0.8
```
