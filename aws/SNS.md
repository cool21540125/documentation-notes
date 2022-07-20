
# Simple Notification Service, SNS

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


# Security

- 同 SQS, 傳輸中加密, 也可額外設定 Server Side Encryption
- Access Control, 核心為 IAM
- SNS Access Policy
    - 同 S3, SQS. 也可設定 Resource Policy, Cross Account && Cross AWS Services
- 搭配 SQS, 做 fan out
    - SQS 需 allow SNS write

    ```mermaid
    flowchart TD;
    buy["Buying Service"];
    f["Fraud Service"];
    s["Shipping Service"];

    buy -- pub --> SNS;
    SNS <-- sub --> SQS1;
    SNS <-- sub --> SQS2;
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
