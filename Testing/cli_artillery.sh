#!/bin/bash
exit 0
# 
# --------------------------------------------------------

###


### 依照壓測規範進行壓力測試
API_URL=
artillery run --target $API_URL loadtest-artillery.yaml
# --------- 內容 ---------
#config:
#  phases:
#  - duration: 300
#    arrivalRate: 150
#scenarios:
#- flow:
#  - get:
#      url: "/"
# --------- 內容 ---------
# 模擬 150 requests/sec && 持續 300 secs


### 