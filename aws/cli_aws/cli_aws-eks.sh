#!/bin/bash
exit 0
# ==============================================================================================================================================

export KUBECONFIG=~/.kube/XXX.yaml
export AWS_PROFILE=dev

### 設定 ~/.kube/config 新增 EKS_NAME cluster 的 KUBECONFIG
EKS_NAME=staging-devops2
aws eks update-kubeconfig --name $EKS_NAME
# 這會更新 $HOME/.kube/config

### ------------------------------------- EKS 權限操作 -------------------------------------\

### 列出與 EKS 有關的 all policies
aws eks list-access-policies


### 
aws eks list-access-entries --cluster-name devops


# 建立 EKS 的 IAM User, 具備 admin 權限, 然而此時其他 IAM User 不具備權限

### 授權其他 AWS IAM 可操作 cluster
AWS_ACCOUNT=942335579121
AWS_USERNAME=shawn
kubectl patch configmap aws-auth -n kube-system --patch "
data:
  mapUsers: |
    - userarn: arn:aws:iam::$AWS_ACCOUNT:user/$AWS_USERNAME
      username: $AWS_USERNAME
      groups:
      - system:masters"
#configmap/aws-auth patched
# WARNING: 是情況給予權限, 上述是給予 k8s cluster admin 權限


### 
k get cm aws-auth -n kube-system -o yaml