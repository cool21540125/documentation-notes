
# CloudFormation

- [What is AWS Cloudformation? Pros and Cons?](https://www.youtube.com/watch?v=0Sh9OySCyb4)
- IaC
- User 定義 Template, 並藉由 Tempalte 建立 Stack
    - AWS 則在背後 提供 Resources
    - template ext: `.json`, `.yaml`, `.template`, `.txt`
- 如果要變更 Infra, 一定最好是藉由 **CloudFormation Change Set** 來查看變更, ex:
    - 如果對 DB 更名, CloudFormation 會砍舊建新, 因此 **update stack** 必須小心
- [CloudFormation 的所有 Resources & Property types 名稱參照](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
- CloudFormation - StackSets
    - Trusted Account 可 cross Account && cross Region 同時做 增刪改 Resources


# [CloudFormation 格式大綱](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)

- [AWS resource and property types reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
- Resource property types 若為 AWS Resources, 則長的像這樣: 
    - `service-provider::service-name::data-type-name`


```yaml
---
AWSTemplateFormatVersion: "version date"

Description:
String

Metadata:
template metadata

Parameters:  (可在 Resources & Outputs 區塊參照使用, 並在 runtime 提供, 例如 敏感資訊)
set of parameters

Rules:
set of rules

Mappings:
set of mappings
# conditional value(用來定義條件宣告) 可在 Resources & Outputs 使用 `Fn::FindInMap` 來做配對

Conditions:
set of conditions

Transform:
set of transforms

# Required (只有這個是 Needed, 其他都是 Optional)
Resources:
set of resources

Outputs:
set of outputs
# 可使用此指令得到結果: aws cloudformation describe-stacks
```


# CLI

```bash
### 刪除 CloudFormation Stack
$# CloudFormationName=
$# Region="ap-northeast-1"
$# aws cloudformation delete-stack \
    --stack-name ${CloudFormationName} \
    --region ${Region}


### 上傳 CloudFormation Template -> S3
$# Bucket_To_Upload=
$# SAM_Template_YAML=
$# aws cloudformation package \
    --s3-bucket "${Bucket_To_Upload}" \
    --template-file "${SAM_Template_YAML}" \
    --output-template-file "template-out.yaml"
# 這指令的第一行, 等同於「sam package」


### 拿 SAM 產出的 CF YAML, 部署到 CloudFormation
$# aws cloudformation deploy \
    --template-file "template-out.yaml" \
    --stack-name "cf-0213" \
    --capabilities CAPABILITY_IAM
# (依舊不曉得哪時候需要給 capability)
# 會依照 CloudFormation Template 建立相關的 AWS Resources && 它的 "AWS::IAM::Role"


### 
$# 
```
