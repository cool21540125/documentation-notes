# AlertManager

- [Alertmanager 的 Routing tree editor](https://prometheus.io/webtools/alerting/routing-tree-editor/)
- [Step-by-step guide to setting up Prometheus Alertmanager with Slack, PagerDuty, and Gmail](https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/)

# Alertmanager configuration

alertmanager 最根本的工作就只是把 alerts 發送給 receivers, 至於 alerts 應該要如何分配(route) 給 recreivers, 便是 alertmanager configuration 的學習重點, 因而 `route` 及 `receiver` 都是 alertmanager 最頂層的配置.

configuration 配置頂層架構如下:

```yaml
global:

templates:

route:

receivers:

inhibit_rules:

mute_time_intervals:

time_intervals:
```

## 1. Routing

### 關於 Matchers

```yaml
### 這是 route 的最單純範例 - 如果 alert label 符合此規則, 那就發送給 "default" receiver
- receiver: "default"
  matchers:
    - "env = prod"
# matchers 的配置, 避免使用單引號:
#    例如: env = 'production'
#   意味著 {env="'production'"}
```

```yaml
### matchers 的部分, 需要全部符合, 才符合此 "special" receiver
# 可接受的寫法, 可以使用  =  !=  =~  !~
- receiver: "special"
  matchers:
    - "env = special"
    - "namespace != default"
    - "team =~ (devops|sre)"
    - "service !~ ^(api.+)"
# WARNING: 早期會有 match 及 match_re, 現在已經 DEPRECATED; 現在都用 matchers 吧!!
```

### 關於 Subroutes

```yaml
### alertmanager 會有個 top-level route, 作為 default route (也就是此範例的 "fallthrough")
# NOTE: 此範例有 3 個 Receivers

route:
  receiver: "fallthrough"
  routes:
    - receiver: "slack"
      matchers:
        - "team = devops"
      routes:
        - receiver: "email"
          matchers:
            - "env = prod"
## Alert Label Set 對應的 Matched Receiver
# {env="prod", team="devops"} 對應到 email
# {env="test", team="devops"} 對應到 slack
# {env="prod", team="sre"}    對應到 fallthrough
```

```yaml
### 如果需要將特定 alert 發送給多個 receivers, 則可考慮使用 continue
# NOTE: 此範例有 4 個 Receivers
route:
  receiver: "fallthrough"
  routes:
    - receiver: "slack"
      continue: true
      matchers:
        - "team = devops"
      routes:
        - receiver: "pagerduty"
          matchers:
            - "env = prod"
    - receiver: "default"
      matchers:
        - "env = prod"
        - "namespace != default"
        - "team =~ (devops|sre)"
        - "service !~ ^(api.+)"
## WARNING: 將此範例拿去問 Grok3 / Claude / ChatGpt / Gemini v.s. 作者給出的解答, 得到了 4 種不同的答案
## Alert Label Set 對應的 Matched Receiver
# {env="prod", team="devops"} 對應到 pagerduty, default
# {env="test", team="devops"} 對應到
# {env="prod", team="sre"}    對應到
```

### 關於 Alert grouping

- 關於 alertmanager 的 grouping, 有底下的配置參數需要留意到 (我順便把其他關聯參數放進來一起比較):
  - group_by
  - group_wait (default 30 secs) : 第一個 alert 出現以後, 再等一段時間, 等待其他 alerts 上車後, 再發送給 receivers
  - group_interval (default 5 mins) : 下一次 send alert 的時間需要與前一次 send alerts 的第一次 alert 之間的時間間隔
  - repeat_interval (default 4 hrs) : 同樣的 alerts re-sent 給 receivers
  - mute_time_intervals
  - active_time_intervals

```
o   o               o                    o       o        o
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|> time
      |     1m          2m          3m          4m          5m          6m
      |                                                     |
      |                                                     v
      v                      send 4 alerts + 2 alerts Resolved 的部分
   send 2 alerts

NOTE: o 表示 alert
```

```yaml
### 任何 alert 只要匹配到這個 group_by 的 labels (全部都要匹配到), 就會被 grouped
route:
  receiver: "fallthrough"
  group_by: ["alertname", "service", "environment"]
```

```yaml
### 善用 time intervals, 可以管控哪些時段才會接收到 alerts
# WARNING: 需要留意到, alerts 的 firing 與 resolve 都會同時受到影響
route:
  receiver: "fallthrough"
  routes:
    - receiver: "slack"
      continue: true
      matchers:
        - "team = devops"
      active_time_intervals:
        - business_hours
time_intervals: # 如果有使用到 active_time_intervals 或 mute_time_intervals 的話, 就必須要有這個
  - name: business_hours
    time_intervals:
      - weekdays: ["Monday:Friday"]
        times:
          - start_time: 09:00
            end_time: 17:00
        location: "Asia/Taipei"
  - name: example
    time_intervals:
      - weekdays: ["monday:thursday", "friday"]
        days_of_month: ["1:31"] # 例如 [-3:-1] 表示當月最後 3 天
        months: ["1:6", "july:december"]
        years: ["2022:2048", "2049"]
        times:
          - start_time: 09:00
            end_time: 17:00
        location: "Asia/Taipei"
```

## 2. Receivers

```yaml
###
receivers:
  - name: "sre"
    slack_configs:
      - channel: "#alerts"
        api_url: "https://hooks.slack.com/services/ZZZZZZZZZZZZZZZ"
    pagerduty_configs:
      - routing_key: "XXXXXXXXXXXXXXX"
# 所有的 receivers 基本上配置都不一樣, 需要個別讀文件, 不過有 2 個參數基本上都是共用的:
#  - send_resolved (default true) : 例如 Linux OOM 發生了, 但解決了以後不怎麼需要通知
#  - http_config                  : 發送通知的 Endpoint 啦!
```

## 3. Inhibitions

具體範例像是, DataCenter 停電了, 那麼網路連線必然異常, 服務必然中斷. 僅需做最大方向性的告警即可. 不用啥告警都噴出來, 看了會累死

告警系統的 inhibition 屬於比較進階的配置, 玩起來真的很複雜 @@"

```yaml
inhibit_rules:
  - source_matchers:
      - severity="critical"
    target_matchers:
      - severity=~"warning|info"
    equal:
      - namespace
      - alertname
```

```yaml
### 例如 DataCenter 網路掛了, 則 Service1 及 Service2 必然 offline (無需 svc 告警, 僅需 DC 告警)
inhibit_rules:
  - source_matchers:
      - severity="critical"
      - alertname="dcOffline"
    target_matchers:
      - severity="warning"
      - alertname=~"svc1Offline|svc2Offline"
    equal:
      - datacenter
```

## 4. Validating

- alertmanager 配置寫好了一後, 是一包很大包的 yaml, 善用工具來做檢測: `amtool`

# Alertmanager templating

```yaml
### alertmanager 的頂層配置, 告知 Template 位置
templates:
  - /path/to/my/template.tmpl
  - /other/path/*.tmpl

### 模板內容範例:
annotations:
  description: Configuration failed to load for
    {{ $labels.namespace }}/{{ $labels.pod}}.
```

```yaml
### 如果沒指名 Template, 會用預設的 `__subject template` 來做解析
{{ define "__subject" }}[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .GroupLabels.SortedPairs.Values | join " " }} {{ if gt (len .CommonLabels) (len .GroupLabels) }}({{ with .CommonLabels.Remove .GroupLabels.Names }}{{ .Values | join " " }}{{ end }}){{ end }}{{ end }}

# 上面這長長一串, 換行後:
{{ define "__subject" }}
  [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}]
  {{ .GroupLabels.SortedPairs.Values | join " " }}
  {{ if gt (len .CommonLabels) (len .GroupLabels) }}
    (
    {{ with .CommonLabels.Remove .GroupLabels.Names }}
      {{ .Values | join " " }}
    {{ end }}
    )
  {{ end }}
{{ end }}

# 中括號那部分, 只是在計算 alert 筆數, ex: [FIRING:4]
# 加上 Group labels 以空格展開, ex: [FIRING:4] production api us-east-1
# NOTE: 後面的 CommonLabels 我還不了解是什麼....
```

```yaml
### 這是個 Slack 的範例 Template
{{ define "slack" }}
  {{- range .Alerts.Firing }}
    [FIRING] - {{ .Annotations.description }}
  {{- end }}
  {{- range .Alerts.Resolved }}
    [RESOLVED] - {{ .Annotations.description }}
  {{- end }}
{{ end }}
# 例如 CPU 及 Memory 都達到告警門檻:
#   {alertname="HighCPU", instance="server1", description="CPU usage on server1 exceeds 90%"}
#   {alertname="HighMemory", instance="server1", description="Memory usage on server1 exceeds 85%"}
#
# 第一次告警
#  CPU 部分: [FIRING] - CPU usage on server1 exceeds 90%
#  Mem 部分: [FIRING] - Memory usage on server1 exceeds 85%
#
# 第二次告警 (假設 CPU 正常了)
#  CPU 部分: [FIRING] - Memory usage on server1 exceeds 85%
#  Mem 部分: [RESOLVED] - CPU usage on server1 exceeds 90%
```
