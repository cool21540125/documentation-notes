AWS Certificated Cloud Practitioner Course

CLF-C01

---------

# Type of Cloud Computing

On Premise    | IaaS | Paas | SaaS
------------- | ---- | ---- | -----
Application   | V    | V    | -
Data          | V    | V    | -
Runtime       | V    | -    | -
Middleware    | V    | -    | -
OS            | V    | -    | -
Visualization | -    | -    | - 
Servers       | -    | -    | - 
Storage       | -    | -    | - 
Networking    | -    | -    | - 

- 租機器 : EC2
- 存 data : EBS, EFS, S3
- 做 Load Balance : ELB
- 做 Scaling : ASG


# IAM: Identity and Access Management
    
- Group 只能有 Users, 不能 Group in Group
- assign Policy -> User/Group
    - Policy 內由 Permissions 組成 
- assign Role -> Resource
- IAM Policy Structure 裡頭要有這些:
    - Effect: "Deny" 或 "Allow"
    - Principle: 此 Policy 所附加的 account/user/role
    - Action: 此 Policy 作用的 action
        - ex: "s3:GetObject"
    - Resource: 此 action 附加的 Resource
        - ex: "arn:aws:s3:::mybucket"
- 又例如 Policy example: AdministratorAccess
    - Policy ARN: "am:aws:iam::aws:policy/AdministratorAccess"
    - ```jsonc
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",  // "Allow" 或 "Deny"
                  "Principle": {},  // 此 Policy 附加的對象, ex: 「{"AWS": ["arn:aws:iam:...:root"]}」
                  "Action": "*",  // 或為 []
                  "Resource": "*",  // 或為 []
                  "Condition": []  // (optional)
              }
          ]
      }
      ```
- IAM Roles 重點:
    - users, services 存取 Resources, 都需要有對應的 Permission(Policy)
        - ex: *EC2 Instance Roles*, *Lambda Function Roles*, *Roles for CloudFormation*
- IAM Security Tools
    - IAM Credential Report (account level)
        - 帳號下所有用戶
    - IAM Access Advisor (user level)
        - IAM user 被授予了哪些 permissions &  哪個 permission 最近用過的時間                


# EC2, Elastic Compute Cloud

- 系列主機
    - t, General Purpose
    - c, Compute Optimized : ML, ...
    - r, Memory Optimized : RDB
    - m, Storage Optimized : OLTP, NoSQL, ...
- 常見訪問問題
    - timeout, 必然是 SG Issue
    - connection refused, app error 或 not launched
- EC2 Instance Connect, 目前未必每個 Region 都有此功能
    - 可直接使用 Web Console 做 login
- IAM Roles
    - 不要把 AWS EC2 credentials 放到 EC2, 要用 **IAM Roles**
    - 把特定 Roles assign 給 EC2 來提供 Credentials
    - 作法:
        - EC2 > Actions > Security > Modify IAM Role
- 初始化 EC2, 使用到 *User data* 的話, 務必寫上 *Shebang Line*, 沒寫會出錯
- EC2 Instance 購買的 Options
    - On-Demand
    - Reserved
        - 1 or 3 年, 預付省更多
        - 分成:
            - Reserved Instance
                - 可省錢達 72%, 提前退租可在 **AWS Marketplace** 賣掉
            - Convertible Reserved Instance
                - 可省錢達 66%, 可改變 instance type, family, os, scope, tenancy
    - Savings Plans
        - 1 or 3 年, 預付省更多
        - 可省錢達 72%
        - 告知定期花費一定金額, 目的是為了長期使用 & 彈性省錢
            - ex: 承諾將來每月花 $300
    - Spot Instances
        - 短期使用, 超便宜, 但可能隨時 loss instance
            - 若自己的 max price < current stop price, 則失去 instance
        - 較適用於 batch job, data analysis, image processing, cc attack, ...
    - Dedicated Host
        - 直接訂閱實體機
    - Dedicated Instances
        - 非共用硬體
    - Capacity Reservations
        - 對特定 az 保留 capacity
        - 不做使用承諾, 但可保有 reserved capacity
        - 短期任務 && 重要(不可中斷), 適合用這種
- Instance 重點在於:
    - *on-demand*, *spot*, *reserved* 這 3 種, 搭配 *Standard*, *Convertable*, *Scheduled*
    - *Dedicated Host* vs *Dedicated Instance*


## EC2 Image Builder

