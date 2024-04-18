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


### 移除特定資源
terraform destroy -target="RESOURCE.NAME"
# 使用 tf state list 查詢 targets


### 列出所有資源
terraform state list | grep xxx


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


### 載入變數
tf plan -var="foo=bar"
TF_VAR_foo="bar" tf plan

tf plan -var-file="foo.tfvars"
tf plan -var-file="foo.tfvars.json"
# terraform.tfvars 及 terraform.tfvars.json 會被自動載入
# 或是可用 xx.auto.tfvars 及 xx.auto.tfvars.json
