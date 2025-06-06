# AWS CLI, SDK, IAM Roles & Policies

## Service Limits

- AWS 對於服務有些軟性限制, ex: EC2 的 On-Demand 規格, 只能開到 1152 vCPU
  - 如果要增加使用需求:
    - 開 Issue
    - 使用 Service Quotas API

# Container - Docker, ECS, EKS, ECR, Fargate

## EKS, Elastic Kubernetes Services

- EKS 支援
  - EC2 - to deploy worker nodes
  - Fargate - to deploy serverless containers

# Elastic Beanstalk

- [clf-Beanstalk](./cert-CLF_C01.md#aws-beanstalk)
- [Beanstalk](./Beanstalk.md)

# AWS CICD

## CodeCommit

- [CodeCommit](./CICD/CodeCommit.md)

## AWS CodePipeline

- 用來組織 CodeCommit, CodeBuild (做 CI/CD 啦)
  - AWS CI/CD 的核心服務
  - Code -> Build -> Test -> Profision -> Deploy
- CodePipeline Orchestration
  - CodeCommit -> CodeBuild -> CodeDeploy -> ... (ex: Elastic Beanstalk, ...)
- 可 fast delivery, rapid update

## AWS CodeBuild

- [CodeBuild](./CICD/CodeBuild.md)

## AWS CodeDeploy

- [CodeDeploy](./CICD/CodeDeploy.md)

## AWS CodeArtifact

- [clf-CodeArtifact](./cert-CLF_C01.md#aws-codeartifact)
- 各種套件管理員的套件管理倉庫 - artifact management
- 其實做了幾件事情
  - 幫 Code 代理抓 dependencies (增強安全性)
  - 快取 dependencies (不知道是不是存到 S3)
  - 可讓 CodeBuild 拉 dependencies 的時間大大加速

## AWS CodeStar

- [clf-CodeStar](./cert-CLF_C01.md#aws-codestar)
- Charge: Service Free. 針對 Resources 收費
- 專案管理整合 - Jira / GitHub Issues

## AWS Cloud9

- [clf-Cloud9](./cert-CLF_C01.md#aws-cloud9)
- 用來管理 Development Activities 的 UI
- Developer 快速建造 CI/CD 的好幫手
- 用來整合 **CodeCommit** && **CodeBuild** && **CodePipeline**
- 用這東西背後會一併 Create (反過來說, 如果不用 **CodeStar** 的話, 底下這些都需要自行處理):
  - CodeCommit
  - CodeBuild
  - CodeDeploy
  - CodePipeline
  - monitoring
  - Elastic Beanstalk
  - EC2
  - Cloud9
- 若要刪除 Project 的話, 先刪除 **Cloud9**, 再來刪除 **CodeStar** Project
- Charge:
  - 無需針對 CodeStar 計費
  - 不過 CodeStar Project 會開一台 EC2...
  - 此外, 會針對額外使用的資源計費, Lambda, EBS, S3
  - 按量計費

## AWS AppSync

- [What is AWS AppSync?](https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html)
- GraphQL api
- real-time WebSocket/MQTT for WebSocket
- 一開始需要先定義 `GraphQL schema`
- 權限及安全性存取方面, 需要至少有底下之一的權限:
  - API_KEY
  - AWS_IAM
  - OPENID_CONNECT
  - AMAZON_CONGNITO_USER_POOLS
- 即時 && 跨裝置, Store && Sync data
  - 支援了 Offline data sync (類似產品 [Cognito](./cognito.md))
- 使用 GraphQL (mobile tech from FB)
- 整合了 DynamoDB/Lambda

# AWS Other Services

## AWS SES, Simple Email Service

- Sending Email using SMTP interface 或 AWS SDK
- Receiving Email, 並整合了: S3, SNS, Lambda
- 收發信都需要 IAM Permission

## AWS Serverless Application Repository, AWS SAR

- 可用來儲存 Serverless APP 的 Repository

## Amazon Certificate Manager, ACM

- provision / manage / deploy / renewal SSL/TLS Certificates
  - public : Free
  - private
- in-flight encryption
-

```mermaid
flowchart TD;

Client -- https --> ALB;
ACM <-- certs --> ALB;
ACM <-- certs --> CloudFront;
ACM <-- certs --> apigw["API Gateway"];

ALB --> ASG;
```

## AWS Fault Injection Simulator, FIS

- Based on Chaos Engineering
- 進階的測試工具, 用來測 Infra 之中的某個 Service Failure 的後果 及 Simulation
  - 支援模擬 EC2, ECS, EKS, RDS, ... 掛掉的情境
- 進階的 Monitoring + Debugging Tool

```mermaid
flowchart LR;

ff["AWS Fault Injection Simulator"];
ee["Experiment Template"];
rr["EC2
RDS
EKS
ECS"];
mm["CloudWatch \n EventBridge \n X-Ray"];

ff -- create --> ee;
ee -- start --> rr;
mm -- tracing --> rr;
```
