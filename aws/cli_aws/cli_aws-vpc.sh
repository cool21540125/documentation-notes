#!/bin/env bash
exit 0
# ------------------------------------------------------------------------------

### 建立 VPCE
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-vpc-endpoint.html
aws ec2 create-vpc-endpoint \
    --vpc-id $VPC_ID \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.your-region.secretsmanager \
    --subnet-ids $SUBNET_ID1 $SUBNET_ID2 $SUBNET_ID3 \
    --security-group-ids $VPCE_SG_ID \
    --tag-specifications ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=$MY_VPCE_TAG_NAME}] # 可省略

### 查詢 VPC cidr
aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[].CidrBlock'

###
