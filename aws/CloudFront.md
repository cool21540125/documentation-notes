
CloudFront, CDN

- 有超過 200+ 個 Edge Locations
    - file cached for TTL
- 結合了 DDoS protection && Shield, Web Application Firewall
- Origins
    - S3 
        - Enhanced security with CloudFront Origin Access Identity, OAI
            - 讓 S3 只能由 CloudFront 來訪問
            - OAI 是用來給 CloudFront 的 IAM Role
            - 如果使用 CloudFront 而不使用 OAI 的話, 那 S3 bucket 必須設成 public access 才可以
        - CloudFront 可作為 S3 upload file 的 ingress
    - Custom Origin(HTTP)
        - ALB && EC2 instance
            - 必須要是 public && SG 要允許 AWS CloudFront IPs 來訪問
                - https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips
        - S3 Website
        - any HTTP backend
- CDN 也可設定 黑白名單 來做訪問許可
    - country 則使用 3rd Geo-IP database
- paid shared content(付費共享內容)
    - 藉由 **CloudFront Signed URL / Signed Cookies**
        - Signed URL = access to individual files (one signed URL per file)
        - Signed Cookies = access to multiple files (one signed cookies for many files)
    - 可設定 URL 在特定時間後到期 OR 設定哪些 IP 可以訪問 等等 (for premium user)
    - 這個和 [S3 Pre-Signed URL](./S3.md#s3-pre-signed-urls) 很容易搞混
        - 可用來 filter by IP, path, date, expiration
            - 相較於 S3 Pre-Signed URL, 只能用來限定特定 URL 有效期限
    - ```mermaid
        flowchart TB

        cdn["CloudFront \n Edge location"];

        Client -- "1.認證授權" --> App;
        App -- "2.SDK gen Signed URL/cookie" --> cdn;
        cdn <-- "3.OAI" --> S3;
        cdn -- "4.取得 Signed URL/cookie" --> App;
        Client -- "5.訪問 Signed URL/cookie 爽看片" --> cdn;
      ```
- Charge 收費方式
    - CloudFront 收費依照 流出流量 計費, 每個 Region 計費都不同
    - 此外也可有 3 種(不知道將來會不會變) Price Classes
        - Price Class All - 所有 Regions 都做 CDN
        - Price Class 200 - 排除掉最貴的 Region
        - Price Class 100 - 只對最便宜的 Region 啟用
    - [Cloudfront](https://aws.amazon.com/cloudfront/pricing/?nc1=h_ls) 詳細計費說明
- CloudFront - Multiple Origin
    - CloudFront 可配置 *Cache Behaviors*, 來針對不同的 URL location, 配置不同的 Origin
        - ex: `/api/*` 丟到 ALB ; 其餘 `/*` 丟到 S3
- CloufFront - Origin Groups
    - 用來因應 HA && failover
    - 1 Primary && 1 Secondary origin (稱之為一組 Origin Group)
    - CloudFront 後面可以有 active-standby 的後端 Resource
    - S3 + CloudFront - Regional HA
        - ```mermaid
            flowchart LR

            subgraph Origin Group
                a["S3 Origin A"]
                b["S3 Origin A"]
            end

            Client --> Cloudfront;
            Cloudfront -- active --> a;
            Cloudfront -- standby --> b;
            a -- "Cross Region Replication" --> b;
        ```
- CloudFront - Field Level Encryption
    - Client -> Edge -> CloudFront -> ALB -> WebServer
    - 如果架構如上, 全部使用 https, *Field Level Encryption* 主要功能是, 能針對 Request 裡頭特定欄位
    - 使用 asymmetric encryption 來做加密, 而最後再由 WebServer decrypt, 避免無關的節點取得非必要機密資訊