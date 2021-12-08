# k8s service type

提供了 4 種方式

- ClusterIP
    - 預設的 ServiceType
    - Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster.
    - 可指定 1~N 個 Node IP, 用來提供服務 (自動映射到 ClusterIP)
- NodePort
    - 可將 Cluster Port 映射到 宿主機的 port (宿主機防火牆開了以後, 可對外提供服務)
    - 會對所有的 Nodes 都對外提供服務
    - Port 可用範圍為 30000-32767
    - Exposes the service on each Node’s IP at a static port (the NodePort). A ClusterIP service, to which the NodePort service will route, is automatically created. You’ll be able to contact the NodePort service, from outside the cluster, by requesting <NodeIP>:<NodePort>.
- LoadBalancer
- ExternalName
