
- 種類
    - Persistent Volume, PV
        - `kind: PersistentVolume`
        - 無法被歸類到 namespace
        - Persistent Volumes provide a file system that can be mounted to the cluster, without being associated with any particular node.
    - Persistent Volume Claim
    - Storage Class
- Storage Requirement
    - 不依賴於 Pod lifecycle
    - available on all nodes
    - survive when cluster crash
- Pod 要使用 volume 就必須配置 
    - `.spec.volumes`
    - `.spec.containers.volumeMounts`
- 一個 Volume 只能給一個 Pod 使用
- Volume Types:
    - [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)
        - 一開始永遠會是個空資料夾. 此為 ephemeral volumes
            - empty at Pod startup, with storage coming locally from the kubelet base directory (usually the root disk) or RAM
        - emptyDir 會在 Pod 被分配到 Node 的時候才產生. 因此直接被 Node 上頭的 kubelet 管理
        - lifecycle 同 Pod, 如果目前 Pod 消失, 那這個 emptyDir volume 就掰了
            - 不過如果是 Pod 內的 Container 掛了, emptyDir volume 不受影響就是了
            - Pod 裡頭的 Containers 可共享 emptyDir volume 裡頭的東西
    - [persistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/volumes/#persistentvolumeclaim)
        - *persistentVolumeClaim volume* 用來 mount persistentVolume 到 Pod
        - persistentVolumeClaim 可使用在不清楚 Cloud Environment 時, 用來 claim *durable storage* 的方式
            - durable storage, ex: iSCSI, GCE PersistentDisk
    - [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
        - 2022/09 的現在, HostPath volume 已被告知存在許多安全性議題!!! 能不使用就不要用!!!
        - *hostPath volume* 把 Node 所在的 Filesystem 的 File/Directory mount 到 Pod
        - lifecycle 同 Node, 因此除非 Node 掛了, volume 才會消失
        - Use cases:
            - 運行 CAdvisor, 需要把使用 `hostPath: /sys`
            - Container 需要使用到 Node 上的 Docker root, `hostPath: /var/lib/docker`
            - Pod 建立以前, 需要確保特定目錄已存在, `hostPath: /path/should/exist`
        - hostPath.type 為 optional, 遇到在學...

# k8s volume

Type of storage      | live time
-------------------- | ------------
Container filesystem | Container lifetime
Volume               | Pod lifetime
Persistent volume    | Cluster lifetime

- Container filesystem
    - overlay2
- Volume
    - emptyDir
- Persistent volume
    - hostPath
        - 這機制的一個缺點是, 他只會在產生 Pod 的主機上
        - 如果有其他 worker node 產生相同 pod, 會在那台機器產生全新 volume (跨主機不能共享 or 乘載之前運行的資料)
    - Local
    - NFS


