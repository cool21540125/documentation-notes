#!/bin/env bash
exit 0
# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
#
#
# ------------------------------------------------------------------------------

### List instances
aws ec2 describe-instances

# filter - instanceId
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId" | yq '.[]'

# filter - EIP & DnsName
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].NetworkInterfaces[].Association"

### 讓 EC2 找到自身的 meta-data, 但只能在 *Web Console* && *CLI*, 這動作本身不需要權限
curl http://169.254.169.254/latest/meta-data
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html

### CLI 找機器的 meta-data
aws ec2 describe-instances

### 查詢 EC2 Instance 的 ImageID
aws ec2 describe-instances \
  --instance-ids $EC2_Instance_ID \
  --region $Region \
  --query 'Reservations[0].Instances[0].ImageId'

###

### Start instance (which is stopped)
aws ec2 start-instances --instance-ids $InstanceId
#StartingInstances:
#- CurrentState:
#    Code: 0
#    Name: pending
#  InstanceId: i-xxxxxxxxxxxxxxxxx
#  PreviousState:
#    Code: 80
#    Name: stopped

### ======================================================
### start EC2
AWS_REGION=ap-northeast-1      # IMAGE 會綁定 Region, 可用這個來做切換
IMAGE_ID=ami-0b7546e839d7ace12 # ap-northeast-1 的 Amazon Linux 2 AMI x86-64
aws ec2 run-instances \
  --image-id ${IMAGE_ID} \
  --instance-type t2.micro \
  --key-name ${KEY} \
  --dry-run

#An error occurred (DryRunOperation) when calling the RunInstances operation: Request would have succeeded, but DryRun flag is set.
# 如果看到這樣, 表示指令可成功下達. 但因家了 --dry-run, 所以沒實際跑下去

### ======================================================

### 啟動 EC2 的 detailed monitoring
aws ec2 monitor-instances --instance-ids ${Instance_ID}

### 列出已經申請的 Elastic IPs
aws ec2 describe-addresses --query 'Addresses[*].PublicIp'

# ======================================================

###
# https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
aws ec2 describe-vpc-endpoint-services \
  --region ap-northeast-1 \
  --filters Name=service-type,Values=Gateway
# service-type: Interface | Gateway | GatewayLoadBalancer
# 上述 CLI 能使用, 但用途我還不是很清楚在查啥

# ====================================================== EC2 Networking ======================================================
### 查看 EC2 是否支援 ENA
aws ec2 describe-instances --instance-ids $Instance_ID --query "Reservations[].Instances[].EnaSupport"
