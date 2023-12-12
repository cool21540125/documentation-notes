
# Install awscli

- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# CLI/SDK - credentials chain (權限順序)

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


# [Signing AWS API requests](https://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html)

> When you send API requests to AWS, you sign the requests so that AWS can identify who sent them. You sign requests with your AWS access key, which consists of an access key ID and secret access key.

- 目前為 SigV4(簽章版本4) (2022/07)
- Signing AWS API requests
- 此為 AWS 專屬的 protocol
- SigV4 是指, 用自己的 credentials 來 sign request to AWS
    - 而非 you are authenticated against AWS


# Troubleshooting

```bash
aws ec2 run-instances \
    --image-id ami-0b7546e839d7ace12 \
    --instance-type t2.micro \
    --key-name ${KEY} \
    --dry-run

#An error occurred (UnauthorizedOperation) when calling the RunInstances operation: You are not authorized to perform this operation. Encoded authorization failure message: tKnNGESxqhaikWXnwV11a6NDB2d72QvQ89I6_gQlR3P8_rE-oSn7N5-psnOBPcidJ_aJyy0St-7iykDTk-R8_W-ACflXUnZQjx4qbG82n2IO7yXXB1BgFa3gG_JVEhDE4F8h0xkEY7OinR_CFp0PK1oBHKf3Tbrtni1xHJy15W1DI90-rizc9APkGBrpTy3R2USZbPWkMkxLLiFarrp0TKTQKOKMsGh7jpKMmtAWQ2BmpE9kg6wSuU-Y-lBKC1hPT3VwzTwq7q7Bz0D7IWn7oHnvCzBC2P1SUSfvEIZTIJSBCH1ZdV3qtDTCZswdWQU8MVjHf-WbTqsuLABizyQcoJndw4sChX6So0Ym1RJ59VTuX_uYfOkUpgV0cTYyGYyc3KSytuB-iN-bJatiBaiTZp2QvnIaGW5T2CV6QvyEZKzGS8G3YsmFMuM4Rq7hOYWkca5NHnKc1LPRX13gV0jSj914KA9jEqcWfoZO59L0q7hGTxZNHno0LysQna1XbQjyD_oTlyuwt2yiCROTP16TZt8XnU11gCthHSe6vEVby19eAT7FDA04AgTqQziMc4mh_AlEnDl8gZlSTN16ZSarykdW83bEJTHbTzRX1WqObDn7AEIcFmJvTQkKnSsDMgXEXgo18eeTSm5OBb2S6riF75RHbBPYK_Z704-B5A


### 解析 aws Encoded Error Message
# (EncodedErrorMessage 就是前面一個指令拋出的 Exception : Encoded authorization failure message 後面那包)
aws sts decode-authorization-message --encoded-message ${EncodedErrorMessage}
#An error occurred (AccessDenied) when calling the DecodeAuthorizationMessage operation: User: arn:aws:iam::152248006875:user/tonytest is not authorized to perform: sts:DecodeAuthorizationMessage because no identity-based policy allows the sts:DecodeAuthorizationMessage action
# 如果再看到這錯誤, 需要 allow sts DecodeAuthorizationMessage 的權限
```


# 其他

如果覺得 `aws xxx` 指令列出結果都是 less 輸出很煩, 可在 `~/.aws/config` 的 profile 配置: `cli_pager=`


# 未整理

```bash
### =================== 環境變數 ===================

### 使用不同的設定檔
export AWS_PROFILE=tonychoucc
# 需配置好 ~/.aws/config 及 ~/.aws/credentials


### 除了 AWS_PROFILE 以外, 可用 AWS_REGION 來動態切換 Region
export AWS_REGION=ap-northeast-1
# ex: Tokyo : ap-northeast-1
# ex: Osaka : ap-northeast-3

### 變數優先級優先於 CLI 的 --region 及 SDK 的 AWS_REGION
export AWS_DEFAULT_REGION=ap-northeast-1


### 變數優先級優先於 profile 裡頭的 aws_access_key_id
export AWS_ACCESS_KEY_ID=







### 可用來查看目前下的 CLI 指令是用 哪個設定檔/環境變數/命令選項
aws configure list


### AWS ACCOUNT_ID
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

### (僅限 EC2 內使用), 取得 instance 所在 AWS_REGION
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')


### 底下這堆都還沒實驗過 (不確定就是了)
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_OUTTPUT
export AWS_MAX_ATTEMPTS
export AWS_RETRY_MODE


# =================== 首次配置 ===================
### REPL 僅配置預設
export AWS_PROFILE=default

aws configure
aws configure --profile ${AWS_PROFILE}
# (aws CLI 會自行讀取 AWS_PROFILE, 因此 `--profile AWS_PROFILE` 可省略)


### aws configure 設定/取得 特定 Profile 的設定
aws configure set default.region ${AWS_REGION}
aws configure get default.region


### show users
aws iam list-users


### =================== CLI/SDK 使用 MFA 的配置 ===================
### 簽發 temperory TOKEN
export MFA_ARN=
aws sts get-session-token \
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
aws configure --profile ${Temp_Profile_Name}


### 可用來查詢 目前正在下 aws xxx 指令的 User 是誰 (查看自己啦)
aws sts get-caller-identity


###
```
