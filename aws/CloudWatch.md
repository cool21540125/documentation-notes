
# AWS CloudWatch

- [What is Amazon CloudWatch?](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
- 用來 `collect / monitor / analyze` AWS Services
    - collect 到的這些數據, 稱之為 metrics
    - 其實也可以把 *CloudWatch* 當作是個 *metrics repository*
- 重要名詞定義
    - Metrics
        - 每隔一段時間發佈到 CloudWatch 的一組 data point
        - metric 只保存在他們所在的 Region, 無法自行刪除 (15 個月後會消失)
    - Namespaces
        - Metrics 的 Container, 用來隔離不同的 Metrics
        - ex: EC2 使用 `AWS/EC2` 這個 namespace
    - Dimensions
        - Metric 裡頭的一組 name/value pair ; 每個 Metric 最多能有 10 個 Dimensions
        - 好像可以理解成 OOP 裡頭的 class, attribute name, attribute value 的概念
            - ex: Instance.id, Environment.name, ...
    - Resolution
        - Metric 的蒐集頻率(StorageResolution API parameter)
            - Standard resolution : 60 secs
            - High resoultion     : 10 or 30 secs (貴)
    - Statistics (不解釋)
    - Percentiles (不解釋)
    - Alarms
        - 針對一段時間特定 Metric 達到某個 threshold 的狀態, 再對此來做因應


## CloudWatch Metrics

- 預設 EC2 每 5 分鐘 會有對應 metrics
    - 可花錢... 每分鐘都有 metrics
    - EC2 Memory Usage 並沒在預設的 metrics 裡頭, 想要這個的話需要 custom
- UNKNOWN Accepts metric data points two weeks in the past and two hours in the future
    - (make sure to configure your EC2 instance time correctly)
- 可使用 [put-metric-data](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-metric-data.html) API 來增加 custom metric
- 可以針對 metric 超過門檻, 配置對應的 [alarm actions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#CloudWatchAlarms)


## CloudWatch Dashboards

- 可用來快速彙整 key metrics && alarms
- 可 cross AWS accounts && cross Region (global)
- Charge: 3 dashboards(up to 50 metrics) for FREE
    - 超過部分, $3/dashboard/month


## CloudWatch Logs

- 儲存 AWS Logs 的地方, 可把 log 彙整到 *Log groups*(通常代表一個 Application)
    - Log group 裡頭會有 *Log streams*(instance/log file/container)
    - Logs Insights, 可下查詢語法(有點類似 SQL, 但完全不同), 針對 Log group 做查詢
- *CloudWatch Logs* 可彙整至:
    - S3
        - 即時: 可使用 *Logs Subscriptions*
            - ```mermaid
                flowchart LR

                cl["CloudWatch Logs"]
                sf["Subscription Filter"]
                kdf["Kinesis Data Firehose"]
                awslf["Lambda \n (managed by AWS)"]
                lf["Lambda (custom)"]
                es["Amazon OpenSearch"]
                kds["Kinesis Data Streams"]

                cl --> sf;
                sf --> awslf;
                awslf -- Real Time --> es;
                kdf --> es;
                sf --> kdf;
                kdf -- Near Real Time --> S3;
                sf --> kds;
                kds --> other["KDF, KDA, EC2, Lambda, ..."]
                sf --> lf;

              ```
        - 非即時
            - CloudWatch Logs -> S3, 使用 `CreateExportTask` API call, 時間可能花上 12 hrs
    - Kinesis Data Stream
    - Kinesis Data Firehose
    - AWS Lambda
    - ElasticSearch
- *CloudWatch Logs* Sources:
    - SDK
    - `CloudWatch Logs Agent`(OLD)
        - EC2 安裝此服務, 並取得對 *CloudWatch Logs* 寫入的 *IAM Role*
        - 也可安裝在 on-premise server 來蒐集 log
        - 只能把 log -> *CloudWatch Logs*
    - `CloudWatch Unified Agent`(NEW)
        - 可蒐集額外的 system-level metrics
            - 可蒐集更多細粒度的數據
        - 能把 log && metric -> *CloudWatch Logs*
        - 可使用 **SSM Parameter Store** 來中央化管理參數
    - Elastic Beanstalk
    - ECS
    - Lambda
    - [VPC Flow Logs](./VPC.md#vpc-flow-logs), 送出特定 VPC metadata network traffic
    - API Gateway, 送出打到 API GW 的所有 requests
    - CloudTrail, 可設定 filter 來傳送 log
    - Route53, all DNS query
- Define *Metric Filter* && *Insights*
    - ex: 設定 filter expression, 計算 log file 裡頭 'error' 出現次數 or 取出 log 裡頭特定 IP
    - filter 可用來 trigger **CloudWatch alarms**
- CloudWatch Logs 支援 cross region && cross accounts
    - ```mermaid
        flowchart LR;
        sf1["Subscription Filter"]
        sf2["Subscription Filter"]
        sf3["Subscription Filter"]
        ac1["Account A Region 1"] --> sf1;
        ac2["Account B Region 2"] --> sf2;
        ac3["Account C Region 3"] --> sf3;
        
        kds["Kinesis Data Streams"]
        kdf["Kinesis Data Firehose"]
        sf1 --> kds;
        sf2 --> kds;
        sf3 --> kds;
        kds --> kdf;
        kdf -- Near Real Time --> S3;
      ```


## CloudWatch Alarms

- 用來針對 *Metrics* 做 trigger notification
- Alarm State (Alarm Status)
    - OK
    - INSUFFICIENT_DATA : 資料量不足以判斷目前 State
    - ALARM
- Alarms 有幾個主要的 Targets
    - EC2     : stop, terminate, reboot, recover
        - Status Check
            - Instance status : check EC2 VM
            - System status   : check 底層硬體
    - EC2 ASG : trigger auto scaling action
    - SNS     : send notification to SNS
- 

```bash
### 使用 CLI 方式來 trigger ALARM
### https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
aws cloudwatch set-alarm-state \
    --alarm-name ${ALARM_NAME} \
    --state-value ALARM \
    --state-reason ${ALARM_REASON}
```


## CloudWatch Insights

- 可用來 query logs && 把 query 加到 *CloudWatch Dashboard*


# AWS EventBridge (前身為 *CloudWatch Events*)

- [What Is Amazon EventBridge?](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)
    - 下圖的 *event*, 其實就是 *stream of real-time data*

    ```mermaid
    flowchart LR

    subgraph Sources
        as["AWS Services"]
        cs["Custom Services"]
        saas["SaaS APPs"]
    end

    subgraph eb["EventBridge"]
        deb["Default Event Bus"] --> Rules;
        ceb["Custom Event Bus"] --> Rules;
        seb["SaaS Event Bus"] --> Rules;
        es["Event Source"]
    end

    es --> seb;
    as -- event --> deb;
    cs -- event --> ceb;
    saas -- event --> es;

    subgraph Targets
        direction LR;
        Lambda; Kinesis; ad["Additional Services"];
        api["API Endpoints"]
        other["其他 AWS Account 的 event bus"]
    end
    Rules --> Targets;
    ```

- [clf-cloudwatch events](./cert-CLF_C01.md#cloudwatch-events)
- EventBridge 核心名詞:
    - Message Bus : (等同於 SNS 的 Topic) Container of event
    - Event : (等同於 SNS 的 Message) 除了可以被 APP 觸發, 也可能是 AWS Resource 來觸發特定 event
    - Rule : 將 incoming events 做規則配對, 並送到對應的 Targets 做後續處理
        - 特定一個 Rule, 可以有 5 個 Targets (致命缺陷)
        - Rules 會依照 event 的 *Event Pattern* 來配發到不同的 Target
    - Target : (等同於 SNS 的 subscriber) 針對 Events 做對應處理
- EventBridge(EB) vs CloudWatch Events(CWE)
    - 基本上 EB 是架構在 CWE 上頭, 使用相同的底層 API
    - EB 可完全取代 CWE, 不過 EB 更加強大.
    - 如今的 CWE, 已等同於 EB 了
    - EventBridge 具備 *Schema Registry* capability
- EventBridge 相較於 SNS
    - 可與 3rd services(for FREE) && your APP 整合
        - ex: Zendesk, DataDog, Segment, Auth0, ...
- EventBridge 可以是 Schedule 或 Cron
- 可在 Event Bus 上頭制定 **Resource-based Policy**, 來讓 cross region 或 cross account 使用
    - 每個 EventBus 可配置 300 個 Rules
        - Rule 定義了如何 process event && 要將 event redirect 到哪個 Service
    - 可將發送到 Event Bus 的 events 做 archive, 並作適當的 長期/永久 保存
    - Default Event Bus : 接收來自 AWS Services 的 events
        - 幾乎等同於舊版的 CloudWatch Events
    - Partner Event Bus : 接收來自 SaaS Services or APPs, ex:
    - Custom Event Bus
        - 可針對裡頭的 events 做 Archive (可自行配置保存期限 or 永久保存)
- Event Bridge 會自行分析發送到他身上的 events 的 schema
- *Schema Registry* 會在 APP 裡頭 generate code, 
    - 來讓 APP 可事先得知 how data is structured in the event bus
    - 而這些 Schema 可版控
- 假設 AccountA 想把 event 發送到 AccountB, 則:
    - AccountA 需設定 [partner event source](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-saas.html)
    - AccountB 需把 event 關聯到上述的 *partner event source*