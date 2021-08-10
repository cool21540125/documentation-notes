

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
```