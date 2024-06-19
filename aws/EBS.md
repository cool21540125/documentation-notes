- IOPS, (I/O Operations Per Second)

# EBS, Elastic Block Storage

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
- Provisioned IOPS, PIOPS
    - Highest performance EBS volumes
- 無法跨 AZ, 若要 Cross AZ, 則需要搭配 snapshot(再由 snapshot 到其他 AZ restore)
- 各種 Volume Types 比較
    - [EBS Volumes 規格比較表](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html)
    - io1/io2 SSD
        - Highest-performance SSD volume for mission-critical low-latency or high-throughput workloads
        - 優化磁碟 IO 操作
            - for Nitro EC2 instances, 最大可達 64000 IOPS
            - 若非 Nitro EC2, 則為 32000 IOPS
        - Charge: by 容量 && I/O 數
        - 4 GiB ~ 16 TiB
        - (僅此 io 系列)支援 Multi-Attach (同 AZ, 多 EC2 同時掛載)
            - 需使用較特殊的 filesystem (cluster-aware)
                - 並非 xfs, ext4
            - 最多同 AZ 只能有 16 EC2 Instances 同時掛載
        - ex: 要使用在非常講究 IOPS 的 DB, 可使用 io1/io2
        - IOPS 與 Size 並沒掛鉤(可獨立調整)
        - io1
            - Max IOPS 64000
        - io2 Block Express, 4GiB ~ 64 TiB
            - Max PIOPS 為 256000 with an IOPS:GiB ratio of 1000:1 (不知道這在講啥...)
    - gp2/gp3 SSD
        - IOPS 隨著 容量 增加(無法彈性選擇), 且 IOPS 最高也只有到 16000
        - General purpose, 平衡了 price && performance
        - 大小由 1 GiB 到 16 TiB
        - 已在 2020/12 停止 gp1
        - gp2
            - Volume Size && IOPS 兩者呈現正相關
                - 小容量 Volume IOPS 為 3000, 最大可提升至 16000
            - 3 IOPS per GB, 也就是說, 增加 30 GiB 空間的話, IOPS 也會提升 10
        -gp3
            - 基本 IOPS 為 3000 && throughput 為 125 MiB/sec
            - 可提升 IOPS -> 16000 或 throughput -> 1000 MiB/sec (兩者獨立)
    - st1 HDD
        - Low cost HDD, frequently accessed, throughput-intensive workloads
        - 125 MiB ~ 16 TiB
        - Use Case: Big Data, Data Warehouses, Log Processing
        - 效能: Max throughput 500 MiB/sec && max IOPS 500
    - sc1 HDD
        - Lowest cost, less frequently accessed workloads
        - Use Case: archived datra
        - 效能: max throughput 250 MiB/sec && max IOPS 250
- EBS Volumes 基本上都有底下的規格
    - Size
    - Throughput
    - IOPS, (I/o Operations Per Second)
- EBS 零散摘要
    - 只有 gp2/gp3 && io1/io2 可用來作為 boot volume
- EBS Encryption
    - AES-
    - 如果 EBS Volume 沒有做 encrypt, 打算把它弄成 encrypt volume
        - Snapshot > Copy Snapshot > Encrypt this snapshot
            - 再由上面的 encrypted snapshot 來做 create volume from snapshot > 得到一個 encryption volume
        - 或是, 也可由原 volume, create snapshot(不做 encrypt)
            - 接著 create volume from snapshot > 勾選 encrypt this volume > 得到一個 encryption volume
- EBS 的服務/額外功能: 
    - Amazon Data Lifecycle Manager, DLM
        - 用來自動 增刪改 EBS snapshots 及 EBS-backed AMI
    - Fast Snapshot Restore, FSR
        - 可將 snapshot 做快速還原
        - 非常非常貴, 一個月幾百美的那種貴
    - Recycle Bin for EBS Snapshots
        - 可以幫 snapshots 開啟資源回收桶
    - EBS Snapshot Archive
        - 將 snapshot 移動到 archive tier
        - 大概可節省 72% 的儲存費用


## gp2 v.s. gp3

- gp2 及 gp3 都具備了高達 99.8% 以上的 durability, 也就是約 0.2% 的 annual failure rate
- Volume Size 可從 1 GiB ~ 16 TiB
- gp2 的 Max IOPS 為 16,000 (也就是 16 KiB I/O); Max throughput 為 128~250 MiB/sec
- gp3 的 Max IOPS 為 64,000 (也就是 64 KiB I/O); Max throughput 為   1,000 MiB/sec

> AWS Disk 每一個操作, 如果資料量 < `256KB`, 則視為一個操作; 如果 資料量 > `256KB`, 則會被視為不同的操作
> 
> 如果是隨機讀寫 < `256KB`, 可能也會被視為是多次操作


# TIPs

- 避免 EBS Snapshot 意外刪除:
    - 啟用 **Recycle Bin for EBS Snapshots**, 防止誤砍
    - 不知道要不要課金 (不過 Snapshot 本身要收錢, 丟到回收桶不曉得會不會停止收費)!!!!
    - 可自行設定保留在回收桶的天數 (1~365 days)
- 為了省點摳摳, 建議針對 "不會有立即使用需求的 EBS Snapshot* 做 archive
    - 可以省 75% 的摳摳
    - 不過還原的話, 需要花上 24~72 hrs


# 未整理雜訊

> If I/O size is very large, you may hit the throughput limit of the volume, causing you may experience a smaller number of IOPS
> 
> 如果 I/O 非常大, 則可能因為已經觸及了 throughput limit, 因而造成體驗到不如預期的 IOPS

> throughput 計算方式 : 
> 
> `Throughput in MiB/s = (Volume Size in GiB) * (IOPS per GiB) * (I/O size in KiB)`
> 
> 也就是: 
> 
> `Throughput in MiB/s = (IOPS performance) * (I/O size in KiB) / 1024`

如果未達到 3000 IOPS 時(也就是 Volume Size < 1000GiB), 此時才會有 Burst 的議題

gp2 EBS Volume 每秒鐘, 能獲得 `IOPS * 3` 的 BurstCredit, 而此 BurstCredit, 一個 EBS Volume 上限為 5,400,000

也就是如果已經把 BurstCredit 消耗光了, 那等他慢慢回滿

對於 10 GiB 的 Volume, 回滿需要花 : 5400000/100/60/60 = 15 hrs (因為 IOPS 最低保障, 不管 Volume Size 多少, 都能夠有 100)

對於 40 GiB 的 Volume, 回滿需要花 : 5400000/(40*3)/60/60 = 12.5 hrs

對於 100 GiB 的 Volume, 回滿需要花 : 5400000/(100*3)/60/60 = 5 hrs

對於 1000 GiB 的 Volume, 因為已有 3000 的 Baseline IOPS performance, 因此也不會有 Burst 的問題
