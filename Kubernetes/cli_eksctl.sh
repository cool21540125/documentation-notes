#!/bin/bash
exit 0
# ----------------------------------------------------------------------

###
eksctl create cluster \
  --name my-cluster \
  --region us-west-2 \
  --version 1.33 \
  --fargate

### 