
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
        - Metric 裡的 Name-Value pair
        - 每個 Metric 最多能有 10 個 Dimensions
        - 好像可以理解成 OOP 裡頭的 class, attribute name, attribute value 的概念
            - ex: Instance.id, Environment.name, ...
        - 每一筆 Metric 都有它的蒐集頻率(StorageResolution API parameter)
            - Standard resolution : 60 secs
            - High resoultion     : 1 sec
                - 很貴
                - 使用 [collected plugin](https://github.com/awslabs/collectd-cloudwatch) 來搜集 metrics
                - 儲存後, 查看 metrics 時, 可再自行選擇資料頻率 1/5/10/30/60 甚至更長的資料頻率
                - WARNING: 很容易與 EC2 detailed monitoring && CloudWatch Alarm high resolution 搞混!!
                    - EC2 detailed monitoring
                        - Enabled  : 每 1 min 發送 metrics 到 CloudWatch (需課金)
                            - 如果是底下的操作, 預設是 Detailed Monitoring:
                                - 使用 AWS CLI 建立 Launch Configuration
                                - 使用 SDK 建立 Launch Configuration
                        - Disabled : 每 5 min 發送 metrics 到 CloudWatch
                            - 如果是底下的操作, 預設是 Basic Monitoring:
                                - 使用 Launch Template
                                - 使用 AWS Management Console 建立 Launch Configuration
                            - `aws ec2 monitor-instances --instance-ids ${Instance_ID}` 可用來啟動 EC2 的 detailed monitoring
                    - 
                    - High-Resolution Metrics (需要課金, 而且很貴)
                        - APPs 可以每 1 sec 發送 metrics 到 CloudWatch
                            -  另一方面, 可以設定 CloudWatch Alarm 在不同的頻率(ex: 每 10 secs) 作為評估
        - 如果自行搜集 custom metric 時, 都會去尻 `PutMetricData API`(收費~), 假設又使用 High Resolution, 小心錢包哭哭
            - `aws cloudwatch put-metric-daata --namespace "xxx" --metric-data file://example-metric.json`
    - Statistics (不解釋)
    - Percentiles (不解釋)
    - Alarms
        - 針對一段時間特定 Metric 達到某個 threshold 的狀態, 所做的 actions
- CloudWatch 會以 time series 的方式, 將這些 metrics 伴隨他的 timestamp 做儲存
    - user 也可自行發布 `aggregated set of data point`, 即 `statistic set` 到 CloudWatch


# CloudWatch Dashboards

- 可用來快速彙整 key metrics && alarms
- 可 cross AWS accounts && cross Region (global)
- Charge: 3 dashboards(up to 50 metrics) for FREE
    - 超過部分, $3/dashboard/month
- Dashboard 該怎麼建立... 現階段先 PASS


# CloudWatch Metrics

- [CloudWatch Metcrics workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/a8e9c6a6-0ba9-48a7-a90d-378a440ab8ba/en-US/200-cloudwatch/210-cloudwatch-metrics)
- 預設 EC2 每 5 分鐘 會有對應 metrics
    - 可花錢... 每分鐘都有 metrics
    - EC2 Memory Usage 並沒在預設的 metrics 裡頭, 想要這個的話需要 custom
- UNKNOWN Accepts metric data points two weeks in the past and two hours in the future
    - (make sure to configure your EC2 instance time correctly)
- 可使用 [put-metric-data](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-metric-data.html) API 來增加 custom metric
- 可以針對 metric 超過門檻, 配置對應的 [alarm actions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#CloudWatchAlarms)
- EC2 預設每 5 mins 會有一筆 metric -> CloudWatch Metric, 如果需要更頻繁的資料, 可啟用 *EC2 Detailed monitoring*(每 1 min 一筆)
    - 很容易與 CloudWatch Metric high resolution && CloudWatch Alarm high resolution 搞混!!
- `Search Expression` 為其中一種 `Math Expression`


## CloudWatch configuration

- 安裝完 CloudWatch 以後, 啟動時需要給一份 JSON, 裡頭包含 3 個部分:
    - agent   : agent configuration
    - metrics : custom metrics
    - logs    : additional log files




# CloudWatch Events

- 老東西, 現在已改為 [EventBridge](#aws-eventbridge-前身為-cloudwatch-events)


# CloudWatch Alarms

- [CloudWatch Alarms workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/a8e9c6a6-0ba9-48a7-a90d-378a440ab8ba/en-US/200-cloudwatch/230-cloudwatch-alarms/231-cloudwatch-alarms)
- 用來 trigger notification
    - 標的為 CloudWatch Metrics, CloudWatch Logs
- Alarm State (Alarm Status)
    - OK
    - INSUFFICIENT_DATA
    - ALARM
- 可對於 Alarms 設定 Period, 用來作為 Length of time in seconds to evaluate the metric
    - 白話文就是, 持續觀察 Metric 多久, 然後才觸發 Alarm, 而發 Metric 一達標就觸發
    - ex: 10 / 30 / 60 secs
        - 很容易與 EC2 detailed monitoring && CloudWatch Metric high resolution 搞混!!
- Alarms 有幾個主要的 Targets:
    - EC2     : stop, terminate, reboot, recover
        - Status Check
            - Instance status : check EC2 VM
            - System status   : check 底層硬體
    - EC2 ASG : trigger auto scaling action
    - SNS     : send notification to SNS
- 也可對 CloudWatch Logs 設定 **Metric Filters**

```mermaid
flowchart LR

subgraph cw["CloudWatch"]
    cwl["CloudWatch Logs"]
    cwa["CloudWatch Alarm"]

    cwl -- Metric Filter --> cwa;
end

cwa -- Alert --> sns["SNS"]
```

```bash
### 使用 CLI 方式來 trigger ALARM (測試用, 可用來觀察後續動作是否正常運作)
### https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
$# ALARM_REASON=testing
$# ALARM_NAME=XXX
$# aws cloudwatch set-alarm-state \
    --alarm-name ${ALARM_NAME} \
    --state-value ALARM \
    --state-reason ${ALARM_REASON}
```


# CloudWatch Insights

- 因為 CloudWatch Logs 都是蒐集到 S3, 但是不方便觀看, 因此借助 CloudWatch Logs Insights, 可有效的:
    - query logs
    - 把 query 加到 *CloudWatch Dashboard*
- Examples:
    1. example - 基本介紹:
        - 第一行, 要列出的欄位
        - 第二行, 排序條件
        - 第三行, 篩選條件
    ```ini
    fields @timestamp, @message
    | sort @timestamp desc
    | filter @message like "Your Wanted Message"
    ```
    2. example - 篩選特定字元:
        - 假設要列出 'GET /login HTTP/2'
        - 第三行, 藉由 parse 加上 '*', 可將之視為變數, 並指定到後面去
    ```ini
    fields @timestamp, @message
    | sort @timestamp desc
    | parse '"GET * HTTP/2' as @location
      ;;; 可取得 location 欄位
    | parse '"GET * */2' as @location, @protocol
      ;;; 可取得 location 及 protocol 兩個欄位
    ```
    3. example - 做統計:
        - 最後一行, 可計算出去尻 login 的次數
    ```ini
    fields @timestamp, @message
    | filter @logStream = "Error Logs"
    | sort @timestamp desc
    | parse '"GET * */2' as @location, @protocol
    | stats count(*) as sum by @location
    ```


# AWS EventBridge

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
- (前身為 *CloudWatch Events*)
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


# AWS CloudTrail

```mermaid
flowchart LR

ct["CloudTrail Console \n (追蹤 AWS Resources 操作紀錄)"]
SDK --> ct
CLI --> ct
Console --> ct
iam["IAM Users \n IAM Roles"] --> ct

ct --> cwl["CloudWatch Logs"]
ct --> S3
```
- governance / compliance / operational auditing / risk auditing of AWS account
- [clf-CloudTrail](./cert-CLF_C01.md#aws-cloudtrail)
- 常用來排查:
    - trace API call
        - 紀錄 SDK/CLI/Console/Users/Roles 的操作
    - Audit changes to AWS Resources by users
        - 哪個小白把 AWS Resources 砍了
- 3 種 CloudTrail Events:
    1. Management Events
        - 預設啟用
        - 針對 AWS Resources 的增刪改, 都會被記錄
            - ex: EC2 的 Start, Stop ; Create IAM Role, ...
        - Events 區分為:
            - Read Events
            - Write Events (需要留意這個是否也被搞破壞, 就無法追查了)
    2. Data Events
        - 預設不啟用 (因為資料量龐大)
        - 針對 AWS Account 裡頭資源的調用
            - Event Source 目前僅能為:
                - S3
                - Lambda
            - ex: call Lambda, put S3 Object, read S3 Object, ...
        - Events 一樣區分為:
            - Read Events
            - Write Events
    3. CloudTrail Insights Events
        - Charge: 要課金 (預設不啟用)
        - 紀錄 AWS Account 裡頭 「非常規活動」
            - ex: 資源配置不正確, 資源使用達到 limits, user behavior, ...
        - Events 僅針對 *Write Events* 做紀錄
            ```mermaid
            flowchart TB;

            me["Management Events"]
            cti["CloudTrail Insights"]
            ie["Insights Events"]

            me <-- Continous analysis --> cti;
            cti -- generate --> ie;
            ie -- 預設保留 90 days --> cc["CloudTrail"]
            ie --> S3
            ie --> ebe["EventBridge Event"]
            ```
- Event History 可能要花上 15 分鐘才會有資料
