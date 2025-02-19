### 使用 CLI 方式來 trigger ALARM (測試用, 可用來觀察後續動作是否正常運作)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
ALARM_REASON=testing
ALARM_NAME=XXX

### 製作 Custom Metric
aws cloudwatch set-alarm-state \
    --alarm-name ${ALARM_NAME} \
    --state-value ALARM \
    --state-reason ${ALARM_REASON}
#
# 狀態有底下 3 種:
#   OK
#   ALARM
#   INSUFFICIENT_DATA

### 推送一筆資料到 CloudWatch - 自行建立 custom metric (區間可以是: 2週前 ~ 2小時候)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-metric-data.html
aws cloudwatch put-metric-data \
    --metric-name "$MetricName" \
    --namespace "/Metric/Namespace" \
    --unit Percent \
    --value 23 \
    --dimensions InstanceId=i-1234567890abcdef0,InstanceType=t2.micro
# publishes a Buffers metric with two dimensions : InstanceId & InstanceType

### 寫 log
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/logs/put-log-events.html
aws logs put-log-events --log-group-name /sre/demo --log-stream-name 1004 --log-events file://JSONFileName

### 建立 CloudWatch Alarm
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-metric-alarm.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricAlarm.html
DIMENSION_TG="Name=TargetGroup,Value=targetgroup/tgForAlbToEcs/bd2b8978d04f7bd9"
DIMENSION_ALB="Name=LoadBalancer,Value=app/albToEcsFlaskBot/081ef33923b8fbdb"
ACTION_SNS_ARN="arn:aws:sns:ap-northeast-1:297886803107:sre-ecs-task-dead-notification"
ACTION_LAMBDA_ARN="arn:aws:lambda:ap-northeast-1:297886803107:function:poc-lambda-cwa-elb"

METRIC_ALARM_NAME="TkoWordpress-task-all-dead-ALARM"
COMPOSITE_ALARM_NAME="TkoWordpress-task-all-dead-OK"

### 建立 CloudWatch Alarm, 進入 ALARM 狀態時候的 actions
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-metric-alarm.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricAlarm.html
aws cloudwatch put-metric-alarm \
    --alarm-name ${METRIC_ALARM_NAME} \
    --alarm-description "Wordpress ECS Tasks - DEAD" \
    --actions-enabled \
    --namespace "AWS/ApplicationELB" \
    --dimensions ${DIMENSION_TG} ${DIMENSION_ALB} \
    --metric-name "HealthyHostCount" \
    --statistic "Maximum" \
    --period 60 \
    --comparison-operator "LessThanThreshold" \
    --threshold 1 \
    --datapoints-to-alarm 1 --evaluation-periods 1 \
    --treat-missing-data "breaching" \
    --alarm-actions ${ACTION_SNS_ARN} ${ACTION_LAMBDA_ARN}

### 建立 CloudWatch Alarm, 進入 OK 狀態時候的 actions (composite alarm)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/put-composite-alarm.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutCompositeAlarm.html
aws cloudwatch put-composite-alarm \
    --alarm-name ${COMPOSITE_ALARM_NAME} \
    --alarm-description "Wordpress ECS Tasks - OK" \
    --actions-enabled \
    --alarm-rule "ALARM(\"${METRIC_ALARM_NAME}\")" \
    --ok-actions ${ACTION_SNS_ARN}

### (測試) 讓 CloudWatch Alarm 進入 ALARM 狀態 (觸發 ALARM/IN_ALARM)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
aws cloudwatch set-alarm-state \
    --alarm-name ${METRIC_ALARM_NAME} \
    --state-value ALARM \
    --state-reason "This is Only test, dont be panic"

### 查詢 CloudWatch Log Groups 的儲存量
PREFIX=production.log
aws logs describe-log-groups --log-group-name-prefix "$PREFIX" --query "logGroups[].{LogGroup: logGroupName, Size: storedBytes}" --output json
aws logs describe-log-groups --log-group-name-prefix "$PREFIX" --output yaml | yq ".logGroups[].logGroupName"

aws logs describe-log-groups --log-group-name-prefix "/aws/cloudtrail/tf-write-events" --query 'logGroups[].{LogGroup: logGroupName, Size: storedBytes}'

### 查看 隨著時間經過的 CW metrics
CLUSTER_NAME=iDing
SERVICE_NAME=iDingClientProduction

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/get-metric-statistics.html
METRIC_NAME=MemoryUtilization
NS=AWS/ECS
aws cloudwatch get-metric-statistics \
    --metric-name $METRIC_NAME \
    --namespace $NS \
    --dimensions Name=ServiceName,Value=${SERVICE_NAME} Name=ClusterName,Value=${CLUSTER_NAME} \
    --start-time 2024-09-14T00:00:00Z \
    --end-time 2024-09-18T00:00:00Z \
    --statistics Average \
    --period 300

###
METRIC_NAME=CPUUtilization
NS=AWS/ECS
aws cloudwatch get-metric-statistics \
    --metric-name $METRIC_NAME \
    --namespace $NS \
    --dimensions Name=ServiceName,Value=${SERVICE_NAME} Name=ClusterName,Value=${CLUSTER_NAME} \
    --start-time 2024-09-14T00:00:00Z \
    --end-time 2024-09-18T00:00:00Z \
    --statistics Average \
    --period 300

###
METRIC_NAME=RequestCountPerTarget
NS=AWS/ApplicationELB
aws cloudwatch get-metric-statistics \
    --metric-name $METRIC_NAME \
    --namespace $NS \
    --dimensions Name=LoadBalancer,Value=app/${CLUSTER_NAME}/33add93a1c7e97ce Name=TargetGroup,Value=targetgroup/ECS-${SERVICE_NAME}/e3b79345705cec5a \
    --start-time 2024-09-15T12:00:00Z \
    --end-time 2024-09-18T00:00:00Z \
    --statistics Sum \
    --period 300
