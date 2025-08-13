----------------------------------------------------------------------------------------
-- Create Athena Table - CloudTrail logs
---------------------------------------------------------------------------------------- 
CREATE EXTERNAL TABLE __YOUR_ALB_TABLE_NAME__ (
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
        clientprovidedhostheader:STRING>
)
PARTITIONED BY (
    `region` STRING,
    `day` STRING
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
    's3://__BUCKET_NAME__/__BUCKET_PREFIX__/AWSLogs/__ACCOUNT_ID__/CloudTrail'
TBLPROPERTIES (
    'projection.enabled' = 'true',
    'projection.day.type' = 'date',
    'projection.day.range' = '2025/01/01,NOW',
    'projection.day.format' = 'yyyy/MM/dd',
    'projection.day.interval' = '1',
    'projection.day.interval.unit' = 'DAYS',
    'storage.location.template' = 's3://__BUCKET_NAME__/__BUCKET_PREFIX__/AWSLogs/__ACCOUNT_ID__/CloudTrail/${region}/${day}'
    'projection.region.values' = 'us-west-2,us-east-1,ap-northeast-1,ap-east-2,__視情況加入有使用到的其他Region__',
);
-- NOTE: 需要留意 __BUCKET_PREFIX__, 大家放的路徑可能不同
