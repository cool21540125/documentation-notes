#!/bin/env bash
exit 0
# ------------------------------------------------------------------------------

### 建立 VPCE

### 查詢 VPC cidr
aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[].CidrBlock'
