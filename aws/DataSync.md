
# [AWS DataSync](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html)

- simplify && auto && accelerate moving data between storage systems and services
- **DataSync 並非即時同步的服務, 而是定時同步**
- 用來作 AWS 及 non-AWS 的資料同步
    - non-AWS 要做 DataSync 的話, 需要安裝 agent
        - 使用時, 記得限流量, 避免影響其他服務
- 可定期同步到 or 讓資料在服務之間傳輸:
    - NFS
    - SMB
    - HDFS
    - Object storage systems
    - S3
    - EFS
    - Glacier
    - Snowcone
    - AWS FSx
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

---

本地與 AWS DataSync 之間的同步方式架構之一

```mermaid
flowchart TB

sync["AWS DataSync"]
agent["DataSync Agent"]
dx["Direct Connect"]
link["Private Link"]


ii["Interface VPC Endpoint"]

subgraph local["On-Premise"]
    agent --> dx;
end

subgraph aws
    subgraph vpc
        link --> ii;
    end
    ii --> sync;
end

dx -- "Private VIF" --> link;
dx -- "Public VPF" --> sync;
```
