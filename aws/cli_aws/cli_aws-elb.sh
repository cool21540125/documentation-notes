#!/bin/bash
exit 0
# --------------------------------------------------------------------------------

### 查詢 ALB
aws elbv2 describe-load-balancers --load-balancer-arns $LOAD_BALANCER_ARN
# (等同於)
aws elbv2 describe-load-balancers --name $LOAD_BALANCER_NAME

###
aws elbv2 describe-listeners --load-balancer-arn $LOAD_BALANCER_ARN

aws elbv2 describe-rules --listener-arn $LOAD_BALANCER_LISTENER_ARN
#
# --------------------------------------------------------------------------------

### Create LB
aws elbv2 create-load-balancer \
    --name $LB_NAME \
    --subnets $SubnetIdAA $SubnetIdBB $SubnetIdCC \
    --security-groups $SgId
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html

###