- 用來自動化 create/maintain/validate/test
- AMI(Amazon Machine Image), container for EC2 instance
- Charge: 只對 Resource 收費(本身免費)
- 需要 allow **Image Builder** access Resources, 需要有 3 個 IAM Role
    - EC2InstanceProfileForImageBuilder
    - EC2InstanceProfileForImageBuilderECRContainerBuilder
    - AmazonSSMManagedInstanceCore
- 建立流程如下, 過程是情況, 可能花上數十分鐘
    ```mermaid
    flowchart LR
        ec2ib["EC2 Image Builder"];
        bec2i["Builder EC2 Instance"];
        ami[New AMI];
        tec2i[Test EC2 Instance];
        dAMI[Distribute AMI to multi-az];

        ec2ib -- create --> bec2i;
        bec2i -- create --> ami;
        ami --> tec2i;
        tec2i -- publish --> dAMI;
    ```
- 會依序建立 EC2 instance 來 Building, 之後還會建另一個來 Testing
- 若要刪除 instance, 需 terminate instance && Deregister AMI && Delete EBS snapshot


# EC2 Storage

## EC2 Instance Store

- 相較於 EBS 快很多, 因為直接使用硬體
- 為 ephemeral storage, instance terminate 資料會消失
- 長久保存的話, 建議使用 EBS


## EBS, Elastic Block Storage

- 為 Network Device
    - 只能同時掛載到一台 Instance
        - 早期的 io1, io2 可同時掛載到多個 EC2
    - 只能存在於 az, 無法跨 az
        - 若要跨 az/region, 可藉由 snapshot
            - 做 EBS snapshot, 不需要 detatch, 但建議
- EBS snapshot
    - 可將 EBS 做這個, 然後搬到其他 az 去做 attach/restore, 即可變相的 cross az
    - EBS snapshot archive 以後, 又可省下 75% 的費用
        - 但是還原非常費時, 24~27 hrs
    - 可以 Enable *Recycle Bin for EBS Snapshow* (資源回收桶, 預設沒啟用) 防止誤砍


## EFS, Elastic File System

- 可 attach 到 EC2 Instance 的 NFS
    - 可跨 az
- 若有成本考量, 可使用 **EFS-IA Lifecycle Policy**
    - EFS-IA, EFS Infrequent Access
    - 可省達 92%


## Amazon FSx

- 可使用 3rd 的 FileSystem
    - AWS FSx for Luster (Linux & Cluster)
    - AWS FSx for Windows File Server
    - AWS FSx for NetApp ONTAP


# ELB, Elastic Load Balancing & ASG, Auto Scaling Group

- HA 通常與 Horizontal Scaling 共存 & 存在於多個 az
- Horizontal Scaling 方式
    - 增加 Instance & 使用 ASG & 使用 ELB
- 名詞解釋比較
    - Scalability: 藉由 scale up, scale out 來因應大流量
    - Elasticity: 若系統為 Scalability, Elasticity 指系統可因目前 load 來 auto-scaling 達成本最佳化
    - Agility: 指雲服務, 只需透過點點點, 就可以快速有資源來操作


## ELB, Elastic Load Balancer

- Load Balancer: 用來 轉發/分攤 流量的 server
- AWS 提供的 Load Balancer
    - L7 : application
    - L4 : TCP & ultra-high performance
    - Classic Load Balancer : 同時有 L7 & L4 功能. 舊時代產物
    - Gateway Load Balancer
        - 2020/11 新增, 但這個與 VPC 較相關
- 配置 ELB, 後面必須要有 **Target Groups** & 對此設定他的 **Security Group** 來 allow traffic


## ASG, Auto Scaling Group

- 可手動調整規模 OR 配置相關參數, 來做 auto scaling
    - Minimum Size
    - Actual Size/Desired Capacity
    - Maximum Size
- 調整的策略可以是 by CPU 或 by Network in/out 或 ...
- 而這些 scaling 的 strategy, 可以是 manual, 或是 dynamic:
    - Simple/Step Scaling - ex: CPU > 70%, then +1 台機器 && CPU < 30%, then -1 台機器 (這樣則是兩條策略規則 )
    - Target Tracking Scaling - ex: 設定  ASG CPU
    - Scheduled Scaling
    - Predictive Scaling


# S3, Simple Storage Service

- 物件儲存, 本身 Cross Region
    - Object Size Limit : 5 GB
    - 雖說 Bucket Name 跨 Region, 但 Bucket 仍須給定 Region
- Object file, ex: `s3://BucketName/123/456/orz.txt`
    - Key         : `123/456/orz.txt` (Object Paths)
    - Prefix      : `/123/456/`
    - Object Name : `orz.txt`
