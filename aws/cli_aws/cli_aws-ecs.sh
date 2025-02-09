#!/bin/bash
exit 0
# ==============================================================================================================================================
ECS_CLUSTER=
ECS_SERVICE=
ECS_TASK_ARN_OR_ID=
ECS_CONTAINER=

### ======================================================================= 基本查詢 =======================================================================

### 列出 Clusters
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-clusters.html
aws ecs list-clusters

### 詳細列出 ECS Service 資訊
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
aws ecs describe-services \
  --cluster $ECS_CLUSTER \
  --services $ECS_SERVICE

# ### 列出 ECS Service 的 ECS tasks (沒啥用, 頂多看到有多少 tasks 而已)
# # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
# aws ecs list-tasks --cluster $ECS_CLUSTER --service $ECS_SERVICE

### 詳細列出 ECS tasks 資訊
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
aws ecs describe-tasks \
  --cluster $ECS_CLUSTER \
  --tasks $ECS_TASK_ARN_OR_ID

### 列出 & 詳述 所有 ECS tasks (in Cluster)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
TASK_ARNS=$(aws ecs list-tasks --cluster $ECS_CLUSTER --output yaml | yq '.taskArns[]')
echo "$TASK_ARNS" | while IFS= read -r task_arn; do
  aws ecs describe-tasks --cluster $ECS_CLUSTER --tasks $task_arn --query 'tasks[0].{ip: containers[0].networkInterfaces[0].privateIpv4Address, name: group, IP: }' --output json | jq
done
# aws ecs describe-tasks --cluster $ECS_CLUSTER --tasks $ECS_TASK_ARN_OR_ID | yq '.tasks[0].containers[0]'

### 列出有哪些 ECS Services 啟用了 ASG 及其 ASG 資訊
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/application-autoscaling/describe-scaling-policies.html
aws application-autoscaling describe-scaling-policies --service-namespace ecs --query 'ScalingPolicies[].{svc: ResourceId, policy: PolicyType}' --output json | jq

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-task-definitions.html
aws ecs list-task-definitions

### 註冊 Task Definition
TASK_DEFINITION_FILE=TaskDefinition.json
aws ecs register-task-definition --cli-input-json file://${TASK_DEFINITION_FILE}
# containerPort : port that container exposes
# hostPort      : port that you want to map it to on the host
# 這檔案長得一副就是 docker-compose 的樣子

### ======================================================================= 查詢 ECS Public IP =======================================================================

### 查詢 ECS Task Public IP
TASK_ARN=$(aws ecs list-tasks --cluster "${ECS_CLUSTER}" --service-name "${ECS_SERVICE}" --query 'taskArns[0]' --output text)
TASK_DETAILS=$(aws ecs describe-tasks --cluster "${ECS_CLUSTER}" --task "${TASK_ARN}" --query 'tasks[0].attachments[0].details' --output json)
ENI=$(echo "${TASK_DETAILS}" | jq -r '.[] | select(.name=="networkInterfaceId").value')
PUBLICIP=$(aws ec2 describe-network-interfaces --network-interface-ids "${ENI}" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
echo $TASK_DETAILS | jq
echo $PUBLICIP

### ======================================================================= Remote ECS Container ssh =======================================================================

### Step1. 遠端 ssh ECS (Task 需有 Public IP) # NOTE: 還沒驗證指令可行性
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/update-service.html
ECS_CLUSTER=ServerAPI
ECS_SERVICE=authServiceStaging
aws ecs update-service \
  --cluster $ECS_CLUSTER \
  --service $ECS_SERVICE \
  --enable-execute-command \
  --force-new-deployment

### Step2. 遠端 ssh ECS (ECS Task 須先 EnableExecuteCommand)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/execute-command.html
# 進入 ECS Container 的前提是, 需要有 enableExecuteCommand
aws ecs execute-command \
  --cluster $ECS_CLUSTER \
  --task $ECS_TASK_ARN_OR_ID \
  --container $ECS_CONTAINER \
  --interactive --command "/bin/sh"

### ======================================================================= 設定 ASG  =======================================================================

### 設定 ECS ASG scheduled scaling
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/application-autoscaling/put-scheduled-action.html
aws application-autoscaling put-scheduled-action \
  --service-namespace ecs \
  --resource-id "service/$ECS_CLUSTER/$ECS_SERVICE" \
  --scheduled-action-name SrePocScheduledScaling \
  --scalable-dimension "ecs:service:DesiredCount" \
  --schedule "cron(30 14 * * ? *)" \
  --timezone "Asia/Taipei" \
  --scalable-target-action MinCapacity=1,MaxCapacity=3

### 刪除 ECS ASG scheduled scaling
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/application-autoscaling/delete-scheduled-action.html#examples
aws application-autoscaling delete-scheduled-action \
  --service-namespace ecs \
  --resource-id "service/$ECS_CLUSTER/$ECS_SERVICE" \
  --scheduled-action-name SrePocScheduledScaling \
  --scalable-dimension "ecs:service:DesiredCount"

### ======================================================================= 全部掃一次 =======================================================================

### 列出 所有 ECS Deployment failure detection
aws ecs list-clusters --output text | awk '{print $2}' | while IFS= read -r ECS_CLUSTER; do
  aws ecs list-services --cluster $ECS_CLUSTER --output text | awk '{print $2}' | while IFS= read -r ECS_SERVICE; do
    aws ecs update-service \
      --cluster $ECS_CLUSTER \
      --service $ECS_SERVICE \
      --deployment-configuration "deploymentCircuitBreaker={enable=true,rollback=true}"
    echo "${ECS_CLUSTER}::${ECS_SERVICE} -- DONE"
  done
done

### Deployment failure - Circuit breaker
aws ecs update-service \
  --cluster $ECS_CLUSTER \
  --service $ECS_SERVICE \
  --deployment-configuration "deploymentCircuitBreaker={enable=true,rollback=true}"

### Deployment failure - Alarm action
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-alarm-failure.html
ALARM_NAME_01=
aws ecs update-service \
  --cluster $ECS_CLUSTER \
  --service $ECS_SERVICE \
  --desired-count 1 \
  --deployment-configuration "alarms={alarmNames=[${ALARM_NAME_01}],enable=true,rollback=true}" \
  --force-new-deployment

### ECS 變更 Subnets 及 SecurityGroup (變更 SG)
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-alarm-failure.html
SubnetId1=
SubnetId2=
SgId=
ECS_SERVICE=
ECS_CLUSTER=

aws ecs update-service \
  --cluster $ECS_CLUSTER \
  --service $ECS_SERVICE \
  --network-configuration '{"awsvpcConfiguration": {"subnets": ["subnet-0000000"], "securityGroups": ["sg-111111111"], "assignPublicIp": "DISABLED"}}'
