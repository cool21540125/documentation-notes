


```bash
### 宿主機執行
$# docker run -it --rm \
    --net host \
    -v "$PWD/.kube:/root/.kube" \
    -v "$PWD:/config" \
    dtzar/helm-kubectl

### ------- 進入 Container ------
$# export KUBECONFIG="/root/.kube/dev.yaml"

### (僅用來確認) 查看部署環境資訊
$# kubectl config view | less
# 用來觀察目前操作的 Cluster 環境


### (僅用來確認) 查看 Namespace 底下的 Deployments
$# kubectl get pods -n ${namespace}    # 請使用 kubectl get ns 來查詢 NS


### 建立要部署上去的設定檔
$# cd xxx    # (需要進入到專案目錄執行)
$# helm template --values values.yaml . > ${namespace}.yaml


### 推送設定檔(執行更新)
$# helm upgrade ${namespace}.yaml -n ${namespace} .


### (僅用來確認) 查看部署歷史
$# helm history ${namespace} -n ${namespace}
# 看最後一筆就可以知道最近一次的 deploy 資訊了


### Rollback 的處理!!!
$# helm rollback ${namespace} -n ${namespace} ${REVISION}
```