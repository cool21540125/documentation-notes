#!/bin/bash
exit 0
# -------------------------------------------------------------------------------------

### ======================================== CloudFormation CLI - 基礎使用 ========================================

API_URL=$(aws cloudformation describe-stacks --stack-name ${CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldApi`].OutputValue' --output text)
LAMBDA_ARN=$(aws cloudformation describe-stacks --stack-name ${CFN_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldFunction`].OutputValue' --output text)
echo API_URL=$API_URL
echo LAMBDA_ARN=$LAMBDA_ARN

### LIST CloudFormation Stacks (without Deleted)
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE ROLLBACK_COMPLETE
# 如果不加上 filter, 則會列出包含已刪除的 Stacks

### GET CloudFormation Stack
aws cloudformation describe-stacks --stack-name CloudFormationStackName

### 使用外部 parameter file 的指令範例
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/create-stack.html
aws cloudformation create-stack \
  --stack-name ${EXAMPLE_STACK} \
  --template-body file://template.yaml \
  --parameters file://parameters.json
# 好像似乎只能用 json file
# [
#     {
#       "ParameterKey": "Parameters.KeyName",
#       "ParameterValue": "value"
#     }, ...
# ]
# 檔案裡面大概長這樣~

### 上傳 CloudFormation Template -> S3
aws cloudformation package \
  --s3-bucket ${Bucket_To_Upload} \
  --template-file ${SAM_Template_YAML} \
  --output-template-file "template-out.yaml"
# 這指令的第一行, 等同於「sam package」

### 拿 SAM 產出的 CF YAML, 部署到 CloudFormation
aws cloudformation deploy \
  --template-file "template-out.yaml" \
  --stack-name "cf-0213" \
  --capabilities CAPABILITY_IAM
# 如果 CloudFormation 裡頭會動到 IAM, 則需要給 --capabilities CAPABILITY_IAM
# 會依照 CloudFormation Template 建立相關的 AWS Resources && 它的 "AWS::IAM::Role"

### 驗證本地撰寫的 CloudFormation Template
aws cloudformation validate-template \
  --template-body file://${LOCAL_CloudFormation_YAML}

### 刪除 CloudFormation Stack
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/delete-stack.html
aws cloudformation delete-stack \
  --stack-name ${CloudFormation_Stack_Name}

### ======================================== CloudFormation 其他工具 ========================================

### ========== 驗證 CloudFormation template ==========
pip install cfn-lint
cfn-lint xxx.yaml

### ========== 用來測試 CloudFormation Templates Cross Region 的問題 (沒用過) ==========
# https://github.com/aws-ia/taskcat
pip install taskcat
taskcat --version

### ========== 可用來做 CloudFormation template 的 json <-> yaml ==========
pip install cfn-flip
cfn-flip Source.json Target.yaml

### ========== 可用來在 CloudFormation 開 EC2 時, 替代 UserData (改用陳述式) 的指令工具 (沒用過) ==========
# cfn-init
# 來讓 EC2 去向 CloudFormation query 初始化 EC2 的結果

### ========== 用來在 CloudFormation 開 EC2 時, cfn-init 以後, 向 CloudFormation 發送 signal (來表示完成的 CLI) (沒用過) ==========
# cfn-signal
# 需要搭配 CloudFormation 的 WaitCondition Resource. 來讓 CloudFormation 等候該 Resource 建立完成後, 再繼續後續動作(block template)

### ========== (忘了是啥了) (沒用過) ==========
# https://catalog.workshops.aws/cfn101/en-US/basics/operations/helper-scripts
# cfn-hup

### ========== CloudFormation Template 生成圖表 ==========
# https://github.com/ljacobsson/cfn-diagram
npm i -g @mhlabs/cfn-diagram
cfn-dia html
