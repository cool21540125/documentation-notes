
## 架構簡圖

![Learn Kubernetes Basics](./img/k8s_arch-1024x437.png)

```mermaid
flowchart LR

subgraph w1["Worker Node"]
    kp["kube-proxy"]
    kt("kubelet")
    subgraph CRI
        subgraph Pod
            ctn["Container"]
        end
    end

    kp --> Pod
    kt --> Pod
end

subgraph ControlPlane
    apisrv("API Server")
    apisrv --> etcd;
    Scheduler --> apisrv;
    cm["Controller Manager"] --> apisrv;
end

kl{"kubectl"} --> apisrv;
ii(("internet")) --> kp;
apisrv --> kt;
```


# 流程
