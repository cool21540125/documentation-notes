```
### 生成 Time Series
sum by (container) (rate({container="evaluate-loki_flog_1"} | json | status=404 [$__auto]))


```

## Example logfmt & line_format
```
---
level=info ts=2026-02-02T12:55:29.123456Z caller=main.go:182 msg="Starting Grafana OSS Logs"
level=info ts=2026-02-02T12:55:29.456789Z caller=loki.go:736 msg="Loki started"
---

## 基礎查詢 logfmt 的語法
{job="someJob"} | logfmt | level = "info"

## 使用 line_format 重新定義 Log format
{job="someJob"} | logfmt | line_format "Level:{{.level}} Log:{{.msg}}"
```


## Pattern
```
---
33.22.66.33 - - [2026-02-18T18:23:44 +0800] "GET /index.html HTTP/2.0" 200 29384
33.22.66.33 - - [2026-02-19T13:59:23 +0800] "POS /api/v1/push HTTP/1.1" 401 293812
---

## 將 Log 以 Pattern 解析成新的 label, 並篩選 status
{job="someJob"} | pattern "<_> - <_> <_> \"<method> <url> <protocol>\" <status> <_> <_> \"<_>\" <_>" | status >= 200 and status < 300
# 也就是說, 將原本的 Log Line 使用 pattern 硬生生地切出 4 個 temp Label:
#   method, url, protocol, status
# <_> 表示不做 Label
```
