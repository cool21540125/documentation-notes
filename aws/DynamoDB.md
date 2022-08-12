
# DynamoDB Common

- [CLF-DynamoDB](./cert-CLF_C01.md#dynamodb)
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


# DynamoDB Streams


