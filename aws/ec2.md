
# Elastic Compute Cloud

- IaaS
- [EC2 機器規格比較表](https://instances.vantage.sh/)
- [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/?nc1=h_ls), 分成底下的 Types:
    - General Purpose
    - Compute Optimized : ML, ...
    - Memory Optimized : RDB
    - Accelerated Computing : 
        - 不曉得這個和 Compute Optimized 差在哪邊
    - Storage Optimized : OLTP, NoSQL, ...
    - Instance Features : 
    - Measuring Instance Performance : 
    - 而上述的這些 Types, 有它旗下的 Series:
        - T2, M4, M5, C4, R5, I3 等等, 有著各種方面的優化
    - 範例 :`m5.2xlarge`
        - m       : instance class
        - 5       : generation (硬體規格編號)
        - 2xlarge : size within the instance class
- EC2 Instance Connect, 目前未必每個 Region 都有此功能
    - 可直接使用 Web Console 做 login
        - 似乎 SG 需要開 allow 22 from 0.0.0.0 (只單純允許 MyIP 登不進去)
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
        - (保證消費/承諾消費) 一定期間花費一定金額, 目的是為了長期使用 & 彈性省錢
            - ex: 承諾將來每月花 $300
    - Spot Instances
        - 短期使用, 超便宜, 但可能隨時 loss instance
            - 若自己的 max price < current stop price, 則失去 instance
        - 較適用於 batch job, data analysis, image processing, cc attack, ...
    - Dedicated Host
        - 直接訂閱實體機, 對於整台機器(硬體)有完整的使用權限
        - 像是有些 license, 是針對 per-core, per-socket 來收費的話, 用這個會是個不錯的選擇
            - BYOL, Bring Your Own License
    - Dedicated Instances
        - 組織內 or 同帳號底下, 可與其他 *non dedicated instance* 共用硬體
        - 除上述以外, 基本上與 *dedicated host* 相差無幾
            - [查看兩者比較](#dedicated-host-vs-dedicated-instancehttpsdocsawsamazoncomawsec2latestuserguidededicated-instancehtmldh-di-diffs)
        - no control over instance placement
    - Capacity Reservations
        - 對特定 az 保留 capacity
        - 不做使用承諾, 但可保有 reserved capacity
        - 短期任務 && 重要(不可中斷), 適合用這種
- Instance 重點在於:
    - *on-demand*, *spot*, *reserved* 這 3 種, 搭配 *Standard*, *Convertable*, *Scheduled*
    - *Dedicated Host* vs *Dedicated Instance*
- EC2 Instance Connect
    - EC2 Web Console > 選取主機 > Connect > Instance Connect
        - 目前如果是 Amazon Linux 2 或 Ubuntu, 預設安裝


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
    - millions IOPS
- 為 ephemeral storage, 如果機器發生底下事件, 則 data loss:
    - terminate
    - stop
    - hibernate
    - 硬體損毀
- NVME, Non-Volatile Memory Express, 似乎就是 Instance Store 的一種
- 長久保存的話, 建議使用 EBS


## EBS, Elastic Block Storage

- [EBS](./EBS.md)


## EFS, Elastic File System

- 可 attach 到 EC2 Instance 的 NFS
    - 可跨 az (Cross AZ)
    - Linux based, 無法用於 Windows (NFS protocol)
    - Expensive (相較 gp2 貴 3 倍). Pay per use
        - 但可搭配 *EFS Lifecycle Policy* 來切換至 EFS-IA 來省錢
            - X days non-access files, 移動到 EFS-IA
            - EFS-IA, EFS Infrequent Access
            - 可省達 92%
    - HA, scalable
    - 不需事先 provision, 空間幾乎是無限模式
- EFS 放置於特定 VPC 裡頭, 需要設定他的 SG
- Performance
    - 可有 10 GB+ throughput
    - 可增長到 PB 量級, automatically
    - Create EFS 時, 可設定他的 Performance mode
        - *General Purpose* (default)
        - *Max I/O*
- Throughput mode (可用來設定 throughput limits 的決定方式)
    - Bursting    : Throughput 會隨著 system size 變動
    - Provisioned : Throughput 固定
        - 這裡還有些聽不是很懂的細節...
            - *Provisioned Throughput (MiB/s)* && *Maximum Read Throughput (MiB/s)*
- Storage Class
    - Standard
    - Infrequent Access(EFS-IA)
- Availability and durability
    - Regional: (for prod env) Multi-AZ
    - One Zone: (for dev env) Single-AZ.
        - ex: 使用 EFS One Zone-IA, 可省下 90%


## Amazon FSx

- 可使用 3rd 的 FileSystem
    - AWS FSx for Luster (Linux & Cluster)
    - AWS FSx for Windows File Server
    - AWS FSx for NetApp ONTAP


# EC2 Other Note

## [Placement Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)

- 為了增加 EC2 之間的傳輸效能, 可藉由 *placement group* 來控制 EC2 在 AWS infra 之中的位置, 有 3 種佈置策略(strategy):
    - Cluster
        - same Rack, same Hardware, same AZ
        - 目的是盡可能降低 latency
    - Spread (Critical)
        - 為了極小化 failure risk
        - diff Hardware, diff AZ
            - 分散到不同的 logical partition
        - *placement group* 之中, 最多只能 7 個 instances
        - ex: Hadoop, Kafka, Cassandra, ...
    - Partition (Distributed) 
        - cross AZ, cross Partition, cross Rack
            - 每個 AZ 最多有 7 個 Racks
        - 類似 Spread 策略, 同 AZ 裡頭, 但不同機櫃
        - ex: HDFS, HBase, Cassandra, Kfaka, ...


## EC2 Hibernate

- 若啟用 hibernate 後, 再把 Instance Stop, 就像一般電腦睡眠一樣, RAM state 被保留
    - 這些 *RAM state* 會被寫入到 *root EBS Volume*
        - 而這個 EBS 需要 Encrypted
    - 加速將來 Instance start 的時間
        - 直接從 *root EBS Volume* 來做 init
- cross OS
- hibernation period < 60 days (無法長久 hybernate)


## EC2 Nitro

- 新一代的 EC2 visualization 技術
    - OLD(current) : EC2 EBS 32000 IOPS
    - Nitro        : EC2 EBS 64000 IOPS


## EC2 - Enhance Networking

- EC2 Enhanced Networking (SR-IOV)
- higher bandwidth && higher PPS(packet per second), lower latency
- 可使用底下的方法
    - Elastic Network Adapter, ENA - up to 100 Gbps
    - Inter 82599 VF (legacy, OLD ENA) - up to 10 Gbps
    - Elastic Fabric Adapter, EFA - Improved ENA for HPC, Linux ONLY
        - 很適合 distributed computation
        - 因藉助 Message Passing Interface(MPI) standard, 可 bypass underlying Linux OS 來 lower latency


## AWS ParallelCluster

- open sources cluster management tool to deploy HPC on AWS
- text file
- 自動建立 VPC, subnet, cluster type, instance type
- 可在 cluster 裡頭 enable [EFA](#ec2---enhance-networking) (加強 Network)




# 額外補充

- AWS 似乎有支援 `ceph`(檔案系統), 可支援 `Object Storage` && `Block Storage`


```bash
### 讓 EC2 找到自身的 meta-data, 但只能在 *Web Console* && *CLI*, 這動作本身不需要權限
$# curl http://169.254.169.254/latest/meta-data
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html

### CLI 找機器的 meta-data
$# aws ec2 describe-instances
```


# CLI

```bash

### start EC2
$# AWS_REGION=ap-northeast-1         # IMAGE 會綁定 Region, 可用這個來做切換
$# IMAGE_ID=ami-0b7546e839d7ace12    # ap-northeast-1 的 Amazon Linux 2 AMI x86-64
$# aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type t2.micro \
    --dry-run

An error occurred (DryRunOperation) when calling the RunInstances operation: Request would have succeeded, but DryRun flag is set.
# 如果看到這樣, 表示指令可成功下達. 但因家了 --dry-run, 所以沒實際跑下去

$# 
```


# Compare

### [Dedicated Host v.s. Dedicated Instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html#dh-di-diffs)


# TIPs

- access EC2 常見問題
    - timeout, 必然是 SG Issue
    - connection refused, app error 或 not launched
- 不要在 EC2 上面做 `aws configure`, 善用 IAM Role

```bash
### EC2 裡頭, 可看到自己的 metadata
$# curl http://169.254.169.254/latest/meta-data/
```