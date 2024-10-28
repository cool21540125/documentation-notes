#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------------------------------------

### 使用 jq 將 json 做排序
FILE="xx.json"
cat $FILE | jq -r 'sort_by(.Timestamp)'

### 使用 jq 排序
FILE="xx.json"
cat $FILE | jq -r 'sort_by(.Timestamp) | .[]'
