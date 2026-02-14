# TraceQL

A span has a duration of over one second on the same span that has a specific attribute.
{.service.namespace = "prod" } | max(duration) > 1s
The trace has a certain number of a given attribute in any namespace.
by(.service.namespace) | {.http.status_code = 500 } | count() > 3
A trace has an ancestor/descendant pair with a specific set of attributes.
{service. namespace = "test" } >> {.service.namespace = "ops" }
A trace sees network latency > 1s when passing between any two services.
{ parent.service.name != service.name } | max(parent.duration - duration) › 1s

```sh
## 特定 Service, 4xx & 5xx, 列出他們的 path
{ resource.service.name = "mythical-requester" && span.http.status_code >= 400 } | select(span.http.target)

## 特定 Service, 4xx & 5xx, 列出他們所有 childrens (不分層級), intrinsic status 為 error && DB 查詢並非已 INSERT 開頭的 spans
{ resource.service.name = "mythical-requester" && span.http.status_code = 500 } >> { status = error && span.db.statement !~ "INSERT.*" }

##

```


# TraceQL 與 PromQL

```sh
## PromQL
## 比較 TraceQL 與 PromQL
{resource.service.name="dilt-demo-prod" && kind=server} | rate() by (resource.service.name)
# 上為 TraceQL, 下為 PromQL
sum by (service_name)(rate(traces_spanmetrics_calls_total {service_namespace="ditl-demo-prod", span_kind="SPAN_KIND_SERVER"}[2m]))

## OrderService 當中, Spans 數量為 2 的 Traces
{service.name="OrderService"} | count()=2

## OrderService 當中, 任意一個 Span > 200 ms
{service.name="OrderService"} | avg(duration)>200ms

## OrderService && span.server.address 為 localhost, 任意一個 Span > 200 ms
{service.name="OrderService" && .server.address="localhost"} | avg(duration)>200ms
```
