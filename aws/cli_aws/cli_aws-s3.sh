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

###
