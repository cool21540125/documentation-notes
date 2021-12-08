
## kubectl 常用基本命令

```bash
### Imperative  運行 k8s
kubectl run ...


### Declarative 運行 k8s
kubectl create ...  # 僅能用來建立
kubectl apply  ...  # 可用來建立 & 更改運行中的規格
# 會去讀取 yml


### 列出 default NAMESPACE 裏頭的 pods 資訊
kubectl get pods


### 同上, 列出更多資訊
kubectl get pods -o wide


### (前景方式)啟用 ip-forward
kubectl port-forward --address $IP pod/POD_NAME FORWARD_PORT:POD_SERVICE_PORT
# ex: kubectl port-forward --address $IP pod/a1 9999:8888
# 本地可訪問 http://POD_IP:9999


### 進入到 pod 裏頭
kubectl exec -it POD_NAME -- bash


### 移除 pod
kubectl delete pods POD_NAME
# master 會送 SIGNAL 給 pod, 並且作 peaceful shutdown
# 所已關閉 pod 時間可能會有點久


### 取得 pod 運作狀態
kubectl describe pods POD_NAME


### 取得 pod 運作的資訊(前提是, pod 需要存在)
kubectl logs POD_NAME


### 列出與 Application 有關的 k8s 物件 (並非所有 k8s 物件)
kubectl get all


### 針對 pod 內的 Container 執行命令
kubectl exec Pod_Name -c Container_Name -- Execution_Command
# 等同於 docker exec Container_Name Execution_Command


### 進入容器執行互動式 sh
kubectl exec -it Pod_Name -c Container_Name -- sh
# 等同於 docker exec -it Container_Name sh


### 查看 log
kubectl logs Pod_Name -c Container_Name


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


###
$# kubectl get pods -n kube-system -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP              NODE   NOMINATED NODE   READINESS GATES
coredns-78fcd69978-lp4ww     1/1     Running   4          20d   10.233.0.11     m1     <none>           <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
coredns-78fcd69978-ps277     1/1     Running   4          20d   10.233.0.10     m1     <none>           <none>  # k8s 內建提供 DNS 服務的 Pods. load-balance
etcd-m1                      1/1     Running   6          20d   192.168.152.4   m1     <none>           <none>
kube-apiserver-m1            1/1     Running   6          20d   192.168.152.4   m1     <none>           <none>
kube-controller-manager-m1   1/1     Running   8          20d   192.168.152.4   m1     <none>           <none>
kube-flannel-ds-7plcb        1/1     Running   4          20d   192.168.152.4   m1     <none>           <none>
kube-flannel-ds-j9cfb        1/1     Running   3          20d   192.168.152.6   w1     <none>           <none>
kube-flannel-ds-v92v4        1/1     Running   1          20d   192.168.152.7   w2     <none>           <none>
kube-proxy-dgcmf             1/1     Running   3          20d   192.168.152.7   w2     <none>           <none>
kube-proxy-fl75v             1/1     Running   6          20d   192.168.152.4   m1     <none>           <none>
kube-proxy-m4vz7             1/1     Running   4          20d   192.168.152.6   w1     <none>           <none>
kube-scheduler-m1            1/1     Running   9          20d   192.168.152.4   m1     <none>           <none>
```