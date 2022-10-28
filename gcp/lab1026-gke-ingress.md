# [Ingress with NGINX controller on Google Kubernetes Engine](https://cloud.google.com/community/tutorials/nginx-ingress-gke)

- 2022/10/26
- 這篇範例講述 ingress 是由 2 個 components 所構成:
    - ingress resource   : 一系列的 hostnames 路由規則, 管控 inbound traffice 到正確的 Services
    - ingress controller : 依照 ingress resource 的規則, 來讓流量經由 **HTTP** 或 **L7 Load Balancer**
        - 常見的 ingress controller 有 Nginx
- 這篇會先建立一個 Deployment, 之後再(使用 helm)搭 (Nginx) Ingress Controller, 然後測試 Nginx Ingress 可將流量送往後面的 Google Cloud L4 (TCP/UDP) LB 來訪問服務
- Prerequest
    - enable *Kubernetes Engine API*

```bash
### 設定 project
$# gcloud config set project lab-gke-nginx-ingress

### 設定 zone
$# gcloud config set compute/zone asia-east1-a
$# gcloud config get-value compute/zone
Your active configuration is: [cloudshell-14342]
asia-east1-a

### 設定 region
$# gcloud config set compute/region asia-east1
$# gcloud config get-value compute/region
Your active configuration is: [cloudshell-14342]
asia-east1
```

## 法1. 建立 Public GKE Cluster

```bash
### 建立名為 gke-plblic 的 public GKE cluster
$# gcloud container clusters create gke-public \
  --enable-ip-alias \
  --num-nodes=2
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.
Creating cluster gke-public in asia-east1-a... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1/projects/lab-gke-nginx-ingress/zones/asia-east1-a/clusters/gke-public].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-east1-a/gke-public?project=lab-gke-nginx-ingress
kubeconfig entry generated for gke-public.
NAME: gke-public
LOCATION: asia-east1-a
MASTER_VERSION: 1.22.12-gke.2300
MASTER_IP: 104.199.130.61
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.22.12-gke.2300
NUM_NODES: 2
STATUS: RUNNING
```


## 法2. 建立 Private GKE Cluster

```bash
### 1. Create and reserve an external IP address for the NAT gateway:
$# gcloud compute addresses create nat-ip-2022
Created [https://www.googleapis.com/compute/v1/projects/lab-gke-nginx-ingress/regions/asia-east1/addresses/nat-ip-2022].
# 似乎是先申請一組 External IP, 等下用來綁 (NAT)router


### 2. Create a Cloud NAT gateway for the private GKE cluster:
$# gcloud compute routers create rt2022 \
    --network=default
Creating router [rt2022]...done.   
NAME: rt2022
REGION: asia-east1
NETWORK: default

$# gcloud compute routers nats create nat-gw-2022 \
    --router=rt2022 \
    --nat-external-ip-pool=nat-ip-2022 \
    --nat-all-subnet-ip-ranges \
    --enable-logging
Creating NAT [nat-gw-2022] in router [rt2022]...done.
# 建立名為 nat-gw-2022 的 Nat Gateway(使用 nat-ip-2022 這個 External IP), router 為 rt2022


### 3. Get the public IP address of your Cloud Shell session:
$# export CLOUDSHELL_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)  # 取得 Cloudshell IP
$# echo $CLOUDSHELL_IP
35.221.223.192
# 等下要用 Cloudshell 來訪問 Private GKE Cluster


### 4. Create a firewall rule that allows Pod-to-Pod and Pod-to-API server communication:
$# gcloud compute firewall-rules create all-pods-and-master-ipv4-cidrs \
    --network default \
    --allow all \
    --direction INGRESS \
    --source-ranges 10.0.0.0/8,172.16.2.0/28
Creating firewall...working..Created [https://www.googleapis.com/compute/v1/projects/lab-gke-nginx-ingress/global/firewalls/all-pods-and-master-ipv4-cidrs].
Creating firewall...done.
NAME: all-pods-and-master-ipv4-cidrs
NETWORK: default
DIRECTION: INGRESS
PRIORITY: 1000
ALLOW: all
DENY:
DISABLED: False
# 建立名為 all-pods-and-master-ipv4-cidrs 的 firewall rule
# 符合過白者, 流量送往 INGRESS


### 5. Create a private GKE cluster:
$# gcloud container clusters create gke-private \
    --num-nodes "2" \
    --enable-ip-alias \
    --enable-private-nodes \
    --master-ipv4-cidr=172.16.2.0/28 \
    --enable-master-authorized-networks \
    --master-authorized-networks $CLOUDSHELL_IP/32
# 建立名為 gke-private 的 GKE Cluster
# 允許 $CLOUDSHELL_IP 來訪問 k8s master (不確定)
# 把 master 放在 172.16.2.0/28 的網段裡
```


# Connect to clusters

這個動作用來切換 Cluster

如果 `~/.kube/config` 有多個 Clusters 的話, 用來切換 current-context

```bash
### 把 cluster 的權限寫入到 ~/.kube/config
$# gcloud container clusters get-credentials gke-public
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke-public.

$# gcloud container clusters get-credentials gke-private
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke-private.
# 後續藉由裡頭的 current-context 做切換
```


