# minikube

- 2022/09/19
- 單機版的 k8s, 適合開發 & 練習用
- 至少需要 CPU*2 && 2 GB RAM, 否則可能會導致不穩定
- 只能在本地玩! 無法 by VM 來看到管理介面!!
- [minikube start](https://minikube.sigs.k8s.io/docs/start/)


```bash
$# minikube version
minikube version: v1.26.1
commit: 62e108c3dfdec8029a890ad6d8ef96b6461426dc
# Win10 2022/09/19 版本


### 啟動單機版本的 Kubernetes Cluster
$# minikube start

### halt cluster
$# minikube stop

### Pause Kubernetes without impacting deployed applications
$# minikube pause
$# minikube unpause

$# minikube status


$# minikube ip

### 清空 minikube cluster 環境
$# minikube delete --all

### 進入 minikube 中
$# minikube ssh

### Cluster all pods
$# kubectl get po -A

### 開啟管理儀表板
$# minikube dashboard
# 只能在本地看
```
