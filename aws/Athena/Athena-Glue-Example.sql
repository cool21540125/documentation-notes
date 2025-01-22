-- https://aws.amazon.com/cn/blogs/china/amazon-athena-partition-projection-and-glue-partition-indexes-performance-comparison/
-- 
CREATE EXTERNAL TABLE `table_without_index` (
    `id` string COMMENT 'from deserializer',
    `value` double COMMENT 'from deserializer'
) PARTITIONED BY (
    `year` string,
    `month` string,
    `day` string,
    `hour` string
) 
ROW FORMAT SERDE 
    'org.openx.data.jsonserde.JsonSerDe' 
STORED AS INPUTFORMAT 
    'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
    'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' 
LOCATION 
    's3://awsglue-datasets/examples/highly-partitioned-table/' 
TBLPROPERTIES (
    'classification' = 'json'
)

-- 