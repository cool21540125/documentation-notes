#!/bin/bash
exit 0
# Grafana Loki CLI
#
# 目前這邊的指令範例, 都是來自於:
#    https://grafana.com/docs/loki/latest/query/logcli/logcli-tutorial/
#
# -----------------------------------------------------------------------------------------------------------------------------

export LOKI_ADDR=http://localhost:3100
export LOKI_USERNAME=
export LOKI_PASSWORD=

### ================================================ Loki logcli 基本用法 ================================================
logcli --version
#logcli, version 3.6.1

### 列出 LOKI_ADDR 有多少 labels
logcli labels
#2025/06/09 16:20:13 http://localhost:3100/loki/api/v1/labels?end=1749486013703845132&start=1749482413703845132
#label_1
#label_2
#mail_house_id
#package_size
#service_name
#state
#label_N

### logcli 基本查詢用法範例
logcli query '{service_name="Delivery World"}'
logcli query '{service_name="Delivery World"} | package_status="critical"'
# {} 裡頭放的是 labels 查詢
# | 後面的則是 log message 本身的 package_status 欄位 (這則 log message 的前提時, 此為 JSON format 才能用這種 key=value 查詢)

### 過去 24 hrs (預設回傳 first 30 log messages)
logcli query --since 24h '{service_name="Delivery World"} | package_status="critical"'

### 可用 limit 來增減預設筆數
logcli query --since 24h --limit 100 '{service_name="Delivery World"} | package_status="critical"'

# 針對 last 24 hours in 1 hour intervals, 做 metrics 查詢
logcli query --since 24h 'sum(count_over_time({state="California"}[1h]))'
#2025/06/09 16:30:09 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749486609509527576&limit=30&query=sum%28count_over_time%28%7Bstate%3D%22California%22%7D%5B1h%5D%29%29&start=1749400209509527576
#[
#  {
#    "metric": {},
#    "values": [
#      [
#        1749485685,
#        "94"
#      ],
#      [
#        1749486030,
#        "304"
#      ],
#      [
#        1749486375,
#        "532"
#      ],
#      [
#        1749486720,
#        "670"
#      ]
#    ]
#  }
#]

### (不會解釋, 但大概可以體會)
logcli query --since 24h 'sum(count_over_time({state="California"} | json | package_type= "Documents" [1h]))'
#2025/06/09 16:32:38 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749486758844022359&limit=30&query=sum%28count_over_time%28%7Bstate%3D%22California%22%7D%7C+json+%7C+package_type%3D+%22Documents%22+%5B1h%5D%29%29&start=1749400358844022359
#[
#  {
#    "metric": {},
#    "values": [
#      [
#        1749485685,
#        "15"
#      ],
#      [
#        1749486030,
#        "45"
#      ],
#      [
#        1749486375,
#        "82"
#      ],
#      [
#        1749486720,
#        "119"
#      ],
#      [
#        1749487065,
#        "123"
#      ]
#    ]
#  }
#]

### 過去 5 mins 接收到的筆數
logcli instant-query 'sum(count_over_time({state="California"}[5m]))'
#2025/06/09 16:34:27 http://localhost:3100/loki/api/v1/query?direction=BACKWARD&limit=30&query=sum%28count_over_time%28%7Bstate%3D%22California%22%7D%5B5m%5D%29%29&time=1749486867546785507
#[
#  {
#    "metric": {},
#    "value": [
#      1749486867.546,
#      "166"
#    ]
#  }
#]

### 把 Query Result 寫入到檔案
logcli query \
  --timezone=UTC \
  --output=jsonl \
  --parallel-duration="12h" \
  --parallel-max-workers="4" \
  --part-path-prefix="./inventory/inv" \
  --since=24h \
  '{service_name="Delivery World"}'

### ================================================ Loki logcli 支援 Meta Query ================================================
# 這邊所謂的 metadata / meta data, 指的是 log insights && query performance

