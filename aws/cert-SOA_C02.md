

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
- EC2 使用 User Data, 查看 log:
    - `/var/log/cloud-init-output.log`
    - `/var/log/cloud-init.log`
    - `/var/log/cfn-init.log`
    - `/var/log/cfn-init-cmd.log`


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


# Monitoring, Audition and Performance



# VPC

- 一個 Region 最多能有 5 VPCs (soft limit)
- VPC 內最多能有 5 CIDRs
    - Min : `/28` (16 IPs)
    - Max : `/16` (65536 IPs)
