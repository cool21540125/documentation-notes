#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/index.html
# ----------------------------


### 遠端登入到 ECS Task
# ECS Task Container 需有 Public IP
aws ecs execute-command \
  --cluster $ECS_CLUSTER \
  --task $ECS_TASK \
  --container $ECS_CONTAINER \
  --interactive --command "/bin/sh"


### 
CLUSTER=
SERVICE_NAME=

TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER --service-name $SERVICE_NAME --query 'taskArns[0]' --output text)
TASK_DETAILS=$(aws ecs describe-tasks --cluster $CLUSTER --task "${TASK_ARN}" --query 'tasks[0].attachments[0].details' --output json)
ENI=$(echo $TASK_DETAILS | jq -r '.[] | select(.name=="networkInterfaceId").value')
PUBLICIP=$(aws ec2 describe-network-interfaces --network-interface-ids "${ENI}" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
echo $TASK_DETAILS | jq
echo $PUBLICIP