- Security
    - User Based
        - allow 特定有權限的 IAM access
    - Resource Based
        - Bucket Policy : Cross IAM. ex: Public Access
        - Object ACL
        - Bucket ACL
    - 若要訪問, 上述兩著需要其一 Vaild && 不存在 Deny


# Database & Analytics

## RDS, Relational DataBase

- 需 run on EC2 (非 Serverless)
- AWS RDS, SaaS, Serverless. 有幾個常見的 DB:
    - MS SQL
    - MySQL
    - PostgreSQL
    - ...
    - Aurora (AWS 針對底下的 distribution 做了優化)
        - Provision Server
        - MySQL (5X 倍速優化)
        - PostgreSQL (3X 倍速優化)
- 東西存放在 EBS
- RDS 最多可配置 5 個 Read Replicas (scalability)
    - 可 Cross AZ
        - multi-az -> HA
        - multi-region -> read-replication scalability (但仍可作為 backup)
    - 可 Auto-Scaling, 一次 10~64 GB
- 可配置 Multi-Region Read
    - 不過 Cross-Region Replication 的流量費用要留意
    - App 就近讀取
- Encryption
    - rest encryption
        - for Oracle / SSMS, 可使用 Transparent Data Encryption, TDE
        - 需要在 launch time 決定啟用
        - Master 沒加密的話, Replica 也無法加密
    - in-flight encryption
        - SSL Certificate 來做上傳期間加密
        - provide SSL options with a trust certificates when ocnnecting to DB and will establish an SSL connection
        - 若要 force SSL
            - for PostgreSQL : 需要對 console Parameter Group 設定 `rds.force_ssl=1`
            - for MySQL : 需做 `GRANT USAGE ON *.* TO 'USER'@'%' REQUIRE SSL;`
- Security
    - Network Security : 使用 SG
    - Access Management : 
        - 使用 IAM 做規範
        - 若為 MySQL/PostgreSQL RDS, 也可使用 IAM-based authentication, 否則使用帳密認證
            - *authentication token*(15 mins) via IAM & RDS API call
            - EC2 也可藉由 **IAM Role** 來取得 RDS *authentication token*
                - 好處是, 流量都做 SSL 加密 && IAM(而非 DB) 管理 users


### Aurora

- 比原生(OpenSource) 的還貴上 20% 以上, 但效能較強
- 此為 AWS Cloud Native Servie


### ElasticCache

- 有兩種
    - Redis
    - Memcache
- 需 run on EC2 (非 Serverless)


### DynamoDB

- HA + Cross 3 AZ replication 的 NoSQL
    - Key-Value
- Serverless DB
- Auto-Scaling 成本低
- 可依照訪問頻率選擇底下的儲存模式的 Table Class
    - Standard
    - Infrequent Access, IA
- 本身並無 Create Database 的概念
    - 動作為 Create Table, 如下範例
    - ```
      TableName: Products
  
      Primary Key
          Partition Key (needed)
          SortKey (optional)
  
      Attributes
          name
          age
          ...
          (每筆資料的欄位都可不同)
      ```
- DynamoDB - Global Table
    - 可作 active-active r/w replication


#### DynamoDB Accelerator, DAX

- DynamoDB fully managed in-memory cache
    - DynamoDB 專用的快取
    - 10x performance improvement


### RedShift

- RedShift 為 *Columnar Storage* (非 row based)
- Data WareHoust
    - OLAP
- 可下 SQL
- 基於 PostgreSQL 的 DB, 但非 OLTP(Online Transaction Processing)
    - Note: OLAP(Online Analytical Processing)
- 用來做 analyze 及 data warehouse
    - 10x performance
- Massively Parallel Query Execution, MBP Engine
- 可下 SQL, 並整合 BI
    - ex: QuickSight, Tableau, ...


### Amazon EMR, Elastic MapReduce

- 用來建 Hadoop Cluster
    - Hadoop ecosystem: Apache Spark, HBase, Presto, Flink, ...
- EMR 用來管 EC2 Instances, config, ...
    - 可 Auto-Scaling
    - 可用 Spot Instance (可能 loss instance)
- Use Case:
    - ML, Data Processing, Web Indexing, Big Data, ...


### Amazon Athena

- Serverless query service to perform analytics against s3 objects
    - 可下 SQL 對 S3 查詢做分析
