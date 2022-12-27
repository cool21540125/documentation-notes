
# RabbitMQ join Cluster

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
```


# 查詢 RabbitMQ

```bash
### 查看 Node 狀態
$# rabbitmqctl status


### Version
$# rabbitmqctl version
3.10.7


### 
$# 
```


# Exchange 與 Queue

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


### 列出 Queues
$# rabbitmqctl list_queues
Timeout: 60.0 seconds ...
Listing queues for vhost / ...
name    messages
hello   1
# 這邊可以看到 QueueName, 及其含有多少 Messages 尚未處理


### 
$# 
```


# RabbitMQ 用戶 & 權限

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
