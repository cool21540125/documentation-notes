#!/bin/bash
exit 0
# ---------------------------

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/get-secret-value.html
SECRET_ID=
aws secretsmanager get-secret-value --secret-id $SECRET_ID

###
