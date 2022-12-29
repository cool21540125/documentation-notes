
## kubectl CLI

```bash
### Imperative  運行 k8s
$# kubectl run ...
# 等同於命令式的 docker run (盡量不要這樣用)


### Declarative 運行 k8s
$# kubectl create -f ${YAML_FILE.yml}  # 依照配置 建立     資源
$# kubectl apply  -f ${YAML_FILE.yml}  # 依照配置 建立/更新 資源
$# kubectl delete -f ${YAML_FILE.yml}  # 依照配置 刪除     資源
# 會去讀取 yml


### 列出 default NAMESPACE 裏頭的 pods 資訊
$# kubectl get po  # po/pod/pods 都可以...


### 同上, 列出更多資訊
$# kubectl get pods -o wide


### 
$# kubectl get pod --show-labels
NAME            READY   STATUS    RESTARTS   AGE   LABELS
my-helloworld   1/1     Running   0          9s    app=helloworld


###
$# kubectl get pods -n kube-system -o wide
NAME                        READY  STATUS   RESTARTS  AGE  IP             NODE  NOMINATED NODE  READINESS GATES
coredns-78fcd69978-lp4ww    1/1    Running  4         20d  10.233.0.11    m1    <none>          <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
coredns-78fcd69978-ps277    1/1    Running  4         20d  10.233.0.10    m1    <none>          <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
etcd-m1                     1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
kube-apiserver-m1           1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
kube-controller-manager-m1  1/1    Running  8         20d  192.168.152.4  m1    <none>          <none>
kube-flannel-ds-7plcb       1/1    Running  4         20d  192.168.152.4  m1    <none>          <none>
kube-flannel-ds-j9cfb       1/1    Running  3         20d  192.168.152.6  w1    <none>          <none>
kube-flannel-ds-v92v4       1/1    Running  1         20d  192.168.152.7  w2    <none>          <none>
kube-proxy-dgcmf            1/1    Running  3         20d  192.168.152.7  w2    <none>          <none>
kube-proxy-fl75v            1/1    Running  6         20d  192.168.152.4  m1    <none>          <none>
kube-proxy-m4vz7            1/1    Running  4         20d  192.168.152.6  w1    <none>          <none>
kube-scheduler-m1           1/1    Running  9         20d  192.168.152.4  m1    <none>          <none>


### (前景方式)啟用 ip-forward
$# kubectl port-forward --address $IP pod/${POD_NAME} ${FORWARD_PORT}:${POD_SERVICE_PORT}
# ex: 
$# kubectl port-forward --address $IP pod/a1 9999:8888
# 本地可訪問 http://POD_IP:9999


### 查看 Services 與 Endpoints 的對應
$# kubectl get endpoints


### 快速建立 (ClusterIP) Service (port 則等同於 Pod 的 containerPort)
$# kubectl expose deployment ${Deployment}
# 不過依舊建議使用 yaml 統一管理 Service

### 進入到 pod 裏頭
$# kubectl exec -it ${POD_NAME} -- /bin/sh
# 等同於 docker exec -it ${ContainerName} /bin/sh


### Deployment 運作過程中升級 Image
$# kubectl set image deployment/${Deployment} ${Container}=${Image}:${ImageTag}
# ex: kubectl edit deploy/nginx-deployment nginx=nginx:1.20.2

### 移除 pod
$# kubectl delete pods ${POD_NAME}
# master 會送 SIGNAL 給 pod, 並且作 peaceful shutdown
# 不過如果有使用 ReplicaSet.... 效果等同於重新建立新的 pod


### 取得 pod 運作狀態
$# kubectl describe pods ${POD_NAME}


### 取得 pod 運作的資訊(前提是, pod 需要存在)
$# kubectl logs ${POD_NAME}


### 列出與 Application 有關的 k8s 物件 (並非所有 k8s 物件)
$# kubectl get all


### 針對 pod 內的 Container 執行命令
$# kubectl exec ${PodName} -c ${ContainerName} -- commands
# 等同於 docker exec Container_Name commands


### 進入容器執行互動式 sh
$# kubectl exec -it ${PodName} -c ${ContainerName} -- sh
# 等同於 docker exec -it Container_Name sh


### 查看 log
$# kubectl logs ${PodName} -c ${ContainerName}


### 列出所有 k8s Namespace
$# $ kubectl get ns
NAME              STATUS   AGE
default           Active   20d
kube-node-lease   Active   20d
kube-public       Active   20d
kube-system       Active   20d


### k8s DNS(內建 Service) 位置, 一定會是 10.X.X.10 && 固定會開啟 53 & 9153 port
$# kubectl -n kube-system get service
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.98.0.10   <none>        53/UDP,53/TCP,9153/TCP   20d
# k8s 的 DNS


### 進入 Pod 中的 Container
$# kubectl -it  $PodName -c $Container -- bash


### 列出 Container logs
$# kubectl logs $PodName -c $Container


### k8s DNS(內建 Pod)
$# kubectl describe service kube-dns -n kube-system
Name:              kube-dns
Namespace:         kube-system
Labels:            k8s-app=kube-dns
                   kubernetes.io/cluster-service=true
                   kubernetes.io/name=CoreDNS
Annotations:       prometheus.io/port: 9153
                   prometheus.io/scrape: true
Selector:          k8s-app=kube-dns
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.98.0.10
IPs:               10.98.0.10
Port:              dns  53/UDP
TargetPort:        53/UDP
Endpoints:         10.233.0.10:53,10.233.0.11:53  # DNS pod, 位於 ClusterIP 的位置
Port:              dns-tcp  53/TCP
TargetPort:        53/TCP
Endpoints:         10.233.0.10:53,10.233.0.11:53
Port:              metrics  9153/TCP
TargetPort:        9153/TCP
Endpoints:         10.233.0.10:9153,10.233.0.11:9153
Session Affinity:  None
Events:            <none>


### 將目前 NS 的 config 列出為 yaml
$# kubectl get configmap -o yaml
# (但我還不知道怎麼解讀)


### 
$# kubectl port-forward ${PodName} ${LocalPort}:${PodPort}
Forwarding from 127.0.0.1:${LocalPort} -> ${PodPort}
Forwarding from [::1]:${LocalPort} -> ${PodPort}
Handling connection for ${LocalPort}
# 本地可訪問 localhost:${LocalPort}


### 
$# kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:60229
CoreDNS is running at https://127.0.0.1:60229/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.


### 如果某次進版導致錯誤, 可使用此方式回退
$# kubectl rollout undo deployment/${DeploymentName}
$# helm rollback -n ${namespace} ${release} ${REVISION}


### 查看 Deployment 更新過程
$# kubectl rollout status deployment/${Deployment}


### 查看 Deployent 的部署歷史
$# kubectl rollout history deployment/${Deployment}


### 查看特定 Deployment 部署歷史
$# kubectl rollout history deployment/${Deployment} --revision=N


### 暫停/還原 Deployment (若要用 kubectl edit 接連修改, 可用這個避免頻繁更新)
$# kubectl rollout pause deployment/${Deployment}
$# kubectl rollout resume deployment/${Deployment}


### 顯示目前有哪些 context
$# kubectl config get-contexts
CURRENT   NAME                  CLUSTER               AUTHINFO   NAMESPACE
*         str                   str                   str        
          str-demo-k8s-str-02   str-demo-k8s-str-02   str        
          str-demo-k8s-str-03   str-demo-k8s-str-03   str        
          str-demo-k8s-str01    str-demo-k8s-str01    str


### 
$# 
```
