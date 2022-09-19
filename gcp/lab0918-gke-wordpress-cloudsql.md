
# [Deploy WordPress on GKE with Persistent Disk and Cloud SQL](https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk?cloudshell=false)

- 2022/09/18
- 概述
    - 用 GKE 跑一個 wordpress
    - DB 使用 CloudSQL
    - 使用 `PersistentVolumes(PV)` && `PersistentVolumeClaims(PVC)` 作永久儲存
- 使用到的 GCP Services:
    - Kubernetes Engine
    - CloudSQL
- [Source Code](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/main/wordpress-persistent-disks)

> Note: If the zone is not set, gcloud will create a regional cluster. A regional cluster will create a node-pool of 3 nodes per zone within the default region for your project. This will result in a cluster with more nodes than a single zonal cluster, and possible quota issues.

```bash
$# export PROJECT_ID=lab0918-gke-wordpress
$# export COMPUTE_ZONE=asia-east1-a
$# gcloud config set project ${PROJECT_ID}
$# gcloud config set compute/zone ${COMPUTE_ZONE}

### 授權專案使用 GCP Services
$# gcloud services enable container.googleapis.com  # GKE
$# gcloud services enable sqladmin.googleapis.com   # CloudSQL

$# git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples example-wordpress-gke
$# cd example-wordpress-gke/wordpress-persistent-disks
$# WORKING_DIR=$(pwd)


### 建立名為 persistent-disk-tutorial 的 GKE Cluster
$# CLUSTER_NAME=persistent-disk-tutorial
$# gcloud container clusters create ${CLUSTER_NAME} \
    --num-nodes=3 \
    --enable-autoupgrade \
    --no-enable-basic-auth \
    --no-issue-client-certificate \
    --enable-ip-alias \
    --metadata disable-legacy-endpoints=true
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.
Creating cluster persistent-disk-tutorial in asia-east1-a... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1/projects/lab0918-gke-wordpress/zones/asia-east1-a/clusters/persistent-disk-tutorial].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-east1-a/persistent-disk-tutorial?project=lab0918-gke-wordpress
kubeconfig entry generated for persistent-disk-tutorial.
NAME: persistent-disk-tutorial
LOCATION: asia-east1-a
MASTER_VERSION: 1.22.11-gke.400
MASTER_IP: 34.80.37.186
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.22.11-gke.400
NUM_NODES: 3
STATUS: RUNNING


$# kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.92.0.1    <none>        443/TCP   10m
```

```yaml
# wordpress-volumeclaim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wordpress-volumeclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Gi
```

```bash
### deploy WordPress 所需的 Storage
$# kubectl apply -f ${WORKING_DIR}/wordpress-volumeclaim.yaml
persistentvolumeclaim/wordpress-volumeclaim created


$# kubectl get persistentvolumeclaim
NAME                    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
wordpress-volumeclaim   Bound    pvc-a8909eff-9647-404c-8502-5a74e5644d09   200Gi      RWO            standard       89s


### 建立 CloudSQL
$# INSTANCE_NAME=mysql-wordpress-instance
$# gcloud sql instances create $INSTANCE_NAME
WARNING: Starting with release 233.0.0, you will need to specify either a region or a zone to create an instance.
Creating Cloud SQL instance for MYSQL_8_0...done.
Created [https://sqladmin.googleapis.com/sql/v1beta4/projects/lab0918-gke-wordpress/instances/mysql-wordpress-instance].
NAME: mysql-wordpress-instance
DATABASE_VERSION: MYSQL_8_0
LOCATION: us-central1-b
TIER: db-n1-standard-1
PRIMARY_ADDRESS: 34.133.202.240
PRIVATE_ADDRESS: -
STATUS: RUNNABLE

### CloudSQL instance name
$# gcloud sql instances describe $INSTANCE_NAME --format='value(connectionName)'
lab0918-gke-wordpress:us-central1:mysql-wordpress-instance  # 此為 CloudSQL instance connection name

$# export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME --format='value(connectionName)')

### Create DB
$# gcloud sql databases create wordpress --instance $INSTANCE_NAME
Creating Cloud SQL database...done.
Created database [wordpress].
instance: mysql-wordpress-instance
name: wordpress
project: lab0918-gke-wordpress


### Create db user
$# CLOUD_SQL_PASSWORD=$(openssl rand -base64 18)  # V6OITR8gA4qbW7PgvYMFPjkg
$# gcloud sql users create wordpress \
    --host=% \
    --instance $INSTANCE_NAME \
    --password $CLOUD_SQL_PASSWORD

### Before you can deploy WordPress, you must create a service account. You create a Kubernetes secret to hold the service account credentials and another secret to hold the database credentials.
$# SA_NAME=cloudsql-proxy
$# gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME
Created service account [cloudsql-proxy].


### Add the service account email address as an environment variable:
$# SA_EMAIL=$(gcloud iam service-accounts list \
    --filter=displayName:$SA_NAME \
    --format='value(email)')
# cloudsql-proxy@lab0918-gke-wordpress.iam.gserviceaccount.com


### Add the cloudsql.client role to your service account
$# gcloud projects add-iam-policy-binding $PROJECT_ID \
    --role roles/cloudsql.client \
    --member serviceAccount:$SA_EMAIL
Updated IAM policy for project [lab0918-gke-wordpress].
bindings:
- members:
  - serviceAccount:cloudsql-proxy@lab0918-gke-wordpress.iam.gserviceaccount.com
  role: roles/cloudsql.client
- members:
  - serviceAccount:service-715028378958@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:service-715028378958@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - serviceAccount:service-715028378958@containerregistry.iam.gserviceaccount.com
  role: roles/containerregistry.ServiceAgent
- members:
  - serviceAccount:715028378958-compute@developer.gserviceaccount.com
  - serviceAccount:715028378958@cloudservices.gserviceaccount.com
  role: roles/editor
- members:
  - user:tonychoucc2022@gmail.com
  role: roles/owner
- members:
  - serviceAccount:service-715028378958@gcp-sa-pubsub.iam.gserviceaccount.com
  role: roles/pubsub.serviceAgent
etag: BwXo9g30Jm0=
version: 1
# 其實到前面幾步我已經有點矇了...


### Create a key for the service account:
$# gcloud iam service-accounts keys create $WORKING_DIR/key.json \
    --iam-account $SA_EMAIL
created key [43de03f19df9a29cfabc955c61eae77453e5b617] of type [json] as [/home/tonychoucc2022/example-wordpress-gke/wordpress-persistent-disks/key.json] for [cloudsql-proxy@lab0918-gke-wordpress.iam.gserviceaccount.com]
# This command downloads a copy of the key.json file (啥~~~?)


### Create a Kubernetes secret for the MySQL credentials
$# kubectl create secret generic cloudsql-db-credentials \
    --from-literal username=wordpress \
    --from-literal password=$CLOUD_SQL_PASSWORD
secret/cloudsql-db-credentials created

### Create a Kubernetes secret for the service account credentials:
$# kubectl create secret generic cloudsql-instance-credentials \
    --from-file $WORKING_DIR/key.json
secret/cloudsql-instance-credentials created

# 上面這些應該都是 wordpress 的東西吧 Orz....
```


# Deploy WordPress

接著要來 deploy wordpress

```bash
### 
$# cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > \
    $WORKING_DIR/wordpress_cloudsql.yaml
```