### 列出 logs 有多少個 unique series (數列基數) -- 此與 Performance & Storage Cost 有顯著關聯
logcli series '{}'
#2025/06/09 16:41:00 http://localhost:3100/loki/api/v1/series?end=1749487260992830625&match=%7B%7D&start=1749483660992830625
#{mail_house_id="DEPOT-02", package_size="Medium", service_name="Delivery World", state="California"}
#{mail_house_id="DEPOT-02", package_size="Medium", service_name="Delivery World", state="New York"}
#{mail_house_id="DEPOT-01", package_size="Medium", service_name="Delivery World", state="Illinois"}
#...(略)

### (將上述查詢語法優化)
#   summary of the unique values for each label in our logs
logcli series '{}' --analyze-labels
#2025/06/09 16:42:49 http://localhost:3100/loki/api/v1/series?end=1749487369851502897&match=%7B%7D&start=1749483769851502897
#Total Streams:  45
#Unique Labels:  4
#
#Label Name     Unique Values  Found In Streams
#state          5              45
#mail_house_id  3              45
#package_size   3              45
#service_name   1              45

### 針對 logs 偵測欄位 -- 可藉此暸解 log structure && log keys(哪些是 labels, 哪些是 metadata) ----- NOTE: 我不懂
logcli detected-fields --since 24h '{service_name="Delivery World"}'
#2025/06/09 16:44:54 http://localhost:3100/loki/api/v1/detected_fields?end=1749487494641600282&limit=100&line_limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749401094641600282&step=10s
#label: city             type: string            cardinality: 15
#label: detected_level           type: string            cardinality: 4
#label: mail_house_id_extracted          type: string            cardinality: 3
#label: note             type: string            cardinality: 7
#label: package_id               type: string            cardinality: 991
#label: package_size_extracted           type: string            cardinality: 3
#label: package_status           type: string            cardinality: 4
#label: package_type             type: string            cardinality: 5
#label: receiver_address         type: string            cardinality: 988
#label: receiver_name            type: string            cardinality: 100
#label: sender_address           type: string            cardinality: 982
#label: sender_name              type: string            cardinality: 100
#label: state_extracted          type: string            cardinality: 5
#label: timestamp                type: string            cardinality: 1000

###
logcli stats --since 24h '{service_name="Delivery World"}'
#2025/06/09 16:56:51 http://localhost:3100/loki/api/v1/index/stats?end=1749488211389951345&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749401811389951345
#{
#  bytes: 5.4MB
#  chunks: 520
#  streams: 45
#  entries: 12059
#}

###
logcli stats --since 24h '{service_name="Delivery World", package_size="Large"}'
#2025/06/09 16:58:17 http://localhost:3100/loki/api/v1/index/stats?end=1749488297890977618&query=%7Bservice_name%3D%22Delivery+World%22%2C+package_size%3D%22Large%22%7D&start=1749401897890977618
#{
#  bytes: 1.8MB
#  chunks: 175
#  streams: 15
#  entries: 4081
#}

###
logcli volume --since 24h '{service_name="Delivery World"}'
#2025/06/09 17:01:01 http://localhost:3100/loki/api/v1/index/volume?end=1749488461258280095&limit=30&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749402061258280095
#[
#  {
#    "metric": {
#      "service_name": "Delivery World"
#    },
#    "value": [
#      1749488461.259,
#      "6261236"
#    ]
#  }
#]

###
logcli volume_range --since 24h --step=1h '{service_name="Delivery World"}'
#2025/06/09 17:01:45 http://localhost:3100/loki/api/v1/index/volume_range?end=1749488505074396303&limit=30&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749402105074396303&step=3600
#[
#  {
#    "metric": {
#      "service_name": "Delivery World"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "7474726"
#      ],
#      [
#        1749488505.075,
#        "140207"
#      ]
#    ]
#  }
#]