- 支援 csv, json, ORC, Avor, Parquet(built on Presto)
- Charge: USD $5/TB second
    - 因為 by scan 量收費, 若 data 有做 Compress 或 columnar 方式儲存, 可省下 $$
- Use Case:
    - ```mermaid
        flowchart LR;
        User -- load data --> s3;
        s3 -- Query & Analyze --> Athena;
        Athena -- Report & Dashboard --> QuickSight;
      ```
    - BI / analytics / reporting, analyze & query VPC Flow Logs, ELB Logs / CloudTrail trails, serverless SQL analyze S3, ...


### AWS QuickSight

- Serverless ML powered BI service to create interactive dashboard.
- 可 Auto-Scaling, auto embeddable
- 整合了 RDS, Aurora, Athena, RedShift, S3, ...
- Use Case:
    - Business analytics, Create Visualization, Perform ad-hoc analysis, Get Business insights using data, ...


### Document DB

- Aurora 為 AWS 基於 PostgreSQL/MySQL 的實作
- Document (同上)    MongoDB 的實作
- Replication 為 Cross 3 AZ
    - HA


### Amazon Neptune

- Graph DB
- Use Case: social network relation, ...
- Replication Cross 3 AZ
    - 可高達 15 個 Read Replicas


### Amazon QLDB, Quantum Ledger Database

- 可下 SQL
- 量子記帳本 DB
    - Financial Transactional Ledger
- 非去中心化 (de-centralize, 此仍為 Centralization)
- Serverless, HA
- Replication 3 AZ
- 可看到所有 Data 變更的 History (Ledger)
    - 資料皆為 Immutable (無法刪除)
    - 資料具備 Cryptographic Signature, 確保資料不會被刪除
- 相較於 Common Ledger Blockchain framework, 快上 2~3 倍


### Amazon Managed Blockchain

- de-centralization, 去中心化唷
- 可執行 Transaction without the need of trust
- 常被拿來與 Hyperledger Fabric, Etherenum 比較


## DMS, Database Migration Services

```mermaid
flowchart LR;
src["Source DB"] -- DMS --> db["AWS Target DB"];
```

- Migration 過程可離線, 但建議離線 or 避免寫入, 以確保資料一致


## AWS Glue

```mermaid
flowchart LR;
s3 -- extract --> glue["Glue ETL"];
RDS -- extract --> glue;
glue -- load --> RedShift;
```

- AWS managed extract, transform and load service(ETL)
    - Data Catalog Service
- Serverless
- 家族服務:
    - Glue Data Catalog
        - catalog of databases
        - 可整合 Athena, RedShift, EMR


# Other Compute Services: ECS, Lambda, Batch, Lightsail

## ECS, Elastic Container Service

- 用來 Launch Container
    - 需自行維護 EC2, ECS 則用來 start/stop Container
- 可整合至 ALB(Application Load Balancer)


## Farget

- Serverless
- 同 ECS 用來 Launch Container, 但不需要自行維護 Infra


## ECR, Elastic Container Registry

- Private Registry
- 用來存 ECS/Farget 所運行的 image


## Lambda

- 最初最初, 雲服務最早的 Serverless 為 AWS Lambda, 當時是 `Serveless == FaaS`
- 目前 Runtime 並非任何語言任何版本都有, 僅部分語言有支援
    - 目前無 Docker Runtime
- Charge: Pay per request and compute time
    - charge by call & running duration
    - Free tier: 每月 100w 次 && 40w GB Compute Time
        - 約 40w sec (with 1G RAM)
        - 約 320w sec (with 128G RAM)
    - 超過免費額度, 後續 60w GB/sec for $1
- Event-Driven
- 可藉由 CloudWatch 來做 monitoring
- 每個 Lambda Function 可設定打 10GB RAM
- 比較特別的是, Lambda Container Image
    - 可用 Lambda 運行容器服務, 但是 Image 需要實作 Lambda Runtime API
- Use Case
    - User 上傳 png -> S3, 背後 trigger 把 png 縮小後, 另外儲存, 可用 Lambda
    - Serverless CRON Job. 藉由 **CloudWatch** 或 **EventBridge** Event 來 trigger Lambda FN


## API Gateway

- Serverless & Scalable
    - RESTful API
    - WebSocket API


```mermaid
flowchart LR;

User -- request --> api["API Gateway"];
api -- trigger --> Lambda;
```


## API Batch

- 背後會起 EC2 或 Spot Instance 來運行 Batch job
    - 因此非 Serverless
- Batch Job 背後其實是個 Docker Image, 運行在 ECS (用來跑 Batch Job)


