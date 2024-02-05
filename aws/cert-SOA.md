
# 考試前, 需要問自己的問題, 很常搞混

- VPC 比較
    - VPC Peering
    - VPC Endpoints
    - Interface Endpoint
    - Gateway Endpoint
    - Transit Gateway
    - VPN Gateway
    - AWS PrivateLink / Endpoint Services
    - VPC Site-to-Site VPN
    - VPN CloudHub
    - VPN Connection
    - Direct Connect, DX
    - ClassicLink
- logs 比較
    - VPC Flow Logs
    - S3 server access logging
    - CloudFront log
    - ALB log
    - Api Gateway log
- EC2 - Placement Group
    - Cluster
    - Spread
    - Critical
    - Partition
    - Distribution
- Role & Policy 比較
    - IAM Role
    - Execution Role
    - Task Role
    - Service-Linked Role
    - Permission Policy
    - Security Credentials
    - Instance Role
    - AssumeRole
    - Identity-Based Policy
    - Resource-Based Policy
- KMS
    - Customer Master Key, KMS
    - customer managed keys
- Security 相關
    - GuardDuty
    - Inspector
    - Macie
- Compliance 相關
    - CloudTrail
    - Trusted Advisor
    - AWS Config
    - VPC Reachability Analyzer
        - 針對 VPCs 之間的 endpoints 的配置做診斷(不做實測)

# CloudFormation

- Pesudo Parameters
    - AWS::AccountId
    - AWS::Region
    - AWS::NotificationARNs
    - AWS::NoValue
    - AWS::StackId
    - AWS::StackName


## EC2 - User Data

- CloudFormation 開 EC2 Instance 的時候, 如果有用到 User Data, 則須考慮下面這些:
    - WaitCondition - 機器開好了, 但仍在安裝配置某些服務, 應該要等待一段時間讓他們完成, 以利後面的 ASG 安排導流 & 監控 Check
    - 為了在 Error 時能看到 log, 需要 disable rollback on failure
- CloudFormation EC2 的 UserData 相關:
    - `/var/log/cloud-init-output.log`
        - 可以視為是 在 Linux 底下直接執行的 Terminal 結果
        - EC2 的 UserData (`Fn::Base64`) 的 log
    - `/var/log/cloud-init.log`
    - `/var/log/cfn-init.log`
        - 可以視為是 `/var/log/cfn-init-cmd.log` 的 精簡版 log
        - EC2 執行完 UserData 以後, 跑 `cfn-init` 來向 CloudFormation query 已取得 init data
    - `/var/log/cfn-init-cmd.log`
        - 可以視為是 `/var/log/cfn-init.log` 的 完整版 log


```yaml
# CloudFormation 的 EC2 - User Data 用法
Resources:
    MyInstance:
        Type: AWS::EC2::Instance
        Properties:
            # Pass~~
            UserData:
                Fn::Base64: |
                    #!/bin/bash -xe
                    yum update -y
                    echo "User Data 需要這樣寫~~"
    
    MyInstance2:
        Type: AWS::EC2::Instance
        # Pass~~
```


# AWS Service Catalog

- 適用於 AWS Organization
- Organization 的 admin 於 AWS Service Catalog, 建立 Product (等同於 CloudFormaiton Teamplate)
    - 用來給 Organization 來做 create/deploy service
    - 此外也可建立 Portfolio (此即為 collection of Products)
    - 最後再配置 IAM policy, 來讓特定 Organization Users 可使用此 products/portfolios
- 因此, 即便 Organization Users 啥都被禁止了, 也可使用 product/portfolio 來 create stack
- 除了給 Organization 使用以外, 也可給其他 AWS Accounts 使用


## Service Catalog 的 TagOptions library

- (沒實作過...)
- 建立 Key Value 以後, 可將它套用到 Portfolio, 來讓建出來的 AWS Resources 都具備此 Tag Key Value
