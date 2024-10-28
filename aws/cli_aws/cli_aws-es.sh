#!/bin/bash
exit 0
# ----------------------------------------------------------------------------------

# ==================================== OpenSearch Common ====================================

# ============================== Metrics ================================
### 列出 OpenSearch 的 metrics
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/list-metrics.html
aws cloudwatch list-metrics --namespace "AWS/ES"

###
