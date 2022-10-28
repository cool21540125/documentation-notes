# [Create a guestbook with Redis and PHP](https://cloud.google.com/kubernetes-engine/docs/tutorials/guestbook)

- 2022/09/18
- 這個範例要跑一個 PHP guestbook, 背後有 redis cluster, 裏頭有幾個重點:
    - 撰寫 Declarative configuration yaml manifest files
    - 釐清 Kubernetes Deployments
    - 釐清 Kubernetes Services
- ![infra](./img/lab0918-app4.png)
- [Source Code](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/99fbbfb528462de6b9ffdfe68be4bd38ff3dd225/guestbook)
- Prerequest
  - 需授權給: Kubernetes Engine API
  - 確保 PROJECT_ID 已啟用 Billing
    - `gcloud beta billing projects describe $PROJECT_ID`

```bash
$# export PROJECT_ID=lab0918-app4
$# gcloud config set project ${PROJECT_ID}

### 環境變數
$# export CLOUDSDK_CORE_PROJECT=$PROJECT_ID
$# export CLOUDSDK_COMPUTE_ZONE=$COMPUTE_ZONE

### Standard 模式
$# export COMPUTE_ZONE=asia-east1-a
$# gcloud config set compute/zone ${COMPUTE_ZONE}
Updated property [compute/zone].

### Autopilot 模式
$# export REGION=asia-east1
$# gcloud config set compute/region ${REGION}
Updated property [compute/region].


### 建立名為 guestbook 的 Cluster
$# gcloud container clusters create-auto guestbook

$# gcloud container clusters create-auto guestbook --region $REGION --project=$PROJECT_ID
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.
Creating cluster guestbook in asia-east1... Cluster is being health-checked...done.     
Created [https://container.googleapis.com/v1/projects/lab1027-app4/zones/asia-east1/clusters/guestbook].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-east1/guestbook?project=lab1027-app4
kubeconfig entry generated for guestbook.
NAME: guestbook
LOCATION: asia-east1
MASTER_VERSION: 1.22.12-gke.2300
MASTER_IP: 34.81.113.163
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.22.12-gke.2300
NUM_NODES: 3
STATUS: RUNNING
# 2000 years later...
# Kubernets Engine web console 會多出個 guestbook 的 Cluster


### 查看 cluster
$# gcloud container clusters list
NAME: guestbook
LOCATION: asia-east1
MASTER_VERSION: 1.22.12-gke.2300
MASTER_IP: 34.81.113.163
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.22.12-gke.2300
NUM_NODES: 2
STATUS: RUNNING


$# gcloud container clusters describe guestbook
# 噴出超多... 省略


### retrieve cluster credentials and configure kubectl command-line tool
$# gcloud container clusters get-credentials guestbook --region $REGION
Fetching cluster endpoint and auth data.
kubeconfig entry generated for guestbook.
# 如果使用 Standard 模式 (clusters create), 而非 Autopilot 模式(clusters create-auto), 則可免除此步驟
# 否則需做這動作來授權給 kubectl 來做後續操作


### 
$# git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples app4
$# cd app4/guestbook
```

```yml
# redis-leader-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        role: leader
        tier: backend
    spec:
      containers:
        - name: leader1
          image: "docker.io/redis:6.0.5"
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
          ports:
            - containerPort: 6379
---
```

```bash
$# kubectl apply -f redis-leader-deployment.yaml
deployment.apps/redis-leader created


### 查看 deployment 詳細 log
$# kubectl logs deployment/redis-leader
1:C 18 Sep 2022 06:13:45.939 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 18 Sep 2022 06:13:45.939 # Redis version=6.0.5, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 18 Sep 2022 06:13:45.939 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 18 Sep 2022 06:13:45.941 * Running mode=standalone, port=6379.
1:M 18 Sep 2022 06:13:45.941 # Server initialized
1:M 18 Sep 2022 06:13:45.942 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
1:M 18 Sep 2022 06:13:45.942 * Ready to accept connections


$# kubectl get service
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.34.0.1    <none>        443/TCP   14m


$# kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
redis-leader-7b4c8d9d75-5hv9h   1/1     Running   0          57s


$# kubectl get deployments
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-leader   1/1     1            1           69s
```

```yaml
# redis-leader-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis
    role: leader
    tier: backend
```

