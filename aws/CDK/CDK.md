
# Cloud Development Kit, CDK

- 2022/06/24
- CDK v1 將於 2023/06 起不再維護, 因此建議改用 CDK v2
- [What is the AWS CDK?](https://docs.aws.amazon.com/cdk/v2/guide/home.html)
- 這東西用來 link Code && Infra
    - 給 Dev, 用各種 programming language 來定義 infra 的工具
- CDK 也有支援 :
    - [Terraform](https://developer.hashicorp.com/terraform/cdktf)
    - [K8s](https://cdk8s.io/)

```bash
### ====== Install ======
### 須先安裝 nodejs, 然後再裝 cdk
# (沒有找到 cdk 的 binary, 也沒找到像是 brew install 的方式, 所以就這樣吧)
$# npm install -g aws-cdk

$# cdk --version
2.65.0 (build 5862f7a)  # 2023/02

### 可用來取得 Account && UserId && Arn
$# aws sts get-caller-identity
# 可以看到 當時設定的 aws configure 是啥

### 每次使用 CDK 起始一個 CloudFormation, 都必須要做這個 init
$# AWS_ACCOUNT_ID=
$# REGION="ap-northeast-1"
$# cdk bootstrap aws://${AWS_ACCOUNT_ID}/${REGION}
# 會建立目前 CDK Project 專屬的 CloudFormation, 放在 S3 bucket
# 此外還會建立相關必要的 IAM
# Bucket Name, ex: cdk-hnb659fds-assets-668363134003-ap-northeast-1


### 初始化 CDK(特定語言) project
$# mkdir cdk-example && cd cdk-example
$# cdk init --language $PROGRAM_LANGUAG
# ex: 
#   cdk init app --language python
#   pip install -r requirements.txt 

### 之後就在此 cdk-example 專案目錄裡頭, 找到同名的 cdk-example Dir
# 進取裡面開始定義 Stack 了


### 產出 「cdk.out」Dir(整個 CDK 的重點就是要把這個 上傳到 S3 && deploy to stack)
$# cdk synth
# 其次, 列出 CloudFormation yaml (放棄閱讀.... 好幾百行=.=")


### 與 deployed stacks 或 local CloudFormation Template 做比較
$# cdk diff


### CloudFormation -> S3 && deploy Stack
$# cdk deploy


### 把 CDK stack 移除 (慎用!!)
$# cdk destroy
# 雖說把 CDK stack 移除(裡頭聲明的 Resources 確實刪除了)
# CloudFormation Console 要多等一下下~ (他會最後移除)
# (紀錄 CDK-CloudFormation的)S3 Bucket 不會被連動刪除 
# (其實還有一堆並不會被 cdk destroy 連動刪除的 Resources, 遇到再讀文件)
```
