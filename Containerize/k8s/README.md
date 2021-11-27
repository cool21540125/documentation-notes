
- [為什麼使用 Kubernetes](https://blog.gcp.expert/kubernetes-gke-introduction/)
- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [k8s-30天](https://ithelp.ithome.com.tw/articles/10192401)
- [raft演算法(去中心化)-超簡明解說](http://thesecretlivesofdata.com/raft/)



## 元件 & 名詞

- K8s Cluster
  - k8s 架構下的所有 Workers && Masters
- Worker Node
  - k8s 最小硬體單位
  - 一台機器 or VM
  - 每個 Node 都有 3 個元件:
    - kubelet
        - 安裝在 Node 上面的管理員(daemon), 負責與 Pods 及 Master 溝通
        - 用來啟動 pods && containers (與 API Server 溝通), 可理解成是 Node 上頭的 Container 代理
    - kube-proxy : 讓其他 Nodes 上的其他物件可以與此 Node 內的 Pods 溝通 (處理 iptables)
    - Container Runtime, Pod : 容器執行環境
- Master Node
  - 內有 4 個元件:
    - Etcd : 存放所有叢集相關的資料
    - kube-apiserver : 使用 kubectl 所下的指令, 都會跑到這裡; Workers 之間溝通的橋樑; k8s 內的身分認證&&授權
    - kube-scheduler : 對資源的調度, 負責分配任務到到 Nodes 上頭的 Pod 來執行
    - kube-controller-manager : 負責監控 Cluster 內的一個 Process(對於各個資源的管理器)
    - DNS: 紀錄啟動 Pods 的位址
- API Server
    - 所有 REST commands 訪問的 Entrypoint, 用來控制整個 cluster
- etcd storage
    - Distributed & Key-Value Store
    - 共享組態配置
    - Service Discovery (CoreDNS)
    - 提供 RESTful API 來對特定 WorkerNodes 更新組態, 並且告知其於 Cluster Nodes 相關配置已改變
    - Meta Store, 用來儲存整個 k8s 的資訊區
    - Deployment object
      - 裏頭會有 `Replicaset Controller`
- kubectl: 安裝在 k8s master 上面的 CLI, 用來與 cluster 溝通使用
- Scheduler
    - 
- service: 為 k8s 分散式叢集架構的核心
    - 擁有唯一的指定名稱
    - 擁有一組 IP:port, 提供遠端服務能力. 每個服務處理程序都有獨立的 Endpoint(IP+Port), 但 k8s 讓我們可透過 Service (Cluster IP+Service Port) 連接到 Service
    - 被對應到提供這種服務能力的一組容器應用上
- Pod : k8s 運作的最小單位, 一個 Pod 對應一個服務, ex: API Server
    - 每個 Pod 都有個專屬的定義, 也就是 `yml` 檔
    - 一個 Pod 可有 1~N 個 Container, 但有 [文章](https://medium.com/@C.W.Hu/kubernetes-basic-concept-tutorial-e033e3504ec0) 寫說最好只有一個
    - Pod 內的 Containers 共享資源 && 網路, 理解成一個家庭提供單一服務, 但家庭成員之間共享家庭內的一切.
- kubeadm(非必要) : 建立&管理 k8s cluster.
- kind(非必要, Deprecated) : 用來運行 local computer 的 k8s
- minikube(用來取代 kind): 用來運行 single-node 的 k8s cluster


# K8s Interface

k8s 只有制定了 3 個介面

- CRI, 容器運行介面
- CNI, 容器網路介面
- CSI, 容器儲存介面


# 一些必要名詞之間的定義 && 釐清

K8s 平台的選擇:

- Bare Metal
- Cloud
  - GCP - Google GKE
  - AWS - Amazon EKS
  - Azure - Azure AKS
- 平台供應商(都會包裝 Bare Metal)
  - RedHat OpenShift
  - VMware Tanzu
  - Rancher : 三者中較為便宜


# 架構

## 1. k8s master 元件

- Etcd
- API Server
- Controller Manager Server

## 2. k8s node 元件

- Kubelet
- Proxy
- Pod
- Container

---


### Container Runtime Interface(CRI)

↓↓↓↓↓↓↓↓↓↓ 這知識可能過期了
k8s 需要這環境來運行 Container (與 Container 溝通的介面), 預設會依照底下去尋找:
- Docker: /var/run/docker.sock  (Docker 內建的 CRI 實作為 `dockershim`, 與 kubelet 於 18.09 整合起來了)
- containerd: /run/containerd/containerd.sock
- CRI-O: /var/run/crio/crio.sock
↑↑↑↑↑↑↑↑↑↑ 這知識可能過期了

So far, 2021/10/30, k8s 以使用 CRI-O 來實作 CRI

配置 control-plane node 上面 kubelet 需要使用的 cgroup driver

若使用的是 Docker, kubelet 會自動偵測 cgroup driver, 並於 Runtime 期間設定於 `/var/lib/kubelet/config.yaml`


# kubernetes CRI 架構演進圖

```
kubelet -> Dockershim              -> Docker Engine -> Containerd -> Containerd-shim -> OCI runtime -> container
kubelet -> CRI-Containerd          ->                  Containerd -> Containerd-shim -> OCI runtime -> container
kubelet -> Containerd + CRI Plugin ->                                Containerd-shim -> OCI runtime -> container
kubelet -> CRI-O                                                                     -> OCI runtime -> container
           ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ 
                          CRI
```




# 安裝

安裝方式, 看[這裡](https://github.com/cool21540125/documentation-notes/blob/master/linux/install/installCentOS7.md#install-k8s)

需要確保 主叢 之間的 **MAC Address** && **product_uuid** 必須都是不同的 (如果再 VM 內, 可能會一樣)

- `ip link`
- `cat /sys/class/dmi/id/product_uuid`



# k3s

- 內建 Ingress
- 內建 Dynamic Volume Provision



# 未整理雜訊

- k8s service 的 CLUSTER-IP 不會變動; 而 pod IP 可能會變動
- k8s apply vs create
  - The key difference between kubectl apply and create is that apply creates Kubernetes objects through a declarative syntax, while the create command is imperative.
  - kubectl apply : declarative syntax, 可用來改變已 deploy 的規格 && 也可用來首次建立
  - kubectl create : imperative, 只能用來首次建立