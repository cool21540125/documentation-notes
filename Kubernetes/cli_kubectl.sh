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

### 基本上這應該是第一步, 確認能對 cluster 做些什麼
kubectl auth can-i --list


### 可查到 k8s resources 的各種 kind 的關鍵字樣
k get api-resources


### =============================================== 基本操作 ===============================================

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


### =============================================== port-forward ===============================================
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

# 針對 deployment 手動擴增 pods 數量
kubectl scale --replicas=3 deployment/deployA

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

### ===================================== k8s Node =====================================

### 如果是 Standalone Cluster 的測試環境, 用來將此 Worker Node(Controller Node) 移除 taint (好讓 Pod 可以做部署)
kubectl taint nodes MY_K8S_NODE_NAME node-role.kubernetes.io/control-plane-
kubectl taint nodes MY_K8S_CONTROL_PLANE_NODE node-role.kubernetes.io/control-plane:NoSchedule-  # 移除 control plane 身上的 label, 讓他可以跑 pods


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


### ===================================== k8s kustomize =====================================

## 參考 kustomize CLI
kubectl apply -k ${DIR_TO_kustomization_yaml}
kustomize build ${DIR_TO_kustomization_yaml} | kubectl apply -f -
# 上面兩者基本上同樣用途, 但需要留意 kubectl 與 kustomize 版本問題

### ===================================== k8s config =====================================

### 設定與 cluster 的連線
kubectl config set-cluster

### 顯示目前有哪些 context
kubectl config get-contexts
#CURRENT  NAME                                               CLUSTER                                            AUTHINFO                                           NAMESPACE
#*        arn:aws:eks:us-west-2:123456789012:cluster/devops  arn:aws:eks:us-west-2:123456789012:cluster/devops  arn:aws:eks:us-west-2:123456789012:cluster/devops
#         default                                            docker-desktop                                     docker-desktop
#         docker-desktop                                     docker-desktop                                     docker-desktop

### 查看目前 kubectl CLI 使用的是哪個 context (位於 ~/.kube/config)
kubectl config current-context
#docker-desktop

### (永久設定) 會去修改 修改 ~/.kube/config 的內容
kubectl config set-context --current --namespace=o11y    # 修改 ~/.kube/config 目前 context 的 namespace
kubectl config set-context --current --namespace=default # 修改 ~/.kube/config 目前 context 的 namespace

### 直接切換 context (必須事先聲明 context name 於 ~/.kube/config)
kubectl config use-context o11y # 變更目前 context (像是 o11y 必須聲明在 ~/.kube/confg 的 contexts)

### 查看合併後的 kubeconfig 設定
kubectl config view
kubectl config view --minify # 不知道加了以後差在哪邊...

### ===================================== k8s cluster =====================================

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

### ===================================== k8s CSR =====================================
#
# 新人加入團隊以後, 老鳥要給新的 admin權限
#

### 新人給了老鳥他的 CSR 以後, 老鳥建立 csr



### ===================================== k8s 系統維護相關 =====================================

### Node 升級/維護的相關操作
kubectl drain $NODE    # 對 NODE 上的 Pods 進行排水 + 設立警戒
kubectl cordon $NODE   # 對 NODE 設立警戒 (Pod 舊的不去新的不來)
kubectl uncordon $NODE # 拔除 NODE 的警戒

kubectl drain $NODE --ignore-daemonsets # 排水(DaemonSet 一樣滾~) + 警戒


### ===================================== k8s patch =====================================

## 如果要移除 Ingress, 需確定它的 finalizers 為空 (此外, ALB 需要額外獨立移除)
ing=
kubectl patch ing $ing -p '{"metadata":{"finalizers":[]}}' --type=merge




### ===================================== k8s 權限操作 =====================================

## non-admin 使用
kubectl auth can-i create deployment
kubectl auth can-i delete nodes

## admin 設定完權限後可用來測試
kubectl auth can-i create deployment --as dev-user
kubectl auth can-i create pods --as dev-user

### 