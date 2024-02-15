
aws cdk


# install cdk

```bash

### ====== Install ======
### 須先安裝 nodejs, 然後再裝 cdk
# (沒有找到 cdk 的 binary, 也沒找到像是 brew install 的方式, 所以就這樣吧)
npm install -g aws-cdk


cdk version
#2.108.1 (build 2320255
```


# cli check

```bash
### 可用來取得 Account && UserId && Arn
aws sts get-caller-identity
# 可以看到 當時設定的 aws configure 是啥


### 檢查 CDK 相關環境變數
cdk doctor
# - AWS_PROFILE = q1
# - AWS_STS_REGIONAL_ENDPOINTS = regional
# - AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
# - AWS_SDK_LOAD_CONFIG = 1


### 
```


# cdk init / cdk bootstrap

```bash
### cdk 於每個 Account/Region 必要做的動作
cdk bootstrap
# 建立底下的東西:
# - CloudFormation Stack
# - S3 Bucket(ex)
# - IAM

### cdk 於每個 Account/Region 必要做的動作 (預設使用 AdministratorAccess Policy)
cdk bootstrap --cloudformation-execution-policies XXX
# 如果使用 cdk pipeline 時, 首次可使用此 AdministratorAccess 來做, 而後續變動通通由 CodePipeline 來執行
# 因此這邊要考量一下如何配置適當的權限


npx cdk bootstrap aws://ACCOUNT-NUMBER/REGION --profile ADMIN-PROFILE \
    --cloudformation-execution-policies arn:aws:iam::aws:policy/AdministratorAccess


### 初始化 CDK(特定語言) project
mkdir cdk-example && cd cdk-example
cdk init sample_app --language python
# ex: 
#   cdk init sample_app --language python
#   pip install -r requirements.txt 
# 之後就在此 cdk-example 專案目錄裡頭, 找到同名的 cdk-example Dir
# 進取裡面開始定義 Stack 了


### 
```


# cdk operation


```bash
### 生成 CloudFormation Template
cdk synth
cdk synth -q  # (不確定) 應該是省略掉 「印出 CFN Temaplate」 的動作吧!?
# 會針對整個 Cdk App 巡覽所有 Constructs, 生成 CloudFormation 所需的 uid
# (整個 CDK 的重點就是要把這個 上傳到 S3 && deploy to stack)


### 與 deployed stacks 或 local CloudFormation Template 做比較
cdk diff
cdk diff -a  # (不確定)


### CloudFormation -> S3 && deploy Stack
cdk deploy
cdk deploy -a  # (不確定)


### 把 CDK stack 移除 (慎用!!)
cdk destroy
# 雖說把 CDK stack 移除(裡頭聲明的 Resources 確實刪除了)
# CloudFormation Console 要多等一下下~ (他會最後移除)
# (紀錄 CDK-CloudFormation的)S3 Bucket 不會被連動刪除 
# (其實還有一堆並不會被 cdk destroy 連動刪除的 Resources, 遇到再讀文件)


### 
```
