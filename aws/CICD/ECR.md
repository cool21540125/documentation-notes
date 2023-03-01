
# ECR, Elastic Container Registry

- [saa-ECR](../cert-SAA_C02.md#ecr-elastic-container-registry)
- Amazon ECR 也有 Public Repository - [Amazon ECR Public Gallery](https://gallery.ecr.aws)
- ECR 皆由 IAM 做存取訪問管控
- ECR 背後是 S3


# CLI

```bash
### login to ECR
$# REGION=ap-northeast-1
$# ACCOUNT_ID=
$# aws ecr get-login-password \
    --region ${REGION} | docker login \
    --username AWS \
    --password-stdin \
    ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
Login Succeeded

Logging in with your password grants your terminal complete access to your account. 
For better security, log in with a limited-privilege personal access token. Learn more at https://docs.docker.com/go/access-tokens/


### 
$# 
```
