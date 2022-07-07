AWS Certificated Solutions Architect Associate

SAA-C02


# EC2


## EC2 Hibernate

- 有點像是, 把 Instance Stop, 就像一般電腦睡眠一樣, RAM state 被保留
    - 加速下次開機時間(OS never stop)
- cross OS
- hibernation period < 60 days (無法長久 hybernate)


# HA && Scalability: ELB && ASG

- ELB 的 Sticky Session(Session Affinity) 相關問題
    - ALB, CLB 皆可處理此情境
    - client by `cookie`
        - Application-based Cookie
            - APP(a.k.a. Target) 自行產生, 可有任意客制屬性
            - Target Group 必須為此 Cookie Name 自行取名字, 但底下名字保留不可使用:
                - AWSALB, AWSALBAPP, AWSALBTG
        - Duration-based cookie (Load balancer generated cookie)
            - LB 產生特定時間到期的 Cookie, Cookie name 為
                - AWSALB for ALB
                - AWSELB for CLB
- ELB - Cross Zone Load Balancing
    - ALB
        - 預設 enabled, 且無法 disabled (always on)
        - AZ 內資料傳輸免錢
    - NLB
        - 預設 disabled
        - 若啟用, AZ 內傳輸要課金
    - CLB
        - 預設 disabled
        - AZ 內資料傳輸免錢


### With Cross Zone Load Balancing

```mermaid
flowchart LR

subgraph az1
    direction TB;
    ec0["instance 10"];
    ec1["instance 10"];
end
subgraph az2
    direction TB;
    ec2["instance 10"]; ec3["instance 10"]; ec4["instance 10"]; ec5["instance 10"];
    ec6["instance 10"]; ec7["instance 10"]; ec8["instance 10"]; ec9["instance 10"];
end

client -- 50 --> az1;
client -- 50 --> az2;
```


### Without Cross Zone Load Balancing

```mermaid
flowchart LR

subgraph az1
    direction TB;
    ec0["instance 25"];
    ec1["instance 25"];
end
subgraph az2
    direction TB;
    ec2["instance 6.25"]; ec3["instance 6.25"]; ec4["instance 6.25"]; ec5["instance 6.25"];
    ec6["instance 6.25"]; ec7["instance 6.25"]; ec8["instance 6.25"]; ec9["instance 6.25"];
end

client -- 50 --> az1;
client -- 50 --> az2;
```


## Elastic Load Balalnce, ELB

- 目前有 4 種 Load Balance
    - Classic Load Balancer, CLB (Since 2009)
        - L4 && L7 : HTTP, HTTPS, TCP, SSL(secure TCP)
    - Application Load Balancer, ALB (Since 2016)
        - L7 : HTTP, HTTPS, WebSocket, HTTP/2
        - ALB 後為 *Target Group*(也會處理 *Health Check*), 裡面可以放置:
            - EC2 instances
            - ECS tasks
            - Lambda functions
            - private IP (可以是 On-premise Data Center Servers)
        - Target 接收到 Request 後, 可由 Header 中的
            - `X-Forwarded-For` && `X-Forwarded-Port` && `X-Forwarded-Proto` 
            - 看到用戶真實 IP && Port && Protocol
        - 可依照不同的 *routing tables(hostname)* && *query string* && *HTTP Header*
            - 將請求送往後端不同的 Target Groups
            - CLB 則無此功能(需要設很多 CLB, 才能做對應流量轉發)
        - 對於 ECS 支援 dynamic port mapping
    - Network Load Balancer, NLB (Since 2017)
        - L4 : TCP, UDP, TLS(secure TCP)
        - high performance, latency ~= 100ms (相較於 ALB ~= 400ms)
        - 配置以後, 同時提供 *DNS Name* && *Elastic IP* 來訪問
            - 相較之下, CLB && ALB, 只有 *DNS name*
        - NLB 後面的 *Target Group*, 裡頭可以是:
            - EC2 Instance
            - private IP Address
            - ALB
        - 細節
            - NLB 在每個 AZ 都有個 static IP (也可支援 assign Elastic IP)
            - 需要課金才能使用
            - NLB 僅作流量轉發, 因此後端的 SG 看到的請求皆來自 Client (而非NLB), 因此需要 allow HTTP 0.0.0.0
    - Gateway Load Balancer, GWLB (Since 2020)
        - deploy / scale / manage 第三方 network virtual app in AWS
        - L3 : IP
        - GENEVE protocol : port 6081
        - 結合了 2 種功能
            - Transparent Network Gateway
            - Load Balancer
- AWS Load Balancer 整合了一堆 AWS Services:
    - EC2, EC2 ASG, ECS, ACM, CloudWatch, Route53, AWS WAF, AWS Global Accelerator, ...
- 兼具 Health Check 功能

```mermaid
flowchart LR

subgraph tg1["Target Group"]
    t1["EC2"]
    t2["EC2"]
end

client -- SG1 --> ALB;
ALB -- SG2 --> tg1;
```
```mermaid
flowchart TB

subgraph tg2["Target Group"]
    t3["3rd Party Security Virtual App"]
end

client -- SG2 --> GLB;
GLB <--> tg2;
GLB --> app;
```


### SSL/TLS for ELB

- client 與 LB 之間的 in-flight encryption
- Public Certificate Authorities, CA
    - Comodo, Symantec, GoDaddy, GlobalSign, Digicert, Letsencrypt, ...
- LB 使用 X.509 certificate (SSL/TLS server certificate)
    - 可使用 ACM, AWS Certificate Manager 來託管


#### SNI, Server Name Indication

- 解決了 loading multiple SSL Certs onto one web server (也就是一台主機提供多個站點啦)
- 此為新一代的 protocol, 客戶需告知 hostname of the target server in the initial SSL handshake
    - AWS 僅 ALB && NLB && CloudFront 支援
- LB 上頭使用 SNI 的話, 可以對應不同 TG, 使用不同的 SSL
    - 相對來說, 一個 CLB 只能使用一個 SSL


### ELB - Connection Draining

- 對於即將進行 maintenance 或 scale down 的 instance, 在此狀態下, 可避免立即下線 && 避免新流量進入此 instance
    - 可藉由 *draining connection parameter* 調整, 1~3600 secs. 預設 300 secs
