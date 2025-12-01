# EKS LoadBalancer Controller / EKS LBC

- EKS 使用 Load Balancer Controller, LBC 控制 Load Balancer
  - 要用來運行 ALB 的 Subnets, 底下必須要有 8 IPs 的空間
  - 起碼要有 2 subnets, 橫跨 2 AZs

```yaml
## EKS - ALB
kind: Ingress
---
## EKS - NLB
kind: Service
  type: LoadBalancer
```
