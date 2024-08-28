#!/bin/bash
exit 0
# ---------------------------

### 列出所有 secrets
aws secretsmanager list-secrets

### 查詢 secret
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/get-secret-value.html
SECRET_ID=
aws secretsmanager get-secret-value --secret-id $SECRET_ID

### 更新 secret
aws secretsmanager rotate-secret --secret-id $SECRET_ID
