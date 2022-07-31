
# ELB, Elastic Load Balancer

- [What is an Application Load Balancer?](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
- ![ELB](./img/LB.png)
    - *Load Balancer* 可有多個 listener
    - listener 必須有一個 *default rule*
        - rule 裡頭會有 priority, actions, conditions
    - Rule 用來決定將流量發到哪個 *Target Group*
    - Target 可以跨重複出現在多個 *Target Group*
    - 可在 *Target Group* 制定 *Health Check*
- ELB - Cross Zone Load Balancing
    - ALB
        - 預設 enabled, 且無法 disabled (always on)
        - AZ 內資料傳輸免錢
    - NLB
        - 預設 disabled
        - 若啟用, AZ 內傳輸要課金
    - CLB
        - 預設 disabled
        - AZ 內資料傳輸免錢
- 目前有 4 種 Load Balance
- AWS Load Balancer 整合了一堆 AWS Services:
    - EC2, EC2 ASG, ECS, ACM, CloudWatch, Route53, AWS WAF, AWS Global Accelerator, ...
- 兼具 Health Check 功能


# ELB 的 Sticky Session(Session Affinity)

- Target Group 裡頭處理 sticky 問題
- 用戶黏著性相關問題   
- ALB, CLB 皆可處理此情境
- 分成 2 種 Cookies (有效期限皆為 1 sec ~ 7 days):
    - Application-based Cookie
        - 有 2 個地方可以產生此 Cookie:
            - Custom cookie
                - Target(a.k.a. APPs) 自行產生, 可有任意客製屬性
                - Cookie name must be specified individually for each target group
                - ELB 已保留使用以下命名(別用這名字就是了):
                    - AWSALB
                    - AWSALBAPP
                    - AWSALBTG
            - Application cookie
                - Load Balancer 產生 cookie, 並且保留底下的命名(別用):
                    - AWSALBAPP
    - Duration-based cookie (Load balancer generated cookie)
        - 保留底下命名:
            - AWSALB (ALB 使用)
            - AWSELB (CLB 使用)


## 1. Classic Load Balancer, CLB (Since 2009)

- L4 && L7 : HTTP, HTTPS, TCP, SSL(secure TCP)


## 2. Application Load Balancer, ALB (Since 2016)

- L7 : HTTP, HTTPS, WebSocket, HTTP/2
- ALB 後為 *Target Group*(也會處理 *Health Check*), 裡面可以放置:
    - EC2 instances
    - ECS tasks
    - Lambda functions
    - private IP (可以是 On-premise Data Center Servers)
- Target 接收到 Request 後, 可由 Header 中的
    - `X-Forwarded-For` && `X-Forwarded-Port` && `X-Forwarded-Proto` 
    - 看到用戶真實 IP && Port && Protocol
- 可依照不同的 *routing tables(hostname)* && *query string* && *HTTP Header*
    - 將請求送往後端不同的 Target Groups
    - CLB 則無此功能(需要設很多 CLB, 才能做對應流量轉發)
- 對於 ECS 支援 dynamic port mapping
    - ECS 為 EC2 launch type 時, 跑在裡頭的 Container, 不需定義 port mapping, ALB 自己能找到

```mermaid
flowchart LR

subgraph tg1["Target Group"]
    direction LR
    t1["EC2"]
    t2["ECS Target"]
    t3["Lambda"]
    t4["IP Address"]
end

subgraph SG["SG (不要忘了我)"]
    ALB
end

client -- SG1 --> ALB;
ALB -- SG2 --> tg1;
```

- 通常實作上
    - SG1 allow 0.0.0.0/0
    - SG2 allow from SG1


## 3. Network Load Balancer, NLB (Since 2017)

- L4 : TCP, UDP, TLS(secure TCP)
- high performance, latency ~= 100ms (相較於 ALB ~= 400ms)
- 配置以後, 同時提供 *DNS Name* && *Elastic IP* 來訪問
    - 相較之下, CLB && ALB, 只有 *DNS name*
- NLB 後面的 *Target Group*, 裡頭可以是:
    - EC2 Instance
    - private IP Address
    - ALB
- NLB 在每個 AZ 都有個 static IP (也可支援 assign Elastic IP)
- Charge: 需要課金, 收費方式尚未知
- NLB 僅作流量轉發, 因此後端的 SG 看到的請求皆來自 Client (而非NLB), 因此需要 allow HTTP 0.0.0.0

```mermaid
flowchart LR

subgraph tg1["Target Group"]
    direction LR
    t1["EC2"]
    t2["IP Address"]
    t3["ALB"]
end

client --> NLB;
NLB -- SG2 --> tg1;
```

- 相較於 ALB 的上圖, NLB 無 SG (僅作 forwarding)
    - 因此這邊的 SG2 需要 allow 0.0.0.0/0


## 4. Gateway Load Balancer, GWLB, GLB (Since 2020)
       
- deploy / scale / manage 第三方 network virtual app in AWS
- L3 : IP
- GENEVE protocol : port 6081
- 結合了 2 種功能
    - Transparent Network Gateway
    - Load Balancer
- GWLB 結合了 2 個功能:
    - Transparent Network Gateway
        - ex: 封包過濾防火牆
    - Load Balancer
        - 分流到 TG 內的 Targets
- Use **GENEVE** protocol on port 6081

```mermaid
flowchart TB

subgraph tg2["Target Group"]
    t1["3rd Party Security Virtual App - EC2"]
    t2["3rd Party Security Virtual App - IP Address"]
end

client -- 1. SG2 --> GLB;
GLB -- 2a --> tg2;
GLB -- 2b --> drop["丟棄封包"];
tg2 -- 3 --> GLB;
GLB -- 4 --> APP;
```

- 上圖的最後, APP 如何回給 Client, 應該是先給 GLB, 再給 client 才對...


# Target Group

- 裡頭可以是:
    - EC2
    - ECS Task
    - IP Address
    - Lambda
    - ALB


### With Cross Zone Load Balancing

```mermaid
flowchart LR

subgraph az1
    direction TB;
    ec0["instance 10"];
    ec1["instance 10"];
end
subgraph az2
    direction TB;
    ec2["instance 10 \n (總共 8 instances, 比例都是 10)"];

end

client -- 50 --> az1;
client -- 50 --> az2;
```


### Without Cross Zone Load Balancing

```mermaid
flowchart LR

subgraph az1
    direction TB;
    ec0["instance 25"];
    ec1["instance 25"];
end
subgraph az2
    direction TB;
    ec2["instance 6.25 \n (總共 8 instances, 比例都是 6.25)"];
end

client -- 50 --> az1;
client -- 50 --> az2;
```


# SSL/TLS for ELB

- client 與 LB 之間的 in-flight encryption
- Public Certificate Authorities, CA
    - Comodo, Symantec, GoDaddy, GlobalSign, Digicert, Letsencrypt, ...
- LB 使用 X.509 certificate (SSL/TLS server certificate)
    - 可使用 ACM, AWS Certificate Manager 來託管


# SNI, Server Name Indication

- 解決了 loading multiple SSL Certs onto one web server (也就是一台主機提供多個站點啦)
- 此為新一代的 protocol, 客戶需告知 hostname of the target server in the initial SSL handshake
    - AWS 僅 ALB && NLB && CloudFront 支援
- LB 上頭使用 SNI 的話, 可以對應不同 TG, 使用不同的 SSL
    - 相對來說, 一個 CLB 只能使用一個 SSL


# ELB - Connection Draining

- Service 即將進入維護狀態時, 對於殘餘 client 的處理機制
- 對於即將進行 maintenance 或 scale down 的 instance, 在此狀態下, 可避免立即下線 && 避免新流量進入此 instance
    - 可藉由 *draining connection parameter* 調整, 1~3600 secs. 
        - default: 300 secs
        - if set to 0 sec, 表示無 draining (直接斷線?)
- 有不同的稱呼
    - 使用 CLB, 稱之為 Connection Draining
    - 使用 ALB && NLB, 稱之為 Deregistration Delay
