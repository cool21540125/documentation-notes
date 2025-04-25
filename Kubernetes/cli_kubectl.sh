#!/bin/bash
exit 0
#
# 懶人快速指令...
#   k get svc           # service
#   k get cj            # cronjob
#   k get po            # pods
#   k get ns            # namespace
#   k get deploy        # deployment
#   k get no            # nodes
#   k get cm            # configmap
#   k get rs            # replicaset
#   k get sts           # statefulset
#   k get storageclass  # storageclass
#
# ----------------------------------------------------------------------

kubectl version
#Client Version: v1.32.3
#Kustomize Version: v5.5.0
#Server Version: v1.30.5
#WARNING: version difference between client (1.32) and server (1.30) exceeds the supported minor version skew of +/-1

# Basic Usage

### Imperative  運行 k8s
kubectl run ...
# 等同於命令式的 docker run (盡量不要這樣用)

### Declarative 運行 k8s
YAML_FILE=example.yaml
kubectl create -f $YAML_FILE # 依照配置 建立     資源
kubectl apply -f $YAML_FILE  # 依照配置 建立/更新 資源
kubectl delete -f $YAML_FILE # 依照配置 刪除     資源
# 會去讀取 yml

### 列出 default NAMESPACE 裏頭的 pods 資訊
kubectl get po # po/pod/pods 都可以...

### 同上, 列出更多資訊
kubectl get pods -o wide

###
kubectl get pod --show-labels
#NAME            READY   STATUS    RESTARTS   AGE   LABELS
#my-helloworld   1/1     Running   0          9s    app=helloworld

### 查看 kube-system Namespace 底下 pods 的詳細資訊
kubectl get pods -n kube-system -o wide
#NAME                        READY  STATUS   RESTARTS  AGE  IP             NODE  NOMINATED NODE  READINESS GATES
#coredns-78fcd69978-lp4ww    1/1    Running  4         20d  10.233.0.11    m1    <none>          <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
#coredns-78fcd69978-ps277    1/1    Running  4         20d  10.233.0.10    m1    <none>          <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
#etcd-m1                     1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
#kube-apiserver-m1           1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
#kube-controller-manager-m1  1/1    Running  8         20d  192.168.152.4  m1    <none>          <none>
#kube-flannel-ds-7plcb       1/1    Running  4         20d  192.168.152.4  m1    <none>          <none>
#kube-flannel-ds-j9cfb       1/1    Running  3         20d  192.168.152.6  w1    <none>          <none>
#kube-flannel-ds-v92v4       1/1    Running  1         20d  192.168.152.7  w2    <none>          <none>
#kube-proxy-dgcmf            1/1    Running  3         20d  192.168.152.7  w2    <none>          <none>
#kube-proxy-fl75v            1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
#kube-proxy-m4vz7            1/1    Running  4         20d  192.168.152.6  w1    <none>          <none>
#kube-scheduler-m1           1/1    Running  9         20d  192.168.152.4  m1    <none>          <none>

### (前景方式)啟用 ip-forward (port forwarding)
### kubectl port-forward --address $IP pod/${PodName} ${FORWARD_PORT}:${POD_SERVICE_PORT}
### $# kubectl port-forward ${PodName} ${LocalPort}:${PodPort}
kubectl port-forward --address $IP pod/a1 9999:8888
#Forwarding from 127.0.0.1:${LocalPort} -> ${PodPort}
#Forwarding from [::1]:${LocalPort} -> ${PodPort}
#Handling connection for ${LocalPort}
# 本地可訪問 http://POD_IP:9999   # localhost:${LocalPort}

### 查看 Services 與 Endpoints 的對應
kubectl get endpoints

### 快速建立 (ClusterIP) Service (port 則等同於 Pod 的 containerPort)
kubectl expose deployment ${Deployment}
# 不過依舊建議使用 yaml 統一管理 Service

### 進入 Pod 取得 sh
kubectl exec -it ${PodName} -- /bin/sh
kubectl exec -it ${PodName} -c ${ContainerName} -- sh
# 等同於 docker exec -it ContainerName sh

kubectl exec ${PodName} -c ${ContainerName} -- ${Commands}
# 等同於 docker exec ContainerName commands

### Deployment 運作過程中升級 Image
kubectl set image deployment/${Deployment} ${Container}=${Image}:${ImageTag}
# ex: kubectl edit deploy/nginx-deployment nginx=nginx:1.20.2

### 移除 pod
kubectl delete pods ${PodName}
# master 會送 SIGNAL 給 pod, 並且作 peaceful shutdown
# 不過如果有使用 ReplicaSet.... 效果等同於重新建立新的 pod

### 取得 pod 運作狀態
kubectl describe pods ${PodName}

### 列出所有 k8s Namespace
$ kubectl get ns
#NAME              STATUS   AGE
#default           Active   20d
#kube-node-lease   Active   20d
#kube-public       Active   20d
#kube-system       Active   20d

### 列出與 Application 有關的 k8s 物件 (並非所有 k8s 物件)
kubectl get all

### 查看 logs - Pod logs (前提是, pod 需要存在)
kubectl logs ${PodName}

