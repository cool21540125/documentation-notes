#!/bin/bash
exit 0
#
# aws s3 ... 此為 High Level API
#  --page-size VALUE
#
# aws s3api ... 此為 Low Level API
#  --page-size VALUE
#  --starting-token VALUE
#  --max-items VALUE
# --starting-token TOKEN
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

### =================== 常見操作 ===================

export AWS_PROFILE=xxx
export AWS_REGION=ap-northeast-1

### 同步 S3 Buckets
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/sync.html
aws s3 sync s3://blog.tonychoucc.com s3://tonychoucc.com

### 列出 Bucket 裡頭所有資料及大小 (幾乎等同於 ls -lhR *) WARNING: 別對 large Bucket 使用
# https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html
BUCKET_NAME=
aws s3 ls --summarize --human-readable --recursive s3://${BUCKET_NAME}

### 列出 all Buckets (建立時間 & 名稱)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-buckets.html
aws s3api list-buckets
