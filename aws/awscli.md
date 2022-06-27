

## Install awscli

需先確保電腦上能使用 `unzip` 這個指令工具

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

↑ 直接安裝最新穩定版的 awscli


## Configure

```bash
aws configure
# 透過互動式的詢問, 依序為
# 1. AWS Access Key ID
# 2. AWS Secret Access Key
# 3. Default region name [None]
# 4. Default output format
# 會把配置寫到 ~/.aws/config && ~/.aws/credentials
# Region 可參考 https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html

### 也可動態切換 Region
export AWS_REGION=ap-northeast-3

# 將來就可透過底下這樣子, 來切換 cli 環境
export AWS_PROFILE=$PROFILE_NAME
```


# Cloud Development Kit, CDK

- 2022/06/24
- [Module 2: Install the AWS Cloud Development Kit (CDK)](https://aws.amazon.com/getting-started/guides/setup-cdk/module-two/)
- 這東西用來 link Code && Infra
    - 給 Dev, 用各種 programming language 來定義 infra 的工具

```bash
### ====== Install ======
### 須先安裝 nodejs
npm install -g aws-cdk

cdk --version
# 2.29.0 (build 47d7ec4

### 可用來取得 Account ID
aws sts get-caller-identity

### ====== Init ======
cdk bootstrap aws://${ACCOUNT_NUMBER}/${REGION}

### 初始化 CDK(特定語言) project
cdk init --language $PROGRAM_LANGUAGE
# ex: PROGRAM_LANGUAGE=typescript
```
