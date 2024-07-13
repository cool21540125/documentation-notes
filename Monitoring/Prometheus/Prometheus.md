# Prometheus

- Prometheus server 對 agent 做 pull metrics. Agent 揭露 監控物件(target) 的方式如下:
    - 靜態檔案設定
    - 動態發現(Auto Discovery)
        - 目前有支援的系統(藉由自動發現, 取得監控物件):
            - Container Platform : K8s, Marathon
            - Cloud              : EC2, Azure, OpenStack
            - Service            : DNS, ZooKeeper, Consul
- target 狀態:
    - unknown : (一開始被加入時)
    - up      : 成功擷取
    - down    : 擷取失敗 (timeout, ...)
- Endpoints
    - '/metrics'
    - '/federate'
        - 讓 Prometheus 可以串 Prometheus
    - '/graph'
        - GUI 介面
