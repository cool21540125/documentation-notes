#!/bin/bash
exit 0

### alloy init run
allow run \
  --server.http.listen-addr=0.0.0.0:12345 \
  --storage.path=/var/lib/alloy/data \
  --feature.community-components.enabled true \
  /etc/alloy/config.alloy
# --server.http.listen-addr 使用 Debug UI
# --feature.community-components.enabled 啟用由社群維護的 Components

###
