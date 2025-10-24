#!/bin/bash
exit 0
# ==============================================================================================================================================

export KUBECONFIG=~/.kube/XXX.yaml
export AWS_PROFILE=dev

### 新增 KUBECONFIG
EKS_NAME=devops
aws eks update-kubeconfig --name $EKS_NAME
# 這會更新 $HOME/.kube/config

### 