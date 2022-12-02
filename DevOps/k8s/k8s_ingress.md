
# k8s Ingress

```
因為

Pod <--> External Service <--> Client

不是很好, 底下這個更棒

Pod <--> Internal Service <--> Ingress <--> Client
```

Ingress 僅為 interface, 由 `Ingress Controller` 來 implementation

- 為 Cluster 增加 ingress 最常見的方法為:
    - add an Ingress controller
    - add a LoadBalancer
- Ingress 裡面必須要有 4 個部分:
    - apiVersion
    - kind
    - metadata
    - spec

