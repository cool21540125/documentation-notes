#!/bin/bash
exit 0
#
# Leveraging the s3 and s3api Commands
#     https://aws.amazon.com/blogs/developer/leveraging-the-s3-and-s3api-commands/
#
# aws s3 ... 此為 High Level API
#  --page-size VALUE
#
# aws s3api ... 此為 Low Level API
#  --page-size VALUE
#  --starting-token VALUE
#  --max-items VALUE
#  --starting-token TOKEN
#
# Pagination
#   Server Side
#     --no-paginate
#     --page-size
#     --starting-token
#     --max-items
#
#   Client Side
#     --query JMESPATH
#
### =================== 好用的設定(一定要配的啦~) ===================

### AWS CLI settings
aws configure set default.s3.max_concurrent_requests 1000
# S3 concurrent 上傳(default: 10)
# aws CLI concurrent upload to S3

#或者
# pass

### =================== 常見操作 ===================

export AWS_PROFILE=xxx
export AWS_REGION=ap-northeast-1

### 同步 S3 Buckets
# cp v.s. sync - https://stackoverflow.com/questions/64728076/aws-s3-cp-vs-aws-s3-sync-behavior-and-cost
# sync - https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/sync.html
# cp - https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/cp.html
aws s3 sync s3://blog.tonychoucc.com s3://tonychoucc.com
aws s3 cp $FILE_PATH s3://$S3_URI

### 列出 Bucket 裡頭所有資料及大小 (幾乎等同於 ls -lhR *)
# WARNING: 別對 large Bucket 使用
# https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html
aws s3 ls --summarize --human-readable --recursive s3://${BUCKET_NAME}
# --no-sign-request : 不對請求做 Signing (對於 Public Access 或是沒有機敏資訊的 S3 Bucket 是個不錯的查詢方式)
# --summarize       : 所有 objects 的摘要資訊

### Bucket Size
aws s3api list-buckets --query "Buckets[].Name" --output text | while IFS= read -r BUCKET; do
  aws s3 ls --summarize --human-readable s3://${BUCKET} | tail -2
done

### 列出 S3 Bucket Size (僅適用於 Linux GnU Shell / Macbook 會掛掉)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/get-metric-statistics.html
## for Linux
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name BucketSizeBytes \
  --start-time "$(date -u --date="1 hour ago" +%Y-%m-%dT%H:%M:%S)Z" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%S)Z" \
  --period 3600 \
  --statistic Average \
  --dimensions Name=BucketName,Value=${BUCKET} Name=StorageType,Value=StandardStorage

## for Mac (起迄時間需要自己填, UTC)
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name BucketSizeBytes \
  --start-time 2025-01-12T00:00:00Z \
  --end-time 2025-01-14T03:00:00Z \
  --period 3600 \
  --statistic Average \
  --dimensions Name=BucketName,Value=${BUCKET} Name=StorageType,Value=StandardStorage
#

###
