
# Service Discovery Concepts

- Service Discovery 核心元件
    - Service Provider
        - 加入/離開 系統時, 都必須到 Registry 註冊
    - Service Consumer
        - 由 Registry 查出 Provider 的 location, 並且 connect to Provider
    - Service Registry
        - 記錄所有加入系統內的 Instances 的 location 的 DB
        - 必須為 HA (by Replicaiton)

```mermaid
flowchart LR;

registry["Registry"]
provider["Provider"]
consumer["Consumer"]

provider -- 1.register --> registry;
consumer -- 2.lookup --> registry;
registry -- 3.response --> consumer;
provider -- 4.get consumers --> consumer;
consumer -- 5 --> provider;
```
------------------------------------------------------------

# Service Discovery Patterns

## Client Side Discovery
```mermaid
flowchart LR;

A -- search --> registry
registry -- ip --> A;
A -- request --> B;
```


## Server Side Discovery
```mermaid
flowchart LR;

A -- request --> Proxy;
Proxy -- ask --> Registry;
Registry -- ip --> Proxy;
Proxy -- request --> B;
```
------------------------------------------------------------

# Service Registration Options

## Self-Registration / Sidecar Pattern
```mermaid
flowchart LR;

subgraph PodA
    direction TB;
    A
    aa["Sidecar"]
end
subgraph PodB
    direction TB;
    B
    bb["Sidecar"]
end
aa -- update --> Registry;
bb -- update --> Registry;
```

## 3rd-Party Registration / Orchestration
```mermaid
flowchart TB;

subgraph Cluster
    3rd["3rd Registrar"]
    3rd -- update --> Registry;
    3rd -- watch -.-> A["A"]
    3rd -- watch -.-> B[" "]
    3rd -- watch -.-> C["C"]
end

3rd -- "watch 不到" -.-> D["Ｄ"]
```

------------------------------------------------------------
