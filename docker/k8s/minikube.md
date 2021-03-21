# minikube

- 2021/01/23
- 單機版的 k8s, 適合開發 & 練習用
- 至少需要 CPU*2 && 2 GB RAM, 否則可能會導致不穩定
- 只能在本地玩! 無法 by VM 來看到管理介面!!

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -ivh minikube-latest.x86_64.rpm

### 底下這個不要使用 root
minikube start
# 會去抓一個練習用的 Image && deploy, 會花些時間
minikube status
minikube stop
minikube ip

### 進入 minikube 中
minikube ssh

### 查看我們的 cluster (看到很多容器)
kubectl get po -A

### 開啟管理儀表板
minikube dashboard
# 只能在本地看
```

Deploy APP

```bash
### 建立 Pod (yml 內需要是 kind: Pod!?)
kubectl create -f xxx.yaml

### 查詢 Pods 數量
kubectl get pods

kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-minikube --type=NodePort --port=8080

kubectl get services hello-minikube

### 運行服務
minikube service hello-minikube
# 會隨機跳 port

kubectl port-forward service/hello-minikube 7080:8080
# 自行指定 port 為 7080

kubectl create deployment balanced --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment balanced --type=LoadBalancer --port=8080
```