# [Deploy an app in a container image to a GKE cluster](https://cloud.google.com/kubernetes-engine/docs/quickstarts/deploy-app-container-image)

- 2022/09/17
- 需要啟用底下的 APIs
    - Artifact Registry
    - Cloud Build
    - Kubernetes Engine API
- 比起第一篇, 分別使用 deployment.yaml 及 service.yaml 來管控 Deployment 及 Service


# Create GKE cluster

```bash
$# PROJECT_ID=lab0917-gke-deploy
$# REGION=asia-east1


### project: https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/99fbbfb528462de6b9ffdfe68be4bd38ff3dd225/quickstart/python

# In this quickstart, you will store your container in Artifact Registry and deploy it to your cluster from the registry. Run the following command to create a repository named
# 建立名為 hello-repo 的 「空 repo」 到 Artifact Registry in the same region as your cluster:
$# gcloud artifacts repositories create hello-repo \
    --project=$PROJECT_ID \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository"
Create request issued for: [hello-repo]
Waiting for operation [projects/lab0917-gke-deploy/locations/asia-east1/operations/9b4bd025-a3c1-43eb-8fec-4a725f8a8dbc] to complete...done.     
Created repository [hello-repo].


### 查看 Artifacts repository Metadata
$# gcloud artifacts repositories describe hello-repo --location=$REGION
Encryption: Google-managed key
Repository Size: 0.000MB
createTime: '2022-09-17T14:53:10.125136Z'
description: Docker repository
format: DOCKER
mavenConfig: {}
name: projects/lab0917-gke-deploy/locations/asia-east1/repositories/hello-repo
updateTime: '2022-09-17T14:53:10.125136Z'



### building image. 等同於 docker build + docker push (只是發生在 gcloud)
$# gcloud builds submit \
  --tag $REGION-docker.pkg.dev/$PROJECT_ID/hello-repo/helloworld-gke .
Creating temporary tarball archive of 4 file(s) totalling 1.3 KiB before compression.
Uploading tarball of [.] to [gs://lab0917-gke-deploy_cloudbuild/source/1663426542.476163-bdaacf437f694ec285bb7cf363c66f22.tgz]
Created [https://cloudbuild.googleapis.com/v1/projects/lab0917-gke-deploy/locations/global/builds/ca596a7e-ee27-44e3-a21b-b6c0aa66b734].
Logs are available at [ https://console.cloud.google.com/cloud-build/builds/ca596a7e-ee27-44e3-a21b-b6c0aa66b734?project=470815836715 ].
-------------------------------------------------------------------------------------------------------------- REMOTE BUILD OUTPUT --------------------------------------------------------------------------------------------------------------
starting build "ca596a7e-ee27-44e3-a21b-b6c0aa66b734"
....略....
b45078e74ec9: Pushed
latest: digest: sha256:8acc6b5abd77ee139c9560bcad5fbe0dc7709b9f43285c88daef2000dd852f5e size: 1995
DONE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ID: ca596a7e-ee27-44e3-a21b-b6c0aa66b734
CREATE_TIME: 2022-09-17T14:55:43+00:00
DURATION: 49S
SOURCE: gs://lab0917-gke-deploy_cloudbuild/source/1663426542.476163-bdaacf437f694ec285bb7cf363c66f22.tgz
IMAGES: asia-east1-docker.pkg.dev/lab0917-gke-deploy/hello-repo/helloworld-gke (+1 more)
STATUS: SUCCESS
# 此時東西就會出現在 Artifact Registry 裏頭了, 版本為 latest


### 建立 GKE cluster, 名為 helloworld-gke
# (等同於 lab0917-gke-app.md)
$# gcloud container clusters create-auto helloworld-gke \
  --region $REGION
# ~~~~~ 2000 years later ~~~~~
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.
Creating cluster helloworld-gke in asia-east1... Cluster is being health-checked...done.     
Created [https://container.googleapis.com/v1/projects/lab0917-gke-deploy/zones/asia-east1/clusters/helloworld-gke].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-east1/helloworld-gke?project=lab0917-gke-deploy
kubeconfig entry generated for helloworld-gke.
NAME: helloworld-gke
LOCATION: asia-east1
MASTER_VERSION: 1.22.12-gke.300
MASTER_IP: 35.194.199.120
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.22.12-gke.300
NUM_NODES: 3
STATUS: RUNNING
# 建立了一個 GKE Cluster, 並且開了 3 台 e2-medium 在那邊開始燒錢了
# Kubernetes Engine 的 Web Console, 能看到此 Cluster
# Compute Engine 的 Web Console, 無法找到此 Cluster VM (因為他們不是一樣的東西XD)

# 假如有發生問題... 可使用底下 CLI 來查出 cluster nodes 的所有細部狀態
$# kubectl cluster-info dump > /tmp/cluster-info-$(date +%FT%R)
# ↑ 數千上萬行的明細資料... (希望不會有用到的一天)


### Verify that you have access to the cluster. The following command lists the nodes in your container cluster which are up and running and indicates that you have access to the cluster.
$# kubectl get nodes
NAME                                            STATUS   ROLES    AGE    VERSION
gk3-helloworld-gke-default-pool-8c7414bd-1jq6   Ready    <none>   6m7s   v1.22.12-gke.300
gk3-helloworld-gke-default-pool-96daa6e5-s2kh   Ready    <none>   6m8s   v1.22.12-gke.300
# UNKNOWN: 不知道怎說明
# 也不知道為何這個過了 20 分鐘以後, 又多了一台機器... (如下)
gk3-helloworld-gke-default-pool-8c7414bd-1jq6   Ready    <none>   50m   v1.22.12-gke.300
gk3-helloworld-gke-default-pool-96daa6e5-p5dx   Ready    <none>   30m   v1.22.12-gke.300
gk3-helloworld-gke-default-pool-96daa6e5-s2kh   Ready    <none>   50m   v1.22.12-gke.300
```


