# Grafana Notifications

- Grafana Notifications 主要分成 3 個部分:
  - Contact points
  - Notification policies
    - Group wait (default 30s) : Group alert 發送首次 notification 之前的等待時間
    - Group interval (default 5m) : alert group 變動後再次發送 notification 之前的等待時間
    - Repeat interval (default 4h) : alert group 沒異動, 再次發送相同 notification 之前的等待時間
  - Grouping
    - Group rule 可配置 Evaluation interval
      - 但該 Group rule 的 Evaluation interval 必須要 >= alert rules 的 pending period

# Contact points

# Notification policies

# Grouping

- Notification grouping 主要目的: 將不同的告警資訊彙整到同一次通知當中, 減低告警疲乏
- Notification grouping 實現方式: 位於 Notification policy 藉由 labels 分組

# 關於 Grafana 的 alert rules 底下這堆東西超容易搞混

## Alert rules

- Grafana 的任何一個 `alert rule`, 都必須要歸屬在一個 `Folder(Rule group)` 當中
  - Folder 會有個 `Evaluation interval`, 用來控制該 group 內的所有 `alert rules` 評估 `Alert states` 的變更 (ex: Pending -> Alerting)
    - `Folder 的 Evaluation interval` 必須 >= `Alert rule 的 Pending period`
- `Alert rule` 細部設定:
  - `Options.Interval` : 用來控制該 `Alert rule` 到 `Datasource` 抓取 `data points` 的頻率 (建議可設定為 1m)
  - `Period` : `Alert rule` 用來計算 `data points` 的時間窗口(duration) (也就是做 aggregation 的時段啦)
  - `Pending period` : 用來控制 `Alert rule` 達到 threshold 必須要超過多久才進入 `Alerting state`
  - `Keep firing for` : 用來控制 `Alert rule` 脫離 threshold 必須要超過多久才進入 `Resolved state`

## Notification Policy

- Group wait : (30s)
- Group interval : (5m)
- Repeat interval : (4h)
