
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

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
 [CONFIG …]
}

```
