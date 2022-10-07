
- Helm
    - Package Manager for Kubernetes - Helm
    - template Engine
        - Template 定義在 `values.yaml`; 使用 `{{ .values.xxx.yyy }}` 取值
- Helm Public Repository
    - Helm Hub
    - Helm Charts Pages
- Release Management
    - Helm Client:
        - helm CLI
    - Helm Server: Tiller
        - Helm v2 版有這東西. 不過 Helm v3 因為 helm 過於強大有一些安全性管理的議題因而移除
        - Helm v3 只剩下 helm binary


```bash
### 
$# helm repo add stable https://charts.helm.sh/stable
"stable" has been added to your repositories


$# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nfs-subdir-external-provisioner" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈


### 
$# helm repo list
NAME    URL
stable  https://charts.helm.sh/stable


### 
$# helm search repo stable | grep -v DEPRECATED
### 2021/11 的現在, 會有一大堆 DEPRECATED (推測是大型贊助者不贊助了)

### 
$# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
"nfs-subdir-external-provisioner" has been added to your repositories
# Example: 增加 Dynamic Volume Provider


### 
$# helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set storageClass.defaultClass=true \
--set nfs.server=192.168.152.4 \
--set nfs.path=/opt/nfs
NAME: nfs-subdir-external-provisioner
LAST DEPLOYED: Sat Nov 20 13:51:30 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None


### install helm pkgs && 指定特定變數值(來自自訂 yaml file)
$# helm install --values=${MyYamlFile} ${ChartName}
# 預設會吃 values.yaml, 但裡頭的值會被 ${MyYamlFile} 的值覆蓋
# 或者
$# helm install --set ${KEY}=${Value}
# 可用命令式指令來動態設定 value (不過此方法建議少用就是了... 不易追蹤)


### 
$# helm up grade ${ChartName}
# 應該等同於 kubectl apply 吧?!


### 
$# helm rollback ${ChartName}


### 
$# kubectl get storageclass
NAME                   PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-client (default)   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   21s

### 
$# kubectl get deployment
NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
nfs-subdir-external-provisioner   1/1     1            1           37s
# 說穿了, dynamic volume provision 也是個 pod


### 
$# helm search <keyword>
```