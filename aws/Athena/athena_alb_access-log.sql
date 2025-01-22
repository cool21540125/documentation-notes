----------------------------------------------------------------------------------------
-- Create Athena Table - Load Balancer - access log
---------------------------------------------------------------------------------------- 
CREATE EXTERNAL TABLE IF NOT EXISTS alb_OfficialService (
    type string,
    time string,
    elb string,
    client_ip string,
    client_port int,
    target_ip string,
    target_port int,
    request_processing_time double,
    target_processing_time double,
    response_processing_time double,
    elb_status_code int,
    target_status_code string,
    received_bytes bigint,
    sent_bytes bigint,
    request_verb string,
    request_url string,
    request_proto string,
    user_agent string,
    ssl_cipher string,
    ssl_protocol string,
    target_group_arn string,
    trace_id string,
    domain_name string,
    chosen_cert_arn string,
    matched_rule_priority string,
    request_creation_time string,
    actions_executed string,
    redirect_url string,
    lambda_error_reason string,
    target_port_list string,
    target_status_code_list string,
    classification string,
    classification_reason string,
    conn_trace_id string
)
PARTITIONED BY (
    `day` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
        'serialization.format' = '1',
        'input.regex' = '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\\s]+?)\" \"([^\\s]+)\" \"([^ ]*)\" \"([^ ]*)\" ?([^ ]*)?'
    ) 
LOCATION 
    's3://alb-log-303053866824-us-west-2/OfficialService/AWSLogs/303053866824/elasticloadbalancing/us-west-2/'
TBLPROPERTIES (
    "projection.enabled" = "true",
    "projection.day.type" = "date",
    "projection.day.range" = "2025/01/01,NOW",
    "projection.day.format" = "yyyy/MM/dd",
    "projection.day.interval" = "1",
    "projection.day.interval.unit" = "DAYS",
    "storage.location.template" = "s3://alb-log-303053866824-us-west-2/OfficialService/AWSLogs/303053866824/elasticloadbalancing/us-west-2/${day}/"
);
--
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
    ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION 's3://BUCKET_NAME/cloudfront/plaintext/';

-- 如果 Table 裡頭不包含 nested 欄位, 基本上都可以使用像這樣的方式來做欄位解析 (\t 及 \n 並搭配 LazySimpleSerDe)
-- ROW FORMAT DELIMITED : 使用 LazySimpleSerDe 這個 default library 來解析資料
----------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------