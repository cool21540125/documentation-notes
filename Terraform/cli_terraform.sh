#!/bin/env bash
# terraform CLI
exit 0
# --------------------

terraform version
#Terraform v1.14.4
#on darwin_amd64

### 切換 terraform workspace
terraform workspace show
terraform worksapce list
terraform workspace select $ENV

### 初始化 Terraform
terraform init
terraform init --var-file="terraform-$ENV.tfvars"

terraform plan
terraform plan --var-file="terraform-$ENV.tfvars"

terraform apply
terraform apply --var-file="terraform-$ENV.tfvars"
terraform apply -auto-approve

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


## ---------------------- Lock issue ----------------------
tf plan
#Acquiring state lock. This may take a few moments...
#╷
#│ Error: Error acquiring the state lock
#│ 
#│ Error message: operation error DynamoDB: PutItem, https response error StatusCode: 400, RequestID: AAAAAAAAAAAAAAAAABBBBBBBBBCCCCCCCCCCCCCDDDDDDDDDDDDD, ConditionalCheckFailedException: The
#│ conditional request failed
#│ Lock Info:
#│   ID:        abcd1234-ef56-gh78-ij90-zzzzzz000000
#│   Path:      ob-terraform-state-123456789012-us-west-2/collectors/internal/terraform.tfstate
#│   Operation: OperationTypeApply
#│   Who:       tony@macbook.m1
#│   Version:   1.14.4
#│   Created:   2026-02-12 08:48:47.975442 +0000 UTC
#│   Info:      
#│ 
#│ 
#│ Terraform acquires a state lock to protect the state from being written
#│ by multiple users at the same time. Please resolve the issue above and try
#│ again. For most commands, you can disable locking with the "-lock=false"
#│ flag, but this is not recommended.
## IMPORTANT 上面的警告再說, 避免使用 "-lock=false", 可能導致狀態崩潰!!

## IMPORTANT 確認此時沒有其他人在使用的去礦下, 使用下面指令釋放
tf force-unlock abcd1234-ef56-gh78-ij90-zzzzzz000000
# 然後輸入 'yes', 即可重跑指令
