# Athena Query

- 如果選擇了 `org.apache.hadoop.mapred.TextInputFormat` 這種 INPUTFORMAT 的話, 需要自行決定使用哪一種 SerDe 來解析文字內容
  - `Avro SerDe`
  - `CloudTrail SerDe`
  - `Grok SerDe`
  - `JSON SerDe`
  - `LazySimpleSerDe`
  - `OpenCSVSerDe`
  - `ORC SerDe`
  - `Parquet SerDe`
  - `RegexSerDe`

```sql
-- -------------------------------------------------------------------
-- | 各種 Create Athena Table 的格式
-- -------------------------------------------------------------------

-- ex1: 文字格式 (ex: ALB access log)
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
-- -------------------------------------------------------------------

-- ex2: Parquet 格式
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
-- 等同於
STORED AS PARQUET
-- -------------------------------------------------------------------

-- ex3: ORC 格式
STORED AS ORC
-- -------------------------------------------------------------------

-- ex4: JSON 格式
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
-- -------------------------------------------------------------------

-- ex5: CSV 格式
STORED AS TEXTFILE
-- -------------------------------------------------------------------


-- ex6: CloudTrail 格式
-- REF1
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'

-- REF2
ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'

-- REF3
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'

OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
```

- REF1
  - AWS 官方建議, 專門用來給 CloudTrail 解析 JSON
  - Apache Hive 提供的標準 JSON SerDe
  - 文章提到早期有 BUG, 現在不知道修好了沒
    - https://www.virtuability.com/blog/2024-07-11-querying-aws-cloudtrail-logs-with-athena-in-aws-organizations-setup-use-and-challenges/
- REF2
  - AWS 官方已宣告 2025/06 此為 DEPRECATED. 建議改用 REF1
  - Amazon EMR 團隊開發出來的 (或許使用 EMR 的話用這個會比較好吧!?)
- REF3
  - OpenX 開發的 3rd JSON SerDe, 適合用來處理非標準 or 動態 JSON 結構
  - 並非 AWS 官方建議, 然而文章建議用這種方式
    - - https://www.virtuability.com/blog/2024-07-11-querying-aws-cloudtrail-logs-with-athena-in-aws-organizations-setup-use-and-challenges/
