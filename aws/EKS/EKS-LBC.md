# EKS LoadBalancer Controller / EKS LBC

EKS 要用 LB 的話:
  - ALB
    - kind: Ingress
  - NLB
    - kind: Service
      - type: LoadBalancer

EKS 使用 Load Balancer Controller, LBC 控制 Load Balancer

---------------


要用來運行 ALB 的 Subnets, 底下必須要有 8 IPs 的空間

並且要有 2 subnets, 橫跨 2 AZs

---------------------------------------------------------------------------------------------------------------------------------------------------------------

LBC 所有的 Annotations 都在這邊: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.14/guide/ingress/annotations/

Object                  | required | annotations 及 tags                                                                                                                        | Note
------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------
Node SG tag (one of SG) | required | `kubernetes.io/cluster/{ClusterName}: {shared OR owned}`                                                                                   | SG 是否為 cluster 專屬
Subnet tag              | better   | `kubernetes.io/cluster/{ClusterName}: {shared OR owned}`                                                                                   | Subnet 是否為 cluster 專屬
Subnet tag              | required | `kubernetes.io/role/internal-elb: "1"` 或 `kubernetes.io/role/elb: "1"` 或 Ingress/Service.LoadBalancer 的 Annotation要聲明 SubnetID(不推) | LBC 才知道要把 LB 放到哪
Ingress annot           | required | `kubernetes.io/ingress.class: alb`                                                                                                         | LBC 用來操作 LB
Ingress annot           | optional | `alb.ingress.kubernetes.io/ip-address-type: dualstack`                                                                                     | 若要使用 IPv6
Ingress annot           | optional | `alb.ingress.kubernetes.io/tags: k1=v1, Env=dev, ...`                                                                                      | 可自訂 LB labels
Ingress annot           | required | `alb.ingress.kubernetes.io/target-type: ip` (用 ip 就好, 除非有 Legacy 改用 `alb.ingress.kubernetes.io/target-type: instance`)             | ALB 直接 forward 到 Pod ip
Ingress annot           | required | `alb.ingress.kubernetes.io/scheme: internet-facing` 或 `alb.ingress.kubernetes.io/scheme: internal`                                        | LBC 建立 ALB 判斷 internet/internal
Ingress annot           | optional | `alb.ingress.kubernetes.io/group.name: {GroupName}`                                                                                        | Ingress 共用 ALB 不同團隊共用, 但分開管 Ingress
Ingress annot           | optional | `alb.ingress.kubernetes.io/group.order: {1~1000}`                                                                                          | Ingress 共用 ALB 彼此的 priority, 避免戶蓋
Ingress annot           | optional | `alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-2:123456789012:certificate/12345678-xy34-ab12-8765-1a2b3c4d5e6f`           | ALB https 使用的 ACM certificate arn
Ingress annot           | optional | `alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'`                                                                  | ALB 的 listeners
Ingress annot           | optional | `alb.ingress.kubernetes.io/healthcheck-path: /health`                                                                                      | (套用到) Ingress 底下的 rules, 共用的 health check endpoint (但不知道雨 Ingress Group 會如何交互影響)

---------------------------------------------------------------------------------------------------------------------------------------------------------------