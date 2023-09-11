

pod

- 只能運行在同一台主機上, 無法跨主機
- 所有 pods 總量的資源限制, 不可超過 pod 所在主機的 80%
- pods 靠著 label 來做 Scheduling Management


# Static Pod (靜態 Pod)

- Static Pod 由 kubelet 建立, 但是 kubelet 無法對它進行健檢
    - 啟動方式, 運行 kubelet daemon 的時候, 會定期去掃:
        - 直接指定
            - kubelet 運行命令加上此選項: `--pod-manifest-path=/etc/Kubernetes/manifest`
            - 指定 statis pods yaml 的資料夾
        - 間接指定 (kube admin tool 使用此種方式):
            - kubelet 運行命令加上此選項: `--config=kubeconfig.yaml`
            - 在此 yaml 內聲明 `staticPodPath: /etc/Kubernetes/manifest`
- Static Pod 只能用來建立 Pods, 與 ReplicationController, Deployment, DaemonSet 無關
    - 不過也可用此來建立 Api Server / Scheduler / Controller Manager
- Static Pod 對於 Api Server 為 ReadOnly
    - Static Pod Name 會自動補上 node name 作為 suffix


# health

- k8s 對於 Pod 的健康狀態
    - 有下列 3 種 probe(探針) 檢測:
        - LivenessProbe
            - 判斷 Container 是否 Running(存活)
            - 若判斷為不健康, 則 kubelet 會將此 Container 殺掉
            - 如果沒設定此檢測, 預設永遠為 Success
        - ReadinessProbe
            - 判斷 Container 是否 Ready(可用)
            - 達到 Ready, Pod 才可 接收/處理 請求
            - 這也是 Service 判斷能否將請求送往此 Pod 的依據
        - StartupProbe
            - 用於啟動需要很久的情況
    - 不管是採用哪種 probe(探針)檢測, 都可使用下列的實現方式:
        - ExecAction
            - 藉由命令執行後的 Exit Code
            ```yaml
            livenessProbe:
              exec:
                command:
                  - cat
                  - /tmp/health
            ```
        - TCPSocketAction
            - 藉由偵測 Container 的 Socket + port
            ```yaml
            livenessProbe:
              tcpSocket:
                port: 80
            ```
        - HTTPGetAction
            - 藉由訪問 Container 的 Endpoint
            ```yaml
            livenessProbe:
              httpGet:
                path: /__check
                port: 80
            ```
    - 不管採用哪種檢測實現方式, 都需要配置:
        - initialDelaySeconds
            - Container 啟動後, 進行 首次檢測 的 等待秒數
        - timeoutSeconds
            - 健康檢查發送請求後的 等待回應的逾時秒數