- 有不同的稱呼
    - 使用 CLB, 稱之為 Connection Draining
    - 使用 ALB && NLB, 稱之為 Deregistration Delay


## Auto Scaling Group, ASG

- 針對後端 instance 做 scale out 或 scale in
    - 自動對後端的 Load Balancer 註冊新的 instance
    - ASG 對後端有問題的 instance 執行 terminate (if unhealthy)
        - ALB 則是幫忙做 health check (取代原有的 EC2 status check)
            - 若不健康, ALB 標記為 unhealthy, ASG 再來 terminate && create
- 服務免費, 對後端 Resource 收費
- ELB 能對 ASG 內的 instance 做 Health Check 
    - (疑問, 這個不是 Target Group 做的嗎?)
- 建立 ASG 時, 需先建立 *Launch Template* (舊名詞為 *Launch Configuration*, 但已 Deprecated)
    - 裡頭包含了建立 EC2 instances 的相關必要資訊
        - AMI, Instance Type, EC2 User Data, EBS Volumes, SG, SSH Key, Network, ELB info, ...
    - 需配置 Min Size && Max Size && Initial Capacity && Scaling Policies
        - ASG Scaling Policy 依賴於 **CloudWatch Alarms**
            - 監控特定的 Metrics
    - 比較 *Launch Template* && *Launch Configuration*
        - 兩者一樣都是用來定義 EC2 建置時的必要參數
        - 舊版的 *Launch Configuration* 
            - ex: 修改裡頭參數時, 都需要 重建 instance
        - 新版的 *Launch Template* 
            - 可有不同版本
            - 配置可做 partial configuration(可繼承). 建立 parameter subsets
            - 支援 On-Demand && Spot instance
- 有兩種 Scaling 的機制
    - Dynamic Scaling Policies, 又有分為 3 種:
        - Target Tracking scaling
            - 最簡單. 只需設定個 baseline
            - ex: 直接設定 average ASG CPU 都維持在 50%
        - Simple Scaling / Step Scaling
            - 藉由 **CloudWatch Alarm** 來做 trigger
            - ex: ASG CPU < 40% 執行 scale in && ASG CPU > 70% 執行 scale out
        - Scheduled Actions
            - 設定特定時段來做 scaling out && scaling in
    - Predictive Scaling
        - auto-scaling service 會持續監控 loading, 預測趨勢來做 scaling
        - 背後借助 ML, 因此可免人工配置相關準則...
- Scaling Policy 還有個叫做 *Cooldown* 的機制, 預設 300 secs. 避免 scaling 機制接連被觸發
- ASG 的 Default Termination Policy(最單純)
    - 會找出不同 AZ 之間, 裡頭最多 instance 的地方, 對裡頭最舊的 instance 做 terminate
- [ASG Lifecycle Hooks](https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks-overview.html)
    - ASG 針對 Instance 做 scale (create 或 terminate), 我們可以針對他作業的 Lifecycle 去做 hook
    - 基本流程為:
        - scale out : Pending --> (Pending:Wait --> Pending:Proceed) --> InService
        - scale in  : Terminating --> (Terminating:Wait --> Terminating:Proceed) --> Terminated
    - ex: 機器關機之前, 要把裡頭的配置取出來 OR 機器建置時, 要再額外安裝東西...

```mermaid
flowchart TB

ww["CloudWatch Alarm"]

subgraph ASG
    direction TB;
    ec1["EC2"]
    ec2["EC2"]
end

user --> ELB;
ELB -- "health \n && \n traffic" --> ASG;
ww -- "監控 metric \n && \n trigger scaling" --> ASG;
```


# SQS, SNS, Kinesis, ActiveMQ

## SQS, Simple Queue Service

- 服務特色
    - Queue Model. Producer Send && Consumer poll
    - 無 messages 的數量限制
    - Latency < 10 ms
    - message 可能會被 read > 1 次
    - 可重複 Deliver Message (因此, coding 時應考慮這個)
    - 盡力而為的維持 Message 順序, 但不保證, 除非使用 FIFO SQS
    - Consumer 一次可拉 10 個 messages
    - message 可存活 1 min ~ 14 days
    - 每個 message 最大 256 KB
    - SQS 可搭配 ASG (讓 EC2(Consumer) in it), 來達到 Auto Scaling
        - **CloudWatch Metric** 監控 **SQS Queue**
            - Queue Length (`ApproximateNumberOfMessages`)
            - Queue Length / Number of Instances
        - **CloudWatch Metric** Alarm for breach **CloudWatch Alarm**, 來對 ASG 做 Auto Scaling
        - 需設定兩條規則, 分別做 Scaling up && Scaling down
    - SQS - Queeu Access Policy
        - 類似 S3 的 Resource Policy
    - SQS - Message Visibility Timeout (預設 30s)
        - 如果 Consumer 無法在既定時間內完成的話, 可考慮調大它
        - Consumer 在此時間內處理不完的話, 會再次放回 SQS, 因此 Message 可能被多次 Read
            - 若 Read 次數過多, 應考慮使用 SQS - Dead Letter Queue, DLQ
        - 使用 `ChangeMessageVisibility API` 調整 timeout
    - SQS - Dead Letter Queue, DLQ
        - 藉由調整 Source SQS Queeu 的 `MaximumReceives`, 超過此 Read time, 則放入此
        - 後續 Developer 在針對此裡頭的 Message debugging
        - 需要給 SQS Queue permission 來 write
    - SQS - DelayQueue
        - default: 0 (max 15 mins)
        - 過多久後再傳送到 Queue
    - SQS - Long Polling
        - default: 0 (range 0 ~ 20 s)
        - Consumer 可設定此參數, 減少 API call 的次數
        - 可在兩個地方設定　
            - Queue Level
            - API Level (設定 `WaitTimeSeconds`)
    - SQS - Request-Response System
        - Producer 送 Message 可告知 Reply 位置, 將來 Consumer 處理完後, 會放到 Reply 指定的 SQS Queue
    - SQS - FIFO Queue
        - 保證 FIFO, 但有限制:
            - 300 Messagess/sec (without Batching)
            - 3000 Messages/sec
        - 具備 *Exactly-once send capability* (一次性發送, 可去除重複)
        - Naming 需要 ".fifo" 結尾
        - 可設定兩個參數來去除重複
            - Message Group
            - Message Deduplication
