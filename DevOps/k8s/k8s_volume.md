
- 種類
    - Persistent Volume, PV
        - `kind: PersistentVolume`
        - 無法被歸類到 namespace
    - Persistent Volume Claim
    - Storage Class
- Storage Requirement
    - 不依賴於 Pod lifecycle
    - available on all nodes
    - survive when cluster crash


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


