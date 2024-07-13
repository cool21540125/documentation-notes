#!/bin/bash
exit 0
# ---------------------------------------------------

# 僅針對 daemon setting 做 Live reload (不做重啟)
systemctl reload docker


### 驗證 daemon setting
dockerd --validate --config-file=/etc/docker/daemon.json
# 不做重啟, 僅作驗證
