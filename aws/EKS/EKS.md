# EKS 最佳化

- [用來計算每台 EC2 適合用來跑多少個 Pods](https://docs.aws.amazon.com/eks/latest/userguide/choosing-instance-type.html#determine-max-pods)


# EKS 權限相關

- EKS cluster 裡頭會自動安裝 `AWS IAM Authenticator for Kubernetes (Github kubernetes-sigs/aws-iam-authenticator)`
- IAM 用來訪問 EKS, 有 2 種機制:
  - 舊機制為 `aws-auth Config` (容易出錯,自動化困難, 缺乏稽核, 存取權遺失風險), 因而 2023 年出了個 `Access Entry`(原生整合 AWS API, 安全, 簡化權限指派, 災難復原)
- **EKS cluster** 與 **AWS Resources** 之間的存取控制, 主要是藉由關聯 **IAM Roles** 與 **Kubernetes Service Account**. 可藉由底下其中一種機制:
  - Pod Identity
  - IAM Roles for Service Accounts (IRSA)
- `kubectl` 指令工具訪問 **EKS cluster**, 則是使用 `KUBECONFIG`
- EKS Cluster IAM Role - IAM Cluster Role, 需要: `AmazonEKSClusterPolicy`
- Worker Nodes 則因應不同的 Compute Options 會有不同的 IAM Role 需求: 
  - EKS Auto Mode (遇到再說) - **Nodes 會貴 12%** - 包含這些功能 : ALB / EBS / Compute ASG / GPU / ClusterDNS / PodAndServiceNetworking
  - EC2 Linux managed node group, 需要讓 `ec2.amazonaws.com` 能夠 `sts:AssumeRole`, 並具備 Policies:
    - `AmazonEKSWorkerNodePolicy`
    - `AmazonEC2ContainerRegistryReadOnly`
    - `AmazonEKS_CNI_Policy`
  - Fargate profile (遇到再說)
  - Hybrid Nodes (遇到再說)
- IAM role for service account, IRSA
- Pod Identity Agent - 運行在 EKS Nodes 的 DaemonSet, 用來協助 Pod 取得 AWS temp creds 來存取 AWS Resources
  - Pod Identity Agent 使用 loopback ip: `169.254.170.23` & `[fd00:ec2::23]`

# AWS Load Balancer Controller, LBC

- [What is AWS Load Balancer Controller](https://devopscube.com/aws-load-balancer-controller-on-eks/)
  - 用來給 EKS cluster 建立 ELB 用的 Controller
- [aws-load-balancer-controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
  - LBC 2.14 以後, LBC 會在當你建立了 k8s Gateway 的時候, 建立 ALB
    - k8s Gateway 比 Ingress 標準化了許多配置 (藉由 annotations)

controller 提供 ELB 指向到 cluster Service or Ingress resources

也就是說, controller 建立 single IP or DNS name 指向到 cluster 裡頭的 pods

- controller provisions 底下的 resources:
  - k8s Ingress
    - LBC 會在當 cluster admin 建立了 k8s Ingress 的時候, 建立 ALB (可藉由 annotations 配置 SG)
  - k8s service of LB type
    - LBC 會在當 cluster admin 建立了 k8s service of type LoadBalancer 的時候, 建立 NLB


# EKS - Non-Auto Mode 額外需要手動處理的任務

- [Amazon EKS Pod 存取 IMDSv2 異常緩慢處理](https://shazi.info/amazon-eks-pod-存取-imdsv2-異常緩慢處理/)
  - 需要從 Launch Template 的 metadata options 下手, 將 response hop limit 由 1 改成 2
- EKS ASG 議題
  - 如果 EKS cluster 使用 `EKS Auto Mode`, 那麼 EKS 會直接幫忙託管 `Karpenter` 來處理 ASG
  - 如果 EKS cluster 並非 `EKS Auto Mode`, 那麼可以自行選擇使用 `Karpenter` 或 `Cluster Autoscaler` 來處理 ASG

