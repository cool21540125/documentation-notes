# AWS DMS, Data Migration Service

- 如果 backup source 與 restore target 的 DB engine 不一樣, 參考 `AWS SCT, Schema Conversion Tool`
  - 反過來說, 如果 source 與 target 相同 Engine, 則不需要 SCT
- Continuous Data Replication, CDC
- 可做轉換的 Data Sources:
  - EC2 上頭的 DB
  - RDS
  - S3
  - DocumentDB

---

```mermaid
flowchart LR

src["Source DB"]
tgt["Target DB"]
subgraph dms["AWS DMS"]
    s0["Source Endpoint"]
    s1["Target Endpoint"]
    subgraph rr["Replication Instance"]
        rt(("Replication Task"))
    end
    s0 --> rt --> s1;
end
src --> s0;
s1 --> tgt;
```

---

```mermaid
flowchart TB

subgraph dc["On-Premise DC"]
    db["Oracle DB (source)"]
    srv["Server with `AWS SCT` Installed"]
end

subgraph AWS Region
    subgraph VPC
        subgraph Public Subnet
            dms["AWS DMS Replication Instance (Full load + CDC)"]
        end
        subgraph Private Subnet
            rds["RDS mysql (target)"]
        end
    end
end

db -- Data migration --> dms;
db -- "backup 到不同 Engine DB" --> srv;
srv -- Schema conversion --> rds;
dms -- insert/update/delete --> rds;
```

---
