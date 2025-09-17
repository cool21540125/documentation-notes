#!/bin/bash
exit 0
#
# 用來建立 PostgreSQL
#
## ------------------------ n8n ------------------------

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# https://artifacthub.io/packages/helm/bitnami/postgresql
helm pull --untar bitnami/postgresql
# helm pull --untar bitnami/postgresql --version 16.7.27  # 2025/09/05
cd postgresql

# helm install my-release bitnami/postgresql --set auth.username=myuser --set auth.password=mypassword --set auth.database=mydb
