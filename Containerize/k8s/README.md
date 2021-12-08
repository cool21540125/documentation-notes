
- [為什麼使用 Kubernetes](https://blog.gcp.expert/kubernetes-gke-introduction/)
- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [k8s-30天](https://ithelp.ithome.com.tw/articles/10192401)
- [raft演算法(去中心化)-超簡明解說](http://thesecretlivesofdata.com/raft/)



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