### 查看 logs - Container logs
kubectl logs ${PodName} -c ${ContainerName}

### ===================================== xxx =====================================
### ===================================== xxx =====================================
### ===================================== xxx =====================================

### 依照狀態找 pods
kubectl get pods --field-selector status.phase=Running
# status.phase = Pending / Running / Succeeded / Failed / Unknown

### 依照特定以支援的 operators 找 pods
kubectl get pods \
  --all-namespaces \
  --field-selector=metadata.namespace!=default
# 如果沒有 --all-namespaces, 預設會到 default namespace 找到後, 再做 filter

### 查看 nodes 資源耗用狀態 (需要依賴 Metrics Server)
kubectl top nodes

### 查看 pods 資源耗用狀態 (需要依賴 Metrics Server)
kubectl top pods -n kube-system

### ===================================== k8s rollback (升級/回滾) =====================================

### 如果某次進版導致錯誤, 可使用此方式回退
kubectl rollout undo deployment/${DeploymentName}
helm rollback -n ${namespace} ${release} ${REVISION}

### 查看 Deployment 更新過程
kubectl rollout status deployment/${Deployment}

### 查看 Deployent 的部署歷史
kubectl rollout history deployment/${Deployment}

### 查看特定 Deployment 部署歷史
kubectl rollout history deployment/${Deployment} --revision=N

### 暫停/還原 Deployment (若要用 kubectl edit 接連修改, 可用這個避免頻繁更新)
kubectl rollout pause deployment/${Deployment}
kubectl rollout resume deployment/${Deployment}

### ===================================== ConfigMap =====================================

### impariative - CLI 方式建立 Key-Value ConfigMap - 傻傻的直接一個個宣告
#kubectl create secret ${SecretName} \
kubectl create configmap ${ConfigMapName} \
  --from-literal=Key1=Value2 \
  --from-literal=Key2=Value2

### impariative - CLI 方式建立 Key-Value ConfigMap - Use File
#kubectl create secret ${SecretName} \
kubectl create configmap ${ConfigMapName} \
  --from-file=${ConfigFileName}

### 查詢 ConfigMap 內容
kubectl get configmap -o yaml

### ===================================== k8s System =====================================

### k8s DNS(內建 Service) 位置, 一定會是 10.X.X.10 && 固定會開啟 53 & 9153 port
kubectl -n kube-system get service
#NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
#kube-dns   ClusterIP   10.98.0.10   <none>        53/UDP,53/TCP,9153/TCP   20d
# k8s 的 DNS

### k8s DNS(內建 Pod)
kubectl describe service kube-dns -n kube-system
#Name:              kube-dns
#Namespace:         kube-system
#Labels:            k8s-app=kube-dns
#                   kubernetes.io/cluster-service=true
#                   kubernetes.io/name=CoreDNS
#Annotations:       prometheus.io/port: 9153
#                   prometheus.io/scrape: true
#Selector:          k8s-app=kube-dns
#Type:              ClusterIP
#IP Family Policy:  SingleStack
#IP Families:       IPv4
#IP:                10.98.0.10
#IPs:               10.98.0.10
#Port:              dns  53/UDP
#TargetPort:        53/UDP
#Endpoints:         10.233.0.10:53,10.233.0.11:53  # DNS pod, 位於 ClusterIP 的位置
#Port:              dns-tcp  53/TCP
#TargetPort:        53/TCP
#Endpoints:         10.233.0.10:53,10.233.0.11:53
#Port:              metrics  9153/TCP
#TargetPort:        9153/TCP
#Endpoints:         10.233.0.10:9153,10.233.0.11:9153
#Session Affinity:  None
#Events:            <none>

### 設定與 cluster 的連線
kubectl config set-cluster

### 顯示目前有哪些 context
kubectl config get-contexts
#CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
#*         docker-desktop   docker-desktop   docker-desktop
## 上面這兩行是因為我跑在 Macbook 的 Docker Desktop

### 查看合併後的 kubeconfig 設定
kubectl config view

### 查詢 kubectl 指向了哪個 k8s cluster (可藉由 KUBECONFIG 變更)
kubectl cluster-info
#Kubernetes control plane is running at https://127.0.0.1:6443
#CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
#
#To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

###
kubectl get apiservices
#NAME                              SERVICE                      AVAILABLE   AGE
#v1.                               Local                        True        452d
#v1.admissionregistration.k8s.io   Local                        True        452d
#v1.apiextensions.k8s.io           Local                        True        452d
#v1beta1.metrics.k8s.io            kube-system/metrics-server   True        452d  # 表示 resource metrics API 有啟用
# 僅節錄部分

###

### ===================================== k8s 系統維護相關 =====================================

### Node 升級/維護的相關操作
kubectl drain $NODE    # 對 NODE 上的 Pods 進行排水 + 設立警戒
kubectl cordon $NODE   # 對 NODE 設立警戒 (Pod 舊的不去新的不來)
kubectl uncordon $NODE # 拔除 NODE 的警戒

kubectl drain $NODE --ignore-daemonsets # 排水(DaemonSet 一樣滾~) + 警戒
