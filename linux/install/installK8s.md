- 有很多種安裝 kubernetes 的方式:
  - K8s Service:
    - kind : 適合 本地開發, 但依賴於 Docker or Podman
    - minikube : 適合 本地開發, Docker 已有內建
    - kubeadm : 適合 生產環境
  - K8s Tool:
    - kubectl
    - bash completion / zsh completion
      - 需要用到的話再來看 - https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/

# Install kubernetes

- 必須確定 Nodes 之間 IP 沒重複 `ifconfig -a`
- 必須確定 硬體裝置 uuid 沒重複 `sudo cat /sys/class/dmi/id/product_uuid`
- 必須確定 Services 之間的 Ports 及 Protocols 之間可以相互聯繫
  - https://kubernetes.io/docs/reference/networking/ports-and-protocols/
  - Control Plane
    - etcd : 2379-2380
    - API Server : 6443
    - kubelet : 10250
    - controller : 10257
    - scheduler : 10259
  - Worker Nodes
    - kubelet : 10250
    - NodePorts : 30000-32767
- ![Debian-based安裝](./installUbuntu.md#install-k8s--install-kubernetes)
- ![RedHat-based安裝](./installCentOS7.md#install-k8s--install-kubernetes)
- 底下使用 pkg manager 的方式紀錄
- 關於 k8s 的版本, 最大的版本號為 api-server, 且需要遵守底下的安裝版本限制
  - kube-apiserver 為最主要的元件, ex:
    - v1.10
  - controller-manager 及 scheduler 可行的版本號則為
    - v1.10 & v1.9
  - kubelet 及 kube-proxy 可行的版本號則為
    - v1.10 & v1.9 & v1.8
  - kubectl 可行的版本號則為
    - v1.11 & v1.10 & v1.9

## 法 1. Use kubeadm

- 所有 Nodes 安裝 container runtime, CRI (預設依序尋找)
  - unix:///var/run/containerd/containerd.sock
  - unix:///var/run/crio/crio.sock
  - unix:///var/run/cri-dockerd.sock
- 所有 Nodes 安裝 kubeadm && kubelet
- Master 執行 init
- 所有 Nodes 配置 Pod Network - CNI
- Worker join cluster

```bash
### 升級 k8s
kubeadm upgrade plan

kubeadm upgrade apply
```

## 法 2. From Scratch

```bash

```
