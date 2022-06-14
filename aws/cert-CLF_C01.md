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
    - ```json
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": "*",
                  "Resource": "*"
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
- AMI, container for EC2 instance
- 服務免費, 只對 Resource 收費
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


## EC2 Instance Store

- 相較於 EBS 快很多, 因為直接使用硬體
- 為 ephemeral storage, instance terminate 資料會消失
- 長久保存的話, 建議使用 EBS


# EBS, Elastic Block Storage

- 為 Network Device
    - 只能同時掛載到一台 Instance
        - 早期的 io1, io2 可同時掛載到多個 EC2
    - 只能存在於 az, 無法跨 az
        - 若要跨 az/region, 可藉由 snapshot
            - 做 EBS snapshot, 不需要 detatch, 但建議


# EFS, Elastic File System

- 可 attach 到 EC2 Instance 的 NFS
    - 可跨 az
- 若有成本考量, 可使用 **EFS-IA Lifecycle Policy**
    - EFS-IA, EFS Infrequent Access
    - 可省達 92%


# Amazon FSx

- 可使用 3rd 的 FS
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


# ELB, Elastic Load Balancer

- Load Balancer: 用來 轉發/分攤 流量的 server
- AWS 提供的 Load Balancer
    - L7 : application
    - L4 : TCP & ultra-high performance
    - Classic Load Balancer : 同時有 L7 & L4 功能. 舊時代產物
    - Gateway Load Balancer
        - 2020/11 新增, 但這個與 VPC 較相關
- 配置 ELB, 後面必須要有 **Target Groups** & 對此設定他的 **Security Group** 來 allow traffic