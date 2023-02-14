
# AWS DataSync

- [What is AWS DataSync?](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html)
    - online data transfer service
        - simplify && auto && accelerate moving data between storage systems and services
        - 支援在底下的各種 服務/儲存系統 之間作移動
            - NFS
            - SMB
            - HDFS
            - Object storage systems
            - S3
            - EFS
            - Glacier
            - Snowcone
            - AWS FSx
- 零星功能摘要:
    - 可設定 rate limit
    - 地端需安裝 `AWS DataSync Agent`
    - Sync 時, 可連同 `File permissions` && `metadata` 一起保留下來
- Usage:
    - 大量 data 想從 On-Premise Data -> AWS, 可參考此服務
- Charge:
    - 針對 DataSync 傳輸的流量計費

---

```mermaid
flowchart LR

subgraph dc["On-Premise"]
    direction LR
    srv["Server"];
    agent["AWS DataSync Agent"];
    
    srv <-- "NFS/SMB protocal" --> agent;
end

subgraph Region
    ds["AWS DataSync"]
    subgraph rr["AWS Storage Resources"]
        direction LR
        S3; S3-IA; EFS;
        glacier["S3 Glacier"]
        efs["AWS EFS"]
        fsx["Amazon FSx"]
    end
    ds <--> rr
end

agent <-- TLS --> ds;
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
