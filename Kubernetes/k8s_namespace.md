
## k8s namespace 概述

- Structure your components
- Avoid conflicts between teams
    - 如果不同團隊 k8s object 名稱一樣, 會把對方資源蓋掉
- Share services between different environments
    - 像是 ELK, logging system, 可讓各種環境共用
- Access and Resource Limits on Namespaces Level
    - 可針對 Namespace 做資源限制, 避免某個 NS 將資源耗盡

```bash
$# kubectl get namespace
NAME              STATUS   AGE
default           Active   21h   # 如果沒指定, 通通都會丟到這
kube-node-lease   Active   21h   # (不曉得這幹嘛)
kube-public       Active   21h   # (不曉得這幹嘛)
kube-system       Active   21h   # 不要去動!!!
my-namespace      Active   4h9m  # custom


### 指定 NS 建立資源
$# kubectl apply -f ${Component.yaml} --namespace=${NameOfNamespace}
# 「--namespace=xxx」 可改成 「-n xxx」
# 或是直接在 yaml config file 裡頭的 metadata 指定 namespace: xxx
```


## namespace 工具

- k8s 預設的 namespace 為名為 default 的 Namespace
- 有個 CLI 叫做 `kubens`, 可用來修改 default namespace

```bash
### 需先安裝 kubectx
$# kubens
default    # 顏色會不一樣, 表示此為預設
kube-node-lease
kube-public
kube-system
my-namespace

$# kubens my-namespace  # 切換 default namespace 為 my-namespace
Context "minikube" modified.
Active namespace is "my-namespace".
```


## k8s namespace 限制

- 不同的 NS 裡頭的 ConfigMap, 無法讓其他 NS 來做使用 (每個 NS 都得自行設定自己的 ConfigMap)
    - Secret 同 ConfigMap
- 不同於 ConfigMap 與 Secret, Service 則是可以提供給不同 NS 來做使用, 但須做些調整~
    - yaml 檔裡頭的 `data key: value`, value 必須為 `.${NAMESPACE}` 結尾
    - ex: 原為 `db_url: mysql-service`, 假如此 URL 放在名為 prod 的 NS
        - 則應改為 `db_url: mysql-service.prod`
- 並非所有 k8s component 都可以被放入特定 NS, ex: Volume
    - 如下

```bash
### 可列出所有 not bound to a namespace 的 components
$# kubectl api-resources --namespaced=false
NAME                            SHORTNAMES   APIVERSION                        NAMESPACED   KIND
componentstatuses               cs           v1                                false        ComponentStatus
namespaces                      ns           v1                                false        Namespace
nodes                           no           v1                                false        Node
persistentvolumes               pv           v1                                false        PersistentVolume
mutatingwebhookconfigurations                admissionregistration.k8s.io/v1   false        MutatingWebhookConfiguration
clusterrolebindings                          rbac.authorization.k8s.io/v1      false        ClusterRoleBinding
clusterroles                                 rbac.authorization.k8s.io/v1      false        ClusterRole
priorityclasses                 pc           scheduling.k8s.io/v1              false        PriorityClass
csidrivers                                   storage.k8s.io/v1                 false        CSIDriver
csinodes                                     storage.k8s.io/v1                 false        CSINode
storageclasses                  sc           storage.k8s.io/v1                 false        StorageClass
volumeattachments                            storage.k8s.io/v1                 false        VolumeAttachment
# (僅隨意擷取部分)
```


## 


