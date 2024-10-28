- [How do I analyze my Amazon S3 server access logs using Athena?](https://aws.amazon.com/premiumsupport/knowledge-center/analyze-logs-athena/?nc1=h_ls)

# Athena

- use SQL query on S3, 用來做分析
  - file 可以是 CSV, JSON, ORC, Avro, Parquet(built on Presto)
  - 後面可以接 **Amazon QuickSight** 來做報表
- Use Case:
  - BI / analytics / reporting, analyze & query VPC Flow Logs, ELB Logs / CloudTrail trails, serverless SQL analyze S3, ...
- Cost
  - `$5/TB second`
  - 因為 by scan 量收費, 若 data 有做 Compress 或 columnar 方式儲存, 可省下 $$
  - per query / per TB of data scanned- 可下 SQL 對 S3 查詢做分析
  - S3 做 Partition dataset 也可節省 Athena scan, ex: _s3://athena-examples/flight/parquet/year=1991/month=9/day=8/_
- 支援 csv, json, ORC, Avor, Parquet(built on Presto)
- Athena query 對於少數的大檔效能較優 (相較於 大量的碎檔)

---

```mermaid
flowchart LR;
User -- load data --> s3;
s3 -- Query & Analyze --> Athena;
Athena -- Report & Dashboard --> QuickSight;
```

---
