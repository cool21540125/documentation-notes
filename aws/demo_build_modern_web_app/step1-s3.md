
- 2020/10/30
- [單元 1：建置靜態網站](https://aws.amazon.com/tw/getting-started/hands-on/build-modern-app-fargate-lambda-dynamodb-python/module-one/)


```bash
### 建立 s3 bucket
aws s3 mb s3://webapptonychoucc202010
#make_bucket: webapptonychoucc202010

# 設定 bucket, 讓他用於靜態網站託管
aws s3 website s3://webapptonychoucc202010 --index-document index.html

# 把此 xxx.json 的 s3 政策, 套用到 --bucket zzzz 的 bucket(也就是上一步弄得 靜態網站) 之中
aws s3api put-bucket-policy --bucket webapptonychoucc202010 --policy file://~/environment/aws-modern-application-workshop/module-1/aws-cli/website-bucket-policy.json

# 把網站內容發布到 s3
aws s3 cp ~/environment/aws-modern-application-workshop/module-1/web/index.html s3://webapptonychoucc202010/index.html
#upload: module-1/web/index.html to s3://webapptonychoucc202010/index.html

# http://webapptonychoucc202010.s3-website-ap-northeast-1.amazonaws.com
# DONE
```