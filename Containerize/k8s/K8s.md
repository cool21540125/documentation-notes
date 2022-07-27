- [為什麼使用 Kubernetes](https://blog.gcp.expert/kubernetes-gke-introduction/)
- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [k8s-30天](https://ithelp.ithome.com.tw/articles/10192401)
- [raft演算法(去中心化)-超簡明解說](http://thesecretlivesofdata.com/raft/)


# 一些必要名詞之間的定義 && 釐清

- kubeadm: 用來啟動 cluster
- kubelet: 安裝在 nodes 上頭, 用來啟動 pods && containers (與 API Server 溝通), 可理解成是 Node 上頭的 Docker 代理
- kubectl: k8s master 用來與 cluster 溝通使用
- etcd: Master Node 們的 分散式資料庫系統.
- kube-proxy: 給 kubectl && kubelet 進行 API Server 連線


# 架構

![Learn Kubernetes Basics](./img/k8s_arch-1024x437.png)

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

