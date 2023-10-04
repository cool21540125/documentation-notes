### =================== 環境變數 ===================

### 使用不同的設定檔
export AWS_PROFILE=tonychoucc
# 需配置好 ~/.aws/config 及 ~/.aws/credentials


### 除了 AWS_PROFILE 以外, 可用 AWS_REGION 來動態切換 Region
export AWS_REGION=ap-northeast-1
# ex: Tokyo : ap-northeast-1
# ex: Osaka : ap-northeast-3


### 可用來查看目前下的 CLI 指令是用 哪個設定檔/環境變數/命令選項
aws configure list


### AWS ACCOUNT_ID
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

### (僅限 EC2 內使用), 取得 instance 所在 AWS_REGION
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')


### 底下這堆都還沒實驗過 (不確定就是了)
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION
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
