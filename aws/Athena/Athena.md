# Athena

- Athena 相關核心名詞
  - Athena Data Source : DataSource 也被稱之為 catalog
  - Athena Database : Database 也被稱之為 schema
- Athena 基於 Presto 引擎之上. Presto 是 distributed SQL Engine (由 FB 開發), 用於 大量資料進行快速查詢, 且不需要事先移動或轉換資料
  - 而 Athena 背後的 distributed Storage 之一就是 S3
- 執行 Athena query 之前, 必須要先在 Athena 裡頭註冊 Table
  - partition 與 partition projection 兩者是不一樣的東西
  - 為了要增加 query table 的效能, 可以搭配使用 partition, 有底下兩種方式可建立 partitions:
    - 使用 `AWS Glue crawler` 自動註冊 Athena Table (也就是註冊到 `AWS Glue Data Catalog`)
      - Crawlers 會自動識別 dataset 的 partition structure, 並且記錄到 `AWS Glue Data Catalog`
    - 手動建立, 則使用 `MSCK REPAIR TABLE`
      - to load partitions, 可使用 `MSCK REPAIR TABLE` 來更新 catalog 的 metadata
      - 此指令會去 scan location, 並且在 catalog 增加 partitions
      - 如果 S3 增加了新的 partition, 則必須要使用 msck repair table 來 load new partitions
      - 範例: `MSCK REPAIR TABLE ATHENA_TABLE_NAME`
- 作為查詢服務的 Amazon Athena / 作為資料倉儲服務的 Amazon Redshift / 作為複雜資料處理框架的 Amazon EMR, 基於這類的各種不同需求, 都可以無痛搭配 Athena
  - Athena 適用於各種資料結構的查詢, 並且無須 aggregate 或 load data into Athena:
    - CSV
    - TSV
    - json
    - columnar, 例如: **Apache Parquet**, **Apache ORC**
- Athena 做欄位拆解的時候, 解析欄位的這個 技術/概念/機制, 稱之為 `SerDe (Serializer/Deserializer)`
  - 至於怎樣的資料, 應該要用怎樣的 SerDe 來做解析, 可以參考: https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html
  - Create Athena Table 階段中, 可選擇底下的 SerDe 機制:
    - `ROW FORMAT DELIMITED` : (implicitly 聲明) 使用預設的 `LazySimpleSerDe` 作欄位解析
      - LazySimpleSerDe 的完整名稱為 `org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe`
    - `ROW FORMAT SERDE 'xxxSerDe'` : (explicitly 聲明) 使用 xxxSerDe 作欄位解析
      - 而例如需要做 Regex 的解析, 可使用 `ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'`
    - 除了上面的 **ROW FORMAT ...** 之外, 還可搭配 `WITH SERDEPROPERTIES (...)` 來聲明細部的欄位解析特性
- Athena 其中一個重要的應用可用來查詢 S3, 並搭配底下其中一種服務來做聯合查詢:
  - AWS Glue Data Catalog
  - external Hive metastore
  - 其他各種 prebuilt connectors
- Athena 除了查詢 S3 以外, 還可以做底下的整合查詢:
  - 連結到 Business Intelligence tool
  - 搭配使用 Athena's JDBC drivers 及 Athena's ODBC drivers
  - 查詢 AWS service logs
  - 查詢 Apache Iceberg tables 及 Apache Hudi databases
  - 查詢 Geospatial data (地理資料)
  - 藉由 Amazon SageMaker AI 的 machine learning inference
  - 使用自訂的 User-defined functions
  - 為了要 load partitions, 可使用 `partition projection` 來加速查詢那些 highly-partitioned tables, 並且做 automate partition management
- Athena Pricing:
  - 使用 Athena Query 時, 依照 Scanned 量計費: `$5/TB`
  - logs 要記得做 compress, 才能夠省成本
  - S3 做 Partition dataset 也可節省 Athena scan, ex: `s3://athena-examples/flight/parquet/year=1991/month=9/day=8/`
- Athena query 的效能, 大型檔案 效能優於 大量小檔案

# Athena Performance

- 官方建議的一次性作業 for Athena Performance
  - 增加 quota limits (因為會大量查詢 S3 Bucket)
- Athena Performance 最主要探討的有底下的方向:
  - 如何下 Athena Query 來查詢 Service
  - 如何組織資料來減少 Scanned, 加速作業及減低成本
- 關於 Athena Partition
  - Apache Hive partitions - `MSCK REPAIR TABLE` command (使用 Hive-style partitions)
  - `ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'`
  - `ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde'`

```sql
-- 像是要解析 JSON, 然後欄位裡頭包含 timestamp 欄位
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
WITH SERDEPROPERTIES ("timestamp.formats"="yyyy-MM-dd'T'HH:mm:ss.SSS'Z',yyyy-MM-dd'T'HH:mm:ss")
```

# Athena 的 partition projection

- 如果 Athena table 被高度的 partitioned, 那麼可以藉由 partition projection 來加速查詢處理
- Athena table 的 properties, 允許 `Athena to 'project', 或者, 決定必要的 partition information 而無須去 AWS Glue Data Catalog 進行更加耗時的 metadata 查詢`
- partition projection 可以預先定義分區的結構, 讓 Athena 查詢時直接利用這些預定義的資訊(in-memory), 而非去 S3 或資料源頭去撈取 metadata(remote access), 藉此提高查詢效能
- 如果查詢的時候, 有設定 **分區過濾(例如查詢特定年份)**, 則可藉由啟用了 partition projection (預先定義的分區結構), 來過濾掉不必要的 partition, 藉此可增加搜尋效率
- `partition pruning` vs. `partition projection`
  - 每次執行 Athena 查詢時, 都會對 **AWS Glue Data Catalog** 發送 `GetPartitions API request`, 如果取得到的 partitions 過多的話, 會顯著性的降低查詢效能
    - 因此借助 `partition projection`, 可避免發送 `GetPartitions API request` (因為 partition projection 已經有了必要的 partitions 資訊了)
  - `partition pruning` 則是用來修剪掉不必要的欄位 (一樣是用來加速查詢效能的方式)
