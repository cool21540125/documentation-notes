

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
# 會把配置寫到 ~/.aws/config && ~/.aws/credentials


### 動態切換 Region
export AWS_REGION=ap-northeast-3
# ex: 大阪
# 參考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
```