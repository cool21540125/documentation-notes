#!bin/bash
exit 0
#
# ---------------------------------------------------------------------------------------------------

### 查看 EventBridge Rules
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/events/list-rules.html
aws events list-rules --output yaml | yq

### 依照 EventBridge Rule 查詢 Targets
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/events/list-targets-by-rule.html
RULE_NAME=
aws events list-targets-by-rule --output yaml --rule $RULE_NAME

###
