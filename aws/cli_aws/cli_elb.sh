# 
# 
# 
# 
# --------------------------------------------------------------------------------

### Create LB
aws elbv2 create-load-balancer \
    --name $LB_NAME \
    --subnets $SubnetIdAA $SubnetIdBB $SubnetIdCC \
    --security-groups $SgId
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html


### 
