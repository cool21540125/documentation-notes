- 2022/09/03
- [Tutorial: Creating a cluster with an EC2 task using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html)
  - (這篇是使用 EC2 Launch Type)

```bash
aws ecs list-clusters

### Step 1: Create a Cluster
aws ecs create-cluster --cluster-name $CLUSTER_NAME

### Step 2: Launch an Instance with the Amazon ECS AMI
# run task 之前, 必須先有 「Amazon ECS container instance in your cluster」
# 先建立一台 EC2, 需要具備 ECS 必要的 Roles
# 為了方便 lab 進展, VPC 要與 ECS Service 一樣 && Security Group 開 80
#
# Tutorial: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html

### Step 3: List Container Instances
aws ecs list-container-instances --cluster ${CLUSTER_NAME}
#{
#    "containerInstanceArns": []
#}
# 如果 Step 2 有建成功, 可看到有東西... things like:
#{
#    "containerInstanceArns": [
#        "arn:aws:ecs:us-east-1:aws_account_id:container-instance/container_instance_ID"
#    ]
#}
#


### Step 4: Describe your Container Instance
$# container_instance_ID=
$# aws ecs describe-container-instances \
    --cluster ${CLUSTER_NAME} \
    --container-instances ${container_instance_ID}
# Output 參考 example-create-ecs-task-output.jsonc


### Step 5: Register a Task Definition
$# aws ecs register-task-definition \
    --cli-input-json file://taskdef-sleep360.json
# 想在 Cluster 里頭 run task, 必須先定義 Task Definition


### Step 6: List Task Definitions
$# aws ecs list-task-definitions


### Step 7: Run a Task
$# aws ecs run-task \
    --cluster ${CLUSTER_NAME} \
    --task-definition taskdef-sleep360:1 \
    --count 1
# Output 參考 example-run-ecs-task-output.jsonc

### Step 8: List Tasks
$# aws ecs list-tasks \
    --cluster ${CLUSTER_NAME}
{
    "taskArns": [
        "arn:aws:ecs:us-east-1:aws_account_id:task/task_ID"
    ]
}


### Step 9: Describe the Running Task
$# task_ID=
$# aws ecs describe-tasks \
    --cluster ${CLUSTER_NAME} \
    --task ${task_ID}
# Output 參考 example-describe-running-task-output.jsonc
```
