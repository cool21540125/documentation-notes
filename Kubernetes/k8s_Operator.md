
- [Setup Prometheus Monitoring on Kubernetes using Helm and Prometheus Operator | Part 1](https://www.youtube.com/watch?v=QoDqxm7ybLc)
- [OperatorHub.io](https://operatorhub.io/)


### Operator 主要用於 **Stateful** Applications

- k8s 可以完全處理 **Stateless Apps**
- 不過對於 **Stateful Apps**
    - ex: mysql, ELK, RabbitMQ, ...
    - 因為具備較多的業務邏輯, 且每個節點都是不同的東西 (有不同的 ID, 不同的 Status, ...), 因而無法完全藉由 Stateful 來處理
    - 因而可考慮 Operators (取代 human operators), ex: 
        - mysql-operator
        - prometheus-operator
        - rabbitmq-operator
- 使用此 Operators 來建構 **Stateful Apps**, k8s 便能夠完全自動化管理他們
- 如果需要自幹自己的 Operators, 則應從 Operator SDK 著手研究...
- k8s 使用 Control Loop 機制, 來管控 Pods
    - Stateless Apps
        - 藉由 k8s 原有的 Control Loop 來做 增/刪/改
    - (Operators)Stateful Apps
        - 與 k8s 原有的 Control Loop 機制一樣 做 增/刪/改
            - 因此可把 Operators 想成是個 *Custom Control Loop* 
        - Operators 也使用了 `CRD, Custom Resource Definitions(客製化的 k8s 物件啦)`
            - 由 k8s API 擴展出來~
        - Controller 其實就是個 `reconciliation loop`
            - 會去解析 desired state, 並隨時監控 actual state, 讓他盡可能靠近 desired state


### 經常安裝服務, 會面臨兩個選擇, 使用 helm OR 使用 Operator ??

- [Helm or Operator SDK with Kubernetes: Why not both? | DevNation Tech Talk](https://www.youtube.com/watch?v=N9QVJk6kjwg)
