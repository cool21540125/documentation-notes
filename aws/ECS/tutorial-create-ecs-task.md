- 2022/09/03
- [Tutorial: Creating a cluster with an EC2 task using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html)
    - (這篇似乎是使用 EC2 Launch Type... not sure)


```bash
### Step 1: Create a Cluster
$# CLUSTER_NAME=MyCluster0903
$# aws ecs create-cluster \
    --cluster-name ${CLUSTER_NAME}
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:ap-northeast-1:xxxxxxxxxxxx:cluster/MyCluster0903",
        "clusterName": "MyCluster0903",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
# 

### Step 2: Launch an Instance with the Amazon ECS AMI
# run task 之前, 必須先有 「Amazon ECS container instance in your cluster」, WTF?
# 看起來是要先建一台 EC2 耶!?
# Tutorial: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html

### Step 3: List Container Instances
$# aws ecs list-container-instances \
    --cluster ${CLUSTER_NAME}
{
    "containerInstanceArns": []
}
# 如果 Step 2 有建成功, 可看到有東西... things like:
{
    "containerInstanceArns": [
        "arn:aws:ecs:us-east-1:aws_account_id:container-instance/container_instance_ID"
    ]
}
# 


### Step 4: Describe your Container Instance
$# container_instance_ID=
$# aws ecs describe-container-instances \
    --cluster ${CLUSTER_NAME} \
    --container-instances ${container_instance_ID}
# Output 參考 example-create-ecs-task-output.jsonc


### Step 5: Register a Task Definition
$# aws ecs register-task-definition \
    --cli-input-json file://sleep360.json
# 想在 Cluster 里頭 run task, 必須先定義 Task Definition


### Step 6: List Task Definitions
$# aws ecs list-task-definitions


### Step 7: Run a Task
$# aws ecs run-task \
    --cluster ${CLUSTER_NAME} \
    --task-definition sleep360:1 \
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
