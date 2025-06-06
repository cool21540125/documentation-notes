# Install kubernetes

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
    - 6443 - API Server
    - 2379~2380 - etcd (Api Server 及 etcd 使用)
    - 10250 - kubelet
    - 10257 - controller
    - 10259 - scheduler
  - Worker Nodes
    - 10250 - kubelet
    - 30000~32767 - NodePorts
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

## 法 2. From Scratch -- Ubuntu 24.04 - arm64

```bash
### Part 1 - kubectl
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg gpg

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
chmod u+x kubectl
sudo mv kubectl /usr/local/bin/
echo 'alias k=kubectl' >> ~/.bashrc

### Part 2 - native package management
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# NOTE: 底下這行 ONLY FOR v1.33 (每個版本都需要各自獨立一行)
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt install containerd

sudo apt update
sudo apt install -y kubelet kubeadm

sudo systemctl enable --now kubelet

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system


```

# Kubernetes - PKI

```bash
export ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > encryption-config.yaml <<EOF
apiVersion: v1
kind: EncryptionConfig
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
```

```bash
# NOTE: etcd 3.4 版以後, 會去偵測 ETCD_NAME 這個環境變數, 如果又同時使用 --name xxx 的話, 會產生錯誤
export _ETCD_NAME=infra1
export INTERNAL_IP=10.200.0.11
export INTERNAL_IP0=10.200.0.10
export INTERNAL_IP1=10.200.0.11
export INTERNAL_IP2=10.200.0.12
export ETCD_INITIAL_CLUSTER="infra0=https://${INTERNAL_IP0}:2380,infra1=https://${INTERNAL_IP1}:2380,infra2=https://${INTERNAL_IP2}:2380"


envsubst < etcd.service.tmpl > /usr/lib/systemd/system/etcd.service
systemctl daemon-reload
systemctl stop etcd
systemctl start etcd
systemctl status etcd

etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.crt --cert=/etc/etcd/etcd.crt --key=/etc/etcd/etcd.key member list
```
