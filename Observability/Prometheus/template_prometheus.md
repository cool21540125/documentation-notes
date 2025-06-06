

# Prometheus Template - Functions

除了 [Golang 預設的 Templates](https://pkg.go.dev/text/template)提供的 default [Functions](https://pkg.go.dev/text/template#hdr-Functions) 以外

Prometheus Templates 有額外支援底下的 Functions 方便查找


```go
// time series data 基礎結構
type sample struct {
  Labels map[string]string
  Value  interface{}
}
```


## Queries

```go
// 查詢 DB 不支援 return range vectors
func query(queryString str) []sample


// (不解釋)
func first(s []sample) sample


// 等同於 `index sample.Labels label`
func label(l label, s sample) string


// 等同於 `sample.Value`
func value(s sample) interface{}


// 依照特定 label 排序 samples
func sortByLabel(l label, s []samples) []sample
```


## Numbers

```go
// v 可為 number | string

// to [metric prefixs] - https://en.wikipedia.org/wiki/Metric_prefix
func (n *Numbers) humanize(v interface{}) string


// to 1024 based
func (n *Numbers) humanize1024(v interface{}) string


// to seconds
func (n *Numbers) humanizeDuration(v interface{}) string


// to 100%
func (n *Numbers) humanizePercentage(v interface{}) string


// to Unix ts
func (n *Numbers) humanizeTimestamp(v interface{}) string


// `Unix ts` to time.Time
func (n *Numbers) toTime(v interface{}) *time.Time
```


## Strings

```go
// each word 字首大寫
func (s *String) title(s string) string


// 
func (s *String) toUpper(s string) string


// 
func (s *String) toLower(s string) string


// 將 net.SplitHostPort 捨棄 port 部分, 僅回傳 host
func (s *String) stripPort(s string) string


// regexp.MatchString
func (s *String) match(p Pattern, text string) boolean


// Regexp.ReplaceAllString
func (s *String) reReplaceAll(p Pattern, replacement string, text string) string


// Returns path to graph view in the expression browser for the expression.
func (s *String) graphLink(expr string) string


// Returns path to tabular ("Table") view in the expression browser for the expression.
func (s *String) tableLink(expr string) string


// Parses a duration string such as "1h" into the number of seconds it represents.
func (s *String) parseDuration(s string) float


// Removes the domain part of a FQDN. Leaves port untouched.
func (s *String) stripDomain(s string) string
```


## Others

- args
- tmpl
- safeHtml
- externalURL
- pathPrefix


# Template type differences


## Alert field templates

- `.Value`          : `$value`  
- `.Labels`         : `$labels`  
- `.ExternalLabels` : `$externalLabels`  the globally configured external labels
- `.ExternalURL`    : `$externalURL`     取值自 `--web.external-url XXX`


## Console templates

無感... PASS


# misc

## rules_alert.yml

- `{{ $labels.<labelName> }}`    可取得 label name
- `{{ $value }}`                 可取得該值


## alertmanager.yml 

- `{{ .CommonLabels.alertname }}`                                可取得 alert rule file 的 alert name
- `{{ range .Labels.SortedPairs }}• *{{ .Name }}:* {{ .Value }}` 可取得 alert rule file 的 alert 的 labels(key value pairs)
- `{{ .Annotations.summary }}`                                   可取得 alert rule file 的 annotations.summary
- `{{ .Alerts.Firing }}`                                         可取得 alert 的詳細資訊

```yaml
alert_name: {{ .CommonLabels.alertname }}
alert_labels: >-
  {{ .CommonLabels.job }}
  {{- if gt (len .CommonLabels) (len .GroupLabels) -}}
    {{" "}}(
    {{- with .CommonLabels.Remove .GroupLabels.Names }}
      {{- range $index, $label := .SortedPairs -}}
        {{ if $index }}, {{ end }}
        {{- $label.Name }}="{{ $label.Value -}}"
      {{- end }}
    {{- end -}}
    )
  {{- end }}
# (alertname="mongodb_dead", name="mongo", severity="fatal")
```