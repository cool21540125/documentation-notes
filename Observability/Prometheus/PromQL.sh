#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

## 查詢此時此刻是否有
curl -s 'http://localhost:9009/prometheus/api/v1/query?query=traces_spanmetrics_calls_total'
#{
#  "status": "success",
#  "data": {
#    "resultType": "vector",
#    "result": []
#  }
#}
# 等同於在 PromQL 查詢 traces_spanmetrics_calls_total

## 
