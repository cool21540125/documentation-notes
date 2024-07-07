#!/bin/bash
exit 0
# ------------------------


### 將已經運行的 prometheus 做 live reload (而非 restart)
kill -s SIGHUP $ORIGINAL_PROMETHEUS_PID


### 