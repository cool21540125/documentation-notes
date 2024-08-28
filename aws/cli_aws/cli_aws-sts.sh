#!/bin/bash
exit 0
# --------------------------------------------------------------

### assume-role
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/assume-role.html
ROLE_ARN=
aws sts assume-role \
    --role-arn $ROLE_ARN \
    --role-session-name demo_role_session

###
