#!/bin/env bash
exit 0
# cdk 的 context 來源
# 1. 由 AWS account
# 2. 藉由 cdk --context
# 3. 藉由 cdk.context.json
# 4. 藉由 cdk.json
# 5. 藉由 ~/.cdk.json
# 6. 藉由 CDK app 的 construct.node.setContext()
# -------------------------------------------------------------------------------------

# ======================== Install cdk ========================

# 須先安裝 nodejs, 然後再裝 cdk
# (沒有找到 cdk 的 binary, 也沒找到像是 brew install 的方式, 所以就這樣吧)
npm install -g aws-cdk
cdk version
#2.126.0 (build fb74c41)

# ======================== aws identity ========================

### 可用來取得 Account && UserId && Arn - GetCallerIdentity Api
aws sts get-caller-identity

### 檢查 CDK 相關環境變數
cdk doctor
# - AWS_PROFILE = q1
# - AWS_STS_REGIONAL_ENDPOINTS = regional
# - AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
# - AWS_SDK_LOAD_CONFIG = 1

# ======================== init && bootstrap ========================

### cdk 於每個 Account/Region 必要做的動作
cdk bootstrap
# 建立底下的東西:
# - CloudFormation Stack
# - S3 Bucket(ex)
# - IAM

### cdk 於每個 Account/Region 必要做的動作 (預設使用 AdministratorAccess Policy)
cdk bootstrap --cloudformation-execution-policies $PolicyArn
# 如果使用 cdk pipeline 時, 首次可使用此 AdministratorAccess 來做, 而後續變動通通由 CodePipeline 來執行
# 因此這邊要考量一下如何配置適當的權限

### 完整的 bootstrap 範例
cdk bootstrap aws://$ACCOUNT_NUMBER/$REGION \
    --profile $ADMIN_PROFILE \
    --cloudformation-execution-policies arn:aws:iam::aws:policy/AdministratorAccess

### 初始化 CDK(特定語言) project
cdk init NewCdkProject --language python

# ======================== Context ========================
cdk context    # 列出目前 cdk project 的 context
cdk context -j # json 呈現

# ======================== Usage ========================
### 初始化專案
cdk init app --language typescript

### 生成 CloudFormation Template
cdk synth -q # 不要 print 出來
cdk synth $StackName

### 與 deployed stacks 或 local CloudFormation Template 做比較
cdk diff

### CloudFormation -> S3 && deploy Stack
cdk deploy
cdk deploy -a
# -a (不確定)

### 把 CDK stack 移除 (慎用!!)
cdk destroy
cdk destroy StackName
