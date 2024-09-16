#!/bin/bash
exit 0


### 建立 CodeDeploy Application
aws deploy create-application --application-name $APPLICATION


### 將 ./ 壓縮成 zip 上傳到 S3, 並且建立一個 CodeDeploy Revision
aws deploy push \
  --application-name $APPLICATION \
  --s3-location s3://$BUCKET/$ZIPFILE.zip \
  --ignore-hidden-files
# 撇除 hidden files


### 建立 CodeDeploy 的 Deployment Group
aws deploy create-deployment-group \
  --application-name $APPLICATION \
  --deployment-group-name $DEPLOYMENT_GROUP_NAME \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --ec2-tag-filters Key=$EC2_TAG_KEY,Value=$EC2_TAG_VALUE,Type=KEY_AND_VALUE \
  --service-role-arn $CODEDEPLOY_ROLE_ARN
# Deployment 類型為 EC2, 並且使用 Tag Key Value 的方式做關聯


### 為 EC2 安裝 CodeDeploy Agent, 並關聯到 SSM State Manager
aws ssm create-association \
  --name AWS-ConfigureAWSPackage \
  --targets Key=tag:$EC2_TAG_KEY,Values=$EC2_TAG_VALUE \
  --parameters action=Install,name=AWSCodeDeployAgent \
  --schedule-expression "cron(0 2 ? * SUN *)" 
# 並令此 EC2 將來 每周日 02:00 進行 update CodeDeploy Agent
# ------------------------------ 產出 ------------------------------
# AssociationDescription:
#   ApplyOnlyAtCronInterval: false
#   AssociationId: 968371b2-6f7f-4370-b1cc-91a768e32a09
#   AssociationVersion: '1'
#   Date: '2024-05-12T01:09:22.753000+08:00'
#   DocumentVersion: $DEFAULT
#   LastUpdateAssociationDate: '2024-05-12T01:09:22.753000+08:00'
#   Name: AWS-ConfigureAWSPackage
#   Overview:
#     DetailedStatus: Creating
#     Status: Pending
#   Parameters:
#     action:
#     - Install
#     name:
#     - AWSCodeDeployAgent
#   ScheduleExpression: cron(0 2 ? * SUN *)
#   Targets:
#   - Key: tag:Name
#     Values:
#     - CodeDeployDemo
# ------------------------------ 產出 ------------------------------


### 進行一次 CodeDeploy 的 deployment
aws deploy create-deployment \
  --application-name $APPLICATION \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name $DEPLOYMENT_GROUP_NAME \
  --s3-location bucket=$BUCKET,bundleType=zip,key=$S3_OBJECT_TO_DEPLOY.zip
#deploymentId: d-YLRE58LO5


### 
aws deploy create-deployment \
  --application-name WordPress_App \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name WordPress_DepGroup \
  --s3-location bucket=this-is-tonychoucc-2024-q1,bundleType=zip,key=WordPressApp.zip
# 背後會使用 SSM - RunCommand 來進行操作 (裡頭有 log 可看)