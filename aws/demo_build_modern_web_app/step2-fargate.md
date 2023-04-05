- [單元 2：在 Web 伺服器上託管應用程式](https://aws.amazon.com/tw/getting-started/hands-on/build-modern-app-fargate-lambda-dynamodb-python/module-two/)
- [Amazon Elastic Container Registry](https://ap-northeast-1.console.aws.amazon.com/ecr/repositories/registry.tonychoucc2020/?region=ap-northeast-1)


```bash
### 2a, 設定核心基礎架構
aws cloudformation create-stack \
    --stack-name MythicalMysfitsCoreStack \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-body file://~/environment/aws-modern-application-workshop/module-2/cfn/core.yml
# 上述指令建議在 cloud9 裡面做, 最後要指向的 template 為 CloudFormation Template
# 可建立相關的 Resources, 看定義的情況, 可能會花費十分鐘以上
# ------- return --------
{
    "StackId": "arn:aws:cloudformation:ap-northeast-1:760386244628:stack/MythicalMysfitsCoreStack/51aa2a92-3185-11eb-ba28-0afff3dcfee2"
}

aws cloudformation describe-stacks \
    --stack-name MythicalMysfitsCoreStack
# 可查看該 cloudformation 相關資源資訊
# ------------- return -----------
{
    "Stacks": [
        {
            "StackId": "arn:aws:cloudformation:ap-northeast-1:760386244628:stack/MythicalMysfitsCoreStack/51aa2a92-3185-11eb-ba28-0afff3dcfee2", 
            "DriftInformation": {
                "StackDriftStatus": "NOT_CHECKED"
            }, 
            "Description": "This stack deploys the core network infrastructure and IAM resources to be used for a service hosted in Amazon ECS using AWS Fargate.", 
            "Tags": [], 
            "EnableTerminationProtection": false, 
            "CreationTime": "2020-11-28T14:24:03.104Z", 
            "Capabilities": [
                "CAPABILITY_NAMED_IAM"
            ], 
            "StackName": "MythicalMysfitsCoreStack", 
            "NotificationARNs": [], 
            "StackStatus": "CREATE_IN_PROGRESS", 
            "DisableRollback": false, 
            "RollbackConfiguration": {}
        }
    ]
}
# Wait until    "StackStatus": "CREATE_IN_PROGRESS" 
#            -> "StackStatus": "CREATE_COMPLETE"      (表示建置完畢)

### 2b, fargate to deploy
$ docker build . -t 760386244628.dkr.ecr.ap-northeast-1.amazonaws.com/mythicalmysfits/service:latest
...(略)...
Successfully built 4c7bd9a8290d
Successfully tagged 760386244628.dkr.ecr.ap-northeast-1.amazonaws.com/mythicalmysfits/service:latest


#### 建立 Registry, named: mythicalmysfits/service
$ aws ecr create-repository --repository-name mythicalmysfits/service

### 2c, code service to auto deploy
$ aws ecs create-cluster --cluster-name MythicalMysfits-Cluster
# 在 ECS 內, 建立新 Cluster

### 建立 CloudWatch logs 的 Log Group
aws logs create-log-group --log-group-name mythicalmysfits-logs
# CloudWatch logs 中建立新的日誌群組
```