# Create Deploy

> To deploy your app to the GKE cluster you created, you need:
>
>  1. A Deployment to define your app.
>  2. A Service to define how to access your app.

接著需要一台 server 來運行 Web APP

後續撰寫一份 deployment.yml 來定義 APP 運行在 cluster 裡面所需要的 Resources (此 Resources 稱之為 Deployment)

後續會用這個 Deployments 來 create/update ReplicaSet 以及 Pods


```yml
# 建立 deployment.yaml
# https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/blob/HEAD/quickstart/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-gke
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello-app
        image: asia-east1-docker.pkg.dev/lab0917-gke-deploy/hello-repo/helloworld-gke  # Change this image
        ports:
        - containerPort: 8080
        env:
          - name: PORT
            value: "8080"
```

```bash
# --- 編輯完上述的 deployment.yml 以後 ---

### 在 Cluster deploy Resources
$# kubectl apply -f deployment.yaml
Warning: Autopilot set default resource requests for Deployment default/helloworld-gke, as resource requests were not specified. See http://g.co/gke/autopilot-defaults.
deployment.apps/helloworld-gke created


### Track the status of the Deployment
$# kubectl get deployments
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
helloworld-gke   0/1     1            0           47s
# The Deployment is complete when all of the AVAILABLE deployments are READY
#

# ------------ ↓↓↓↓↓↓ 偶爾可能看到這樣 ↓↓↓↓↓↓ ------------
$# kubectl get pods
NAME                              READY   STATUS             RESTARTS   AGE
helloworld-gke-d5774649d-sgwb7    0/1     ImagePullBackOff   0          5m4s
# ImagePullBackOff 或 ErrImagePull 都表示找不到相關的 image (朝著 image 的方向去排查)
$# kubectl apply -f deployment.yaml
# ↑ 排查完以後, 使用此 CLI 來套用新的 Deployments

# ~~~ later ~~~

$# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
helloworld-gke-7577f9949f-kp5gj   1/1     Running   0          2m38s

$# kubectl get deployments
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
helloworld-gke   1/1     1            1           10m
# ------------ ↑↑↑↑↑↑ 偶爾可能看到這樣 ↑↑↑↑↑↑ ------------

### 查看 Service (注意~~~ 此時都還沒有 deploy service)
$# kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.39.0.1    <none>        443/TCP   34m
#                                     ^^^^^^ 這時候是空的
# 此時只 deploy Deployment(定義 APP)
# 尚未 deploy service(定義如何 access APP), 因此無 External IP
```


# Create Service

上面已完成 Deploy an APP

接著需要 Deploy a Service

> Services provide a single point of access to a set of Pods. While it's possible to access a single Pod, Pods are ephemeral and can only be accessed reliably by using a Service address. In your Hello World app, the "hello" Service defines a load balancer to access the hello-app Pods from a single IP address. This Service is defined in the service.yaml file.

```yml
# 建立 service.yaml
# https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/blob/HEAD/quickstart/service.yaml

# The hello service provides a load-balancing proxy over the hello-app
# pods. By specifying the type as a 'LoadBalancer', Kubernetes Engine will
# create an external HTTP load balancer.
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  type: LoadBalancer
  selector:
    app: hello
  ports:
  - port: 80
    targetPort: 8080
```

The Pods are defined separately from the Service that uses the Pods. Kubernetes uses labels to select the Pods that a Service addresses. With labels, you can have a Service that addresses Pods from different replica sets and have multiple services that point to an individual Pod.

```bash
### Create Service
$# kubectl apply -f service.yaml
service/hello created


### 查看 Service
$# kubectl get services
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP      10.39.0.1     <none>        443/TCP        59m
hello        LoadBalancer   10.39.3.136   <pending>     80:31642/TCP   43s
#                                         ^^^^^^^^^ 要再等一下 ~~~
# It can take up to 60 seconds to allocate the IP address. The external IP address is listed under the column EXTERNAL-IP for the hello Service.


### 查看 Service (1 minute later~)
$# kubectl get services
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
kubernetes   ClusterIP      10.39.0.1     <none>         443/TCP        61m
hello        LoadBalancer   10.39.3.136   34.81.165.56   80:31642/TCP   2m9s
#                                         ^^^^^^^^^^^^


### access
$# EXTERNAL_IP=34.81.165.56
$# curl $EXTERNAL_IP
```



# Clean up

```bash
$# gcloud container clusters delete helloworld-gke \
    --region $REGION
The following clusters will be deleted.
 - [helloworld-gke] in [asia-east1]

Do you want to continue (Y/n)?  Y  # yyyy

Deleting cluster helloworld-gke...done.     
Deleted [https://container.googleapis.com/v1/projects/lab0917-gke-deploy/zones/asia-east1/clusters/helloworld-gke].
# 500 years later~~~


### 
$# gcloud artifacts docker images delete \
    $REGION-docker.pkg.dev/$PROJECT_ID/hello-repo/helloworld-gke
This operation will delete all tags and images for asia-east1-docker.pkg.dev/lab0917-gke-deploy/hello-repo/helloworld-gke.

Do you want to continue (Y/n)?  Y  # yyyy

Delete request issued.
Waiting for operation [projects/lab0917-gke-deploy/locations/asia-east1/operations/09d64411-3e74-4697-9689-63778d7d8c69] to complete...done.
```