```bash
$# kubectl apply -f redis-leader-service.yaml
service/redis-leader created


$# kubectl get services
NAME           TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
kubernetes     ClusterIP   10.34.0.1    <none>        443/TCP    15m
redis-leader   ClusterIP   10.34.0.63   <none>        6379/TCP   6s
# 目前僅建立了名為 redis-leader, Type 為 ClusterIP 的 Service
```

```yaml
# redis-follower-deployment.yaml
# [START gke_guestbook_redis_follower_deployment_deployment_redis_follower]
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-follower
  labels:
    app: redis
    role: follower
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        role: follower
        tier: backend
    spec:
      containers:
      - name: follower
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-redis-follower:v2
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
# [END gke_guestbook_redis_follower_deployment_deployment_redis_follower]
---
```

```bash
### create deployment for redis follower
$# kubectl apply -f redis-follower-deployment.yaml


$# kubectl get deployments
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
redis-follower   0/2     2            0           9s
redis-leader     1/1     1            1           4m42s


$# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
redis-follower-7fb76b74f7-b4mnf   1/1     Running   0          23s
redis-follower-7fb76b74f7-v596l   0/1     Pending   0          23s
redis-leader-7b4c8d9d75-5hv9h     1/1     Running   0          4m56s
```

```yaml
# redis-follower-service.yaml
# [START gke_guestbook_redis_follower_service_service_redis_follower]
apiVersion: v1
kind: Service
metadata:
  name: redis-follower
  labels:
    app: redis
    role: follower
    tier: backend
spec:
  ports:
    # the port that this service should serve on
  - port: 6379
  selector:
    app: redis
    role: follower
    tier: backend
# [END gke_guestbook_redis_follower_service_service_redis_follower]
---
```

```bash
$# kubectl apply -f redis-follower-service.yaml
$# kubectl get services
NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
kubernetes       ClusterIP   10.34.0.1     <none>        443/TCP    19m
redis-follower   ClusterIP   10.34.0.141   <none>        6379/TCP   4s
redis-leader     ClusterIP   10.34.0.63    <none>        6379/TCP   3m23s
# 建立了名為 redis-follower, TYPE 為 ClusterIP 的 Service, 用來給 redis-leader Deployment 連線
```

```yml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-php
spec:
  replicas: 3
  selector:
    matchLabels:
        app: guestbook
        tier: frontend
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5
        env:
        - name: GET_HOSTS_FROM
          value: "dns"
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 80
```

```bash
$# kubectl apply -f frontend-deployment.yaml
$# kubectl get deployment
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
frontend-php     3/3     3            3           3m22s
redis-follower   2/2     2            2           6m1s
redis-leader     1/1     1            1           10m


$# kubectl get pods -l app=guestbook -l tier=frontend
NAME                            READY   STATUS    RESTARTS   AGE
frontend-php-64bcc69c4b-478hk   1/1     Running   0          109s
frontend-php-64bcc69c4b-9vd7x   1/1     Running   0          109s
frontend-php-64bcc69c4b-zszhc   1/1     Running   0          109s
```

```yaml
# frontend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: guestbook
  labels:
    app: guestbook
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: guestbook
```

```bash
### 依照上述規格, 建立了 LoadBalancer (開始燒錢)
$# kubectl apply -f frontend-service.yaml
service/guestbook created


$# kubectl get service
NAME             TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
guestbook        LoadBalancer   10.34.0.60    35.194.234.208   80:30541/TCP   52s
kubernetes       ClusterIP      10.34.0.1     <none>           443/TCP        29m
redis-follower   ClusterIP      10.34.0.141   <none>           6379/TCP       10m
redis-leader     ClusterIP      10.34.0.63    <none>           6379/TCP       13m


$# gcloud compute forwarding-rules list
NAME: af76f8b468171428895f119d8ed775e2
REGION: asia-east1
IP_ADDRESS: 35.194.234.208
IP_PROTOCOL: TCP
TARGET: asia-east1/targetPools/af76f8b468171428895f119d8ed775e2


```


# Clean up

```bash
$# kubectl delete service frontend
$# kubectl delete service redis-follower
$# kubectl delete service redis-leader
$# kubectl delete deploy frontend-php
$# kubectl delete deploy redis-follower
$# kubectl delete deploy redis-leader
$# gcloud container clusters delete guestbook
# ↑ 最後一步... 記得把 Cluster VM 也砍了
```
