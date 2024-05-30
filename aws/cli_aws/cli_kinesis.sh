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
#ShardIterator: AAAAAAAAAAHewPk7PVKnPT58LwpW+xr8CWmdxdJIjlOJxLWRRsHnT9qeH9TyfasykAuSq7eaExo/2wvEnRdCq+gXGG/aEgDuRmzvSRo4ZNMHQUYzPVC313qM9HNSgurLX5xUCDPXDcZcfHFPt1D3Z5YarXycXqQ1RuHdk6RRrQadzh3I6A/Z1dpipMQi6LuOlIAkr0XMr2F0wljmHg89uVVQX6mSXf1qunYlKLB6qVsD85VYwMb5sA==
SHARD_ITERATOR=AAAAAAAAAAHewPk7PVKnPT58LwpW+xr8CWmdxdJIjlOJxLWRRsHnT9qeH9TyfasykAuSq7eaExo/2wvEnRdCq+gXGG/aEgDuRmzvSRo4ZNMHQUYzPVC313qM9HNSgurLX5xUCDPXDcZcfHFPt1D3Z5YarXycXqQ1RuHdk6RRrQadzh3I6A/Z1dpipMQi6LuOlIAkr0XMr2F0wljmHg89uVVQX6mSXf1qunYlKLB6qVsD85VYwMb5sA==


### 由 KDS - shard 拿取 record
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis/get-records.html
aws kinesis get-records \
  --shard-iterator $SHARD_ITERATOR


### 