- Encryption
    - in-flight Encryption: 傳輸 message 的過程, 預設已有加密(HTTPS API). 
    - Server Side Encryption: 也可額外設定這個, 來再次加密
        - by "KMS key"
- Access Control
    - by IAM Policies
    - by SQS Access Policies
        - 等同於 S3 Bucket Policy
        - 可 Cross Account
            - SQS Policy 需 allow action: `["SQS:ReceiveMessage"]`
        - 可 Cross AWS Services
            - ex: SNS, S3 events, 來寫入 Message -> SQS
                - 檔案上傳到 S3 以後, 自動 trigger, SendMessage -> SQS
                    - SQS Policy 需 allow action: `["SendMessage"]`
- API
    - Producer 藉由 
        - SendMessage API 發送 Message
    - Consumer 藉由 
        - ReceiveMessage API 拉 Message
        - DeleteMessage API 將已處理好的 Message 移除
- 使用範例
    - ```mermaid
        flowchart TD;
        api[API request];
        app["Web App(with ASG)"];
        trans["Video Transcoding App(with ASG)"];

        api -- request --> app;
        app -- SendMessageAPI --> sqs;
        sqs -- ReceiveMessageAPI --> trans;
        trans -- Store --> S3;
        ```


## SNS, Simple Notification Service

- 不同於 SQS, 可設定多個 Receivers
- Pub/Sub Pattern
- up to 1250w 個 Subscribers
- up to 10w 個 Topics / account
- 基本資訊可參考[CLF-SNS](./cert-CLF_C01.md)
- 一堆 AWS Services 都可 publish 到 SNS (using SDK)
- SNS 可 publish 到
    - AWS Services
    - HTTP(S)
    - SMS && mobile Notification
    - Emails
- Security
    - 同 SQS, 傳輸中加密, 也可額外設定 Server Side Encryption
    - Access Control, 核心為 IAM
    - SNS Access Policy
        - 同 S3, SQS. 也可設定 Resource Policy, Cross Account && Cross AWS Services
    - 搭配 SQS, 做 fan out
        - SQS 需 allow SNS write
        - ```mermaid
            flowchart TD;
            buy["Buying Service"];
            f["Fraud Service"];
            s["Shipping Service"];

            buy -- pub --> SNS;
            SNS -- sub --> SQS1;
            SNS -- sub --> SQS2;
            SQS1 -- Receive --> f;
            SQS2 -- Receive --> s;
          ```
    - SNS 也可直接整合 AWS **Kinesis Data Firehose, KDF**
        - load streams into S3, RedShift, OpenSearch(前身 ElasticSearch)
    - SNS 也可做 FIFO
        - 可去重複
        - 具有 content-based ID && deduplication ID 來設定唯一
        - naming 結尾 ".fifo"
        - 至今只有 SQS FIFO 可 Read SNS FIFO
    - SNS - Message Filtering
        - 讓 SNS Topic subscription 用來 filter message 的 JSON Policy
            - 只允許取得特定欄位給訂閱者 (而非全部欄位都給)


## Kinesis

- 即時 collect && process && analyze Streaming data
    - ex: app logs, metrics, Web Click streams, IOT telemetry data
    - 用來即時 蒐集, 處理, 分析 串流資料
- Kinesis 用 Partition ID 作為 PK
    - 相同的 Partition ID 資料, 會進入到相同的 Shard
- Kinesis 家族服務:
    - Kinesis Data Streams
        - capture, process, store data streams
    - Kinesis Data Firehose
        - load sata stremas -> AWS data stores
    - Kinesis Data Analytics
        - analyze data streams with SQL or Apache Flink
    - Kinesis Video Streams
        - capture, process, store video streams


### Kinesis Data Streams, KDS

- 名詞術語: https://docs.aws.amazon.com/streams/latest/dev/key-concepts.html
    - KCL, Kinesis Client Library
    - KPL, Kinesis Produce Library
- 構成
    - 一個 **Kinesis Data Stream** 由一系列的 Shards 所構成
        - 每個 Shard 可有 1 MB/s 的傳輸 or 1000 Messages/s
        - 每個 Shard 都有一個 sequence of data records
            - 每個 Data Record 都會被 Kinesis Data Streams 賦予一個 Sequence Number
    - 每個進入 KDS 的 Record 裡頭有 *Partition Key* && *Data Blob(up to 1MB)*
    - 每個由 KDS 出去的 Record 裡頭有 *Partition Key* && *Sequence no* && *Data Blob*
        - 可有 2 種 throughputs
            - 2 MB/s (shared), Per Shard all consumers
            - 2 MB/s (enhanced), Per Shard per consumers  (燒錢)
- 特性
    - 可保留 1 ~ 365 天
    - 可 reprocess(replay) data
    - 資料一但進 Kinesis, 無法刪除(immutable)
    - capacity 有 2 種 mode (若無規劃, 使用 B; 若能事先規劃, 使用 A)
        - A. provisioned mode(historic capacity mode)
        - B. on-demand mode(neuro mode)
- data stream producers
    - app, client, SDK, KPL, Kinesis Agent, ...
- data stream consumers
    - app(SDK, KCL), Lambda, Kinesis Data Firehose, Kinesis Data Analytics


### Kinesis Data Firehose, KDF

- 此為 Serverless
- Store data into Destination
- 可送入 KDF 的 data stream 有
    - data stream producers
    - kinesis data streams
    - CloudWatch Logs & CloudWatch Events
    - AWS IOT
- kDF 本身支援 AWS Lambda
- KDF 可 batch write to...
    - 3rd
        - Data Dog, Splunk, MongoDB, ...
    - AWS Services
        - s3, RedShift, OpenSearch, ...
    - Custom
        - HTTP Endpoint (API)
- Charge: Pay for data going through Firehose
- 此為半即時, 最起碼 delay 60s
    - 因 batch write
    - 最小 32MB 傳輸(可再調整)

Kinesis Data Streams                | Kinesis Data Firehose
----------------------------------- | -------------------------------
需要自幹 consumer & producer         | Fully managed
delay 200 ms                        | 有 buffer, 最小 delay 60s
自行 Scale(shard splitting/merging)  | Auto-Scaling
data store 1 ~ 365 days             | no data store
用於取 巨量資料                       | load streaming data to store
可 replay                           | 無法 replay


### Kinesis Data Analytics, KDA

