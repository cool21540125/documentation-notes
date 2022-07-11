

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
        - user 會去訪問他能訪問到最小 TTL 的 AWS Region
        - 會與 Health Check 搭配
    - Geolocation
        - 依照 user 所在 *實際地理位置* 來做 routing
        - 需要給一個 Default
    - [Geoproximity](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html)
        - 有點類似 Geolocation, 不過這方式可以針對 Resource 設定一個 bias
        - 除了用戶依照地理位置就進訪問 Resource 以外, 還會把這個 bias 納入訪問位置的考量
            - 可設定 [1 to 99] 來增加流量, [-1 to -99] 減少流量
        - 使用了 *Route53 Traffic Flow* feature
        - Traffic Flow Policy
    - Multi-Value Answer
        - 有點類似於 Simple, 不過這個有 Health Check
            - client dig 出來的結果, 看起來與 Simple 長一樣, 但如果某個後端節點 unhealthy, 則不會顯示也不會被用到
        - Client Routing
- 各種名詞解釋
    - Domain Registar : 註冊(買) 域名的地方..., ex: *NameCheap*, *Route53*, *Godaddy*, ...
    - DNS Service     : 


# Health Check

- 假如 APP 本身 cross region, 為了 HA, Route53 可以設定 Health Check
- Health Check, 為了達成 Automated DNS Failover
    - Health checks that monitor an endpoint
        - 世界各地 15 個 Health Checker 會對 endpoint 做 check
            - 因此, 被監控的 Resource, 需要允許 Health Checker's IP Range 做訪問
        - 18% 以上說 health, 即被視為正常
        - 若為 text response, 由 check response 前 5120 bytes 來判斷 pass/fail
    - Health checks that monitor other health checks (calculated health check)
        - 可對 *Parent Health Check* 設定最多 256 個 *Child Health Check*
        - 讓 *Child Health Check* 針對單一 Resource 做監控
        - *Parent Health Check* 再設定針對 *Child Health Check* 的監控結果定義如何叫做 health
    - Health checks that monitor **CloudWatch Alarms**
        - 可做 private
            - 搭配 **CloudWatch Metric**, 然後安排 **CloudWatch Alarms** 在它上頭
        - more control && helpful for private resources

```mermaid
flowchart LR;

subgraph private VPC
    cc["CloudWatch Alarms"] -- monitor --> rr["Resource"]
end
hc["Health Checker"] -- monitor --> cc;
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
