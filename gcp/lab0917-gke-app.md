# [Deploy an app to a GKE cluster](https://cloud.google.com/kubernetes-engine/docs/deploy-app-cluster?cloudshell=true#main.go)

- 2022/09/17 GKE lab
- 先去啟用底下的 API
    - Artifact Registry API
    - Google Kubernetes Engine API
- 這個範例其實沒幹嘛...
    - 只是用 GKE 來示範如何用 CLI 做必要的環境配置 && 授權
    - create cluster && create deployment && expose service... 然後把他們砍了
    - 營養價值及複習價值不高...
- 進入 CloudShell

```bash
# GCP zones 清單: https://cloud.google.com/compute/docs/regions-zones#available
$# PROJECT=lab0917-gke-app
$# gcloud config set project ${PROJECT}
$# REGION=asia-east1
$# gcloud config set compute/region ${REGION}

### 建立一個 GKE cluster: hello-cluster (會花好幾分鐘...)
$# gcloud container clusters create-auto hello-cluster
# 如果遇到 Pod address range limits the maximum size of the cluster 再來看 https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr
Creating cluster hello-cluster in asia-east1... Cluster is being health-checked...done.     
Created [https://container.googleapis.com/v1/projects/lab0917-gke-app/zones/asia-east1/clusters/hello-cluster].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-east1/hello-cluster?project=lab0917-gke-app
kubeconfig entry generated for hello-cluster.
NAME: hello-cluster
LOCATION: asia-east1
MASTER_VERSION: 1.22.12-gke.300
MASTER_IP: 34.80.145.181
MACHINE_TYPE: e2-medium  # 太哭了, 機器給我開 medium 在那邊燒錢
NODE_VERSION: 1.22.12-gke.300
NUM_NODES: 3
STATUS: RUNNING
# 目前已知建立了 k8s cluster, 名為 hello-cluster
# 有 3 台運行中的 nodes 在燒錢


### Get authentication credentials for the cluster
$# gcloud container clusters get-credentials hello-cluster
# cloudshell 裡頭一開始就有 2 種 CLI: gcloud && kubectl
# 此指令授權給 kubectl 來操作此 cluster


# k8s 提供了 Deployment object 用來 deploy APP, ex: web servers. 
# k8s 提供了 Service objects define rules && load balancing for accessing 來讓 internet 訪問 APP


### 指定 image && 在 Cluster 裡頭建立 deployment, 名為 hello-server
$# kubectl create deployment hello-server \
    --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
Warning: Autopilot set default resource requests for Deployment default/hello-server, as resource requests were not specified. See http://g.co/gke/autopilot-defaults.
deployment.apps/hello-server created
# cluster mode 使用預設的 autopilot (暫時不知道是啥)
# 這個 Deployment's Pod 負責運行 hello-app 這個 image


### APP 部署完以後, 就把它 expose 到 internet
$# kubectl expose deployment hello-server \
    --type LoadBalancer \
    --port 80 \
    --target-port 8080
service/hello-server exposed
# --type LoadBalancer : 會建立一台 Compute Engine load balancer for your container... (又要燒錢)
# ASK: 如何知道 service/hello-server 是否已經 exposed?


### Inspect the running Pods
$# kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
hello-server-8444b8cdf-5s925   1/1     Running   0          13m


### Inspect the hello-server Service
$# kubectl get service hello-server
NAME           TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
hello-server   LoadBalancer   10.17.2.36   35.201.180.40   80:30929/TCP   2m11s
#                                          ^^^^^^^^^^^^^ 廢物 APP 出爐


### 為了錢包著想, 記得把它毀了
$# kubectl delete service hello-server
service "hello-server" deleted
# 看到這個才能確認服務已刪除

### 最主要依然是 cluster 裡頭的機器在燒錢
$# gcloud container clusters delete hello-cluster
The following clusters will be deleted.
 - [hello-cluster] in [asia-east1]

Do you want to continue (Y/n)?  y   # yyyy

Deleting cluster hello-cluster...working 
Deleted [https://container.googleapis.com/v1/projects/lab0917-gke-app/zones/asia-east1/clusters/hello-cluster].
# 看到這個表示已刪除 cluster
```


# 此範例 image 的 Dockerfile

```dockerfile
FROM golang:1.8-alpine
ADD . /go/src/hello-app
RUN go install hello-app

FROM alpine:latest
COPY --from=0 /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
```
