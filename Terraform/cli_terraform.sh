#!/bin/env bash
# terraform CLI
exit 0
# --------------------

terraform version
#Terraform v1.7.5
#on darwin_amd64


### 初始化 Terraform
terraform init
terraform init --var-file="terraform-$ENV.tfvars"

terraform plan
terraform plan --var-file="terraform-$ENV.tfvars"

terraform apply
terraform apply --var-file="terraform-$ENV.tfvars"

terraform destroy
terraform destroy --var-file="terraform-$ENV.tfvars"


### 檢查當前資料夾下的 .terraform.tfstate
terraform show


### ============ Terraform Workspace ============
### 可用來切不同環境, ex: dev / stg / prd
tf workspace new dev
tf workspace new pre
tf workspace new prd

tf workspace select dev

tf workspace list

tf workspace delete pre

# state 會被保存在
# ./terraform.tfstate.d/${terraform.workspace}/terraform.tfstate