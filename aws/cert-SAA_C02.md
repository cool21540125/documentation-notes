AWS Certificated Solutions Architect Associate, SAA-C02


# EC2

- [EC2](./EC2.md)


# HA && Scalability: ELB && ASG

- [ELB](./ELB.md)
- [ASG](./ASG.md)


# SQS, SNS, Kinesis, ActiveMQ

- [SQS](./SQS.md)
- [SNS](./SNS.md)
- [Kinesis](./Kinesis.md)

## Compare

SQS                          |     SNS                        |     Kinesis
---------------------------- | ------------------------------ | -------------------------
Queue                        | Pub/Sub                        | Real-time Streaming (Big Data)
consumer pull                | push to subscribers            | 
consume 後 delete data       | 一但未 delivered, data loss     | 可能可以 reply data (但 x 天候資料消失)
workers(consumer) 未限制      | 1250w subscribers & 10w topics | 
不用鳥 throughputs            | 不用鳥 throughputs              | standard: 2M/shard & enhances: 2M/consumer
僅在 FIFO 保證順序             |                                | 在 Sharded Level 決定 ordering


## ActiveMQ

- 需要有 Dedicated Machine 跑 AmazonMQ
    - 支援 HA
- ActiveMQ 可有 queues (類似 SQS) && 可有 topics (類似 SNS)
- 不同 Region 的 ActiveMQ Broker, 可掛載相同的 EFS 來達到 HA


# Containers: ECS, Farget, ECR, EKS

## ECS, Elastic Container Service

- [ECS](./ECS.MD)


## ECR, Elastic Container Registry

- 不解釋


## EKS, Amazon Elastic Kubernetes Service

- 類似於 ECS, 但使用不同的 API
- 此為 OpenSource, 相對於 ECS, 純 AWS
- 與 ECS 一樣, 也支援 2 種 launch mode:
    - EC2 mode
        - deploy on EC2
    - Farget mode
        - Serverless
- EKS Pods, 有點類似於 ECS Tasks
- 如果要 Expose EKS Service, 則需要設定 **Load Balancer**


## Cognito

