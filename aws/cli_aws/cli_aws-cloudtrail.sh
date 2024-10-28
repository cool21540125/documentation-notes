#!/bin/bash
exit 0
# --------------------------------------------------------------------

### 驗證 CloudTrail logs 是否遭到竄改 CloudTrail Integrity (完整性驗證)
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-cli.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudtrail/validate-logs.html
export AWS_ACCOUNT=
export AWS_REGION=us-west-2
aws cloudtrail validate-logs \
  --trail-arn arn:aws:cloudtrail:${AWS_REGION}:${AWS_ACCOUNT}:trail/tf-management-write-events \
  --start-time 2024-06-10T00:00:00Z \
  --end-time 2024-06-12T00:00:00Z \
  --verbose
