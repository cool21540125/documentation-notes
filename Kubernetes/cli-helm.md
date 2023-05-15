
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
        - Helm v2 版有這東西. 但由於 Helm Server 能夠去對 k8s 做 Create/Update/Delete, 權限太大有安全疑慮, v3 就沒有 Tiller 了~
        - Helm v3 只剩下 helm binary (無 Tiller)


# helm CLI

```bash
### 本地不安裝 helm CLI 的情況下, 使用 helm docker container 來操作 k8s

### 宿主機執行
docker run -it --rm \
    --net host \
    -v "$PWD/.kube:/root/.kube" \
    -v "$PWD:/config" \
    dtzar/helm-kubectl

### ------- 進入 Container ------
export KUBECONFIG="/root/.kube/XXX.yaml"
```


# misc

```bash
### 新建一個 Chart (可理解成 git init NewGitProjectFromScratch)
$# helm create ${NewChartFromScratch}


### 增加 helm 訂閱的 helm repository
$# helm repo add stable https://charts.helm.sh/stable
"stable" has been added to your repositories

$# helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" has been added to your repositories

$# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
"nfs-subdir-external-provisioner" has been added to your repositories
# Example: 增加 Dynamic Volume Provider


### 列出 helm client 以追蹤的 helm repository
$# helm repo list
NAME    URL
stable  https://charts.helm.sh/stable     
bitnami https://charts.bitnami.com/bitnami


### 搜尋 特定 helm repo
$# helm search repo ${Helm_Repo_Name}


### 排除特定
$# helm search repo ${Helm_Repo_Name} | grep -v DEPRECATED
### 2021/11 的現在, 會有一大堆 DEPRECATED (推測是大型贊助者不贊助了)


### 有點像是 apt-get update 那種感覺...
$# helm repo update ${Helm_Repo_Name}
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nfs-subdir-external-provisioner" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈


### 由本地的 Helm Charts 部署 Release
$# helm install -f ${PATH_to_valuesyaml} ${ReleaseName} ${PATH_to_ChartDir}
$# helm install ${Installed_Release_Name} ${Local_Helm_Repo_Name}/${Chart_Name_From_Helm_Repo}
$# helm install -f values.yaml ${Local_Helm_Repo_Name}/${Chart_Name_From_Helm_Repo}

$# helm upgrade -f ${PATH_to_valuesyaml} ${ReleaseName} ${PATH_to_ChartDir}
### 
$# helm upgrade ${ChartName}
# 應該等同於 kubectl apply 吧?!

### 安裝 nfs-subdir-external-provisioner, 並設定幾個值覆寫預設
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
# --values=${MyYamlFile}, 可自行定義變數來自其他的 values2.yaml
#     則 values2.yaml 裡頭的變數, 將可覆寫 values.yaml(default)
# 不管是 --values=xxx 或 --set xx=xx
#     最終都會產生出 「.Values object」


### 僅測試(語法驗證等), 但不保證可行
$# helm install --debug --dry-run ${ReleaseName} ${Release_Definition_Source}
# ex: helm install --debug --dry-run goodly-guppy ./mychart


### 
$# helm rollback ${ChartName}


### 列出 Release 所有的 k8s resources
$# helm get manifest ${ReleaseName}


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