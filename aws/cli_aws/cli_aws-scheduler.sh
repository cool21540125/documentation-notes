#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

QUEUE_ARN=
ROLE_ARN=

### 建立 EventBridgeScheduler Group
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/scheduler/create-schedule-group.html
aws scheduler create-schedule-group \
  --name SrePocScheduleGroup \
  --tags Key=Usage,Value=SrePoc Key=CreatedVia,Value=cli

### 建立 EventBridgeScheduler
# https://docs.aws.amazon.com/scheduler/latest/UserGuide/getting-started.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/scheduler/create-schedule.html
aws scheduler create-schedule \
  --name SrePocSchedulerCli \
  --schedule-expression 'cron(25 22 * * ? *)' \
  --flexible-time-window '{ "Mode": "FLEXIBLE", "MaximumWindowInMinutes": 5}' \
  --schedule-expression-timezone 'Asia/Taipei' \
  --group-name SrePocScheduleGroup \
  --target "{\"RoleArn\": \"${ROLE_ARN}\", \"Arn\": \"${QUEUE_ARN}\", \"Input\": \"OffDutyHours\" }"

### 刪除 EventBridgeScheduler
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/scheduler/delete-schedule.html
aws scheduler delete-schedule --name SrePocSchedulerCli

### 刪除 EventBridgeScheduler Group
aws scheduler delete-schedule-group --name SrePocScheduleGroup