- KDS, KDF 資料進入到 KDA 做分析
- KDA 支援 SQL
- 之後資料又可輸出到
    - KDS
        - 接 lambda 處理 or 客制 program
    - KDF
        - 接 S3, RedShift, ...
- 特色
    - real-time analytics
    - fully-managed, serverless
    - Auto-Scaling
    - by SQL
- Charge: by streams out of real-time queries
- Use Case:
    - Time-Series analytics
    - Real-Time Dashboards
    - Real-Time Metrics


## ActiveMQ

- 需要有 Dedicated Machine 跑 AmazonMQ
    - 支援 HA
- ActiveMQ 可有 queues (類似 SQS) && 可有 topics (類似 SNS)
- 不同 Region 的 ActiveMQ Broker, 可掛載相同的 EFS 來達到 HA


## SQS, SNS, Kinesis, ActiveMQ 其他摘要比較

SQS                          |     SNS                        |     Kinesis
---------------------------- | ------------------------------ | -------------------------
Queue                        | Pub/Sub                        | Real-time Streaming (Big Data)
consumer pull                | push to subscribers            | 
consume 後 delete data       | 一但未 delivered, data loss     | 可能可以 reply data (但 x 天候資料消失)
workers(consumer) 未限制      | 1250w subscribers & 10w topics | 
不用鳥 throughputs            | 不用鳥 throughputs              | standard: 2M/shard & enhances: 2M/consumer
僅在 FIFO 保證順序             |                                | 在 Sharded Level 決定 ordering


# Containers: ECS, Farget, ECR, EKS

## ECS, Elastic Container Service

- Task Definition: Defines how to create ECS task
- 有 2 種的 Launch Types, 但都可用 EFS 作為儲存:
    - EC2 Launch Type
        - 需自行維護 EC2, 裡頭需要有 `ECS Agent`
        - 此模式運行在 EC2 內的多個 **Task**, 他們可能被賦予了不同的 **EC2 Instance Profile Role**
        - 需要在 **ECS Service** 裡頭, 定義 **Task Role**
    - Farget Launch Type
        - Serverless
        - Launch 時, 可決定 CPU && RAM
        - Scaling 時, 決定 tasks number 即可
- 權限
    - 若 Task 需要 access AWS Resources, 則需給 **Task Role**
- Run **ECS Task** on **ECS Cluster**
- Use Case:
    - Hybrid Environment
    - Batch Processing
    - Scale Web Applications
- Auto Scaling
    - 用來 scale *Number of ECS Tasks*
    - 有 3 個 metric 可作為依據 (QQQ)
        - CPU Utilization
        - Memory Utilization
        - ALB Request Count Per Target
            - 由 ALB 來的 Metric
    - 有不同種類的 Auto Scaling
        - Target Tracking - 依照 CloudWatch 特定 Metric
        - Step Scaling - 依照 CloudWatch Alarm
        - Scheduled Scaling
    - Scaling *Task Level of ECS* != Scaling number of instances(EC2 launch type)
    - 如果是 EC2 Launch Type 的話, Auto Scaling 有 2 種做法:
        - Auto Scaling Group Scaling
            - 依照 (QQQ) 來 +- EC2 instances
        - ECS Cluster Capacity Provider
            - 比較聰明, 但須與 ASG 共同運作
- ECS Rolling Update
    - 滾動式更新(服務不中斷), 需要設定兩個參數
        - Minimun Healthy Percent
            - 最少需存活多少 Nodes
        - Maximum Percent
            - 最多開到多少 Nodes


### ECS - Load Balancer

- Application Load Balancer
    - 適用多數情況
- Network Load Balancer
    - high throughput 情境使用
    - 可搭配 **AWS Private Link**
- Classic Load Balancer
    - 別用就是了

```mermaid
flowchart LR;

subgraph cluster["ECS Cluster"]
    subgraph EC21["EC2"]
        Task1["Task"];
        Task2["Task"];
    end
    subgraph EC22["EC2"]
        Task3["Task"];
    end
end

User --> ALB;
ALB --> Task1;
ALB --> Task2;
ALB --> Task3;
```


## ECR, Elastic Container Registry

- 不解釋


## EKS, Amazon Elastic Kubernetes Service

- 類似於 ECS, 但使用不同的 API
- 此為 OpenSource, 相對於 ECS, 純 AWS
- 與 ECS 一樣, 也支援 2 種 launch mode:
    - EC2 mode
        - deploy on EC2
    - Farget mode
        - Serverless
- EKS Pods, 有點類似於 ECS Tasks
- 如果要 Expose EKS Service, 則需要設定 **Load Balancer**


## Cognito

> Provides authentication && authorization && user management for your web and mobile apps. Your users can sign in directly with a user name and password, or through a third party such as Facebook, Amazon, Google or Apple.
> 
> Offers user pools and identity pools. User pools are user directories that provide sign-up and sign-in options for your app users. Identity cagnito pools provide AWS credentials to grant your users access to other AWS services.


# Databases

- DB Types
    - RDBMS(=SQL/OLTP)
        - RDS, Aurora, MySQL, ...
    - NoSQL
        - DynamoDB (~JSON)
        - ElastiCache (key-value pairs)
        - Neptune (graphs)
    - Object Store
        - S3
        - Glacier
    - Data Warehouse (=SQL Analytics/BI)
        - Redshift (OLAP)
        - Athena
            - Query data on S3
    - Search
        - OpenSearch
    - Graphs
        - Neptune


## RDS, Relational Database Service

- 允許在 RDS 裡頭開 RDB
- RDBMS/OLTP
- 自行準備 EC2 instance && EBS Volume type & size
    - 但無須自行維護機器, OS
    - 因為是需要 Provision EC2, 因此只能做 垂直擴展, 無法水平擴增
    - Storage
        - RDS 具有 storage auto-scaling
            - 可自動偵測 Disk 用量, 並視情況 Scaling EBS
        - use EBS volumes
- 區分成 5 個了解方向:
    - Operations
        - 須自行處理 replicas, ec2 scaling, EBS restore, App Change, ...
    - Security
        - 自行處理 Security Group, KMS, SSL for encryption in transits, IAM Authentication
        - PostgreSQL && MySQL 皆支援 IAM Authentication
    - Reliability
        - 支援 Read-Replica && Multi AZ
    - Performance 依賴於 EC2 && EBS spec
    - Cost
        - based on EC2 && EBS