- 如果使用了 partition projection 了以後:
  - partition values 及 locations 都會藉由 configuration 來做計算, 而非道 repository 去做查詢
  - 無需使用 `MSCK REPAIR TABLE` 或 `Glue Crawler`
- 使用 partition projection 的時候, 需要在 **AWS Glue Data Catalog** 或 **external Hive metastore** 裡頭聲明 **partition values 的範圍** 及 **projection types 的欄位**
  - 善用 partition projection 不僅僅可以有效增加查詢效能, 也能夠免除需要手動在 Athena/AWS Glue/external Hive metastore 裡頭建立 partition 的動作 (automates partition management)
  - Athena table 啟動了 partition projection 可讓 Athena 忽略掉 partition metadata 註冊到 AWS Glue Data Catalog 或 Hive metastore

# Athena Query

# Reference

- [ ] [Querying AWS CloudTrail Logs with Athena in AWS Organizations: Setup, Use and Challenges](https://www.virtuability.com/blog/2024-07-11-querying-aws-cloudtrail-logs-with-athena-in-aws-organizations-setup-use-and-challenges/)
  - 營養滿滿的 Athena 查詢說明!!!
  - 有提到關於 JSON 欄位的解析查詢 - json_extract_scalar
  - 有提到關於 partition projection 的建立
  - 有提到關於 injected 欄位的聲明
- [ ] [Top 10 Performance Tuning Tips for Amazon Athena](https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/)
  - 營養滿滿的 Athena partition 查詢說明 & 執行效能分析 (但比較深, 看不懂)
- [ ] [Using Athena data source](https://docs.aws.amazon.com/grafana/latest/userguide/Athena-using-the-data-source.html)
  - 裡頭有對於 Athena 的 內建功能做解說
- [x] [How do I use Amazon Athena to analyze my Application Load Balancer access logs?](https://repost.aws/knowledge-center/athena-analyze-access-logs)
  - 營養價值不是很高, 但裡頭有提到非常多實用的 Athena - alb access logs 的查詢
  - 裡頭只有講到為 alb access log 建立 partition projection 的 Athena Table
- [x] [Get started Athena](https://docs.aws.amazon.com/athena/latest/ug/getting-started.html)
  - 沒啥重要的資訊...
- [x] [Visualize Amazon S3 data using Amazon Athena and Amazon Managed Grafana](https://aws.amazon.com/blogs/big-data/visualize-amazon-s3-data-using-amazon-athena-and-amazon-managed-grafana/)
  - Grafana 要使用 Athena 的話, 可授予 `AmazonGrafanaAthenaAccess` Policy
  - Pricing : 會使用到 Athena 匯入 Open DataSet, 200 GiB, 大概要花 $1
- [x] [How do I use Amazon Athena to analyze my Amazon S3 server access logs?](https://repost.aws/knowledge-center/analyze-logs-athena)
  - 使用 Athena 分析 S3 Server Access log
  - 有許多查詢 logs 的 SQL 可以參考
- [x] [Automating AWS service logs table creation and querying them with Amazon Athena](https://aws.amazon.com/blogs/big-data/automating-aws-service-logs-table-creation-and-querying-them-with-amazon-athena/)
  - 使用 CloudFormation 自動化建立 AWS service log tables / partitions / queries
  - 文章營養成分不高.... 雖說提到用 CloudFormation 建立 Athena Table, 但是裡頭沒提到 CloudFormation Template 的內容...
  - 重點圍繞在要怎麼查, 則應該要建立對應的 Partition 來 Increase Performance && Lower Costs
- [x] [Create a table for CloudTrail logs in Athena using manual partitioning](https://docs.aws.amazon.com/athena/latest/ug/create-cloudtrail-table.html)
  - 裡頭提到如果又解析的 STRING 欄位, 其實是個 JSON, 那就要使用 `JSON_EXTRACT` Function
- [x] [Create the table for ALB access logs in Athena using partition projection](https://docs.aws.amazon.com/athena/latest/ug/create-alb-access-logs-table-partition-projection.html)
  - 看完以後沒啥心得... 依舊不明白 partition projection 是啥東西
- [x] [Create the table for ALB access logs](https://docs.aws.amazon.com/athena/latest/ug/create-alb-access-logs-table.html)
  - 提到了 ALB access logs 會隨著時間而增減欄位, 因此建立 Athena Table 的時候, 需要留意是否 ALB access log 有這個欄位 (沒有的話記得在 Athena create table 的時候刪除)
  - 短短一篇 Athena ALB access logs, 重點大概就只有上面這樣= =
- [x] [Use partition projection with Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)
  - 裡頭比較多的感受是得知了 `partition pruning` 及 `partition projection` 的差異, 除此之外零碎的概念居多...
- [ ] [Easily query AWS service logs using Amazon Athena](https://aws.amazon.com/blogs/big-data/easily-query-aws-service-logs-using-amazon-athena/)
  - 使用 Python library for AWS Glue 建立一套用來處理 AWS service logs, 並使用 Athena Query
- [ ] [Optimize Athena performance](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)
  - 探討關於 Athena 的最佳化議題.... (慢慢看了)
- [ ] [Improve productivity by using keyboard shortcuts in Amazon Athena query editor](https://aws.amazon.com/blogs/big-data/improve-productivity-by-using-keyboard-shortcuts-in-amazon-athena-query-editor/)
  - Athena 的熱鍵
