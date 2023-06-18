
Type of storage      | live time
-------------------- | ------------
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
        - 一開始永遠會是個空資料夾. 此為 ephemeral volumes
            - empty at Pod startup, with storage coming locally from the kubelet base directory (usually the root disk) or RAM
        - emptyDir 會在 Pod 被分配到 Node 的時候才產生. 因此直接被 Node 上頭的 kubelet 管理
        - lifecycle 同 Pod, 如果目前 Pod 消失, 那這個 emptyDir volume 就掰了
            - 不過如果是 Pod 內的 Container 掛了, emptyDir volume 不受影響就是了
            - Pod 裡頭的 Containers 可共享 emptyDir volume 裡頭的東西
    - [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
        - 2022/09 的現在, HostPath volume 已被告知存在許多安全性議題!!! 能不使用就不要用!!!
        - *hostPath volume* 把 Node 所在的 Filesystem 的 File/Directory mount 到 Pod
        - lifecycle 同 Node, 因此除非 Node 掛了, volume 才會消失
        - Use cases:
            - 運行 CAdvisor, 需要把使用 `hostPath: /sys`
            - Container 需要使用到 Node 上的 Docker root, `hostPath: /var/lib/docker`
            - Pod 建立以前, 需要確保特定目錄已存在, `hostPath: /path/should/exist`
        - hostPath.type 為 optional, 遇到在學...
        - 缺點: Volume 與 Node 綁定, 無法跨主機共享
    - [Local]
- PV 和 網路共用儲存類型:
    - CephFS
    - Cinder
    - CSI
    - FC
    - FlexVolume
    - Flocker
    - GlusterFS
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
