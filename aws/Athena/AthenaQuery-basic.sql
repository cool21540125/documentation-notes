
-- 
ALTER TABLE TABLE_NAME ADD
    PARTITION (region='us-west-2',
               year='2025',
               month='01')
    LOCATION 's3://BUCKET_NAME/PREFIX/AWSLogs/ACCOUNT_ID/CloudTrail/us-west-2/2025/01/';

-- 
SHOW partitions TABLE_NAME;

-- 