
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
- 命名
    - terraform.tfvars
    - terraform-provider.tf
    - terraform-provider.tf.json
    - terraform-instances.tf
- 變數順位
    - 1. CLI                         (for 特殊情境)
    - 2. terraform Environment       (for CI/CD)
    - 3. xx.tfvars                   (for dev 環境)
        - 此檔案不上版控, 不過可版控一個 xx.tfvars.example
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
