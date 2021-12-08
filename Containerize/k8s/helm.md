


- k8s (system) 的套件管理員
- 


```bash
$# helm repo add stable https://charts.helm.sh/stable
"stable" has been added to your repositories


$# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈


$# helm repo list
NAME    URL
stable  https://charts.helm.sh/stable

### 2021/11 的現在, 會有一大堆 DEPRECATED (推測是大型贊助者不贊助了)
$# helm search repo stable | grep -v DEPRECATED


### Example: 增加 Dynamic Volume Provider
$# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
"nfs-subdir-external-provisioner" has been added to your repositories

$# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nfs-subdir-external-provisioner" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈

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

$# kubectl get storageclass
NAME                   PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-client (default)   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   21s

### 說穿了, dynamic volume provision 也是個 pod
$# kubectl get deployment
NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
nfs-subdir-external-provisioner   1/1     1            1           37s

### 
$# 
```