
- [Using high-level (s3) commands with the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-objects-param)


# Install awscli

- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# CLI/SDK - credentials chain

權限順序

1. CLI 明確聲明為最優先. ex: `aws ec2 ... --region XXX`
2. 環境變數. ex: `AWS_PROFILE`
3. `~/.aws/credentials`
4. `~/.aws/config`
5. ECS task credentials
6. EC2 Instance Profiles

- 需要留意安全性的範例:
    - 已配置 Instance Profile (具備最小必要權限)
    - 但有使用環境變數, 取得另一個權限身份 (具備完整權限)
    - 因此依照順位, 使用 CLI/SDK 是具備完整權限
    - 需要特別留意


# aws CLI - Environment variables

```bash
### 使用不同的 profile 設定檔
export AWS_PROFILE=xxx


### AWS CLI v2 的相關環境變數
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY


### AWS_REGION 優先於 AWS_DEFAULT_REGION
export AWS_REGION
export AWS_DEFAULT_REGION


### 
export AWS_DEFAULT_OUTTPUT
export AWS_MAX_ATTEMPTS
export AWS_RETRY_MODE


### 


```


# Config aws CLI v2

```bash
# =================== 首次配置 ===================
### -------------- Configure --------------
### 法1. 僅配置預設
$# aws configure

### 法2. 配置多個命名環境
$# aws configure --profile ${AWS_PROFILE}
# 切換 cli 環境 (~/.aws/config 裡頭定義好的那些)
# 不過其實 AWS_PROFILE 為 aws CLI 吃得到的環境變數之一, 因此上面的指令可簡化成:
$# aws configure
# 原因可看 credentials chain


### 如果有多 IAM User, 可用這樣來動態切換 IAM Users (~/.aws/config && ~/.aws/credential 底下以配置的用戶)
$# export AWS_PROFILE=XXX

### 動態切換 Region/AZ
$# export AWS_REGION=ap-northeast-1
# ap-northeast-1 : Tokyo
# ap-northeast-3 : Osaka


### Simple Usage
$# aws iam list-users

# =================== CLI/SDK 使用 MFA 的配置 ===================
### 簽發 temperory TOKEN
$# MFA_ARN=
$# aws sts get-session-token \
    --serial-number ${MFA_ARN} \
    --duration-seconds 3600 \
    --token-code ${KEYIN_YOUR_2FA_CODE}
# MFA_ARN 來自 Web Console > IAM > Users > $USER > Security Credentials > Assigned MFA device
# 格式長這樣: 「arn:aws:iam::000000000000:mfa/$USER 」
# 可以得到:
#    AccessKeyId
#    SecretAccessKey
#    SessionToken  (此為 temperory TOKEN, 完成稍後 aws configure 以後, 需自行配置到 ~/.aws/credentials  增加一行, aws_session_token = XXXXXXXXXX)

### 配置 & 使用 temperory TOKEN
$# aws configure --profile ${Temp_Profile_Name}


### 可用來查詢 目前正在下 aws xxx 指令的 User 是誰 (查看自己啦)
$# aws sts get-caller-identity


### AWS CLI settings
aws configure set default.s3.max_concurrent_requests 100
# S3 concurrent 上傳(default: 10)


### 

```


## [Signing AWS API requests](https://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html)

> When you send API requests to AWS, you sign the requests so that AWS can identify who sent them. You sign requests with your AWS access key, which consists of an access key ID and secret access key.

- 目前為 SigV4(簽章版本4) (2022/07)
- Signing AWS API requests
- 此為 AWS 專屬的 protocol
- SigV4 是指, 用自己的 credentials 來 sign request to AWS
    - 而非 you are authenticated against AWS


# Troubleshooting

```bash
$# aws ec2 run-instances \
    --image-id ami-0b7546e839d7ace12 \
    --instance-type t2.micro \
    --key-name ${KEY} \
    --dry-run

An error occurred (UnauthorizedOperation) when calling the RunInstances operation: You are not authorized to perform this operation. Encoded authorization failure message: tKnNGESxqhaikWXnwV11a6NDB2d72QvQ89I6_gQlR3P8_rE-oSn7N5-psnOBPcidJ_aJyy0St-7iykDTk-R8_W-ACflXUnZQjx4qbG82n2IO7yXXB1BgFa3gG_JVEhDE4F8h0xkEY7OinR_CFp0PK1oBHKf3Tbrtni1xHJy15W1DI90-rizc9APkGBrpTy3R2USZbPWkMkxLLiFarrp0TKTQKOKMsGh7jpKMmtAWQ2BmpE9kg6wSuU-Y-lBKC1hPT3VwzTwq7q7Bz0D7IWn7oHnvCzBC2P1SUSfvEIZTIJSBCH1ZdV3qtDTCZswdWQU8MVjHf-WbTqsuLABizyQcoJndw4sChX6So0Ym1RJ59VTuX_uYfOkUpgV0cTYyGYyc3KSytuB-iN-bJatiBaiTZp2QvnIaGW5T2CV6QvyEZKzGS8G3YsmFMuM4Rq7hOYWkca5NHnKc1LPRX13gV0jSj914KA9jEqcWfoZO59L0q7hGTxZNHno0LysQna1XbQjyD_oTlyuwt2yiCROTP16TZt8XnU11gCthHSe6vEVby19eAT7FDA04AgTqQziMc4mh_AlEnDl8gZlSTN16ZSarykdW83bEJTHbTzRX1WqObDn7AEIcFmJvTQkKnSsDMgXEXgo18eeTSm5OBb2S6riF75RHbBPYK_Z704-B5A
# 需要使用

### 解析 aws Encoded Error Message
$# aws sts decode-authorization-message --encoded-message ${EncodedErrorMessage}

An error occurred (AccessDenied) when calling the DecodeAuthorizationMessage operation: User: arn:aws:iam::152248006875:user/tonytest is not authorized to perform: sts:DecodeAuthorizationMessage because no identity-based policy allows the sts:DecodeAuthorizationMessage action
# 如果再看到這錯誤, 需要 allow sts DecodeAuthorizationMessage 的權限


$# 
```


# Monitoring 相關

```bash
### 使用 CLI 方式來 trigger ALARM (測試用, 可用來觀察後續動作是否正常運作)
### https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
ALARM_REASON=testing
ALARM_NAME=XXX
aws cloudwatch set-alarm-state \
    --alarm-name ${ALARM_NAME} \
    --state-value ALARM \
    --state-reason ${ALARM_REASON}
# 
# OK / ALARM / INSUFFICIENT_DATA


### 
```
