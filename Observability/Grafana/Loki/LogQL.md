```
### 生成 Time Series
sum by (container) (rate({container="evaluate-loki_flog_1"} | json | status=404 [$__auto]))
```
