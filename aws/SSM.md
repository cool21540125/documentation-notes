
# SSM, System Manager

- [SSM workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/a8e9c6a6-0ba9-48a7-a90d-378a440ab8ba/en-US/300-ssm)
- 可把 SSM 的 `Run Command` 解成 系統以外的 ansible 的概念...
    - 不用額外開 SG port
    - 可指定要針對哪些 groups/instances/tags 來運行某些 `Document` 規範好的命令
        - Document 又有點像 ansible playbook 那樣, 可參考 [這個](https://docs.aws.amazon.com/systems-manager/latest/userguide/document-schemas-features.html)
    - 如果針對 EC2 Instance 來執行的話, 需要確保 EC2 已完成底下任務:
        - 已安裝 && 啟動 *SSM Agent*
            - `sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm`
            - `systemctl status amazon-ssm-agent`
        - Instance Roles:
            - 如果要整合 CloudWatch, 那就給這個 *CloudWatchFullAccess* Policy
            - 如果要讓 SSM 訪問 EC2, 那就給這個 *AmazonSSMManagedInstanceCore* Policy


# CLI

```bash
### 查詢特定規格 EC2 (ex: CentOS7.6) 在特定 Region 的 AMI 資訊
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2


### 建立 custom SSM Parameter Store 
aws ssm put-parameter \
    --name "/golden-images/amazon-linux-2" \
    --value ami-02b9b693377a07477 \
    --type "String"
# output ----------------------------
# Tier: Standard
# Version: 1
# output ----------------------------
# 建立 SSM > Parameter Store 裡頭的 My parameters, 名為 /golden-images/amazon-linux-2
# 


### 使用 Run Command 指定特定 EC2 Instance 運行命令
aws ssm send-command \
    --document-name "AWS-RunShellScript" \
    --document-version "1" \
    --targets "Key=tag:usage,Values=test-ssm" \
    --parameters '{"workingDirectory":[""],"executionTimeout":["3600"],"commands":["echo I am $(whoami) && ps -aux | grep -i agent"]}' --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --cloud-watch-output-config '{"CloudWatchOutputEnabled":true,"CloudWatchLogGroupName":"/ssm/runcommand"}'
# 把命令發送給 usage: test-ssm 這個 tag 的 instances
# 運行相關命令... 並把結果帶到 CloudWatch Logs


### 查看上一步跑完的 logs (或者可直接到 Console/CloudWatch 去看)
aws ssm get-command-invocation --command-id "${上一步驟輸出的Command.CommandId}" --instance-id "${Ec2InstanceId}" 


### 
```
