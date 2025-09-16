# 跑在 EC2 上頭的 Kubernetes 使用 EBS / EFS drivers 的 issue

https://github.com/kubernetes/cloud-provider-aws/tree/master/charts/aws-cloud-controller-manager

```
helm repo add aws-cloud-controller-manager https://kubernetes.github.io/cloud-provider-aws
helm repo update

helm upgrade --install aws-cloud-controller-manager aws-cloud-controller-manager/aws-cloud-controller-manager
```
