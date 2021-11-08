
## 常用基本命令

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

###


```