# R53 - aws cli

- [AwsCli_Configure](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-configure-files.html)
- [Route53移轉](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53domains/transfer-domain-to-another-aws-account.html)
- [Migrating a hosted zone to a different AWS account](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html#hosted-zones-migrating-install-cli)
- 2020/10/09


把 domain 由 aws 帳戶 移轉到另一個帳戶

```bash
profile=r53
aws route53 list-hosted-zones --profile ${profile}
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


$# aws route53 list-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --profile ${profile}
# 列出所有托轉的子域名

### Route53 移轉到其他帳戶
aws route53domains transfer-domain-to-another-aws-account --domain-name ${HOSTED_DOMAIN_NAME} --account-id ${OLD_AWS_ACCOUNT_ID} --profile ${profile}
# 幹@@ 上個禮拜已經重新續約一年了, 所以現在移轉需要再次付費, 不爽轉了.
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