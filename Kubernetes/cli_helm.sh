#!/bin/bash
exit 0
#
# Helm 主要工作 : 在 Repository 找到所需要的 Chart, 然後將 Chart 以 Release 的形式安裝到 k8s
# 每個 Release 都會有他目前的 Revision
#
# Helm Repositories: Appscode / TrueCharts / Bitnami / Kubeapps / Community Operators / etc.
# 上面這些 Repositories, 有個共通的 single location: Helm Hub, 也就是 artifacthub.io

# -----------------------------------------------------------------

### =========== Settings ===========
export KUBECONFIG=~/.kube/XXX.yaml


### ========================================= Helm 安裝 Charts 標準操作 =========================================
# Case1. 簡化一切, 直接使用 install
helm show values oci://8gears.container-registry.com/library/n8n --version 1.0.0 > default-values.yaml
cp default-values.yaml values.yaml
# 編輯 values.yaml
helm install n8nPoc oci://8gears.container-registry.com/library/n8n --version 1.0.0 -f values.yaml

# Case2. 先下載完整 Charts, 修改後再 install (可完整控制, 但複雜)
helm pull oci://8gears.container-registry.com/library/n8n --version 1.0.0 --untar
# 可以拿到一整包完整的 n8n 資料夾, 裡頭會有完整的 Chart 資訊

### ========================================= Helm repository 操作 =========================================

### 增加訂閱 add Helm Repo
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
#"nfs-subdir-external-provisioner" has been added to your repositories
#(增加 Dynamic Volume Provider)

### 列出追蹤的 Helm repository
helm repo list
#NAME    URL
#grafana https://grafana.github.io/helm-charts
#stable  https://charts.helm.sh/stable
#bitnami https://charts.bitnami.com/bitnami

### 確保可以抓到 latest charts (同 apt-get update)
helm repo update
helm repo update ${Helm_Repo_Name}
#Hang tight while we grab the latest from your chart repositories...
#...Successfully got an update from the "nfs-subdir-external-provisioner" chart repository
#...Successfully got an update from the "stable" chart repository
#Update Complete. ⎈Happy Helming!⎈

### 移除 bitnami repo
helm repo remove ${Helm_Repo_Name}

### 如果要安裝的 Helm Charts 有不同版本(並不是要裝 latest), 先看看人家有哪些版本吧
helm search repo ${Helm_Repo_Name} --versions
helm search repo ${Helm_Repo_Name}                      # 搜尋 特定 helm repo
helm search repo ${Helm_Repo_Name} | grep -v DEPRECATED # 排除特定

### ========================================= Helm chart 操作 =========================================

### 新建一個 Chart (可理解成 git init NewGitProjectFromScratch)
helm create NewChartFromScratch
# 有點像是使用 docker-compose 建立整個 compose file 的起手式
# 連帶建立整個 values.yaml / Chart.yaml / templates / charts/

### 列出 releases
helm list
helm list -n $NS
helm list -d       # sort by release date
helm list --all
helm list --uninstalled
helm list uninstalled --failed

### 列出 chart 的 information
helm show chart ${HelmRepo}/${ChartName}
helm show chart ${HelmRepo}/${ChartName} -n $NS

### =============================================== helm install ===============================================
# Example:
#  (X)  helm install bitnami/redis
#  (O)  helm pull --untar bitnami/redis && helm install demo-redis ./redis
# 上面為 不建議 v.s. 建議用法. 這樣本地才會有完整的 Chart 資訊


### 由本地的 Helm Charts 部署 Release
helm install ${ReleaseName} ${HelmRepo}/${ChartName}
helm install -f values.yaml ${ReleaseName} ${PATH_to_ChartDir}
helm install -f values.yaml ${HelmRepo}/${ChartName}

helm install my-n8n oci://8gears.container-registry.com/library/n8n --version 0.20.0

### 依照 Values.yml 安裝 loki Helm Chart
helm install --values values.yml loki grafana/loki -n loki --create-namespace

### 安裝 nfs-subdir-external-provisioner, 並設定幾個值覆寫預設
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set storageClass.defaultClass=true \
    --set nfs.server=192.168.152.4 \
    --set nfs.path=/opt/nfs

#NAME: nfs-subdir-external-provisioner
#LAST DEPLOYED: Sat Nov 20 13:51:30 2021
#NAMESPACE: default
#STATUS: deployed
#REVISION: 1
#TEST SUITE: None

### install helm pkgs && 指定特定變數值(來自自訂 yaml file)
helm install --values=${MyYamlFile} ${ChartName}
# 預設會吃 values.yaml, 但裡頭的值會被 ${MyYamlFile} 的值覆蓋
# 或者
helm install --set ${KEY}=${Value}
# 可用命令式指令來動態設定 value (不過此方法建議少用就是了... 不易追蹤)
# --values=${MyYamlFile}, 可自行定義變數來自其他的 values2.yaml
#     則 values2.yaml 裡頭的變數, 將可覆寫 values.yaml(default)
# 不管是 --values=xxx 或 --set xx=xx
#     最終都會產生出 「.Values object」

helm install --set key="value" my-release bitnami/wordpress

### 僅測試(語法驗證等), 但不保證可行
helm install --debug --dry-run ${ReleaseName} ${Release_Definition_Source}
# ex: helm install --debug --dry-run goodly-guppy ./mychart

### =============================================== helm upgrade ===============================================

helm upgrade -f values.yaml ${ReleaseName} ${PATH_to_ChartDir}
###
helm upgrade ${ChartName}
#應該等同於 kubectl apply 吧?!

# 升級 Release 到指定的 Chart 版本 (可能連同裡頭的 Image 都更新)
helm upgrade $ReleaseName $ChartName --version 1.2.3

### =============================================== helm rollback 退版 ===============================================
# NOTE: helm rollback 只會 rollback 到上個版本, 而不是某個特定的版本 (也就是 git revert 的概念)

helm rollback ${ChartName}
helm rollback ${ChartName} 3 # 指定 Revision (回到 revision 3 的狀態)

### ===============================================

### 列出 Release 所有的 k8s resources
helm get manifest ${ReleaseName}

###
kubectl get storageclass
#NAME                   PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
#nfs-client (default)   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   21s

###
kubectl get deployment
#NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
#nfs-subdir-external-provisioner   1/1     1            1           37s
# 說穿了, dynamic volume provision 也是個 pod

###
helm search $Keyword

# Without install helm locally

### 本地不安裝 helm CLI 的情況下, 使用 helm docker container 來操作 k8s
docker run -it --rm \
    --net host \
    -v "$PWD/.kube:/root/.kube" \
    -v "$PWD:/config" \
    dtzar/helm-kubectl

### --------------------------------- chart hooks ---------------------------------
# Helm Chart hooks 是一種特殊的 template, 會在特定的時機點被執行
# chart hook 好像也可以拿來做 DB restore (不確定)