# 開始

```bash
### Cloud Shell 預設已安裝 helm 3
$# helm version
version.BuildInfo{Version:"v3.9.3", GitCommit:"414ff28d4029ae8c8b05d62aa06c7fe3dee2bc58", GitTreeState:"clean", GoVersion:"go1.17.13"}

### 部署一個 Deployment
$# kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
deployment.apps/hello-app created

### 建立 hello-app 的 Service (沒指定 Service 名稱, 因此預設為同名)
$# kubectl expose deployment hello-app --port=8080 --target-port=8080
service/hello-app exposed

$# kubectl get service
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
hello-app    ClusterIP   10.60.0.22   <none>        8080/TCP   10s
kubernetes   ClusterIP   10.60.0.1    <none>        443/TCP    122m


### 接著要用 helm 來建立 nginx ingress controller
$# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

### (不是很懂這個的目的)
$# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "ingress-nginx" chart repository
Update Complete. ⎈Happy Helming!⎈

$# helm repo list
NAME            URL
ingress-nginx   https://kubernetes.github.io/ingress-nginx


### 由 ingress-nginx Helm Repo 安裝 ingress-nginx, 並命名為 nginx-ingress2022 (此為 Chart Name?)
$# helm install nginx-ingress2022 ingress-nginx/ingress-nginx
NAME: nginx-ingress2022
LAST DEPLOYED: Fri Oct 28 09:57:52 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace default get services -o wide -w nginx-ingress2022-ingress-nginx-controller'

An example Ingress that makes use of the controller:
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: example
    namespace: foo
  spec:
    ingressClassName: nginx
    rules:
      - host: www.example.com
        http:
          paths:
            - pathType: Prefix
              backend:
                service:
                  name: exampleService
                  port:
                    number: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
      - hosts:
        - www.example.com
        secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
# 這指令好像有些貓膩... 還看不清Orz


$# kubectl get deployment
NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE
hello-app                                    1/1     1            1           9m56s
nginx-ingress2022-ingress-nginx-controller   1/1     1            1           56s
# 建立了 ingress controller 這個 Deployment


$# kubectl get service
NAME                                                   TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                      AGE
hello-app                                              ClusterIP      10.60.0.22    <none>          8080/TCP                     3m43s
kubernetes                                             ClusterIP      10.60.0.1     <none>          443/TCP                      126m
nginx-ingress2022-ingress-nginx-controller-admission   ClusterIP      10.60.2.253   <none>          443/TCP                      99s
nginx-ingress2022-ingress-nginx-controller             LoadBalancer   10.60.0.9     34.80.237.157   80:30012/TCP,443:31903/TCP   99s
#                                                                                   ^^^^^^^^^^^^^  建立了 GCP L4 的 Load Balancer

$# export NGINX_INGRESS_IP=$(kubectl get service nginx-ingress2022-ingress-nginx-controller -ojson | jq -r '.status.loadBalancer.ingress[].ip')
$# echo $NGINX_INGRESS_IP
34.80.237.157
```

之後的動作, 就要來配置 Ingress Resource(此為 路由到 k8s Services 的 L7 routing rules 的 collection), 以及綁定它背後的 Ingress Controller

這個綁定的動作, 藉由 `annotations`

- 若要使用 nginx controller, 使用  `kubernetes.io/ingress.class: nginx`
- 若沒有聲明, 在 GCP 預設為 GCLB L7, 等同於 `kubernetes.io/ingress.class: gce`

```yaml
cat <<EOF > ingress-resource.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: "$NGINX_INGRESS_IP.nip.io"
    http:
      paths:
      - pathType: Prefix
        path: "/hello"
        backend:
          service:
            name: hello-app
            port:
              number: 8080
EOF
```

- `kind: Ingress` 聲明了這東西是 Ingress Resource object
- 這個 Ingress Resource 定義了 `/hello` 到 `hello-app` 8080 port 的這個 Service 的 inbound L7 rule
- `${NGINX_INGRESS_IP}.nip.io` 是個非常神奇的東西(給 developer 做開發測試的服務吧!!).... 去 dig 它的話, 會拿到自身的 IP
    - ex: `dig -t A 1.2.3.4.nip.io` 會拿到 `1.2.3.4`
    - 或是可綁 hosts 然後自己填 domain

```bash
$# kubectl apply -f ingress-resource.yaml
ingress.networking.k8s.io/ingress-resource created
# 建立名為 ingress-resource 的 Ingress


$# kubectl get ingress ingress-resource
NAME               CLASS    HOSTS                  ADDRESS   PORTS   AGE
ingress-resource   <none>   34.80.237.157.nip.io             80      39s


$# curl http://$NGINX_INGRESS_IP.nip.io/hello
Hello, world!
Version: 1.0.0
Hostname: hello-app-6d7bb985fd-6bb4x
```


# Clean up

```bash
$# kubectl delete -f ingress-resource.yaml
$# helm del nginx-ingress2022
$# kubectl delete service hello-app
$# kubectl delete deployment hello-app
$# gcloud container clusters delete gke-public --async
$# gcloud container clusters delete gke-private --async
$# rm ingress-resource.yaml
```