## Compare Batch and Lambda

catalog      | Batch                      | Lambda
------------ | -------------------------- | ----------------
timeout      | No                         | Yes, 15 mins
Runtime      | Any                        | Specific
Storage      | EBS, instance storage, ... | Limited
infra        | 背後為 ECS & EC2            | Serverless


## AWS Lightsail

- Lightsail 是個 Virtual Server
    - Storage, DB, Networking (我忘了這邊在寫啥了)
- 此為 EC2, RDS, ELB, EBS, R53, ... 的替代方案
    - lightsail 是個 Standalone Service
- Cloud Beginner 可用這個
    - 很像 Synology 上頭的服務... 點點點就起服務了
    - UI 導向
- 可用來做 Dev, Test Envir
- 有 HA, 但無 Auto-Scaling
- 幾乎無法與其他 AWS Services 整合 (幾乎自成一體)


# Deployments, Managing Infrastructure at Scale

- 各種部署到 AWS 的方式 & 服務


## CloudFormation

- User 定義 Template, 並藉由 Tempalte(JSON, YAML) 建立 Stack
    - AWS 則在背後 提供 Resources
- IaaS
    - 可只用來管 Infra
- JSON, YAML config, 告知 SG, EC2, S3 (if ELB), 它會建立 Resource
    - 若要刪除 Resources, 也可由 CloudFormation 來刪除. 他會一併刪除依賴 
- Infra 內的 Resources, 都有相同的 tag(方便辨識)
- 可用 **CloudFormation Template**, 協助估 Cost
- 例如 Dev Env
    - 可設定 08:00 ~ 17:00 開 Env, 其餘時間關閉. 可 Cost Down
- 幾乎支援 All AWS Services


## AWS CDK, Cloud Deployment Kit

- 可用各種程式語言來定義 infra, CDK 會將此 compile 成 CloudFormation 所需要的 JSON/YAML
    - 感覺很像是給 Developer 玩的=.=
- 因此可用 CDK 來一口氣 Deploy: Infra && Your Code

```mermaid
flowchart LR;

code["Your Code"] --> cdk["CDK CLI"];
cdk --> tmpl["CloudFormation Template"];
tmpl --> CloudFormation;
```


## AWS Beanstalk

- 給純 Dev 用的
    - PaaS
    - 只能用來管 Code
    - 如果 Dev 懶得 config Server, 懶得 config DB, ...
- Charge: Beanstalk is free. 但對於背後的 Resources 收費
- Monitoring
    - 有 BeansTalk 自己的 Monitoring, 叫做 **Health Agent**, 他用來 push metrics 到 **CloudWatch** && publish **Health Events**
- Beanstalk 背後會去使用 CloudFormation
- Example, 有個 3-tier APP
    - ```mermaid
      flowchart LR;

      subgraph asg
        az1["EC2"];
        az2["EC2"];
      end

      User --> elb["Multi-AZ ELB"];
      elb --> asg;
      asg --> ElasticCache;
      asg --> RDS;
      ```


## AWS CodeDeploy

- Hybrid Cloud
    - 可用 EC2 或 On-Premise Server
    - 但是機器上面必須安裝 *CodeDeploy Agent*
- 不同於 Beanstalk, 比較放任一些 (不知道這在講啥)
    - 不依賴於 CloudFormation && Beanstalk


## AWS CodeCommit

- 地位等同於 Git Repo


## AWS CodeBuild

- Serverless, Scalable, HA
- 可在 Cloud 做 Build Code
    - compile, test, 產生 package
- 可到 **CodeCommit** pull, build 出 Artifacts
- Charge: 只對 Build Time 收 $$


## AWS CodePipeline

- 用來組織 CodeCommit, CodeBuild (做 CI/CD 啦)
    - AWS CI/CD 的核心服務
    - Code -> Build -> Test -> Profision -> Deploy
- CodePipeline Orchestration
    - CodeCommit -> CodeBuild -> CodeDeploy -> ... (ex: Elastic Beanstalk, ...)
- 可 fast delivery, rapid update


## AWS CodeArtifact

- 用來管理 Code 依賴. code dependencies, artifact management, ...
    - 也稱為 Code Dependencies
    - CodeBuild 可到 CodeArtifact 拉 dependencies
- Work with: Maven, pip, yum, npm, NuGet, Gradle, yarn, twine, ...


## AWS CodeStar

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


## AWS Cloud9

- Cloud IDE
- edit the code "in-the-cloud"


## AWS SSM, Systmes Manager

