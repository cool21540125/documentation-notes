

pod

- 只能運行在同一台主機上, 無法跨主機
- 所有 pods 總量的資源限制, 不可超過 pod 所在主機的 80%
- pods 靠著 label 來做 Scheduling Management


# Static Pod (靜態 Pod)

- 無法與 ReplicationController, Deployment, DaemonSet 進行連結
- 由 kubelet 建立
    - 但是 kubelet 無法對它進行健檢
- 僅存在於 Node 上頭
    - 不能透過 API Server 進行管理
- 建立方式可使用 設定檔 or HTTP 方式來建立, 遇到再學
