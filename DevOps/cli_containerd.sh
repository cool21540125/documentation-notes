#!/bin/bash
exit 0
# ------------------------------

### 2025 的現在, 目前有 v1 及 v2
containerd --version
#containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da

### 如果 containerd 的配置檔被改爛了的話, 可以用這個指令重置
containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd
systemctl status containerd

### 

[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.10"