- [What is Amazon Cognito?](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html)
- 即時 && 跨裝置, Store && Sync data (同 [APPSync](#aws-appsync))

> Provides authentication && authorization && user management for your web and mobile apps. Your users can sign in directly with a user name and password, or through a third party such as Facebook, Amazon, Google or Apple.
> 
> Offers user pools and identity pools. User pools are user directories that provide sign-up and sign-in options for your app users. Identity cagnito pools provide AWS credentials to grant your users access to other AWS services.


# Databases && AWS Storage Extras

- [Databases and Storage](./DatabaseAndStorage.md)


# CloudFront && Global Accelerator

- [CloudFront](./CloudFront.md)


## Global Accelerator

- 要來解決 Service 在 Single Region, 但請求來自世界各地的長途路由問題
- Charge: 需要摳摳
    - 固定設定費用 + 資料傳輸費用
- 必要網路知識:
    - Unicast IP : 一台 Server 有一個 IP
    - Anycast IP : 所有 Servers 有相同 IP && client 就近訪問其中一台
- **Global Accelerator** 使用了 **Anycast IP**
    - 不管 client 在哪邊, 都將請求送往鄰近的 Edge, 之後再走 AWS internal network 到後端 Server
    - work with *Elastic IP*, *EC2 instance*, *ALB*, *NLB*, ... (private && public)
    - 會拿到 2 組 Anycast IP for APP
    - intelligent routing && fast regional failover
    - 不存在 client cache 的問題 (因為東西都往後端丟)(proxy)
    - health check
    - DDos protection (by Shield)
    - Improve performance
        - 如果 APP != HTTP, 像是 UDP, MQTT, VoIP, ... 表現都不錯
        - 如果 APP == HTTP, 需要一組 static IP 或 一組 failover regional 可快速切換
- 容易與 [S3 Transfer Acceleration](./S3.md#s3---baseline-performance--kms-limitation) 搞混


# AWS Monitoring & Audit: CloudWatch, CloudTrail & Config

## CloudWatch

- [CloudWatch](./CloudWatch.md)


## CloudTrail

- Enable governance, compliance, operational auditing, and risk auditing of AWS account.
- 資料保存 90 天
    - 可把資料 log 到 S3
    - 紀錄關於 SDK && CLI && Console && IAM Users && IAM Roles 的操作
        - AWS CloudTrail can be used to audit AWS API calls
- 3 種 CloudTrail Events:
    - Management Events
        - 免費, 預設啟用
        - 針對 AWS Account 資源的增刪改, 都會被記錄
            - ex: EC2 的 Start, Stop ; Create IAM Role, ...
        - Events 區分為 *Read Events* && *Write Events*
    - Data Events
        - 資料龐大, 預設不紀錄(因為資料量很龐大)
        - 針對 AWS Account 裡頭資源的調用
            - ex: call Lambda, 上傳到 S3, 讀取 S3 Object, ...
        - Events 區分為 *Read Events* && *Write Events*
    - CloudTrail Insights Events
        - Charged $$
        - 紀錄 AWS Account 裡頭 非常規的活動
            - ex: 資源配置不正確, 資源使用達到 limits, user behavior, ...
        - Events 僅針對 *Write Events* 做紀錄
        - ```mermaid
            flowchart TB;

            me["Management Events"]
            cti["CloudTrail Insights"]
            ie["Insights Events"]

            me <-- Continous analysis --> cti;
            cti -- generate --> ie;
            ie --> cc["CloudTrail Console"]
            ie --> S3
            ie --> ebe["EventBridge Event"]
          ```
- Event History 可能要花上 15 分鐘才會有資料


## AWS Config

- 用途
    - 衡量 AWS Resources 之間的關係
    - 確保 AWS Resources 符合公司的 compliances
        - 後續可由 **SSM Documentation** 來對這些資源做 Remediation(整治/補救)
            - ex: `AWSConfigRemediationRevokeUnusedIAMUserCredentials`, 用來 deactivate 已過 compliance duration 的 IAM Access Key
    - 追蹤 AWS Resources configurations 的變更 (背後可藉由其他服務做相對因應 or 有問題時 Rollback)
        - 可設定為 定期檢查 or 變更事件
    - ![AWS Config Overview](./img/AWS%20Config%20Overview.png)
- Charge: 
    - no free tier. 需要課金
- 若有多個 Region, 則需逐一啟用並配置
- User 啟用 AWS Config 以後, 可設定 **rules** 來針對特定 AWS Resources 做 auditing && compliance && tracking
    - by using `DescribeResource` && `ListResource` API
        - 將之結果彙整於 *Configuration Item*, 裡頭包含了:
            - metadata, attribute, relationship, related event, ..., 將結果保存到 S3
    - Config Rules 可有底下幾種方式
        - AWS managed config rules (> 75)
        - custom config rules (必須在 *AWS Lambda* 裡頭定義)
            - config rules 可以定義像是:
                - S3 bucket 需要是 encrypted, versioned, not public access, ...


# Other AWS Services

## Cloudformation

- 對於 SAA 來說似乎不是重點..
- [saa-CloudFormation](./CloudFormation.md)
- IaaS, declarative


## AWS Step Functions (易與 SWF 搞混)

- 用來一口氣管理一堆 **Lambda Function**
    - 具備了一堆特色: sequence, parallel, conditions, timeouts, error handling, ...
    - 除了 Lambda 以外, 也可與像是 EC2, ECS, API Gateway 等服務整合(但較少)
- *JSON state machine*
- 


## Simple Workflow Service, SWF (老東西, 已經不支援了)

- 與 **Step Function** 有點像, 但運行在 EC2
- Runtime 最長為 1 年
- *activity step* && *decision step* && *built-in intervention step*
- 除非有底下需求, 不然建議改用 Step Function
    - 需要 external signals 來干預目前 processes
    - 需要 child process 回傳結果給 parent process


## Amazon Elastic MapReduce, EMR

- Auto-scaling && integrated with **Spot Instances**
- 相關關鍵字: Hadoop, Big Data, ML, Web indexing, data processing, ...
    - Support: Apache Spark, HBase, Presto, Flink, ...


## AWS Opsworks

- [clf-opsworks](./cert-CLF_C01.md#aws-opsworks)
- AWS 的世界中, `AWS Opsworks == Managed Chef & Puppet`
- Chef & Puppet - 協助 perform server configuration automatically 或 repetitive actions
    - Chef   : Recipes
    - Pupuet : Manifest
- 功能有點類似 **AWS SSM**, **Beanstalk**, **CloudFormation**
- CaaS
- Linux & Windows


## AWS WorkSpaces

- managed, Secure Cloud Desktop
- 減少本地 VID(Virtual Desktop Infrastrucure) 的管理
- Charge: 用多久, 收多少
- 整合 Windows AD


## AWS AppSync

- 即時 && 跨裝置, Store && Sync data
    - 支援了 Offline data sync (類似產品 [Cognito](#cognito))
- 使用 GraphQL (mobile tech from FB)
- 整合了 DynamoDB/Lambda


## Cost Explorer

- Billing Service 底下其中一個小服務
- 支援 **Savings Plan** 的選擇
- monthly/yearly cost 組成 && 視覺話


## ElasticTranscoder

- Saas
- Media(video, music) converter service into various optimized formats (雲轉碼)


## SSO, Single Sign On

- 會有個集中化的 Portal
    - 集中化管理 permission
    - 可得知 user login (via CloudTrail)
- support *SAML 2.0 markup*, 整合了 SAML && on-premise *Active Directory*

```mermaid
flowchart LR

subgraph on-premise
    ad["Windows AD"]
end

subgraph AWS
    ss["AWS SSO"]
    rr["AWS Other Resources"]
end

ad -- AD Connector / AD trust --> ss;
ss -- SSO access --> rr;
ss -- SSO access --> 3rd["3rd APPs"]
ss -- SSO access --> saml["SAML APPs"]
```


# Security & Encryption

- [KMS, Key Management Service](#aws-kms-key-management-service)
- [SSM Parameter Store](#ssm-parameter-store)
- [Secret Manager](#secret-manager)
- [CloudHSM](#cloudhsm-hardware-security-module)
- [WAF & Shield](#waf--shield)
- [GuardDuty](#guardduty)
- [Inspector](#inspector)
- [Macie](#macie)


## Encryption

- encryption in-flight
    - 資料傳送過程中加密, HTTPS
    - ensure no MITM(man in the middle attack)
- encryption at rest
    - Server 接收到以前皆已完成加密
- client side encryption
    - Client 自行加密後再傳送, Server 永遠不知道自己收到的是殺小
    - Could leverage *Envelop Encryption*


## AWS KMS, Key Management Service

- 常被拿來與 [CloudHSM](#cloudhsm-hardware-security-module) 做比較
- 可藉由 CloudTrail 來查看 Key Usage. 與 IAM 有高度的整合
- Charge: $0.03/10000 call KMS API
- API call > 4KB data 須借助 *envelop encryption*
- *KMS Key* 無法 cross region 傳送
- Key policies are the primary way to control access to KMS keys. Every KMS key must have exactly one key policy.
    - 其次也可使用 IAM
- 2 types of KMS:
    - Symmetric Keys
        - AES-256
        - CMK, Customer Master Key
            - 又有分成 3 種:
                - AWS Managed Service Default CMK (AWS owned CMK)
                    - Free
                - User Keys created in KMS (AWS managed CMK)
                    - 一把 Key $1/month
                - User Keys imported (Customer managed CMK)
                    - 一把 Key $1/month
                    - 必須為 256 bit symmetric key
        - envelop encryption
        - user call API to use Key
    - Asymmetric Keys
        - RSA & ECC key pairs
        - user CAN NOT call API to see private key


## SSM Parameter Store

- [clf-SSM](./cert-CLF_C01.md#aws-ssm-systmes-manager)
- Securely store your configuration && secrets
    - 有 Versioning
    - 可使用 KMS 來將參數加密
- 相較於 [Secret Manager](#secret-manager), 此服務比較舊, 且以 儲存參數 的功能為導向
- Name 得以 Path 的形式來做命名, ex: "/my-app/dev/db-url"
- 與 *CloudFormation*, *CloudWatch Events* 整合
- 其他 AWS Services 在使用此服務時, 需要經常留意 IAM 的權限
    - 若有加密, Lambda 需要解密後取用時, 也需要留意 KMS 權限
- Parameter Store 區分為
    - Standard Tier(Free)
    - Advanced Tier(Charge)
        - 可制定 Parameter Policy

```mermaid
flowchart TB
ssmps["SSM Parameter Store"]
kms["AWS KMS"]

APP -- PlainText / Encryption --> ssmps;
ssmps <-- check permisson --> IAM;
ssmps <-- Eecryption API --> kms;
```


## Secret Manager

- 要用來取代 [SSM Parameter Store](#ssm-parameter-store)
- 相較於上者, *Secret Manager* 較以 secret 為導向
    - 使用 Lambda 來實踐, 加密則使用 KMS
    - 可制定每隔 X days 來對 secret 做 rotation (force rotation)
    - ex: 可由此服務, 來同步 RDS 的 secrets
- 與 RDS, Aurora 有相當高度的整合
- Charge: 依照 secret 數量 && API call 數量 來計費


## CloudHSM, Hardware Security Module

- 常被拿來與 [AWS KMS](#aws-kms-key-management-service) 做比較
- 不便宜..
- CloudHSM 與 Secret Manager 相比較的話:
    - Secret Manager : AWS manage  software for encryption
    - CloudHSM       : AWS provide hardware for encryption
        - user 自行管理 keys
        - 需額外安裝 `CloudHSM client`
            - 使用上, 須留意 IAM permission 要開給 Client CRUD && 軟體面, 要維護 Keys & Users
            - 相較 KMS, 則全由 IAM 管理
- SaaS, HA
- 與 Redshift 有高度整合
- Good option for SSE-C Encryption
- 安全防護規格 `FIPS 140-2 Level 3 compliance` (看看就好...)
- *Master Key* 方面, 僅支援 [Customer Managed CMK](#aws-kms-key-management-service)
- CloudHSM deployed in VPC, 不過可 cross Region (by VPC sharing)


## WAF & Shield

- AWS Shield Standard, Free, 預設啟用
    - SYN/UDP Floods, Reflection attacks, L3/L4 attacks, DDoS
- AWS Shield Advanced, Charge $3000/month
    - DDoS mitigation service
    - Protect: EC2, ELB, CloudFront, Global Accelerator, Route53
    - 24*7 access to AWS DDoS response team(DRP)
    - 防止 DDoS 期間 ELB 爆量的費用
- WAF, Web Application Firewall
    - L7, Deploy on(only): 
        - ALB & API Gateway (Regional)
        - CloudFront (Global)
    - 需要自行配置 Web ACl, Web Access Control List
    - Protect:
        - XSS, Cross-Site Scripting
        - SQL injection
        - 設定訪問流量限制(size constraint)
        - 藉由 Geometric 屏蔽特定國家 IP
        - DDoS (by rate-based rule)
- AWS Firewall Manager
    - 用來管理 AWS Organization 所有 accounts 的 access rules

    > AWS Firewall Manager is a security management service that allows you to centrally configure and manage firewall rules across your accounts and applications in AWS Organizations. 
    > It is integrated with AWS Organizations so you can enable AWS WAF rules, AWS Shield Advanced protection, security groups, AWS Network Firewall rules, and Amazon Route 53 Resolver DNS Firewall rules.

```mermaid
flowchart LR

subgraph Shield1
    Route53
end
subgraph Shield2
    CloudFront
end
CloudFront <-- 過濾 --> waf["AWS WAF"];

subgraph AWS
    subgraph pu["Public Subnet"]
        subgraph Shield3
            ELB
        end
    end
    subgraph pi["Public Subnet"]
        subgraph Shield4
            ALB
        end
    end
end

user --> Shield1;
Shield1 --> Shield2;
Shield2 --> Shield3;
Shield3 --> Shield4;
```


## GuardDuty

> perform intelligent threat discovery in order to protect your AWS account

- 用 ML && 3rd data, 來看 user account 是否 under attack
- Charge: 30 天免費..
- 後續動作像是, 偵測異常後, 藉由 *CloudWatch Events Rules* -> Lambda/SNS
- Protect *CryptoCurrency attacks*(WTF?)
- Input data 包含了:
    - CloudTrail Events Logs
        - CloudTrail Management Events
            - 從 *CloudTrail Event logs* 取 data, 來判斷是否有 unusual API call
        - CloudTrail S3 Data Events
    - [VPC Flow Logs](./VPC.md#vpc-flow-logs)
    - DNS Logs
    - EKS Audit Logs

```mermaid
flowchart LR
data["Input data"]
gd["GuardDuty"]
ce["CloudWatch Event"]

data --> gd;
gd --> ce;
ce --> SNS;
ce --> Lambda;
```


## Inspector

- 讓 user automated security assessment for your AWS infra
    - 幫你的 AWS 做健診
- Inspector 只能 inspect:
    - EC2 - leverage *AWS System Manager (SSM) agent*, 分析異常流量 && OS 漏洞
        - database of vulnerabilities (CVE)
    - ECR - 當有人 docker push 就去評估 image/Container
- reporting & integrating with *AWS Security Hub*, 若發現問題會送到 *Amazon EventBridge*

```mermaid
flowchart LR

ssm["SSM agent"]
subgraph EC2
    ssm;
end

is["Inspector Service"]
is -- inspect --> ssm;
is -- if problem, report --> sh["Security Hub"]
is -- if proble, report --> eb["EventBridge"]
```


## Macie

- [What is Amazon Macie?](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)
- Fully managed data security && data privacy service, by using:
    - ML && Pattern matching to discover && protect sensitive data
    - 也用來協助 identify && alert sensitive data, ex: personally identifiable information, PII
- SaaS

```mermaid
flowchart LR
ce["CloudWatch Event \n EventBridge"]
macie["Macie"]

macie <-- "analyze \n (Discover Sensitive Data(PII))" --> S3;
macie -- notify --> ce;
ce -- integration --> pipeline["SNS, Lambda, ..."];
```


## AWS Security Hub

- Central Security tool, 用來管理 security, cross AWS accounts & automate security checks
- Charge: 燒錢~~
- 可將底下的服務集中到 Security Hub (但需要先 enable *AWS Config Service*)
    - GuardDuty
    - Inspector
    - Macie
    - IAM Access Analyzer
    - AWS System Manager
    - AWS Partner Network Manager


## Amazon Detective

- 因應 Security, 可用 GuardDuty, Macie, SecurityHub, ...
- 但如果要找出因果關係, 可使用 *Amazon Detective*
- 啟用後, 會自動蒐集底下這些, 來建立 view (用來呈現)
    - [VPC Flows Logs](./VPC.md#vpc-flow-logs)
    - [CloudTrail](#cloudtrail)
    - GuardDuty


## AWS Abuse

> Report suspected AWS Resources used for abusive or illegal purposes

- 用來跟 AWS 反映違規使用的 Service


# VPC

- [VPC](./VPC.md)


# Disaster Recovery & Migrations

- [clf-dr](./cert-CLF_C01.md#disaster-recovery-strategy)
- [Disaster recovery options in the cloud](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)


## Disaster Recovery in AWS

- DR, Disaster recovery
- 備份還原策略, 關鍵決策的核心要考慮 2 個重點, 後續的備份還原策略, 都基於這兩者:
    - RPO, Recovery Point Objective
        - Disaster 與 RPO 之間, 為 data loss 可接受的範圍
    - RTO, Recovery Time Objective
        - RTO 與 Disaster 之間, 為 downtime 可接受的期間

```
   RPO        Disaster             RTO
    | Data Loss |  Service Downtime |
    v           v                   v
------------------------------------------> time
```

- 常見的 Disaster Recovery Strategies 如下:
    - Backup and Resotre
        - 遇到問題時, restore/recreate from backup
        - high RPO && high RTO
    - Pilot Light
        - 僅將核心資源做線上備份 (critical systems are already up)
        - ex: RDS 隨時與 local DB 做 replication
            - EC2 上頭安裝了與 running APP 一樣的環境 (但關機)
            - 遇到問題時, 改變 Route53 解析, 開 EC2
        - 相較上者, 有較低的 RPO && RTO
    - Warm Standby
        - 隨時都有另一套規格較小的在運行, 作為備源
    - Hot Site / Multi Site Approach
        - 最貴方案, 不過 RPO & RTO 能盡可能降到最低
        - full production scale


## Database Migration Service, DMS

- 如果 backup source 與 restore target 的 DB engine 不一樣, 參考 *AWS SCT*
    - AWS Schema Conversion Tool, SCT
    - 反過來說, 如果 source 與 target 相同 Engine, 則不需要 SCT
- Continuous Data Replication, CDC

```mermaid
flowchart TB

subgraph dc["Corporate Data Center"]
    db["Oracle DB \n (source)"]
    srv["Server with AWS SCT Installed"]
end

subgraph Region
    subgraph VPC
        subgraph Public Subnet
            dms["AWS DMS Replication Instance \n (Full load + CDC)"]
        end
        subgraph Private Subnet
            rds["RDS mysql \n (target)"]
        end
    end
end

db -- Data migration --> dms;
db -- "backup 到不同 Engine DB" --> srv;
srv -- Schema conversion --> rds;
dms -- insert/update/delete --> rds;
```


## On-Premises Strategies with AWS

- AWS Application Discovery Service
    - 用來蒐集 On-Premise Servers 資訊, 來做 migration plan
    - Server utilization & dependency mappings
    - Track with AWS Migration Hub
- 除了上述 DMS, Database Migration Service, 可以處理 AWS 與 On-Premise 的 migration 以外, 地端可使用 *AWS Server Migration Service, SMS*
    - 可將 On-Premise DB 做 incremental backup -> AWS


## DataSync

- [What is AWS DataSync?](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html)
    - online data transfer service
    - 大量 data 想從 On-Premise Data -> AWS, 可參考此服務
    - 可設定 rate limit
    - online data transfer service
- [clf-DataSync](./cert-CLF_C01.md#aws-datasync)
- Charge:
    - 針對 DataSync 傳輸的流量計費
- Use Case:

```mermaid
flowchart LR

subgraph dc["On-Premise"]
    srv["Server"]
    dsa["AWS DataSync Agent"]

    srv <-- NFS/SMB protocal --> dsa
end

subgraph Region
    ds["AWS DataSync"]
    subgraph rr["AWS Storage Resources"]
        direction LR
        S3; S3-IA;
        glacier["S3 Glacier"]
        efs["AWS EFS"]
        fsx["Amazon FSx"]
    end
    ds <--> rr
end

dsa <-- TLS --> ds;
```

-----------

```mermaid
flowchart BT

subgraph r0["Region A \n (source)"]
    subgraph VPC
        efs0["Amazon EFS"]
        ec2["EC2 with DataSync Agent"]
        ec2 --- efs0
    end
end

subgraph r1["Region B \n (Destination)"]
    ds["AWS DataSync Service endpoint"]
    efs1["Amazon EFS"]
    ds --- efs1
end

ec2 -- sync --> ds;
```
-----------


## Transferring Large Datasets

- local 與 AWS 巨量資料的傳遞
    - 一次性
        - ~~Site-to-Site VPN~~
        - ~~Direct Connect~~
        - [Snowball](./cert-CLF_C01.md#aws-snow-family)
    - on-going
        - [Site-to-Site VPN](./VPC.md#aws-site-to-site-vpn)
        - [Direct Connect](./VPC.md#direct-connect-dx)
        - [DMS](./cert-CLF_C01.md#dms-database-migration-services)
        - [DataSync](#datasync)


## AWS Backup

- [clf-backup](./cert-CLF_C01.md#aws-backup)
- SaaS, 統一管理 && auto backup across AWS Services
- 無需 custom Scripts, 無需 manual processes
- 支援一堆 AWS Services:
    - EC2 / EBS
    - S3
    - RDS / Aurora / DynamoDB
    - DocumentDB / Neptune
    - EFS / FSx
    - Storage Gateway (Volume Gateway)
- 支援 cross-region && cross-account
- 支援 point-in-time recovery, PITR
- 支援 on-demand && scheduled backups
- 支援 tag-based backup policy
- backup plans:
    - frequency
    - Backup window
    - Transition -> Code Storage
    - Retention period
- 支援 [Backup Vault Lock](./S3.md#s3-lock-policies--glacier-vault-lock)

```mermaid
flowchart LR

backup["AWS Backup"]
plan["AWS Backup Plan"]
subgraph rr["AWS Resources"]
    direction LR
    EC2; EBS; s3["S3"]; 
    RDS; DynamoDB; DocumentDB; 
    EFS; Aurora; Neptune; FSx;
    sg["Storage Gateway"]
end

backup --> plan;
plan --> rr;
rr -- "Auto backup" --> S3;
```


# ML, Machine Learning

- [Machine Learning](./cert-CLF_C01.md#machine-learning)


# WhitePaper Section Introduction

- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)
    - 不要去猜測需求規模, 取而代之善用 ASG
    - 使用 Prod 規格來做測試 (因機器可隨時關閉, 別省這點錢, 別偷懶 )
    - 善用 CloudFormation 來重建架構, 方便實驗
    - Drive architecture using data
    - Well Architecture 有幾個重要構面:
        - Operational Excellence
        - Security
        - Reliability
        - Performance Efficiency
        - Cost Optimization
        - Sustainability
- [What is AWS Well-Architected Tool?](https://docs.aws.amazon.com/wellarchitected/latest/userguide/intro.html)
    - Free tool to review architecture
    - 建立一份 Workload 以後, 開始回答一堆問題... AWS 會提出相關的 risk 以及 improvment plan
- [AWS Trusted Advisor](https://docs.aws.amazon.com/awssupport/latest/user/trusted-advisor.html)
    - [clf-TrustedAdvisor](./cert-CLF_C01.md#aws-trusted-advisor)
    - 除非有啟用 Enterprise 或 business plan, 否則只有底下部分的 core checks:
        - Cost Optimization
        - Performance
        - Security
        - Fault Tolerance
        - Service Limits
    - [AWS-Github-Samples](https://github.com/aws-samples)
- [Disaster Recovery of Workloads on AWS: Recovery in the Cloud](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html)
- [AWS Well-Architected Framework – Updated White Papers, Tools, and Best Practices](https://aws.amazon.com/blogs/aws/aws-well-architected-framework-updated-white-papers-tools-and-best-practices/)