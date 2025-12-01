
Type of storage      | live time
---------------------|-------------------
Container filesystem | Container lifetime
Volume               | Pod lifetime
Persistent volume    | Cluster lifetime


- 一個 Volume 只能給一個 Pod 使用 (這邊指的 Volume, 應該就是指 Pod 的 Volume, 而非 PV)
- k8s 支援的 Volume 類型
  - k8s 內部資源物件類型
  - 開放原始碼共用儲存類型
  - 儲存廠商提供的硬體存放裝置
  - 公有雲提供的儲存
- 宿主基本機存放區 類型 (與 Node 綁定):
  - [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)
  - [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
  - [Local]
- PV 和 網路共用儲存類型:
  - CephFS / Ceph (開源分散式系統)
    - 基於 RADOS (Reliable Autonomic Distributed Object Store); better for block-based I/O
  - Cinder : OpenStack Block Storage
  - CSI
  - FC
  - FlexVolume : storage plugins 的擴展機制 (k8s 的進階Storage機制)
  - Flocker : 開源容器 Data Volume Manager for Dockerized App
  - GlusterFS(Gluster File System) (開源分散式系統)
    - 基於 TCP/IP 或 InfiniBand Remote Direct Memory Access (RDMA); better for file-based I/O
  - iSCSI
  - Local
  - NFS
  - [persistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/volumes/#persistentvolumeclaim)
    - *persistentVolumeClaim volume* 用來 mount persistentVolume 到 Pod
    - persistentVolumeClaim 可使用在不清楚 Cloud Environment 時, 用來 claim *durable storage* 的方式
      - durable storage, ex: iSCSI, GCE PersistentDisk
  - Portworx
  - QuobyteVolumes
  - RBD
- 儲存廠商提供的 Volume
  - ScaleIO Volumes
  - StorageOS
  - VsphereVolume
- 公有雲廠商提供的 Volume
  - AWSElasticBlockStorage
  - AzureDisk
  - AzureFile
  - GCEPersistentDisk

```yaml
### Pod 使用 Volume 的配置
spec:
  volumes:
    xxx
  containers:
    volumeMounts:
      xxx
```
