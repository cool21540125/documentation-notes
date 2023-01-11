

# Cloud Development Kit, CDK

- 2022/06/24
- [Module 2: Install the AWS Cloud Development Kit (CDK)](https://aws.amazon.com/getting-started/guides/setup-cdk/module-two/)
- 這東西用來 link Code && Infra
    - 給 Dev, 用各種 programming language 來定義 infra 的工具

```bash
### ====== Install ======
### 須先安裝 nodejs
$# npm install -g aws-cdk

$# cdk --version
# 2.29.0 (build 47d7ec4

### 可用來取得 Account && UserId && Arn
$# aws sts get-caller-identity
# 可以看到 當時設定的 aws configure 是啥

### ====== Init ======
$# cdk bootstrap aws://${ACCOUNT_NUMBER}/${REGION}

### 初始化 CDK(特定語言) project
$# cdk init --language $PROGRAM_LANGUAGE
# ex: PROGRAM_LANGUAGE=typescript
```
