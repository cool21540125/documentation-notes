- [為什麼使用 Kubernetes](https://blog.gcp.expert/kubernetes-gke-introduction/)
- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [k8s-30天](https://ithelp.ithome.com.tw/articles/10192401)
- [raft演算法(去中心化)-超簡明解說](http://thesecretlivesofdata.com/raft/)

# 基本組成

- Pod : k8s 運作的最小單位, 一個 Pod 對應一個服務, ex: API Server
  - 每個 Pod 都有個專屬的定義, 也就是 `yml` 檔
  - 一個 Pod 可有 1~N 個 Container, 但有 [文章](https://medium.com/@C.W.Hu/kubernetes-basic-concept-tutorial-e033e3504ec0) 寫說最好只有一個
  - Pod 內的 Containers 共享資源 && 網路, 理解成一個家庭提供單一服務, 但家庭成員之間共享家庭內的一切.
- Worker Node
  - k8s 最小硬體單位
  - 一台機器 or VM
  - 每個 Node 都有 3 個元件:
    - kubelet : Node 上的管理員, 負責與 Pods 及 Master 溝通
    - kube-proxy : 讓其他 Nodes 上的其他物件可以與此 Node 內的 Pods 溝通 (處理 iptables)
    - Container Runtime : 容器執行環境
- Master Node
  - 內有 4 個元件:
    - Etcd : 存放所有叢集相關的資料
    - kube-apiserver : 使用 kubectl 所下的指令, 都會跑到這裡; Workers 之間溝通的橋樑; k8s 內的身分認證&&授權
    - kube-scheduler : 對資源的調度, 負責分配任務到到 Nodes 上頭的 Pod 來執行
    - kube-controller-manager : 負責監控 Cluster 內的一個 Process(對於各個資源的管理器)
    - DNS: 紀錄啟動 Pods 的位址
- Cluster
  - k8s 架構下的所有 Workers && Masters


# 一些必要名詞之間的定義 && 釐清

- kubeadm: 用來啟動 cluster
- kubelet: 安裝在 nodes 上頭, 用來啟動 pods && containers (與 API Server 溝通), 可理解成是 Node 上頭的 Docker 代理
- kubectl: k8s master 用來與 cluster 溝通使用
- etcd: Master Node 們的 分散式資料庫系統.
- kube-proxy: 給 kubectl && kubelet 進行 API Server 連線


# 架構

![Learn Kubernetes Basics](../img/k8s_arch-1024x437.png)

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

`Container Runtime Interface(CRI)`: k8s 用來與 Container 溝通的介面. 預設會依照底下去尋找:

- Docker: /var/run/docker.sock  (Docker 內建的 CRI 實作為 `dockershim`, 與 kubelet 於 18.09 整合起來了)
- containerd: /run/containerd/containerd.sock
- CRI-O: /var/run/crio/crio.sock

---


# 安裝

安裝方式, 看[這裡](https://github.com/cool21540125/documentation-notes/blob/master/linux/install/installCentOS7.md#install-k8s)

需要確保 主叢 之間的 **MAC Address** && **product_uuid** 必須都是不同的 (如果再 VM 內, 可能會一樣)

- `ip link`
- `cat /sys/class/dmi/id/product_uuid`

