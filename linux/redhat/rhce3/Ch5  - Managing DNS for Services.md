# Ch5  - Managing DNS for Services

1. DNS 概念
2. 名稱查詢
3. 註冊 domain


## 1. DNS 概念

- [`/rhce3/attach/lanDNS.xml`](https://www.draw.io/)
- [`/rhce3/attach/DNS.xml`](https://www.draw.io/)


## 2. 名稱查詢

### 2-1. Windows10

1. RAM Cache
2. `C:\Windows\System32\drivers\etc\hosts`
3. Network Connection DNS

### 2-2. CentOS7

1. RAM Cache
2. `/etc/nsswitch` : 檢查 `hosts:      files dns myhostname` 看誰先
    - files : `/etc/hosts`
    - dns   : Network Connection DNS
    - myhostname : (這我不清楚)


## 3. 註冊 domain

- [AWS Route53](https://console.aws.amazon.com/route53)
- [GoDaddy](https://tw.godaddy.com/)

