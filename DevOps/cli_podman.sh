#!/bin/bash
exit 0
#
# NOTE: podman 的 Image 必須要完整名稱
#       如 docker.io/library/nginx:latest
#
# IMPORTANT: podman 並無 daemon 的概念, 因此無法開機後自動啟用
#
#
# -------------------------------------------------------------------


### 建立 pod
podman pod create --name MyPod101 -p 8080:80
podman pod list

### 建立 container 加入到 pod
podman run -d \
  --pod MyPod101 \
  --name mongo \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=admin \
  -v /home/ubuntu/mongo_data:/data/db \
  docker.io/library/mongo

### 
podman run -d \
  --pod MyPod101 \
  --name app \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=admin \
  -e ME_CONFIG_MONGODB_SERVER=localhost \
  docker.io/library/mongo-express
# 留意 server 位置, pod 使用 localhost 通訊

### 
podman ps --pod


### 把 Pod 導出到 k8s
podman generate kube MyPod101 > mypod101.yaml
# 文件與 k8s 兼容


### 使用 k8s manifest 啟動 Pod
podman play kube mypod101.yaml


### ======================================= 開機後自動運行 podman pods =======================================
podman generate systemd \
  --name MyPod101 --name --files > ~/.config/systemd/user/podman_MyPod101.service

systemctl --user daemon-reload
systemctl --user enable podman_MyPod101.service
sudo loginctl enable-linger $(whoami)