
- 2021/01/01

使用 acme.sh 來申請 wildcard domain cert

目前解析是透過 r53(AWS Route53) 來處理

```sh
### 此部分為半手動方式處理... 將來有那閒情逸致再來弄全自動
cat ~/.aws/credentials
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

./acme.sh --issue --dns dns_aws --ocsp-must-staple --keylength 4096 -d '*.tonychoucc.com'
# [五  1月  1 14:43:22 UTC 2021] Your cert is in  /home/ec2-user/.acme.sh/*.tonychoucc.com/*.tonychoucc.com.cer 
# [五  1月  1 14:43:22 UTC 2021] Your cert key is in  /home/ec2-user/.acme.sh/*.tonychoucc.com/*.tonychoucc.com.key 
# [五  1月  1 14:43:22 UTC 2021] The intermediate CA cert is in  /home/ec2-user/.acme.sh/*.tonychoucc.com/ca.cer 
# [五  1月  1 14:43:22 UTC 2021] And the full chain certs is there:  /home/ec2-user/.acme.sh/*.tonychoucc.com/fullchain.cer 

# 後續再把 fullchain.cer && key 安裝到 web server
```

```ini
### ~/.aws/credentials 大概長這樣, 需要到 aws 去申請 API key
[default]
aws_access_key_id = 
aws_secret_access_key = 

[r53]
aws_access_key_id = 
aws_secret_access_key = 
```