--  ----------------------------------------------------------------------------------------
--  -- Create Athena Table - CloudFront - access log - cloudfront_logs
--  ---------------------------------------------------------------------------------------- 
-- 
CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_logs (
    `Date` DATE,
    Time STRING,
    Location STRING,
    Bytes INT,
    RequestIP STRING,
    Method STRING,
    Host STRING,
    Uri STRING,
    Status INT,
    Referrer STRING,
    ClientInfo STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION 's3://__BUCKET_NAME__/cloudfront/plaintext/';

-- 如果 Table 裡頭不包含 nested 欄位, 基本上都可以使用像這樣的方式來做欄位解析 (\t 及 \n 並搭配 LazySimpleSerDe)
-- ROW FORMAT DELIMITED : 使用 LazySimpleSerDe 這個 default library 來解析資料
----------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------