#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------

# TODO:
sudo hostnamectl set-hostname $__WORKER_NODE_NAME__
sudo timedatectl set-timezone $__CLUSTER_TZ_NAME__

sudo apt update
sudo swapoff -a

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
sysctl net.ipv4.ip_forward
sysctl net.ipv4.conf.all.forwarding


### ---------------------------------- containerd ----------------------------------
# https://github.com/containerd/containerd/releases
VERSION=2.1.4
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

systemctl status containerd
containerd --version


### runc
# https://github.com/opencontainers/runc/releases
VERSION=1.3.0
ARCH=arm64
wget https://github.com/opencontainers/runc/releases/download/v${VERSION}/runc.${ARCH}

sudo install -m 755 "runc.${ARCH}" /usr/local/sbin/runc
rm -f runc.${ARCH}


# ---------------------------------- CNI-plugin ----------------------------------
# https://github.com/containernetworking/plugins/releases
VERSION=1.7.1
ARCH=arm64
wget https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${ARCH}-v${VERSION}.tgz

sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-${ARCH}-v${VERSION}.tgz
rm cni-plugins-linux-${ARCH}-v${VERSION}.tgz

### overlay 為 cri-o 及 containerd 依賴項目; br_netfilter 允許橋接網路流量通過 iptables 或 ip6tables 進行過濾
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

### ---------------------------------- kubeadm kubelet ----------------------------------
K8S_VERSION=v1.33
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt-get install -y kubelet kubeadm
sudo apt-mark hold kubelet kubeadm
sudo systemctl enable --now kubelet

### ===================================== join cluster =====================================

# Control plane 執行:
kubeadm token create --print-join-command

# Worker nodes 再來加入 - 記得加 sudo