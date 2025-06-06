#!/bin/bash

### 2025/05/10
# 從頭來過, new Ubuntu 24.04

alias la='ls -a --color'
alias ll='ls -l --color'
alias lla='ls -al --color'
alias k='kubectl'
alias km='kubeadm'

sudo apt update
sudo swapoff -a

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
EOF

sudo sysctl --system
sysctl net.ipv4.ip_forward
sysctl net.ipv4.conf.all.forwarding
# sudo apt install -y cri-tools

### containerd
# https://github.com/containerd/containerd/releases
VERSION=2.1.0
ARCH=arm64
wget https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-${ARCH}.tar.gz
sudo tar Cxzvf /usr/local "containerd-${VERSION}-linux-${ARCH}.tar.gz"

echo '[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target dbus.service

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target' | sudo tee /usr/lib/systemd/system/containerd.service

sudo mkdir /etc/containerd

echo '[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.10"' | sudo tee /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

### runc
# https://github.com/opencontainers/runc/releases
VERSION=1.3.0
ARCH=arm64
wget https://github.com/opencontainers/runc/releases/download/v${VERSION}/runc.${ARCH}

sudo install -m 755 "runc.${ARCH}" /usr/local/sbin/runc

### CNI-plugin
# https://github.com/containernetworking/plugins/releases
VERSION=1.7.1
ARCH=arm64
wget https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${ARCH}-v${VERSION}.tgz

sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-${ARCH}-v${VERSION}.tgz

### kubeadm kubectl kubelet
K8S_VERSION=v1.33
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
### --------------------------------------------------------------------------------------------------------

sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

### --------------------------------------------------------------------------------------------------------
sudo kubeadm init

# ubuntu User 的話
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

k get ns
k get po -n kube-system
k get po -n kube-flannel
k get no

kubeadm join 10.200.0.11:6443 --token anobmw.94o3b81h1elsmuh5 \
  --discovery-token-ca-cert-hash sha256:0f1b7b1677ba53558ad1beb0fb2d7cc9b75990d96b73b252aa8ce158fc9fbc2c

### 安裝 metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
k
k top
