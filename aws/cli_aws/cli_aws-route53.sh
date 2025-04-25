#!/usr/bin/env bash
exit 0
# ------------------------------------

# ======================================== 把 domain 由 aws 帳戶 移轉到另一個帳戶 ========================================

### 1. 想要轉出的 AWS_ACCOUNT 執行
aws route53 list-hosted-zones
#HostedZones:
#- CallerReference: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#  Config:
#    Comment: ''
#    PrivateZone: false
#  Id: /hostedzone/xxxxxxxxxxxxxxxxxxxxx
#  Name: tonychoucc.com.
#  ResourceRecordSetCount: xx
# profile 為 ~/.aws/credentials 裡面的其中一個帳戶 [profile] <- 這個

### 2. 列出所有託管的子域名
aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID

### 3. Route53 移轉到其他 AWS 帳戶
YOUR_DOMAIN=tonychoucc.com
TARGET_ACCOUNT_ID=
aws route53domains transfer-domain-to-another-aws-account --domain-name ${YOUR_DOMAIN} --account-id ${TARGET_ACCOUNT_ID}

# ======================================== 把 domain 轉到 Cloudflare ========================================

### ======================================== 設定解析 ========================================

aws route53 list-hosted-zones

### 查看目前的 ZONE 有哪些 Records
aws route53 list-resource-record-sets --hosted-zone-id $ZONE_ID

###
