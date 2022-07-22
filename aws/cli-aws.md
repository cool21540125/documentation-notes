

## Install awscli

需先確保電腦上能使用 `unzip` 這個指令工具

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

↑ 直接安裝最新穩定版的 awscli

- 第一版, 稱之為 `awscli`
- 第二版, 稱之為 `aws`, 但為了方便辨識, 這邊都會以 awscli 來做稱呼


## Configure awscli

```bash
### -------------- Configure --------------
### 法1. 僅配置預設
$# aws configure

### 法2. 配置多個命名環境
$# export AWS_PROFILE=
$# aws configure --profile ${AWS_PROFILE}
# 切換 cli 環境 (~/.aws/config 裡頭定義好的那些)


### 如果有多 IAM User, 可用這樣來動態切換 IAM Users (~/.aws/config && ~/.aws/credential 底下以配置的用戶)
$# export AWS_PROFILE=XXX

### 動態切換 Region/AZ
$# export AWS_REGION=ap-northeast-1
# ap-northeast-1 : Tokyo
# ap-northeast-3 : Osaka

### Simple Usage
$# aws iam list-users
```


## Tools

### Install stress

壓測工具

```bash
### Install
$# sudo amazon-linux-extras install epel -y
$# sudo yum install stress -y

### Usage
$# stress -c 4
# 讓 4 個 CPU 飆到 100%
```
