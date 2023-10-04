
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

# SSM - Documents

> Console > AWS System Manager > Documents

- 使用 SSM 的 RunCommand 來運行
- 這根本就是 Ansible Playbook 嘛...
    - Documents 可用 Yaml 或 Json
    - 定義裡頭的 parameters 及 actions
- 有點類似 SSM - Automation


# SSM - Run Command / RunCommand

- 用來跑 Documents
    - 可結合像是 EventBridge 來觸發執行
- 可設定 Rate Control / Error Control


# SSM - Automation

> Console > AWS System Manager > Automation

- 用來跑 Runbooks (automation documents)
    - 可結合像是 SDK / Maintenance Windows / EventBridge / AWS Config Remediation 來觸發執行
- 自動化 maintenance & deploy 到 EC2 及 AWS Resources


# SSM - Parameter Store

- Secure store configuration 及 secrets(明碼)
    - 不過可無縫與 KMS 整合
- 與 CloudFormation 有著深度的整合
- 額度及限制
    - Standard 
        - 每個 AWS Account 每個 Region, 能使用 10,000 個 params
        - 每個 param, 大小為 4 KB
        - Free
        - Parameter Policies : NO
    - Advanced 
        - 每個 AWS Account 每個 Region, 能使用 100,000 個 params
        - 每個 param, 大小為 8 KB
        - 針對 Advanced 收費, 每個每月收 $0.05 
        - Parameter Policies : YES


# SSM - Inventory

- 用來搜集 EC2/On-Premises 的 metadata
    - installed softwares
    - OS drivers
    - configurations
    - installed updates
    - running services
    - 甚至可設定 custom metadata, ex:
        - rack location
- 定期 (per minute/hour/day) 蒐集 metadata
- 可跨 Account / Region 蒐集
- 查詢方式 - 藉由在 SSM 的 Inventory 建立 **Resource data sync**, 可將資訊彙整到 S3
    - 須確保 SSM 有權限寫入到 S3 Bucket
 

# SSM - State Manager

- 與 SSM - Inventory 很像
    - 用來蒐集 metadata
- 不過, State Manager 用來記錄 State
- 

# SSM - Patch Manager

- SSM Patch Manager 有 2 個主要元件:
    - Patch Baseline
        - 又分為 2 種:
            - Pre-Defined Patch Baseline
            - Custom Patch Baseline
        - 定義 patch 的項目及方式, ex:
            - Auto Approve / Manual Approve / Reject 
        - 預設, 只會 patch **critical patches 及 security patches**
    - Patch Group
        - 針對 Instance 定義唯一的 Tag Key: `Patch Group`
            - 如果 Instance 沒有設定 Patch Group 的話, 則會被歸類為 `Default`
        - 因為上述的限制, 因此一個 Instance 只能同時隸屬於一個 Patch Group
            - 且一個 Patch Group, 只能 register 到一個 **Patch Baseline**
- 運行方式
    - 使用 AWS **Run Document** - `AWS-RunPatchBaseline`
- 經常與 **Maintenance Windows** 及 **AWS Tags** 結合

---

```
Patch Baseline ID    Patch Group  Default
pb-0123456897265agf  Default      Yes
pb-abceefgp1qj98afa  Dev          No
```

- 如果 Instance 沒有設定 `Tag Key: Patch Group`, 則套用第一個 Patch Baseline, 預設會套用 Patch
- 如果 Instance 有設定 `Tag Key: Patch Group=Dev`, 則套用 第二個 Patch Baseline, 預設不套用 Patch

---


# SSM - Maintenance Windows

- 可用來設定 offline service 的定期排程
    - ex: 半夜更新, 跑排程...
    - 可設定 Registered Instances
    - 可設定 Registered Tasks
- 經常與 **Patch Manager** 結合


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
