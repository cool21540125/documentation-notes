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
