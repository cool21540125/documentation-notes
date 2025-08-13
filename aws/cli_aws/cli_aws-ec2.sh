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

### 查看 EC2 的 CPU 為 nitro 或 xen
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instance-types.html
INSTANCE_TYPE=m6i.2xlarge
aws ec2 describe-instance-types --instance-type $INSTANCE_TYPE --query "InstanceTypes[].Hypervisor"

### 查詢 EC2 Console 上頭的 Key Pair 的 KeyFingerprint
# 這把Key 是建立 EC2 的時候, 建立出來的 KeyPair
aws ec2 describe-key-pairs --key-names $KEY_NAME
#KeyFingerprint: 27:39:26:0c:3f:ee:57:c4:13:f1:a9:96:55:a6:4f:f6:99:52:f6:e9
#KeyType: rsa
# (僅擷取部分)

###
openssl pkcs8 -in ${KEY_NAME}.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c

### ====================================================== Security Group, SG ======================================================

### 於 VPC 裡頭建立 SG
VPC_ID=
SG_NAME=
SG_DESCRIPTION=
aws ec2 create-security-group --vpc-id $VPC_ID --group-name $SG_NAME --description $SG_DESCRIPTION
# 可以拿到 GroupId

### 建立 SG rule
aws ec2 authorize-security-group-ingress --group-id $GroupId --protocol tcp --port 443 --cidr 10.0.0.0/16
aws ec2 authorize-security-group-ingress --group-id $GroupId --protocol tcp --port $PORT --source-group $FROM_SG_ID

### 列出 SG/SecurityGroup 的 associations
SG_ID=sg-0872a8a14cb5eac03
aws ec2 describe-network-interfaces --filters Name=group-id,Values=$SG_ID

### ENI 反查出他的 Public IP
ENI=eni-0ba04ba3a91828d8d
aws ec2 describe-network-interfaces --network-interface-ids $ENI --output yaml | yq '.NetworkInterfaces[0].Association.PublicIp'

### ==================

### 查看 VPCE 的 DNS names
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-vpc-endpoints.html
VPCE=
aws ec2 describe-vpc-endpoints --vpc-endpoint-ids ${VPCE} --output json --query "VpcEndpoints[*].DnsEntries"
