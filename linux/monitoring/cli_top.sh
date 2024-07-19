#!/bin/bash
exit 0
# ---------------------


### 僅顯示 PROCESS_NAMES 的 TOP
top -p `pgrep PROCESS_NAMES | tr "\\n" "," | sed 's/,$//'`


### 