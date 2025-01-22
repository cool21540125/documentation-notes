-- 
-- https://www.virtuability.com/blog/2024-07-11-querying-aws-cloudtrail-logs-with-athena-in-aws-organizations-setup-use-and-challenges/
-- 這篇文件提到了, 關於使用 Athena 查詢 `Organization` 的 CloudTrail logs 的話, 有 3 種 SerDe:
--   org.apache.hive.hcatalog.data.JsonSerDe : AWS 官方建議, 不過這篇文件提到早期這有 BUG, 但不知道修好了沒
--   com.amazon.emr.hive.serde.CloudTrailSerde : 似乎已經是 legacy 了
--   org.openx.data.jsonserde.JsonSerDe : 這篇文件建議的方式(2024/07/11)
-- 
CREATE EXTERNAL TABLE cloudtrail_logs(
    eventVersion STRING,
    userIdentity STRUCT<
        type: STRING,
        principalId: STRING,
        arn: STRING,
        accountId: STRING,
        invokedBy: STRING,
        accessKeyId: STRING,
        userName: STRING,
        sessionContext: STRUCT<
            attributes: STRUCT<
                mfaAuthenticated: STRING,
                creationDate: STRING>,
            sessionIssuer: STRUCT<
                type: STRING,
                principalId: STRING,
                arn: STRING,
                accountId: STRING,
                userName: STRING>,
            ec2RoleDelivery:string,
            webIdFederationData: STRUCT<
                federatedProvider: STRING,
                attributes: map<string,string>
            >
        >
    >,
    eventTime STRING,
    eventSource STRING,
    eventName STRING,
    awsRegion STRING,
    sourceIpAddress STRING,
    userAgent STRING,
    errorCode STRING,
    errorMessage STRING,
    requestparameters STRING,
    responseelements STRING,
    additionaleventdata STRING,
    requestId STRING,
    eventId STRING,
    readOnly STRING,
    resources ARRAY<STRUCT<
        arn: STRING,
        accountId: STRING,
        type: STRING>>,
    eventType STRING,
    apiVersion STRING,
    recipientAccountId STRING,
    serviceEventDetails STRING,
    sharedEventID STRING,
    vpcendpointid STRING,
    eventCategory STRING,
    tlsDetails struct<
        tlsVersion:string,
        cipherSuite:string,
        clientProvidedHostHeader:string>
    )
PARTITIONED BY (
    `origin_region` string,
    `origin_account` string,
    `delivered_timestamp` string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
    's3://aws-controltower-logs-123456789012-eu-west-1/o-123456789a/AWSLogs/o-123456789a/'
TBLPROPERTIES (
    'projection.enabled'='true',
    'projection.origin_account.type'='injected',
    'projection.origin_region.type'='injected',
    'projection.delivered_timestamp.type'='date',
    'projection.delivered_timestamp.format'='yyyy/MM/dd',
    'projection.delivered_timestamp.interval'='1',
    'projection.delivered_timestamp.interval.unit'='DAYS',
    'projection.delivered_timestamp.range'='2023/01/01,NOW',
    'storage.location.template'='s3://aws-controltower-logs-123456789012-eu-west-1/o-123456789a/AWSLogs/o-123456789a/${origin_account}/CloudTrail/${origin_region}/${delivered_timestamp}');

-- 
-- 
-- 