

## Basic

- DNS Records : DNS 解析紀錄
    - Alias Record: 可選擇 alias (只能)指向到 AWS Resources ; 可使用 ROOT DOMAIN
        - 只能使用 A or AAAA
        - Record Target 可能是 ELB, CloudFront, S3 WebSite, Beanstalk, API Gateway, Global Accelerator, ...
    - CNAME Record: 不可使用 ROOT DOMAIN
- Zone File   : 包含所有的 DNS Records
- Cost: 12/year && 0.5/month
- Routing Policy
    - Simple
        - 無 Health Check
    - Weighted
    - Failure
        - 只能有 1 master && 1 secondary
    - Latency
        - 與 user 最近的 Region (依照 TTL 判斷)
    - Geolocation
        - 容易與 Latency 及 Geoproximity 搞混@@
        - 依照 user 所在 *實際地理位置(洲, 國家)* 來做 routing
            - 因此可用這方法來屏蔽特定國家
        - 需要給一個 Default
    - [Geoproximity](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html)
        - 有點類似 Geolocation, 不過這方式可以針對 Resource 設定一個 bias
        - 除了用戶依照地理位置就進訪問 Resource 以外, 可再用 bias 來做地理空間的微調
            - 可設定 [1 to 99] 來增加流量, [-1 to -99] 減少流量
        - 使用了 *Route53 Traffic Flow* feature
        - Traffic Flow Policy
        - 可依照 geographic 就近訪問
    - Multi-Value Answer
        - 把這個當成是有 Health Check 的 Simple routing policy 就是了~
            - client dig 出來的結果, 看起來與 Simple 長一樣
            - 但如果其後的節點為 unhealthy, 則 dig 出來以後看不到它
        - 可把這個視為 Client Routing
- 各種名詞解釋
    - Domain Registrar : 註冊(買) 域名的地方..., ex: *NameCheap*, *Route53*, *Godaddy*, ...
        - 基本上這些機構都會提供 DNS Service
    - Zone File : 註冊到的域名的所有相關的解析紀錄, 包含: SOA, NS, ...
    - Name Server : resolves DNS queries (Authoritative 或 Non-Authoritative)


## Traffic Policy

- Route53 的服務裡頭有個 Traffic Polies 可使用
- Charge: 非常貴! 一個 policy 50 美元 / month
- 可使用 visual 的方式, 並設定有點類似 pipeline 的方式, 來配置 routing 政策
    - 可用來做非常複雜的 routing decision tree (視覺化!)
- 具備 versioning
- cross domain name


# Health Check

- 假如 APP 本身 cross region, 為了 HA, Route53 可以設定 Health Check
- Health Check 基本上只能做 Public Resources 做檢測 (除了 CloudWatch Alarms)
- 全世界有 15 個 *Global Health Checkers*
    - Checkers' IP : https://ip-ranges.amazonaws.com/ip-ranges.json
- Health check (為了達成 Automated DNS Failover) 可以檢查底下幾個標的:
    - Endpoint
        - 如果 18% 以上的 *Global Health Checkers* 檢測為 Health 則視為 Health
        - 預設 30 sec 檢測一次, 如果頻率要提高需要課金
        - health check 除了用 Response Status Code 來判斷檢測結果(2xx 或 3xx)
        - 可自行設定從 response 前 5120 bytes 來判斷 pass/fail
            - 前提是這個 response 是 text
        - 被監控的 Resource, 需要允許 Health Checker's IP Range 做訪問
    - other health checks (calculated health check)
        - *Parent Health Check* 可對最多 256 個 *Child Health Check* 做 calculated check
            - *Child Health Check* 針對單一 Resource 做監控
        - 需自行定義怎樣的 calculated check 結果算正常 (要定義什麼才叫 parent pass 啦)
        - 最為實際的使用情境是, 檢測是否 所有的 Health Check 都掛了
    - [CloudWatch Alarms](./CloudWatch.md#cloudwatch-alarms)
        - 可以對 Private Resources 做檢測!!
            - 搭配 **CloudWatch Metric**, 然後安排 **CloudWatch Alarms** 在它上頭
        - more control && helpful for private resources
        - 示意圖大概長這樣:

            ```mermaid
            flowchart LR

            subgraph private VPC
                rr["Resource"]
                cc["CloudWatch Alarms \n (是否變成 Alarm State)"]
                cm["CloudWatch Metrics"] --- rr;
                cc -- monitor --> cm
            end
            hc["Health Checker"] -- "monitor \n (private resources)" --> cc;
            ```


# 域名帳戶移轉

- [AwsCli_Configure](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-configure-files.html)
- [Route53移轉](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53domains/transfer-domain-to-another-aws-account.html)
- [Migrating a hosted zone to a different AWS account](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html#hosted-zones-migrating-install-cli)
- 2020/10/09

把 domain 由 aws 帳戶 移轉到另一個帳戶

```bash
### 想要轉出的帳號執行
$# PROFILE_NAME=r53
$# aws route53 list-hosted-zones --profile ${PROFILE_NAME}
{
    "HostedZones": [
        {
            "Id": "/hostedzone/XXXXXXXXXXXX",
            "Name": "tonychoucc.com.",
            "CallerReference": "XXXXXXXXXXXX-XX:XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
            "Config": {
                "Comment": "HostedZone created by Route53 Registrar",
                "PrivateZone": false
            },
            "ResourceRecordSetCount": 22
        }
    ]
}
# profile 為 ~/.aws/credentials 裡面的其中一個帳戶 [profile] <- 這個

### 列出所有託管的子域名
$# aws route53 list-resource-record-sets \
    --hosted-zone-id ${HOSTED_ZONE_ID} \
    --profile ${PROFILE_NAME}

### Route53 移轉到其他帳戶
$# aws route53domains transfer-domain-to-another-aws-account \
    --domain-name ${HOSTED_DOMAIN_NAME} \
    --account-id ${TARGET_AWS_ACCOUNT_ID} \
    --profile ${PROFILE_NAME}
```


# note

2020/11/24 已改用 cloudflare 做為 NS, 原始 NS 如下

```
tonychoucc.com. NS 
ns-670.awsdns-19.net.
ns-474.awsdns-59.com.
ns-1669.awsdns-16.co.uk.
ns-1080.awsdns-07.org.
```

cloudflare

```
adrian.ns.cloudflare.com.
coby.ns.cloudflare.com.
```
