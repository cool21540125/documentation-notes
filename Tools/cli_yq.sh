#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------------------------------------

### yq 排序
yq 'sort_by(.Timestamp)' FILE.yaml
# FILE 檔案內容範例:
# - Timestamp: xxx
#   Value: xxx
# - Timestamp: yyy
#   Value: yyy

### yaml to json
cat FILE.yaml | yq -o json

### 移除欄位
cat FILE.yaml | yq e 'del(.[] | .Unit)'
# - Sum: 1237.142859
#   Timestamp: '2024-09-17T07:55:00+00:00'
#   Unit: '%'
#  整理成 (也就是移除不希望的欄位)
# - Sum: 1237.142859
#   Timestamp: '2024-09-17T07:55:00+00:00'

###
