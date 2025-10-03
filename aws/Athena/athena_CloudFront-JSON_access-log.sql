--  ----------------------------------------------------------------------------------------
--  -- Create Athena Table - CloudFront - access log - cloudfront_logs
--  https://docs.aws.amazon.com/athena/latest/ug/create-cloudfront-table-partition-json.html
--  ---------------------------------------------------------------------------------------- 

CREATE EXTERNAL TABLE `__YOUR_TABLE_NAME__`(
  `date` string, 
  `time` string, 
  `x-edge-location` string, 
  `sc-bytes` string, 
  `c-ip` string, 
  `cs-method` string, 
  `cs(host)` string, 
  `cs-uri-stem` string, 
  `sc-status` string, 
  `cs(referer)` string, 
  `cs(user-agent)` string, 
  `cs-uri-query` string, 
  `cs(cookie)` string, 
  `x-edge-result-type` string, 
  `x-edge-request-id` string, 
  `x-host-header` string, 
  `cs-protocol` string, 
  `cs-bytes` string, 
  `time-taken` string, 
  `x-forwarded-for` string, 
  `ssl-protocol` string, 
  `ssl-cipher` string, 
  `x-edge-response-result-type` string, 
  `cs-protocol-version` string, 
  `fle-status` string, 
  `fle-encrypted-fields` string, 
  `c-port` string, 
  `time-to-first-byte` string, 
  `x-edge-detailed-result-type` string, 
  `sc-content-type` string, 
  `sc-content-len` string, 
  `sc-range-start` string, 
  `sc-range-end` string)
  PARTITIONED BY(
         distributionid string,
         year int,
         month int,
         day int,
         hour int )
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES ( 
  'paths'='c-ip,c-port,cs(Cookie),cs(Host),cs(Referer),cs(User-Agent),cs-bytes,cs-method,cs-protocol,cs-protocol-version,cs-uri-query,cs-uri-stem,date,fle-encrypted-fields,fle-status,sc-bytes,sc-content-len,sc-content-type,sc-range-end,sc-range-start,sc-status,ssl-cipher,ssl-protocol,time,time-taken,time-to-first-byte,x-edge-detailed-result-type,x-edge-location,x-edge-request-id,x-edge-response-result-type,x-edge-result-type,x-forwarded-for,x-host-header') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://__BUCKET_NAME__/AWSLogs/__ACCOUNT_ID__/CloudFront/'
TBLPROPERTIES (
  'projection.distributionid.type'='enum',
  'projection.distributionid.values'='__DISTRIBUTION_ID__',
  'projection.enabled'='true', 
  'projection.year.type'='integer', 
  'projection.year.range'='2025,2026', 
  'projection.month.type'='integer', 
  'projection.month.range'='01,12', 
  'projection.month.digits'='2', 
  'projection.day.type'='integer', 
  'projection.day.range'='01,31', 
  'projection.day.digits'='2', 
  'projection.hour.type'='integer',
  'projection.hour.range'='00,23',
  'projection.hour.digits'='2',
  'storage.location.template'='s3://__BUCKET_NAME__/AWSLogs/__ACCOUNT_ID__/CloudFront/${distributionid}/${year}/${month}/${day}/${hour}/');
