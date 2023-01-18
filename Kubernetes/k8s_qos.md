
# Configure Quality of Service for Pods

- https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/
- k8s 建立 Pod 的時候, 該 Pod 被賦予了特定一種 `QoS classes`:
    - Guaranteed
        - 要件:
            - 每個 Containers, Pod 必須要有 memory limit 及 memory request
            - Pod 內的每個 Container, memory limit 必須等同於 memory request
            - 每個 Containers, Pod 必須要有 CPU limit 及 memory request
            - Pod 內的每個 Container, CPU limit 必須等同於 memory request
        - Example:
            ```yaml
                ...
                # 符合 Guaranteed 要件的 Container spec
                resources:
                    limits:
                        cpu: 700m
                        memory: 200Mi
                    requests:
                        cpu: 700m
                        memory: 200Mi
            ```
    - Burstable
        - 要件:
            - Pod 不符合 Guaranteed
            - Pod 之中至少有一個 Container 具備 memory or CPU request or limit
        - Example:
            ```yaml
                ...
                # 符合 Burstable
                resources:
                    limits:
                        memory: "200Mi"
                    requests:
                        memory: "100Mi"
            ```
    - BestEffort
        - 要件: Containers in the Pod must not have any memory or CPU limits or requests
        - Example:
            ```yaml
                ...
                # 沒有限定 requests 及 limits
                spec:
                    containers:
                    - name: qos-demo-3-ctr
                        image: nginx
            ```
- 如果一個 Pod, 只有設定 `resources.limits`, 則 k8s 會自動將他的 `resources.requests` 設定一樣
    - 也就是說, 只設定了 `resources.limits` 的 Pod, 會是個 Guaranteed Pod
