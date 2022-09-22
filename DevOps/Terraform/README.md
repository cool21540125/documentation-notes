
# Terraform

- 用來提供 architecture, TF 使用了 2 個 Main Components
    - Core
        - 使用 2 個 input sources:
            - TF-Config
            - State
    - Cloud Provider
        - AWS, GCP, Azure, ... [IaaS]
        - Kubernetes [PaaS]
        - Fastly [SaaS]

- Usage
    - refresh : query infra provider to get current state
    - plan    : create an execution plan
    - apply   : execute the paln
    - destroy : delete resources/infra


# Terraform v.s. Ansible

兩者官方定義有著 87 分的相似, 兩者皆為 IaC

- Terraform 主要是 infrastructure provisioning tool
    - 此外在某些情況下, 也可用來 deploy APP
- Ansible 則主要是 Configuration tool
    - 已有 Infra 的情況下, 致力於 deploy APPs, config infra
