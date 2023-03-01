

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


# Monitoring, Audition and Performance