- Read Replicas
    - RDS Database, 至多可有 5 個 Read Replicas
    - 此為 Async Replication (相較於 Multi-AZ, 使用 Sync Replication)
    - 如果使用的話, Connection String 必須修改
    - Read Replicas 僅需要 Read 權限即可
    - 因 RDS 為 managed service, Same Region && Different AZ, sync Data 不需流量費用
        - 但若跨 Region, 則需要 $$
- Reliability
    - 如果要設定 Multi-AZ 非常簡單, 僅需 Enable 即可. 而且服務可免中斷


### RDS Backups

- Backup (自動)
    - Full      : 每天 
    - Transaction logs : 每 5 分鐘
        - 因此可隨時還原 5 分鐘前資料
    - 預設保留 7 天, 但可增至 35 天
- DB Snapshot (手動觸發)
    - 可自行決定保留多久


### Aurora

- RDS 旗下的其中一款 Engine Type, 地位等同於 RDS MySQL, RDS PostgreSQL, ...
    - AWS 魔改 MySQL/PostgreSQL 以後的 RDBMS
        - CloudNative
    - 可選擇自行 Provision Server 或是 Serverless
    - Operations
        - 可自行選擇是否使用 *Single-master* 或 *Multi-master*
        - 相較於其他 Type, less operations
        - auto scaling storage
        - Auto Scaling
            - 一次 10GB, 最多可擴充達 128 TB
    - Security
        - 同 RDS
        - Encryption at rest by KMS
        - Encryption in-flight uging SSL
        - 可用 IAM token 認證
        - auto backups, snapshots and replicas (皆 encrypted)
    - Reliability
        - AWS 自行幫忙處理好 6 replicas
            - 這 6 個 replication 橫跨了 3 AZ - HA
                - 而他們的背後也是寫入到不同的 Volume(免 user 自管)
            - 具備 Self healing(peer-to-peer replication)
        - auto failover < 30 secs
            - 單一 Cluster 最多可設定 15 Read Replicas (可放在 Auto Scaling)
            - 若超過, 其餘 read replicas 會產生新的 master 來做 write
        - 本身支援 cross replication
        - Global for Disaster Recovery / latency purpose
        - Backtrack: restore data at any point of time without using backups
    - Performance
        - MySQL && Postgresql 效能的 5x && 3x (宣稱)
            - 但是貴了 20%
    - Cost 
        - Pay for use
- Aurora DB Cluster
    - ![Aurora DB Cluster](./img/aurora%20cluster.png)
    - Load Balancing 發生在 connection level (而非 statement level)
    - *Writer Endpoint* && *Reader Endpoint*
- Deletion
    - 先刪除 Reader Instance
    - 再刪除 Writer Instance
        - 最後刪除 Regional Cluster (又或者, 此會隨著 *Writer Instance* 一同刪除, 不是很確定)
- Auto Scaling for Aurora Replicas
    - 可針對 by CPU 用量 OR by conneciton 數量, 來增加 Read Replicas
    - 增加的 Replicas, 也可產生不同規格的大小
        - 針對 *Aurora DB Cluster* 那張圖, 產生 *Custom Endpoint*(取代掉 *Reader Endpoint*)
- Serverless Aurora
    - Client 連線到 *Proxy Fleet*(而非上述的 *Writer Endpoint* && *Reader Point*)
        - 背後怎麼做 scaling 由 AWS 控制
- Global Aurora
    - 可設定 *Aurora Cross Region Read Replicas*, 但是使用 *Aurora Global Database* 較優
        - 擁有一個 Primary Region(rw)
        - 也可額外設定 5 個 Secondary Region(rr)
            - latency < 1 sec
            - 每個 Secondary Region 有高達 16 Read Replicas
        - 如果原本的 Primary Region 掛了, Promotion 到其他的 Secondary Region < 1 sec
- 整合了 ML

```mermaid
flowchart BT;
aurora["Amazon Aurora"];

subgraph ml
    sm["Amazon SegaMaker"];
    ac["Amazon Comprehend"];
end

app -- query --> aurora;
aurora -- data --> ml;
ml -- preditions --> aurora;
aurora -- result --> app;
```


## ElastiCache

- Managed Redis 或 Memcache
- 需要提供 EC2 instance type
- app 在做 DB query 之前, 會先查詢 ElastiCache, 如果有查到資料, 此稱之為 *Cache hit*
    - 反之沒查到, 則稱為 *Cache miss*. 後續動作為 DB query
        - 可對 DB query result, 寫入到 ElastiCache
- Operations
    - 同 RDS
    - load data -> ElastiCache 有三種 pattern:
        - Lazy Loading
            - 所有 read data 皆 cached
        - Write Through
            - 從 DB 來做 add/update
        - Session Store
            - TTL
- Security
    - 自行處理 KMS, Security Group, IAM
    - 關於 IAM authentication
        - ElastiCache 裡頭, 不支援 *IAM authentication*, 這認證僅支援 API-level Security (delete cache, create cache, ...) 
        - if redis
            - 本身無 IAM 驗證, 但可藉由 RedisAuth 做驗證, "password/token"
            - SSL in-flight
        - if memcached
            - SASL-based authentication
- Reliability
    - Clustering, Multi AZ
- Performance
    - 毫秒級快取
- Cost
    - Pay for usage
- ElastiCache 重要比較
    - ElastiCache - Redis
        - 支援 Multi AZ with Auto-Failover
        - Read Replicas scale reads && HA
        - Data Durability using AOF
        - Backup && restore feature
    - ElastiCache - Memcache
        - Multi-node partitioning of data(sharding)
        - 無 HA && 無 persistent && 無 backup && restore
        - Multi-thread architecture
        - pure cache
- 建立時, 可選擇 Cloud 或 On-premise
    - On-premise, 需搭配 **AWS Outpost**


## DynamoDB

