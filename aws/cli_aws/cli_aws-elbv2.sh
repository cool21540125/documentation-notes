#!/bin/bash
exit 0
# --------------------------------------------------------------------------------

### Create LB
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/create-load-balancer.html
aws elbv2 create-load-balancer \
    --name $LB_NAME \
    --subnets $SubnetIdAA $SubnetIdBB $SubnetIdCC \
    --security-groups $SgId

### 查詢 ALB
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancers.html
aws elbv2 describe-load-balancers --load-balancer-arns $LOAD_BALANCER_ARN
# (等同於)
aws elbv2 describe-load-balancers --name $LOAD_BALANCER_NAME

### 查看 ALB > Listeners
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-listeners.html
aws elbv2 describe-listeners --load-balancer-arn $LOAD_BALANCER_ARN

### 查看 ALB > Listeners > Rules
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-rules.html
aws elbv2 describe-rules --listener-arn $LOAD_BALANCER_LISTENER_ARN
#
# --------------------------------------------------------------------------------

### 列出 ALB 背後的 all Target Groups
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-groups.html
aws elbv2 describe-target-groups

###
