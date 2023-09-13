

terraform version
#Terraform v1.5.7
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

### 對 xx.tf 排版
terraform fmt


### 驗證 xx.tf 是否合規
terraform validate


### 檢查當前資料夾下的 .terraform.tfstate
terraform show


### 