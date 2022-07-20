
- [Getting started with Application Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html)
- 2022/07

```bash
### Create LB
$# aws elbv2 create-load-balancer \
    --name ${LB_NAME} \
    --subnets subnet-0e3f5cac72EXAMPLE subnet-081ec835f3EXAMPLE \
    --security-groups ${SG}
```