```bash
### 檢測 EC2 建立的 KeyPair 的 Fingerprint
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/verify-keys.html
openssl pkcs8 -in  ~/.ssh/${PRIVATE_KEY_NAME}.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c

###
```

# EC2, Elastic Compute Cloud

- IaaS
- [EC2 機器規格比較表](https://instances.vantage.sh/)
- EC2 Instance Connect, 目前未必每個 Region 都有此功能
  - 可直接使用 Web Console 做 login
    - 似乎 SG 需要開 allow 22 from 0.0.0.0 (只單純允許 MyIP 登不進去)
- IAM Roles
  - 不要把 AWS EC2 credentials 放到 EC2, 要用 **IAM Roles**
  - 把特定 Roles assign 給 EC2 來提供 Credentials
  - 作法:
    - EC2 > Actions > Security > Modify IAM Role
- 初始化 EC2, 使用到 _User data_ 的話, 務必寫上 _Shebang Line_, 沒寫會出錯
- Instance 重點在於:
  - _on-demand_, _spot_, _reserved_ 這 3 種, 搭配 _Standard_, _Convertable_, _Scheduled_
  - _Dedicated Host_ v.s. _Dedicated Instance_
- EC2 Instance Connect
  - EC2 Web Console > 選取主機 > Connect > Instance Connect
    - 目前如果是 Amazon Linux 2 或 Ubuntu, 預設安裝
- access EC2 常見問題
  - timeout, 必然是 SG Issue
  - connection refused, app error 或 not launched
- 不要在 EC2 上面做 `aws configure`, 善用 IAM Role
- 申請 EC2 時, 有幾個構面需要優先思考:
  - Launch Type
    - On-demand, Stop Instance, Dedicated, Reserved, ...
  - Instance Type
    - R, C, M, I, ...
    - Instance Family
      - M5, M6, T2, T3, ...
- 製作 EC2 的 image
  - 強烈建議, Termination 以前都做這個.
  - AWS 會為製作 image 的 EC2 一併製作 image 及 snapshot

## Instance Type

- M7g, General Purpose
- T, Burstable
  - 因為大多數人開了機器以後, 基本上 EC2 都閒在那邊, 因此有了 t 系列主機, ex: t2.micro
  - 這類型機器是與其他人共用實體機器, 藉由 AWS 的 Hypervisor 用來運行 VM, 這就是你的 EC2
    - 這句話是我自己做結論的, AWS 官方並沒有這樣說
  - 機器沒在使用(沒有在操 CPU)時, 會累積 credits
    - 等到需要 安裝東西/跑些啥程式/做些有的沒的, 會耗用之前累積的 CPU credits
  - CPU Credit 計算:
    - 1 CPU credit = 1 vCPU _ 100% _ 1 min
    - 1 CPU credit = 1 vCPU _ 50% _ 2 mins
    - 1 CPU credit = 2 vCPU _ 25% _ 2 mins
  - CPU credit 的累積, 如果是 t2 將 instance stop 以後會全數消失, t3 以上則會保存一週
  - 如果開了 t2.micro 以後, 真的很需要 CPU, 除了調整 instance type 以外, 還可以切換成 `t2 ultimate`
- C, Compute Optimized : ML, ...
- M, Memory Optimized : RDB
- I, Storage Optimized : OLTP, NoSQL, ...
- G?, Accelerated Computing :
  - 不曉得這個和 Compute Optimized 差在哪邊
- Instance Features :
- Measuring Instance Performance :
- 而上述的這些 Types, 有它旗下的 Series:
  - T2, M4, M5, C4, R5, I3 等等, 有著各種方面的優化
- 範例 :`m5.2xlarge`
  - m : instance class
  - 5 : generation (硬體規格編號)
  - 2xlarge : size within the instance class

## Launch Type (Instance purchasing options)

EC2 選購時, 有底下這一大堆的 purchasing options:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html

- On-Demand
- Reserved
  - 1 or 3 年, 預付省更多
  - 分成:
    - Standard Reserved Instance
      - 可省錢達 72%, 提前退租可在 **AWS Marketplace** 賣掉
    - Convertible Reserved Instance
      - 可省錢達 66%, 可改變 instance type, family, os, scope, tenancy
  - Reserved Instance 在選購時可選擇底下 2 種 scope:
    - Regional: When you purchase a Reserved Instance for a Region, it's referred to as a regional Reserved Instance.
    - Zonal: When you purchase a Reserved Instance for a specific Availability Zone, it's referred to as a zonal Reserved Instance.
    - 至於 Regional 與 Zonal, 有需要再去研究 [Differences between regional and zonal Reserved Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-scope.html)
- Spot Instances
  - 短期使用, 超便宜, 但可能隨時 loss instance
    - 若自己的 max price < current stop price, 則失去 instance
  - 較適用於 batch job, data analysis, image processing, cc attack, ...
- Dedicated Host
  - 直接訂閱實體機, 對於整台機器(硬體)有完整的使用權限
  - 像是有些 license, 是針對 per-core, per-socket 來收費的話, 用這個會是個不錯的選擇
    - BYOL, Bring Your Own License
- Dedicated Instances
  - 組織內 or 同帳號底下, 可與其他 _non dedicated instance_ 共用硬體
  - no control over instance placement
- Capacity Reservations
  - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-reservations.html
  - 不做使用承諾, 但可保有 reserved capacity
    - 基本上就是大多數人使用的 EC2 那樣, 不需要就把他 Terminate 掉了
    - 享受不到 Discount
  - 可跨帳號共用這些 Capacity Reservations
    - 但並非 cross Account transferable
- [Dedicated Host v.s. Dedicated Instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html#dh-di-diffs)

# [Placement Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)

- 為了增加 EC2 之間的傳輸效能, 可藉由 _placement group_ 來控制 EC2 在 AWS infra 之中的位置, 有 3 種佈置策略(strategy):
  - Cluster
    - same Rack, same Hardware, same AZ
    - 目的是盡可能降低 latency
  - Partition (Distributed)
    - 每一台 EC2 都座落於不同的 logical segments / partition
      - 而這些不同的 segments / partition 並不會共用相同的 hardware
    - different Rack
      - 每個 AZ 最多有 7 個 Racks
    - 類似 Spread 策略, 同 AZ 裡頭, 但不同機櫃
    - 適用於 large distributed and replicated workloads
      - ex: Hadoop / Cassandra / Kafka
  - Spread (Critical)
    - 嚴格地將 一個小群組的 EC2 Instances 設置到不同的 機器實體
      - 而這些 機器實體 坐落於同一個 rack(機櫃)
        - Same Network, Same Power Supply
      - 一個 AZ 裏頭最多只能有 7 台 EC2 Instances (using Spread)
        - 因此如果超過 7 台 EC2, 則會座落於 Same Region but cross AZ
    - 為了極小化 failure risk
- User Data
  - 初始化建機器以後所做的 init script, 相關的 log 紀錄在 `/var/log/cloud-init-output.log`
    - 上面這個, 如果是在 EC2 Console 建立的時候不曉得會不會有 log.... 但如果使用 CloudFormation 的 User Data, 能找到上述 log

## EC2 Hibernate

- 若啟用 hibernate 後, 再把 Instance Stop, 就像一般電腦睡眠一樣, RAM state 被保留
  - 這些 _RAM state_ 會被寫入到 _root EBS Volume_
    - 而這個 EBS 需要 Encrypted
  - 加速將來 Instance start 的時間
    - 直接從 _root EBS Volume_ 來做 init
- cross OS
- 使用限制:
  - 適用於: **On-Demand**, **Reserved**, **Spot**
  - RAM 必須要 < 150 GiB
  - hibernation period < 60 days (無法長久 hybernate)

## EC2 Nitro

- 新一代的 EC2 visualization 技術
  - OLD(current) : EC2 EBS 32000 IOPS
  - Nitro : EC2 EBS 64000 IOPS

## EC2 - Enhance Networking

- ENA, EC2 Enhanced Networking, (SR-IOV)
  - Networking 支援較高的 bandwidth 及 PPS(packet per second) && lower latency
  - 僅適用於 newer generation EC2 Instances:
    - Elastic Network Adapter, ENA - up to 100 Gbps
    - Inter 82599 VF (legacy, OLD ENA) - up to 10 Gbps (Legacy)
- EFA, Improved ENA for HPC, Elastic Fabric Adapter - (Linux Only)
  - 很適合 distributed computation (相同 Cluster 的 Internal communication)
  - 因藉助 Message Passing Interface(MPI) standard, 可 bypass underlying Linux OS 來 lower latency

```bash
### 查詢 ENA mod 是否已安裝(預設 new generation EC2 Instances 都有安裝)
modinfo ena

### 查看 ENI 使用的 driver
ethtool -i eth0
#driver: xxx  <-- 如果已啟用 Enhanced Networking, 應該看到 ena
# Amazon Linux 2023, 使用 enX0 取代原有的 eth0

### 或者可以使用 aws cli 查看是否已經啟用了 ENA
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[].Instances[].EnaSupport"
```

## AWS ParallelCluster

- open sources cluster management tool to deploy HPC on AWS
- text file
- 自動建立 VPC, subnet, cluster type, instance type
- 可在 cluster 裡頭 enable EFA

## EC2 Image Builder

- 可能會跑上 30+ mins
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
-

# EC2 - Status Check

- EC2 的 Health Check 分成 2 種
  - System status checks - 硬體, ex: AWS power, networking, or software systems
  - Instance status checks - 軟體, ex: OS 是否能夠接收 traffic
- 能夠在 EC2 裡頭查看自己的 metadata

```bash
curl http://169.254.169.254/latest/meta-data/
```

# EC2 Storage

- AWS 似乎有支援 `ceph`(檔案系統), 可支援 `Object Storage` && `Block Storage`

## EC2 Storage - EC2 Instance Store

- 相較於 EBS 快很多, 因為直接使用硬體
  - millions IOPS
- 為 ephemeral storage, 如果機器發生底下事件, 則 data loss:
  - terminate
  - stop
  - hibernate
  - 硬體損毀
- NVME, Non-Volatile Memory Express, 似乎就是 Instance Store 的一種
- 長久保存的話, 建議使用 EBS

## EC2 Storage - Amazon FSx

- 可使用 3rd 的 FileSystem
  - AWS FSx for Lustre (Linux & Cluster)
  - AWS FSx for Windows File Server
  - AWS FSx for NetApp ONTAP

# EC2 metrics

- InstanceLimitExceeded : 特定 region 的 service quota 達到使用上限
- InsufficientInstanceCapacity : AWS 那邊於 AZ 裡頭已經沒有相關的資源可供開立

# Study

- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html
