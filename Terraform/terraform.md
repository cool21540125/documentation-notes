
- Terraform 及 Ansible 皆為 IaC, 皆為 auto provisioning configuration and managing the infra
    - Terraform 較適合用來作為 infra provisioning tool
    - Ansible 較適合用來作為 configuration tool
- Terraform 主要分成 2 個部分:
    - Core - 用來構建 execution plan
        - TF-Config
        - State
    - Providers
        - IaaS, 個大雲端廠商
        - PaaS, Kubernetes
        - SaaS, Fastly
- 檔案&目錄
    - `.terraform.tfstate`
        - 如果執行過 `terraform apply`, 則會在當前目錄產生此檔案
        - 此為 Terraform state file, 也是 Terraform 唯一可用來追蹤 & 紀錄 它所管理的資源(包含 敏感資訊)
        - 需要好好的保存此檔案!!
    - `.terraform.lock.hcl`
        - 用來記錄確切的 provider versions
        - 也是用來作 upgrade providers 的依據
    - `.terraform/`
        - 像是 `terraform init` 會在裡頭安裝相關的 provider plugin
- provisioners 配置器
    - Create/Update infra 的過程中, 可用來執行額外的 設定/命令
        - ex: install pkg 或 update config
        - ex: 可用 remote Shell
    - Terraform Provisioner 支援底下這些:
        - local-exec
        - remote-exec
        - file
        - chef
        - salt-masterless
- 命名
    - `terraform.tfvars`
    - terraform-provider.tf
    - terraform-provider.tf.json
    - terraform-instances.tf
- 變數順位
    - 1. CLI                         (for 特殊情境)
    - 2. terraform Environment       (for CI/CD)
    - 3. xx.tfvars OR xx.tfvars.json (for specific ENV)
        - tfvars 的順位:
            - 1. CLI -var 或 CLI -var-file
            - 2. xx.auto.tfvars 及 xx.auto.tfvars.json
            - 3. terraform.tfvars.json
            - 4. terraform.tfvars
            - 5. ENV
    - 4. variable definition         
        - 也就是 xx.tf 裡頭的 variable 區塊啦
    - 5. variable default definition
- Dependency
    - 使用 `depends_on` ; 循環依賴可參考: `implicit` 或 `module graph`
- Lifecycle
    - `prevent_destroy` / `ignore_changes` / `precondition`


--- 

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
 [CONFIG …]
}
```


## 遠端狀態後台 Backend
    - A backend defines where Terraform stores its state data files.
    - 用來讓團隊共同維持 **terraform.tfstate** (避免衝突), 可保存到:
        - AWS S3 / GCP Stroage / HashiCorp Consul / Azure Blog / HashiCorp Terraform Cloud / 等等
        - 預設使用 **local**

```hcl
// Terraform Backend
terraform {
  backend "gcs" {
    bucket = ""
    prefix = ""
    project = ""
  }
}
```

# Note

- 迴圈
    - count parameter
        - 適用於 迴圈掃視 resource && module
        - `${count.index}`
    - for_each expression
        - 適用於 迴圈掃視 resource && block in resource && module
    - for expression
        - 適用於 迴圈掃視 lists && maps
    - for string drective
        - 適用於 迴圈掃視 字串中的 lists && maps