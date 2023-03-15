
# System Manager



# CLI

```bash
### 查詢特定規格 EC2 (ex: CentOS7.6) 在特定 Region 的 AMI 資訊
$# aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 


### 建立 custom SSM Parameter Store 
$# aws ssm put-parameter \
    --name "/golden-images/amazon-linux-2" \
    --value ami-02b9b693377a07477 \
    --type "String" \
    --region eu-west-2
Tier: Standard
Version: 1
# 建立 SSM > Parameter Store 裡頭的 My parameters, 名為 /golden-images/amazon-linux-2
# 


### 
$# 
```
