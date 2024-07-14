#!/bin/bash
exit 0
# ------------------------


### 將已經運行的 prometheus 做 live reload (而非 restart)
kill -s SIGHUP $ORIGINAL_PROMETHEUS_PID
# 可用來動態載入 rule_files


### 
prometheus --config.file=config/prometheus.yml --web.config.file=config/web.yml --web.listen-address="0.0.0.0:29090"
# web.yml        - https://prometheus.io/docs/prometheus/latest/configuration/https/
# prometheus.yml - 


### reload the Prometheus configuration
curl -X POST http://localhost:29090/-/reload -u "admin:PASSWORD"
# 需要搭配 --web.enable-lifecycle 才能使用


### 