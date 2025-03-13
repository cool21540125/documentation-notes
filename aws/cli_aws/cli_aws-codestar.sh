#!/bin/bash
exit 0
# ------------------------

### list-notification-rules
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codestar-notifications/list-notification-rules.html
aws codestar-notifications list-notification-rules

### 查看 CodePipeline Notification Rule
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codestar-notifications/describe-notification-rule.html
aws codestar-notifications describe-notification-rule \
  --arn arn:aws:codestar-notifications:us-west-2:000000000000:notificationrule/YOUR_CODEPIPELINE_ID

###
