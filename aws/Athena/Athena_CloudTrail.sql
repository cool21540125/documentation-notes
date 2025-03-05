-- 
-- AWS 官方提供的 Cloudtrail logs in Athena - 使用 Partition projection
--   https://docs.aws.amazon.com/athena/latest/ug/create-cloudtrail-table-partition-projection.html
-- 使用 partition projection 的優點
--   1. 降低 Runtime query 的成本
--   2. automate partition management (partition projection 會自動為 new data 加入 partition)
--      藉此免除需要手動 `ALTER TABLE ADD PARTITION` 的動作
-- 
-- 
-- https://www.virtuability.com/blog/2024-07-11-querying-aws-cloudtrail-logs-with-athena-in-aws-organizations-setup-use-and-challenges/
-- 這篇文件提到了, 關於使用 Athena 查詢 `Organization` 的 CloudTrail logs 的話, 有 3 種 SerDe:
--   org.apache.hive.hcatalog.data.JsonSerDe : AWS 官方建議, 不過這篇文件提到早期這有 BUG, 但不知道修好了沒
--   com.amazon.emr.hive.serde.CloudTrailSerde : 似乎已經是 legacy 了
--   org.openx.data.jsonserde.JsonSerDe : 這篇文件建議的方式(2024/07/11)
-- 

CREATE EXTERNAL TABLE cloudtrail_logs_partition_projection (
    eventversion STRING,
    useridentity STRUCT<
        type: STRING,
        principalid: STRING,
        arn: STRING,
        accountid: STRING,
        invokedby: STRING,
        accesskeyid: STRING,
        username: STRING,
        onbehalfof: STRUCT<
            userid: STRING,
            identitystorearn: STRING>,
        sessioncontext: STRUCT<
            attributes: STRUCT<
                mfaauthenticated: STRING,
                creationdate: STRING>,
            sessionissuer: STRUCT<
                type: STRING,
                principalid: STRING,
                arn: STRING,
                accountid: STRING,
                username: STRING>,
            ec2roledelivery:string,
            webidfederationdata: STRUCT<
                federatedprovider: STRING,
                attributes: map<string,string>>
        >
    >,
    eventtime STRING,
    eventsource STRING,
    eventname STRING,
    awsregion STRING,
    sourceipaddress STRING,
    useragent STRING,
    errorcode STRING,
    errormessage STRING,
    requestparameters STRING,
    responseelements STRING,
    additionaleventdata STRING,
    requestid STRING,
    eventid STRING,
    readonly STRING,
    resources ARRAY<STRUCT<
        arn: STRING,
        accountid: STRING,
        type: STRING>>,
    eventtype STRING,
    apiversion STRING,
    recipientaccountid STRING,
    serviceeventdetails STRING,
    sharedeventid STRING,
    vpcendpointid STRING,
    vpcendpointaccountid STRING,
    eventcategory STRING,
    addendum STRUCT<
        reason:STRING,
        updatedfields:STRING,
        originalrequestid:STRING,
        originaleventid:STRING>,
    sessioncredentialfromconsole STRING,
    edgedevicedetails STRING,
    tlsdetails STRUCT<
        tlsversion:STRING,
        ciphersuite:STRING,
        clientprovidedhostheader:STRING>)
PARTITIONED BY (
    `day` string)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
    's3://__YOUR_S3_BUCKET__/AWSLogs/__AWS_ACCOUNT_ID__/CloudTrail/__REGION__'
TBLPROPERTIES (
    'projection.enabled'='true', 
    'projection.day.format'='yyyy/MM/dd', 
    'projection.day.interval'='1', 
    'projection.day.interval.unit'='DAYS', 
    'projection.day.range'='2024/12/01,NOW', -- Change start date
    'projection.day.type'='date', 
    'storage.location.template'='s3://__YOUR_S3_BUCKET__/AWSLogs/__AWS_ACCOUNT_ID__/CloudTrail/__REGION__/${day}')

-- 
-- Cloudtrail Athena Query 
--   https://docs.aws.amazon.com/athena/latest/ug/cloudtrail-logs.html
-- 
