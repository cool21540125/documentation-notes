#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------------------------------------------------------

## 搜尋時段內, Tempo 已建立索引 & 可供搜尋的 resource attributes / span attributes / intrinsics 欄位名稱
tempo-cli query api search-tags localhost:3200 2026-01-13T14:00:00Z 2026-01-13T15:59:59Z | jq
{
  "scopes": [
    {
      "name": "resource",  # 蒐集到了這些
      "tags": [
        "environment.name",
        "service.name",
        "service.version"
      ]
    },
    {
      "name": "intrinsic",  # Tempo 自行建立
      "tags": [
        "duration",
        "event:name",
        "...(略)...",
        "trace:rootService",
        "traceDuration"
      ]
    },
    {
      "name": "span",  # 蒐集到了這些
      "tags": [
        "db.collection.name",
        "db.namespace",
        "...(略)...",
        "user.username"
      ]
    }
  ],
  "metrics": {
    "inspectedBytes": "20356"  # 用來表示此次搜尋的成本 (20,356 bytes, 算得上是非常小)
  }
}