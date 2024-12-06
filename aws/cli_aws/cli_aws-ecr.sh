#!/bin/bash
exit 0
#
#
# ------------------AWS CLI ------------------
# Login, v1 : `aws ecr get-login`
# Login, v2 : `aws ecr get-login-password`
# --------------------------------------------

export AWS_PROFILE=
export AWS_ACCOUNT_ID=
export AWS_REGION=

# ========================================== ECR - 基礎動作 ==========================================
### 操作 AWS ECR 前置動作
aws ecr get-login-password \
    --region ${AWS_REGION} | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
#Login Succeeded

# ========================================== ECR - 查資訊 ==========================================
### 列出 ECR Repository Names
aws ecr describe-repositories | yq ".repositories[].repositoryName"
# --repository-name $ECR_REPOSITORY_NAME 指定單一 ECR Repo, 沒指定的話列出全部

### 查看每個 ECR repo 隨機一個 image 的大小 (似乎 images 列出時無法排序)
aws ecr describe-repositories | yq ".repositories[].repositoryName" | while IFS= read -r repo; do
    image_id=$(aws ecr list-images --repository-name $repo | yq ".imageIds[0].imageDigest")
    bytes=$(aws ecr describe-images --repository-name $repo --image-ids "imageDigest=$image_id" | yq ".imageDetails[0].imageSizeInBytes")
    mb=$(expr $bytes / 1024 / 1024)
    echo "$repo --- $image_id --- $mb"
done

# ========================================== ECR - 使用 ==========================================
### Pull ECR Image
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/demo-lambda:v1.23.0

### ECR 建立一個 repo, 名為 hello-server101
image_repo=$(aws ecr create-repository --repository-name hello-server101 --query repository.repositoryUri --output text)
echo $image_repo

# ========================================== ECR - Lifecycle Policy ==========================================

### 設定單一 ECR Repository 的 Lifecycle Policy
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/put-lifecycle-policy.html
aws ecr put-lifecycle-policy \
    --repository-name ${ECR_REPO_NAME} \
    --lifecycle-policy-text file://cli_files/ecr_lifecycle_policy.json
