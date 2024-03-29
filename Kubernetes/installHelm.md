
Install services using Helm


# Install RabbitMQ

```bash
### repo 來自 bitnami
$# helm repo add bitnami https://charts.bitnami.com/bitnami
# 將最後的 URL (Helm Repo) 加入本地, 並命名為 bitnami


### Install RabbitMQ - https://bitnami.com/stack/rabbitmq
$# kubectl create ns ns-rabbitmq
$# Release_Name="event-driven-rabbitmq"
$# MQ_PASSWORD=""
$# helm install ${Release_Name} bitnami/rabbitmq \
    -n ns-rabbitmq \
    --set replicaCount=3 \
    --set auth.password="${MQ_PASSWORD}"
# 安裝 release 的來源為 名為 bitnami 的 Helm Repo 底下的 rabbitmq 
# replicaCount >=3, 會自動將他們架設為 Cluster
# 最好是一開始就帶入密碼, 否則將來做 helm upgrade 的時候密碼遺失


### RabbitMQ management~
$# kubectl port-forward --namespace ns-rabbitmq svc/${Release_Name} 15672:15672
# localhost:15672


### 查看 Helm Releases
$# helm list -n ns-rabbitmq
NAME                   NAMESPACE    REVISION  UPDATED                        STATUS    CHART            APP VERSION
event-driven-rabbitmq  ns-rabbitmq  1         2023-01-24 00:59:55 +0800 CST  deployed  rabbitmq-10.3.9  3.10.8  
# (稍微整理過輸出)


### 進入 Pods
$# kubectl exec -it ${Release_Name}-0 \
    -n ns-rabbitmq \
    -- /bin/bash
$# 

### Log Path
$# ls -l /opt/bitnami/rabbitmq/var/log/rabbitmq


### Default config Path
$# ls -l /opt/bitnami/rabbitmq/etc/rabbitmq/


### RabbitMQ home : rabbitmq_home
$# cd /opt/bitnami/rabbitmq/.rabbitmq
# 裡頭有 .erlang.cookie
```


# Install traefik

- 2023/05/04

```bash
### install
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm list

TRAEFIK_NS="traefik_ns"

kubectl create ns $TRAEFIK_NS

### Install traefik
helm install -n "$TRAEFIK_NS" --set="additionalArguments={--log.level=DEBUG}" traefik traefik/traefik


kubectl expose deployment traefik --type=NodePort --port=8080

kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" -n $TRAEFIK_NS --output=name) -n $TRAEFIK_NS 9000:9000

```


### 
