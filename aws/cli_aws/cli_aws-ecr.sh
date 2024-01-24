#!/bin/bash
# 
# 
# ------------------AWS CLI ------------------
# Login, v1 : `aws ecr get-login`
# Login, v2 : `aws ecr get-login-password`
# --------------------------------------------
exit 0

export AWS_PROFILE=
export AWS_ACCOUNT_ID=
export AWS_REGION=


### 列出 ECR Images
aws ecr describe-repositories


### 操作 AWS ECR 前置動作
aws ecr get-login-password \
    --region ${AWS_REGION} | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
#Login Succeeded


### Pull ECR Image
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/wondercise-lambda:v1.23.0


### ECR 建立一個 repo, 名為 hello-server101
image_repo=$(aws ecr create-repository --repository-name hello-server101 --query repository.repositoryUri --output text)
echo $image_repo


### 查看 repo
aws ecr describe-repositories --repository-name hello-server101


### 

