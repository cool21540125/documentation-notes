# Notification template

- [Notification template reference](https://grafana.com/docs/grafana/latest/alerting/configure-notifications/template-notifications/reference/#notification-template-reference)
- 由於 notification 是針對 group alerts 做發送, 因此裡頭的 `Alerts` 包含了所有 alerts 資訊

### Notification Data && Alert

| Notification Data  | Type      | Description                                               |
| ------------------ | --------- | --------------------------------------------------------- |
| Receiver           | string    | contact point name                                        |
| Status             | string    | `firing` or `resolved`                                    |
| Alerts             | []Alert   | firing and resolved alerts                                |
| Alert.Status       | string    | `firing` or `resolved`                                    |
| Alert.Labels       | KV        | a set of labels of alert                                  |
| Alert.Annotations  | KV        | a set of annotations of alert                             |
| Alert.StartsAt     | time.Time | alert started firing time                                 |
| Alert.EndsAt       | time.Time | alert ended firing time                                   |
| Alert.GeneratorURL | string    | backlink to alert                                         |
| Alert.Fingerprint  | string    | fingerprint to alert                                      |
| Alerts.Firing      | []Alert   | firing alerts                                             |
| Alerts.Resolved    | []Alert   | resolved alerts                                           |
| GroupLabels        | KV        | labeld grouped based on `group_by` option                 |
| CommonLabels       | KV        | labels common to all alerts                               |
| CommonAnnotations  | KV        | annotations common to all alerts                          |
| ExternalURL        | string    | link to Grafana or Alertmanager                           |
| GroupKey           | string    | key of alert group                                        |
| TruncatedAlerts    | integer   | number of alerts that were truncated (Webhook and OnCall) |

### KV && KV methods

```go
type KV map[string]string

{
  summary: "alert summary",
  description: "alert description",
}

func SortedPairs() []KV {}
func Remove(s []string) KV {}
func Names() []string {}
func Values() []string {}
```

### Strings

| Name             | Arguments                  | Returns                                      |
| ---------------- | -------------------------- | -------------------------------------------- |
| title            | string                     | strings.Title 首字大寫                       |
| toUpper          | string                     | strings.ToUpper 全大寫                       |
| toLower          | string                     | strings.ToLower 全小                         |
| trimSpace        | string                     | strings.TrimSpace 移除前後空白               |
| match            | pattern, string            | Regexp.MatchString 使用 Regexp match string  |
| reReplaceAll     | pattern, replacement, text | Regexp.ReplaceAllString 未定錨正規表達式替換 |
| join             | sep string, s []string     | strings.Join                                 |
| safeHtml         | text string                | html/template.HTML                           |
| stringSlice      | ...string                  | return slice of strings                      |
| date             | string, time.Time          |
| tz               | string, time.Time          |
| since            | time.Time                  | time.Duration                                |
| humanizeDuration | number of string           | human-readable string duration               |

```go
{{ define "slack." }}

{{ end }}
```
