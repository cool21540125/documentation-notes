# Reference

- [Supported logs and discovered fields](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_AnalyzeLogData-discoverable-fields.html#CWL_AnalyzeLogData-discoverable-JSON-logs)

因為 CloudTrail 的格式 @message 欄位是固定的, 為 JSON

CloudTrail 查詢時不需使用其他額外表示式, 直接 a.b.c 即可查詢 JSON 內的欄位

```
fields @timestamp, @message
| filter awsRegion='us-east-1'
```
