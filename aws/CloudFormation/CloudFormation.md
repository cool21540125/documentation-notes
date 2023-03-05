
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
- 避免 CloudFormation 被意外刪除, 可使用 **termination protection**
- 如果想對 CloudFormaion 裡頭的 Resources 做個別限制, ex:
    - 禁止在此 CloudFormation stack 裡頭新增xxx, 修改 EC2, 針對 RDS 做 xxx
    - 可參考 Prevent Update to Stack Resources 或是 **Stack Policy**
    - Stack Policy 可以聲明(json format) 像是 Resource-Based Policy 來對資源操作做限制
- 刪除 CloudFormation 時, 其相關 Resources 的 DeletionPolicy
    - Retain
    - Snapshot
        - 底下 2 種情況的預設行為:
            - `AWS::RDS::DBCluster`
            - 未在裡頭聲明 DBClusterIdentifier 的 `AWS::RDS::DBInstance`
    - Delete
        - 除了上述兩者以外, 預設都是 Delete
- 如果 Resources 都是透過 CloudFormation, 但偏偏有人直接去改 Resources(不透過 CloudFormation), 則可參考 *Stack actions > Detect drift*
    - drift 這機制可以用來看, actual Resources 與 desired Resources(from CloudFormation) 差了些什麼
    - 很強大的地方是, 可透過這種方式來 *view drift*, 藉此獲得 CloudFormation template
        - 先簡單寫 CloudFormation, create 以後, 手動改, 在用 drift 取得現階段的 template


# CloudFormation 可能比叫少用到的細節

- 如果要針對 Cross Region 甚至是 Cross Account 使用 CloudFormation, 可參考 [StackSet](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)
- CloudFormation 聲明 ASG(`AWS::AutoScaling::AutoScalingGroup`) 的議題
    - ASG 內部的 EC2 User Data 更新時 -> update Template, 並不會讓 ASG 去替 EC2 做更新
    - 此時需要借助 UpdatePolicy Attribute, 有底下 3 種方式
        - AutoScalingReplacingUpdate
            - immutable
            - 會建立新的 ASG, 由此 ASG 建立其相關的 EC2 Instances
            - 完成後, delete old ASG 及其相關的 EC2 Instances
        - AutoScalingRollingUpdate
            - 在原有 ASG 裡頭, 藉由 min 及 max, 滾動更新其相關的 EC2 Instances
        - AutoScalingScheduleAction


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


### 驗證本地撰寫的 CloudFormation Template
$# LOCAL_CloudFormation_YAML="example.yaml"
$# aws cloudformation validate-template --template-body file://${LOCAL_CloudFormation_YAML}


### 使用外部 parameter file 的指令範例
$# aws cloudformation create-stack \
    --stack-name EXAMPLE_STACK \
    --template-body file://template.yaml \
    --parameters file://parameters.json
# 好像似乎只能用 json file
[
    {
      "ParameterKey": "Parameters.KeyName",
      "ParameterValue": "value"
    }, ...
]
# 檔案裡面大概長這樣~


### 
$# 
```
