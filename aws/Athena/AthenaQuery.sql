-- 
CREATE EXTERNAL TABLE cloudtrail_logs (
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
                username: STRING>,
            ec2RoleDelivery: STRING,
            webIdFederationData: MAP<STRING,STRING>>>,
    eventTime STRING,
    eventSource STRING,
    eventName STRING,
    awsRegion STRING,
    sourceIpAddress STRING,
    userAgent STRING,
    errorCode STRING,
    errorMessage STRING,
    requestParameters STRING,
    responseElements STRING,
    additionalEventData STRING,
    requestId STRING,
    eventId STRING,
    resources ARRAY<STRUCT<
        arn: STRING,
        accountId: STRING,
        type: STRING>>,
    eventType STRING,
    apiVersion STRING,
    readOnly STRING,
    recipientAccountId STRING,
    serviceEventDetails STRING,
    sharedEventID STRING,
    vpcEndpointId STRING,
    tlsDetails STRUCT<
        tlsVersion: STRING,
        cipherSuite: STRING,
        clientProvidedHostHeader: STRING>
)
COMMENT 'CloudTrail table for aws-cloudtrail-logs bucket'
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://aws-cloudtrail-logs-/'
TBLPROPERTIES ('classification'='cloudtrail');

-- 


-- https://gist.github.com/0xdeadbeefJERKY/25eb17714657ce3847a299a84648a26d


-- AAA 建立表格時
-- https://www.virtuability.com/blog/2024-07-10-querying-cloudtrail-logs-with-athena/

CREATE EXTERNAL TABLE cloudtrail_tracing202406 (
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
    `delivered_timestamp` string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
-- STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
    's3://aws-cloudtrail-logs-換成你的AWS_ACCOUNT_ID-45ae7317/AWSLogs/換成你的AWS_ACCOUNT_ID/'
TBLPROPERTIES (
    'projection.enabled'='true',
    'projection.origin_region.type'='injected',
    'projection.delivered_timestamp.type'='date',
    'projection.delivered_timestamp.format'='yyyy/MM/dd',
    'projection.delivered_timestamp.interval'='1',
    'projection.delivered_timestamp.interval.unit'='DAYS',
    'projection.delivered_timestamp.range'='2024/06/01,NOW',
    'storage.location.template'='s3://aws-cloudtrail-logs-換成你的AWS_ACCOUNT_ID-45ae7317/AWSLogs/換成你的AWS_ACCOUNT_ID/CloudTrail/${origin_region}/${delivered_timestamp}'
)


-- AAA 查詢時
SELECT * FROM "default"."cloudtrail_tracing202406" 
WHERE 
    origin_account in ('換成你的AWS_ACCOUNT_ID')
	AND delivered_timestamp BETWEEN '2024/06/10' AND '2024/09/10';


SELECT * FROM "default"."cloudtrail_tracing202406" 
WHERE 
    origin_region in ('ap-northeast-1', 'ap-northeast-2', 'ap-northeast-3', 'ap-south-1', 'ap-southeast-1', 'ap-southeast-2', 'ca-central-1', 'eu-central-1', 'eu-north-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'sa-east-1', 'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2') AND 
    delivered_timestamp BETWEEN '2024/06/10' AND '2024/09/10' AND sourceipaddress = '36.70.236.27';


-- TBLPROPERTIES (
--     'projection.enabled'='true', 
--     'projection.timestamp.format'='yyyy/MM/dd', 
--     'projection.timestamp.interval'='1', 
--     'projection.timestamp.interval.unit'='DAYS', 
--     'projection.timestamp.range'='$START_TIMESTAMP,$END_TIMESTAMP', 
--     'projection.timestamp.range'='2024/06/01,2024/06/30',
--     'projection.timestamp.type'='date', 
--     'storage.location.template'='s3://aws-cloudtrail-logs-換成你的AWS_ACCOUNT_ID-45ae7317/'
-- )

-- 