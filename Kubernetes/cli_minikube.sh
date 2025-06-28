#!/bin/bash
exit 0
# ----------------------------------------------------------------------

minikube version
#minikube version: v1.27.0
#commit: 4243041b7a72319b9be7842a7d34b6767bbdac2b

### 啟動單機版本的 Kubernetes Cluster
minikube start

### halt cluster
minikube stop

### Pause Kubernetes without impacting deployed applications
minikube pause
minikube unpause
minikube status

minikube ip
#192.168.49.2

### 清空 minikube cluster 環境
minikube delete --all

### 進入 minikube 中
minikube ssh

### Cluster all pods
kubectl get po -A

### (無法重置)
minikube proxy
#Starting to serve on 127.0.0.1:8001
# 畫面 hang 住 (似乎可看到 k8s APIs)

### 訪問 minikube Service
minikube service ${SERVICE_NAME}
# 因為 minikube 比較特別的關係... EXTERNAL-IP 會一直是 <pending>, 需要用此方式來訪問
# 此 ${SERVICE_NAME} 必須為對外提供服務的 Service, 會用 Browser 開啟

### Ingress Controller Pod
kubectl get pod --namespace=ingress-nginx
#NAME READY STATUS RESTARTS AGE
#ingress-nginx-admission-create-jxlh4 0/1 Completed 0 4m9s
#ingress-nginx-admission-patch-cs6g9 0/1 Completed 1 4m9s
#ingress-nginx-controller-755dfbfc65-tngnk 1/1 Running 0 4m9s
# 早期版本會存在於 kube-system Namespace

### ------------------------------------ minikube addons ------------------------------------

### 查看目前可啟用的 addons
minikube addons list

minikube addons enable ${ADDON_NAME}

### expose addon 的 Entrypoint
minikube addons open ${ADDON_NAME}

### 開啟管理儀表板
minikube addons enable dashboard
#minikube dashboard
#🤔 Verifying dashboard health ...
#🚀 Launching proxy ...
#🤔 Verifying proxy health ...
#🎉 Opening http://127.0.0.1:60268/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
## 只能在本地看

### 啟用 kubelet 的 cAdvisor
minikube addons enable metrics-server # 這裡頭才是啟用 cAdvisor
# minikube addons enable cadvisor     # WARNING: 沒有這東西
# 啟用了以後, 要等個一兩分鐘, 就可以查看 node 了:
k top node
k top pod

### 啟用 ingress
minikube addons enable ingress
#💡 ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
#You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
#💡 After the addon is enabled, please run "minikube tunnel" and your ingress resources would be available at "127.0.0.1"
#▪ Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
#▪ Using image k8s.gcr.io/ingress-nginx/controller:v1.2.1
#▪ Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
#🔎 Verifying ingress addon...
#🌟 The 'ingress' addon is enabled
#
# 自動啟用 K8s Nginx implementation of Ingress Controller
# minikube addons disable ingress
