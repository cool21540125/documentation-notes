#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/index.html
# --------------------------------------------------------------------------------------------------------

ECS_CLUSTER=
ECS_TASK_ID=
ECS_CONTAINER=

### 遠端登入到 ECS Task
# ECS Task Container 需有 Public IP
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/execute-command.html
# 進入 ECS Container 的前提是, 需要有 enableExecuteCommand
aws ecs execute-command \
  --cluster $ECS_CLUSTER \
  --task $ECS_TASK_ID \
  --container $ECS_CONTAINER \
  --interactive --command "/bin/sh"

### 查詢 ECS Task Public IP
ECS_SERVICE=
#
TASK_ARN=$(aws ecs list-tasks --cluster $ECS_CLUSTER --service-name $ECS_SERVICE --query 'taskArns[0]' --output text)
TASK_DETAILS=$(aws ecs describe-tasks --cluster $ECS_CLUSTER --task "${TASK_ARN}" --query 'tasks[0].attachments[0].details' --output json)
ENI=$(echo $TASK_DETAILS | jq -r '.[] | select(.name=="networkInterfaceId").value')
PUBLICIP=$(aws ec2 describe-network-interfaces --network-interface-ids "${ENI}" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
echo $TASK_DETAILS | jq
echo $PUBLICIP

### 列出 Cluster 的 ECS Services
aws ecs list-services --cluster $ECS_CLUSTER

### 列出 ECS Service 的 ECS tasks (沒啥用, 頂多看到有多少 tasks 而已)
ECS_SERVICE_NAME=
aws ecs list-tasks --cluster $ECS_CLUSTER --service $ECS_SERVICE_NAME

### 詳細列出 ECS tasks 資訊
aws ecs describe-tasks --cluster $ECS_CLUSTER --tasks $ECS_TASK_ID

### 列出 & 詳述 所有 ECS tasks (in Cluster)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html

task_arns=$(aws ecs list-tasks --cluster $ECS_CLUSTER --output yaml | yq '.taskArns[]')
echo "$task_arns" | while IFS= read -r task_arn; do
  aws ecs describe-tasks --cluster $ECS_CLUSTER --tasks $task_arn --query 'tasks[0].{ip: containers[0].networkInterfaces[0].privateIpv4Address, name: group, IP: }' --output json | jq
done
# aws ecs describe-tasks --cluster $ECS_CLUSTER --tasks $task_arn | yq '.tasks[0].containers[0]'

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
export ECS_CLUSTER=
export ECS_SERVICE=
aws ecs describe-services \
  --cluster $ECS_CLUSTER \
  --services $ECS_SERVICE

###
