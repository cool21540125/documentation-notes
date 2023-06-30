
# Taints,  Tolerations

- 2 種因素決定 `哪種 Pod` 運行在 `哪種 Node`
    - Node 的 Taint (某人的污點標籤)
    - Pod 的 Toleration (某人對於有特定 污點標籤 的人的 **免疫力**)
    - 這 2 者決定了, Scheduler 會如何安排 Pods 到哪些 Nodes 上頭去運行
- Scheduler 基本上不會安排 Pods 到 k8s Master Nodes
    - Master Nodes 上頭有 `node-role.kubernetes.io/master:NoSchedule` 這個 Taint

```bash
### 把 NODE 貼上 TAINT 的 Key Value 標籤, 並標記 TAINT_EFFECT
kubectl taint nodes $NODE $TAINT_KEY=$TAINT_VALUE:$TAINT_EFFECT
# TAINT_EFFECT
#    NoSchedule       : new Pod 別來,    old Pod 不影響
#    PreferNoSchedule : new Pod 盡量別來, old Pod 不影響
#    NoExecute        : new Pod 別來,    old Pod 請你搬家


### 範例
kubectl taint nodes node1 app=myapp:NoSchedule     # 加上標籤
kubectl taint nodes node1 app=myapp:NoSchedule-    # 移除標籤


### 查詢 Node 具有的 Taints
kubectl describe node $NODE | grep Taint
```

```yaml
### 此 CLI 使用後
# kubectl taint nodes node1 app=myapp:NoSchedule

### Pod Definition 如果是這樣的話, 則將來不會再 schedule 到上述的 Node, (現有 Pod 也不會有動作)
spec:
  containers:
  - name: xxx
    image: xxx
  tolerations:
  - key: "app"
    operator: "myapp"
    value: "Equal"
    effect: "NoSchedule"
```


# Node Affinity

- 讓 Nodes 吸引特定 Pods (無論 硬體限制 or 偏好)
- 有 2 個 Properties:
    - Taints (污點)
        - 讓 Nodes 排斥特定 Pods
    - Tolerations
        - 用來讓 scheduler 調度 *帶有特定污點的 Pods*
        - 僅允許調度, 但不保證調度 (不懂這句話意思)
- 此兩者 taints 及 tolerations 相互配合, 用以確保 Pods 不會被分配到不適合的 Nodes


# 確切安排 Pods 到哪些 Nodes

- 有底下 2 種方式
    - Node Selector
    - Node Affinity

```bash
### 
kubectl label nodes $NODE $LABEL_KEY=$LABEL_VALUE


### 指示 node-1 增加標籤
kubectl label nodes node-1 size=Large
# yaml 內: spec.nodeSelector.size=Large
```
