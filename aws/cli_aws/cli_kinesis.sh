#/bin/bash
exit 0


### ================================== Kinesis Data Stream ==================================


aws kinesis describe-stream --stream-name $STREAM_NAME

aws kinesis list-streams


### 寫入測試資料到 KDS
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis/put-record.html
aws kinesis put-record \
  --stream-name $STREAM_NAME \
  --partition-key 123 \
  --data "Test Event Record" \
  --cli-binary-format raw-in-base64-out
#SequenceNumber: '49651664165295404105531111269707766195609363655767883778'
#ShardId: shardId-000000000000
SHARD_ID=shardId-000000000000


### 
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis/get-shard-iterator.html
aws kinesis get-shard-iterator \
  --stream-name $STREAM_NAME \
  --shard-id $SHARD_ID \
  --shard-iterator-type TRIM_HORIZON
#ShardIterator: AAAAAAAAAAHD8u6sVzMqXyQb9bDvV91O3QQPE9xGugJmvqsHAV3+5xacKmIHrSybYcJ+xZwRLk4KW/dw6QbSv0r4BMGIp/dzMt++h4UvaQBNT9y5BPikBuj86KfBQQl9WGDGzR0XmrvDM9mO4a/ax7uMpxlP4IrB3YtvRqSA9qgZw+H6vWe/u0Au9HOacwenus4n+LplAPnEBXzMQbyazvSDQ7fpOs3nBF1lE/6Bd1GILG2kR63kng==
SHARD_ITERATOR=AAAAAAAAAAHD8u6sVzMqXyQb9bDvV91O3QQPE9xGugJmvqsHAV3+5xacKmIHrSybYcJ+xZwRLk4KW/dw6QbSv0r4BMGIp/dzMt++h4UvaQBNT9y5BPikBuj86KfBQQl9WGDGzR0XmrvDM9mO4a/ax7uMpxlP4IrB3YtvRqSA9qgZw+H6vWe/u0Au9HOacwenus4n+LplAPnEBXzMQbyazvSDQ7fpOs3nBF1lE/6Bd1GILG2kR63kng==


### 由 KDS - shard 拿取 record
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis/get-records.html
aws kinesis get-records \
  --shard-iterator $SHARD_ITERATOR


### 