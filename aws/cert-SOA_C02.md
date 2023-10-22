
# 考試前, 需要問自己的問題

- 合規/建議/配置 比較
    - CloudTrail
    - Trusted Advisor
    - AWS Config
    - VPC Reachability Analyzer
        - 針對 VPCs 之間的 endpoints 的配置做診斷(不做實測)
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
        - 
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


# RDS

- RDS 考試重點之一 : `Read Replicas` v.s. `Multi-AZ`
- Read Replicas
    - 主要目標: 讀寫分離, 降低負載
    - Replication 為 **ASYNC** (eventually consistent)
    - max 5 Read Replicas, 可 Cross AZ && Cross Region
    - APP 的 ConnectionString 需要隨著 Read Replicas 調整
    - Cost
        - Cross Region Read Replica 的網路流量需要收費
            - Same Region, Cross AZ -> 不收費
            - Cross Region, Cross AZ -> 收費
- Multi-AZ
    - 主要目標: availability && Disaster Recovery
    - Replication 為 **SYNC** (strongly consistent)
    - APP 的 ConnectionString 指向 DNS Name
        - 此 DNS Name 主要連到 Master, 除非有問題, 會自動改目標
- Auth
    - Password authentication
    - Password and IAM database authentication
    - Password and Kerberous authentication