###
logcli volume_range --since 24h --step=1h --targetLabels='state' '{service_name="Delivery World"}'
#2025/06/09 17:01:58 http://localhost:3100/loki/api/v1/index/volume_range?end=1749488518199138675&limit=30&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749402118199138675&step=3600&targetLabels=state
#[
#  {
#    "metric": {
#      "state": "Illinois"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "1593878"
#      ],
#      [
#        1749488518.2,
#        "31589"
#      ]
#    ]
#  },
#  {
#    "metric": {
#      "state": "California"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "1516890"
#      ],
#      [
#        1749488518.2,
#        "35079"
#      ]
#    ]
#  },
#  {
#    "metric": {
#      "state": "Florida"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "1494757"
#      ],
#      [
#        1749488518.2,
#        "30113"
#      ]
#    ]
#  },
#  {
#    "metric": {
#      "state": "New York"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "1476878"
#      ],
#      [
#        1749488518.2,
#        "28408"
#      ]
#    ]
#  },
#  {
#    "metric": {
#      "state": "Texas"
#    },
#    "values": [
#      [
#        1749488399.999,
#        "1387973"
#      ],
#      [
#        1749488518.2,
#        "30582"
#      ]
#    ]
#  }
#]

###
logcli query \
  --timezone=UTC \
  --parallel-duration="12h" \
  --parallel-max-workers="4" \
  --part-path-prefix="./inventory/inv" \
  --since=24h \
  --merge-parts \
  --output=raw \
  '{service_name="Delivery World"}' >./inventory/complete.log
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749488650559952351&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749445450559952351&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749402250559952351
#2025/06/09 17:04:10 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749488317271887001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:10 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749487984165145001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:10 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749487651046651001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:10 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:10 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749487317932739001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749486984814668001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749486651712951001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749486318574368001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749485985439648001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749485652305946001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {service_name="Delivery World"}
#2025/06/09 17:04:15 http://localhost:3100/loki/api/v1/query_range?direction=BACKWARD&end=1749485502180672001&limit=1000&query=%7Bservice_name%3D%22Delivery+World%22%7D&start=1749445450559952351
#2025/06/09 17:04:15 Common labels: {detected_level="error", mail_house_id="DEPOT-01", package_id="PKG23782", package_size="Medium", package_status="error", service_name="Delivery World", state="California"}

###
cat ./inventory/complete.log | logcli --stdin query '{service_name="Delivery World"} | json | package_status="critical"'
#2025/06/09 17:05:09 Common labels: {package_status="critical", source="logcli"}
#2025-06-09T17:05:09Z {city="New York City", mail_house_id="DEPOT-03", note="Damaged during transit", package_id="PKG65134", package_size="Large", package_type="Furniture", receiver_address="345 Cedar Blvd, New York City, New York", receiver_name="Receiver85", sender_address="542 Main St, New York City, New York", sender_name="Sender91", state="New York", timestamp="2025-06-09T17:04:10.377757Z"}        {"timestamp": "2025-06-09T17:04:10.377757Z", "state": "New York", "city": "New York City", "package_id": "PKG65134", "package_type": "Furniture", "package_size": "Large", "package_status": "critical", "note": "Damaged during transit", "sender": {"name": "Sender91", "address": "542 Main St, New York City, New York"}, "receiver": {"name": "Receiver85", "address": "345 Cedar Blvd, New York City, New York"}, "mail_house_id": "DEPOT-03"}
#2025-06-09T17:05:09Z {city="San Diego", mail_house_id="DEPOT-01", note="Delivered successfully", package_id="PKG24170", package_size="Large", package_type="Electronics", receiver_address="900 Oak St, Los Angeles, California", receiver_name="Receiver25", sender_address="104 Broadway, San Diego, California", sender_name="Sender99", state="California", timestamp="2025-06-09T17:04:10.228490Z"}             {"timestamp": "2025-06-09T17:04:10.228490Z", "state": "California", "city": "San Diego", "package_id": "PKG24170", "package_type": "Electronics", "package_size": "Large", "package_status": "critical", "note": "Delivered successfully", "sender": {"name": "Sender99", "address": "104 Broadway, San Diego, California"}, "receiver": {"name": "Receiver25", "address": "900 Oak St, Los Angeles, California"}, "mail_house_id": "DEPOT-01"}
#...(略)

###
