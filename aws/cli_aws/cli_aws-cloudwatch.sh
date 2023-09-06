
### 使用 CLI 方式來 trigger ALARM (測試用, 可用來觀察後續動作是否正常運作)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/set-alarm-state.html
ALARM_REASON=testing
ALARM_NAME=XXX

aws cloudwatch set-alarm-state \
    --alarm-name ${ALARM_NAME} \
    --state-value ALARM \
    --state-reason ${ALARM_REASON}
# 
# OK / ALARM / INSUFFICIENT_DATA


### 
