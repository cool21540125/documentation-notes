#!/bin/bash
exit 0
# -----------------------------------------------------------------

### 日後的 Nodes 打算加入到既有 Cluster 的時候, 用此方式來取得 join 相關的資訊
kubeadm token create --print-join-command
# 這串為 worker node 加入 cluster 的指令


### 重設 kubeadm
sudo kubeadm reset --force
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/dockershim
sudo rm -rf /var/lib/cni
sudo rm -rf /var/lib/kubernetes
sudo rm -rf /etc/cni/net.d
sudo rm -rf ~/.kube
# 前提是可以 100% 確定之前的 kubeadm 設定的東西可以完全捨棄

###
kubeadm config print init-defaults >init.default.yaml

### kubeadm 開始設定以前, 可先把 image 都先拉下來
kubeadm config images pull

### show kubeadm images
kubeadm config images list
#registry.k8s.io/kube-apiserver:v1.33.0
#registry.k8s.io/kube-controller-manager:v1.33.0
#registry.k8s.io/kube-scheduler:v1.33.0
#registry.k8s.io/kube-proxy:v1.33.0
#registry.k8s.io/coredns/coredns:v1.12.0
#registry.k8s.io/pause:3.10
#registry.k8s.io/etcd:3.5.21-0


### kubeadm init
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
