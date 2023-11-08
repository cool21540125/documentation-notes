
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


### 推送一筆資料到 CloudWatch
aws cloudwatch put-metric-data \
    --metric-name "$MetricName" \
    --namespace "/Metric/Namespace" \
    --unit Percent \
    --value 23 \
    --dimensions InstanceId=i-1234567890abcdef0,InstanceType=t2.micro
# publishes a Buffers metric with two dimensions : InstanceId & InstanceType


###