- Hybrid. 可管 EC2 && On-Premise instances
- 用來做
    - automative patching
    - enhance compliance
    - 對整個 EC2 fleets 下指令(有點像 ansible...)
    - 協助儲存 param configuration
        - by **SSM Parameter Store**
- For Win & Mac & Linux
- 機器需安裝 *SSM Agent* (某些類型的 EC2 預設已安裝)


### SSM Session Manager - Systems Manager

- 用來 access EC2 的一種方式
    - by *SSM Session Manager* (免開 ssh port)
- 也會 send log -> **S3** or **CloudWatch**
    - 需要有合適的 IAM Role: `AmazonSSMManagedInstanceCore`


## AWS OpsWorks

- 此為 AWS 魔改 Chef & Puppet
    - 若上 AWS 前已在使用, 則可接續使用 **AWS OpsWorks**
    - 用來配置主機
- 讓 ops 用來管理 cloud/on-premise instance
- `AWS OpsWorks = Managed Chef & Puppet`
    - AWS OpsWork 為 SSM 另一套替代品


# Global Infrastructure Section

- Cloudfront (CDN), Edge Locations, 也稱為 Points of Presence
- S3 Transfer Acceleration, 加速 upload/download
- AWS Global Accelerator, 加速 App availability & performance


## Route53

- 分成四種 routing policy
    - Simple Routing Policy
        - 路由到標的 Server 不做 Security Check
    - Weighted Routing Policy
        - 路由到標的 Server, 會排除掉 unreachable 的機器
    - Latency Routing Policy
        - 依 TTL, Routing 到最快的 Node
    - Failover Routing Policy
        - 可設定 Primary Node 與 Failover Node
        - 之前用到的 DNSPod 也有這樣的配置


## CloudFront

- CDN
- 其中一個功能可做 DDoS Protection
- 整合 Shield, AWS Web Application Firewall (WAF)
- by using CloudFront's *Origin Access Identity(OAI)* to enhance security
    - ```mermaid
        flowchart LR;

        User --> Edge;
        Edge -- private --> S3;
        S3 -- OAI --> oia["Origin Access Identity + S3 Bucket Policy"]
      ```
- Cloudfront 可作為 ingress(入口), 來上傳 file -> S3
    - ```mermaid
      flowchart LR;
      
      subgraph origin
        S3;
        http["HTTP Server"];
      end
      
      client --> cloudfront["Cloudfron(Local Cache)"];
      cloudfront --> origin;
      ```


## S3 Transfer Acceleration



# Machine Learning

## Amazon Rekognition

- 用來辨識 images && videos
- Use Case
    - Labeling
    - Content Moderation
    - Text Detection
    - Face Detection and Analysis 
    - Face Search and Verification
    - Celebrity Recognition
    - Pathing
- [AWS Rekognition](https://aws.amazon.com/rekognition/?nc1=h_ls)


## Amazon Transcribe

- Speech -> Text



## Amazon Policy

- Text -> Speech
- 與 Amazon Transcribe 相反


## Amazon Translate

- Website 之類的大量文章翻譯


## Amazon Lex + Connect

- Amazon Lex
    - chatbot 或 call center bot
    - Automatic Speech Recognition(ASR) Speech to Text
    - 懂語意
- Amazon Connect
    - Cloud-based virtual contact center
    - 接收 calls && create contact flow
    - 可整合 CRM
    - No upfront payment
        - 比起 traditional contact center solution 節省 80%

```mermaid
flowchart LR;

phone["Phone Call"]
connect["Amazon Connect"]

phone -- "call" --> connect;
connect -- stream --> Lex;
Lex -- invoke --> Lambda;
Lambda -- schedule --> CRM;
```


## Amazon Comprehend

- Natural Language Processing, NLP
- by ML, 文字中找到 insight && relations
- Serverless


## Amazon SageMaker

- 相較於其他的 ML, 這服務比較不那麼聚焦於特定用途, 而是可以 create 自己的 ML model
    - Building Machine Learning models


## Amazon Forecast

- 用來做預測
- data -> S3 -> Amazon Forecast


## Amazon Kendra

- document search service
    - 針對許多文件檔案做 文件分析 的 ML
    - 據此來建立 knowledge index


## Amazon Personalize

- build apps with real-time personalized recommendations
- 針對個人化的行銷建議, 推薦系統
- S3 或 real-time data -> Amazon Personalize


## Amazon Textract

- 針對文件掃描後 extract text
    - ex: 駕照掃描後建立相關資料


#
