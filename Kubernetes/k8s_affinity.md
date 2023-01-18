
- 


# Taints and Tolerations

- Node affinity
    - 讓 Nodes 吸引特定 Pods (無論 硬體限制 or 偏好)
    - 有 2 個 Properties:
        - Taints (污點)
            - 讓 Nodes 排斥特定 Pods
        - Tolerations
            - 用來讓 scheduler 調度 *帶有特定污點的 Pods*
            - 僅允許調度, 但不保證調度 (不懂這句話意思)
    - 此兩者 taints 及 tolerations 相互配合, 用以確保 Pods 不會被分配到不適合的 Nodes
    - 
