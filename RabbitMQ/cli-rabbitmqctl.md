
# Cluster && Status && Connections && Channels

- RabbitMQ Cluster 裡頭的 Nodes, 至少比需要有一台是 `Disk Node` (其餘可為 `RAM Nodes`)
- 

```bash
### (其中兩台 RabbitMQ Nodes)
$# rabbitmqctl stop_app
$# rabbitmqctl reset
$# rabbitmqctl join_cluster --ram rabbit@mq1
# 可以是 --ram 或 --disk(或 --disc)

$# rabbitmqctl start_app
$# rabbitmqctl cluster_status


### 查看 Node 狀態
$# rabbitmqctl status


### Version
$# rabbitmqctl version
3.10.7


### 列出 Channels
$# rabbitmqctl list_channels
Listing channels ...
pid     user    consumer_count  messages_unacknowledged
<rabbit@event-driven-rabbitmq-1.event-driven-rabbitmq-headless.ele-rabbitmq.svc.cluster.local.1672821890.22819.1>       user    0       0
<rabbit@event-driven-rabbitmq-1.event-driven-rabbitmq-headless.ele-rabbitmq.svc.cluster.local.1672821890.22834.1>       user    1       0
...
# 
```


# Exchange && Queue && Consumer

```bash
### 列出所有 exchanges
$# rabbitmqctl list_exchanges
Listing exchanges for vhost / ...
name    type
amq.rabbitmq.trace      topic
amq.direct      direct
amq.headers     headers
amq.topic       topic
amq.fanout      fanout
        direct               # 此為 default (unnamed) exchange
amq.match       headers
# 


### list bindings - 列出現存的 bindings (exchange 與 queue 之間的關係)
$# rabbitmqctl list_bindings


### 查詢特定 vhost 的所有 consumers
$# rabbitmqctl list_consumers -p '/game/sg001'
Listing consumers on vhost /game/sg001 ...
app1         <mq1@mq1.2.1554.0>      ctag2.972fffd4fe23049ad361db299b1834dc  true   10  []
app1         <mq1@mq1.2.1419.0>      ctag2.241b42bc13a43921be019d2ddf3f5302  true   10  []
game.sg001   <mq1@mq1.2.1560.0>      ctag3.f7f58a3d7b4e932dbeae2354f9aa3cef  true   10  []
game.sg001   <mq1@mq1.2.1425.0>      ctag3.adbb4ba2d2325b1844d697a7e4daee26  true   10  []
app1.daemon  <mq1@mq1.2.1548.0>      ctag1.0e2932e01eae88ff1843395cb6e956ae  true   10  []
app1.daemon  <mq1@mq1.2.1413.0>      ctag1.4756e3ee9e6c6b6ed9e9330e7ce998d1  true   10  []


### 刪除上述的 consumer connection
$# rabbitmqctl close_connection "<mq1@mq1.2.1413.0>" "(delete reason)"
# 但實測發現會有些問題(有待驗證)

```


# User && Auth

```bash
### 列出所有用戶
$# rabbitmqctl list_users --formatter=json
[
    {"user":"app_user","tags":["management"]},
    {"user":"guest","tags":["administrator"]}
]


### 新增用戶
$# rabbitmqctl add_user 新帳號 "密碼"


### 授予權限
$# rabbitmqctl set_permissions -p V-HOST 帳號 EXCHANGE WRITE READ
$# rabbitmqctl set_permissions -p / 帳號 ".*" ".*" ".*"


### 變更 Permission
$# rabbitmqctl set_user_tags 新帳號 權限標籤


### 變更密碼
$# rabbitmqctl change_password guest "設定新的密碼"
```