同 [CLF-DynamoDB](./cert-CLF_C01.md#dynamodb)

- store documents, key-value
    - 一筆 400 KB
    - 可配置 RCU && WCU
- Operations
    - Serverless -> 無需 operations
    - Auto Scaling
- Security
    - IAM Policy
    - KMS encryption
    - SSL in flight
- Reliability
    - Multi AZ, Backups
- Performance
    - 毫秒等級 latency
    - 若要 caching, 可搭配 DynamoDB Accelerator, DAX
- Cost
    - Pay for usage


## S3

- Operations
    - Serverless, no operations needed
- Security
    - User based
        - IAM policies
    - Resource Based
        - Bucket Policies
        - Object Access Control List
        - Bucket Access Control List
    - ACL
    - Encryption
        - SSE-S3
        - SSE-KMS
        - SSE-C
        - client side encryption
        - SSL in transit
- Reliability
    - 有多種類型可選擇, 但可用性都很多 9 就對了. 支援 Cross-Region Replication, CRR
        - S3 Standard
        - S3 IA
        - S3 One Zone IA
        - Glacier
        - 等等
- Performance
    - single object size limit 5TB
- Cost
    - Pay for storage usage
    - infinite storage


## Athena

- 實作
    - [How do I analyze my Amazon S3 server access logs using Athena?](https://aws.amazon.com/premiumsupport/knowledge-center/analyze-logs-athena/?nc1=h_ls)
- Query Engine on S3
    - Serverless
    - use SQL query on S3, 用來做分析
        - file 可以是 CSV, JSON, ORC, Avro, Parquet(built on Presto)
        - 後面可以接 **Amazon QuickSight** 來做報表
- Use Case: log analytics
- Operations
    - Serverless, no operations needed
- Security
    - IAM + S3 security
- Reliability
    - use Presto Engine, HA
- Performance
    - Query scale based on data size
- Cost
    - per query / per TB of data scanned

```mermaid
flowchart LR;

user <-- "load data" --> S3;
Athena -- Query/Analyze --> S3;
Athena -- Report/Dashboard --> QuickSight;
```


## AWS Redshift

- based on PostgreSQL, use SQL query
    - Columnar Storage (非  row based)
    - Analytics / BI / Data Warehouse
- 為 OLAP, 可用來做 analyze && data warehouse
    - 可達 PB 量級
    - 不適用於 OLTP
    - 整合了 BI tools, ex: **AWS Quicksight** OR **Tableau**
- Redshift Cluster
    - 1 ~ 128 nodes, 每個 node 可達 128 TB
    - Leader Node  : Query planning && aggregating query results
    - Compute Node : Perform queries && return to Leader
- Redshift Spectrum
    - 可直接對 S3 query (免 load)
        - Query -> *Redshift Cluter* 內的 *Leader Node*
        - *Leader Node* 分派給 *Compute Nodes*
        - *Compute Nodes* 再分派給 *Redshift Spectrum*
        - *Redshift Spectrum* 會對 S3 做資料查詢
    - 也就是說, 資料不會進入我們的 Nodes, 會在 *Redshift Spectrum*(AWS Service) 查詢完後回傳結果
- Operations
    - like RDS
- Security
    - 存在於 VPC 之中, using IAM
    - KMS
    - Backup & Restore
    - monitoring
- Reliability
    - 無 Multi AZ
    - 自行對 Cluster 做 cross-region snapshot(point-in-time backup)
        - 可 manual 或 automatically
            - 若 auto, AWS 每隔 8 hrs 或 異動打 5 GB, 會做 snapshot
    - 可藉由配置 auto copy snapshot Cluster 到其他的 Region, 來加強 Disaster Recovery Strategy
- Performance
    - 因 Massively Parallel Query Execution(MPP) Engine, 因而 high-performance
    - 宣稱比其他 10x 於其他 WareHouse
- Cost
    - pay for node provisioned
    - 宣稱僅其他 WareHouse 1/10 Cost
- Redshift Enhanced VPC Routing
    - COPY / UNLOAD COMMAND, 可免藉由 public internet 來 copy data
- 有三種 Load Data -> Redshift 的方式
    - 使用 Kinesis Data Firehose, KDF
        - KDF 由不同 source 蒐集資料, 倒入 Redshift Cluster
        - 藉由 COPY COMMAND, S3 -> Redshift
            - ```
              copy customer
              from 's3://my_bucket/my_data'
              iam_role 'arn:aws:iam::123456887123:role/MyRedshiftRole'
              ```
        - EC2 Instance, JDBC driver
            - EC2 data -> Redshift Cluster
    - By using COPY COMMAND, 可從 S3, DynamoDB, DMS, other DB 來 load data

```mermaid
flowchart LR;

rc1["Redshift Cluster 0"];
rc2["Redshift Cluster 0'"];
c1["Cluster Snapshot"];
c2["Copied Snapshot"];

subgraph Region1
    rc1 -- "Take Snapshot" --> c1;
end

subgraph Region2
    c2 -- Restore --> rc2;
end

c1 -- Auto/Manual Copy --> c2;
```


## AWS Glue

- ETL, Serverless
- Glue Data Catalog - catalog of datasets

```mermaid
flowchart LR;

S3 -- Extract --> Glue;
RDS -- Extract --> Glue;

Glue -- load --> Redshift;
```

```mermaid
flowchart LR;

glue["Glue Data Crawler"];
gdc["Glue Data Catalog"];
gjob["Glue Jobs(ETL)"];

S3 --> glue;
RDS --> glue;
DynamoDB --> glue;
JDBC --> glue;

glue -- write metadata --> gdc;

glue -- ETL --> gjob;

gdc -- Data Discovery --> Athena;
gdc -- Data Discovery --> r["Redshift Spectrum"];
gdc -- Data Discovery --> EMR;
```


## AWS Neptune

- Graph DB
- Use Case
    - Social Network
    - Wikipedia
- Point-in-time recovery
    - 不斷 backup to S3
- Security
    - KMS encryption + HTTPS
- Reliability
    - HA, multi-az, up to 15 read replicas
- Performance
- Cost: Pay per node provisioned (類似 RDS)


## AWS DMS, Data Migration Service

- Data Migration Service
- 地端 DB 上雲端


## OpenSearch

- 可適用於 Big Data
    - Search / Indexing
- 整合了 *Kinesis Data Firehose*, *AWS IoT*, *CloudWatch Logs*, ...
- Operations
    - 類似 RDS
- Security
    - Cognito
    - IAM
    - KMS encryption
    - SSL
    - VPC
- Reliability
    - Multi AZ, Clustering
- Performance
    - Based on ElasticSearch; PB 量級
- Cost
    - Pay per node provisioned (類似 RDS)


# CloudFront && Global Accelerator

## CloudFront, CDN

- 有超過 200+ 個 Edge Locations
    - file cached for TTL
- 結合了 DDoS protection && Shield, Web Application Firewall
- Origins
    - S3 
        - Enhanced security with CloudFront Origin Access Identity, OAI
            - 讓 S3 只能由 CloudFront 來訪問
            - OAI 是用來給 CloudFront 的 IAM Role
            - 如果使用 CloudFront 而不使用 OAI 的話, 那 S3 bucket 必須設成 public access 才可以
        - CloudFront 可作為 S3 upload file 的 ingress
    - Custom Origin(HTTP)
        - ALB && EC2 instance
            - 必須要是 public && SG 要允許 AWS CloudFront IPs 來訪問
                - https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips
        - S3 Website
        - any HTTP backend
- CDN 也可設定 黑白名單 來做訪問許可
    - country 則使用 3rd Geo-IP database
- paid shared content(付費共享內容)
    - 藉由 **CloudFront Signed URL / Signed Cookies**
        - Signed URL = access to individual files (one signed URL per file)
        - Signed Cookies = access to multiple files (one signed cookies for many files)
    - 可設定 URL 在特定時間後到期 OR 設定哪些 IP 可以訪問 等等 (for premium user)
    - 這個和 [S3 Pre-Signed URL](./S3.md#s3-pre-signed-urls) 很容易搞混
        - 可用來 filter by IP, path, date, expiration
            - 相較於 S3 Pre-Signed URL, 只能用來限定特定 URL 有效期限
    - ```mermaid
        flowchart TB

        cdn["CloudFront \n Edge location"];

        Client -- "1.認證授權" --> App;
        App -- "2.SDK gen Signed URL/cookie" --> cdn;
        cdn <-- "3.OAI" --> S3;
        cdn -- "4.取得 Signed URL/cookie" --> App;
        Client -- "5.訪問 Signed URL/cookie 爽看片" --> cdn;
      ```
- Charge 收費方式
    - CloudFront 收費依照 流出流量 計費, 每個 Region 計費都不同
    - 此外也可有 3 種(不知道將來會不會變) Price Classes
        - Price Class All - 所有 Regions 都做 CDN
        - Price Class 200 - 排除掉最貴的 Region
        - Price Class 100 - 只對最便宜的 Region 啟用
    - [Cloudfront](https://aws.amazon.com/cloudfront/pricing/?nc1=h_ls) 詳細計費說明
- CloudFront - Multiple Origin
    - CloudFront 可配置 *Cache Behaviors*, 來針對不同的 URL location, 配置不同的 Origin
        - ex: `/api/*` 丟到 ALB ; 其餘 `/*` 丟到 S3
- CloufFront - Origin Groups
    - 用來因應 HA && failover
    - 1 Primary && 1 Secondary origin (稱之為一組 Origin Group)
    - CloudFront 後面可以有 active-standby 的後端 Resource
    - S3 + CloudFront - Regional HA
        - ```mermaid
            flowchart LR

            subgraph Origin Group
                a["S3 Origin A"]
                b["S3 Origin A"]
            end

            Client --> Cloudfront;
            Cloudfront -- active --> a;
            Cloudfront -- standby --> b;
            a -- "Cross Region Replication" --> b;
        ```
- CloudFront - Field Level Encryption
    - Client -> Edge -> CloudFront -> ALB -> WebServer
    - 如果架構如上, 全部使用 https, *Field Level Encryption* 主要功能是, 能針對 Request 裡頭特定欄位
    - 使用 asymmetric encryption 來做加密, 而最後再由 WebServer decrypt, 避免無關的節點取得非必要機密資訊


## Global Accelerator

- 要來解決 Service 在 Single Region, 但請求來自世界各地的長途路由問題
- Charge: 需要摳摳
    - 固定設定費用 + 資料傳輸費用
- 必要網路知識:
    - Unicast IP : 一台 Server 有一個 IP
    - Anycast IP : 所有 Servers 有相同 IP && client 就近訪問其中一台
- **Global Accelerator** 使用了 **Anycast IP**
    - 不管 client 在哪邊, 都將請求送往鄰近的 Edge, 之後再走 AWS internal network 到後端 Server
    - work with *Elastic IP*, *EC2 instance*, *ALB*, *NLB*, ... (private && public)
    - 會拿到 2 組 Anycast IP for APP
    - intelligent routing && fast regional failover
    - 不存在 client cache 的問題 (因為東西都往後端丟)(proxy)
    - health check
    - DDos protection (by Shield)
    - Improve performance
        - 如果 APP != HTTP, 像是 UDP, MQTT, VoIP, ... 表現都不錯
        - 如果 APP == HTTP, 需要一組 static IP 或 一組 failover regional 可快速切換
- 容易與 [S3 Transfer Acceleration](./S3.md#s3---baseline-performance--kms-limitation) 搞混


# AWS Storage Extras

## AWS snow Family

- [clf-SnowFamily](./cert-CLF_C01.md#aws-snow-family)
- 蒐集/處理 data && 將 data in/out AWS 的離線裝置
- Use Case:
    - 巨量資料要放 Glacier, 可藉由 Snow Family 相關服務 -> S3, 再藉由 `S3 lifecycle policy` -> Glacier


## AWS FSx

- 可在 AWS 使用 3rd file system
- [clf-FSx](./cert-CLF_C01.md#amazon-fsx)
- FSx 可選 HDD/SSD && 與 S3 整合 && on-premise infra 藉由 `VPN` 或 `Direct Connect` 來訪問
- FSx 的 Disk throughputs 在建立的時候就要先定義
- 各種 FSx:
    - AWS FSx for Windows File Server
        - 因為 EFS 只能運行在 POSIX (Linux 啦), 因而有這東西, 支援 `SMB` && `NTFS`
        - 支援 Windows Active Directory(AD), ACLs, user quotas (不知道這啥..)
        - 可以被 mount 到 Linux!!!
        - 支援秒級 scale (10s of GB/s, millions of IOPS), 可打 100s PB of data
        - Multi-AZ, HA
    - AWS FSx for Luster (Linux & Cluster)
        - Luster 為 parallel distributed file system, for large-scale computing
            - 名字結合字 Linux && Cluster
        - Machine Learning, High Performance Computing(HPC)
        - Video Processing, Financial Modeling, Electronic Design Automation
        - Scale up to 100s GB/s && millions IOPS
- FSx File System Deployment Options (不知在供三小)
    - Scratch File System
        - Temporary storage
        - data 沒做 replication (如果 file server fail, 資料就消失了!!)
            - 但速度非常快 (6x faster, 200MBps per TiB)
        - Use Case : short-term processing, optimize cost
    - Persistent File System
        - Long-term storage
        - Data replicate within same AZ
        - Use Case : long-term processing, sensitive data


## Storage Gateway

- Hybrid Cloud 使用~ 雲端之間傳輸資料的方式
- [clf-StorageGateway](./cert-CLF_C01.md#storage-gateway)
- 有不同種類的 Storage Gateway
    - Amazon S3 File Gateway
        - via NFS && SMB, access S3 bucket
        - 支援: S3 standard && S3 IA && S3 one-zone IA && S3 Glacier
        - 使用 IAM Role 管控 access
        - 可使用 on-premise AD 來做 user auth
        - 最近使用的檔案會被 cache
        - ```mermaid
            flowchart LR
            ap["Application Server"]
            fg["File Gateway \n (cache)"]
            ad["Active Directory"]

            subgraph Data Center
                ad <-- authentication --> fg;
                ap <-- "NFS(v3/v4.1)" --> fg;
            end
            subgraph AWS Cloud
                subgraph Region
                    s3["S3"]
                    ia["S3 IA"]
                    gg["S3 Glacier"]
                end
            end
            fg <-- HTTPS --> Region;
          ```
    - Volume Gateway
        - iSCSI protocol 到 S3
        - 最主要功能之一就是 backup, 背後有 EBS snapshot
        - 2 types of Volume Gateway
            - Cached Volumes : cache 最近使用的 data, 降低 latency
            - Stored Volumes : 對整個 dataset, schedule backups 到 S3
            - ```mermaid
                flowchart LR
                ap["Application Server"]
                vg["Volume Gateway \n (cache 或 stored)"]
                ad["Active Directory"]

                subgraph Data Center
                    ap <-- iSCSI --> vg;
                end
                subgraph AWS Cloud
                    subgraph Region
                        s3["S3"]
                        ebs["EBS snapshot"]
                    end
                end
                vg <-- HTTPS --> s3;
                s3 <-- backup --> ebs;
              ```
    - Tape Gateway
        - Cloud 使用 Virtual Tape Library(VTL), 背後為 S3 && Glacier
        - ```mermaid
            flowchart LR
            bs["Backup Server"]
            tg["Tape Gateway"]

            subgraph Data Center
                subgraph tg["Tape Gateway"]
                    mc["Media Changer"];
                    td["Tape Drive"];
                end
                bs <-- iSCSI --> mc;
                bs <-- iSCSI --> td;
            end
            
            subgraph AWS Cloud
                subgraph Region
                    s3["Virtual Tapes stored in S3"]
                    gg["Archived Tapes stored in Glacier"]
                end
            end
            tg <-- HTTPS --> s3;
            s3 <-- backup --> gg;
          ```
    - Amazon FSx File Gateway
        - 新一代的 Gateway
        - FSx for Windows File Server 原生支援 access Amazon
        - local cache
        - Windows AD, SMB, NTFS
        - useful for group file shares && home directories (殺小?)
        - ```mermaid
            flowchart LR
            smb["SMB Clients"]
            fsx["Amazon FSx File Gateway \n (cache)"]

            subgraph Data Center
                smb <--> fsx;
            end

            subgraph AWS Cloud
                subgraph win["for Windows File Server"]
                    fasx["Amazon FSx"]
                    fs["File systems"]
                end
            end
            fsx <-- HTTPS --> win;
          ```
- 上述的這些 Gateway, 都需要安裝在 DataCenter
    - 另一種方式是, 跟 AWS 下訂 `Storage Gateway-Hardware appliance`
        - 此為運行 Storage Gateway 的實體裝置, 可與上述的 gateway 整合
        - 適用於 DataCenter 做 daily backup to NFS
- exam 的關鍵字
    - File access/NFS - user auth with AD => File Gateway (backed by S3)
    - Volumes/Block Storage/iSCSI => Volume Gateway (backed by S3 with EBS snapshots)
    - VTL Tape solution/Backup with iSCSI => Tape Gateway (backed by S3 and Glacier)
    - No on-premises virtualization => Hardware Appliance          

```mermaid
flowchart TB
sg["Storage Gateway"];

subgraph block
    EBS;
    is["EC2 instance store"];
end
subgraph FileSystem
    EFS;
    FSx;
end
subgraph Object
    S3;
    Glacier;
end

Object  <--> sg;
FileSystem  <--> sg;
block  <--> sg;
sg <--> client;
```


## AWS Transfer Family

- transfer file <--> S3 或 EFS, via FTP
- Serverless, scalable, reliable, HA
- Charge: pay per provisioned endpoint per hour + data transfer in GB
- Security
    - 可在服務內儲存 user creds 或整合 Win AD, LDAP, Okta, Amazon Cognito, ...
- 支援的 protocols
    - AWS Transfer for FTP(File Transfer Protocol)
    - AWS Transfer for FTPS(File Transfer Protocol over SSL)
    - AWS Transfer for SFTP(Secure File Transfer Protocol)

```mermaid
flowchart LR

user["FTP Client"]

ff["FTP Transfer Family"];

ad["AD, LDAP, ..."] <-- auth --> ff;
user -- DNS --> ff;
user -- direct --> ff;
ff -- IAM Role --> S3;
ff -- IAM Role --> EFS;
```


# AWS Monitoring & Audit: CloudWatch, CloudTrail & Config

## CloudWatch

- [CloudWatch](./CloudWatch.md)


## CloudTrail

- Enable governance, compliance, operational auditing, and risk auditing of AWS account.
- governance && compliance && audit for AWS Account
- CloudTrail 資料只保留 90 天. 需自行 backup 到 S3
- 3 種:
    - Management Events
        - 免費, 預設啟用
    - Data Events
        - 資料龐大, 預設不收
    - CloudTrail Insights Events
        - 需要課金
- Event History 可能要花上 15 分鐘才會有資料


## AWS Config

- 


# ...