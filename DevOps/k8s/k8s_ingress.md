
# k8s Ingress

```
因為

Pod <--> External Service <--> Client

不是很好, 底下這個更棒

Pod <--> Internal Service <--> Ingress <--> Client
```

Ingress 僅為 interface, 由 `Ingress Controller` 來 implementation