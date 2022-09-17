2021/08/13(五) GCP 參訓課程筆記

- [gcloud SDK](https://cloud.google.com/sdk/gcloud/reference)


## Part1. Getting Started with Compute Engine

```bash
### Ubuntu 可安裝 gsutil SDK (非課堂範圍)
# https://cloud.google.com/storage/docs/gsutil_install#deb
# 略
```

```bash
### 建立 GCE 可透過 Cloud Shell 來秒殺...
$# gcloud compute zones list | grep us-central1
us-central1-c              us-central1              UP
us-central1-a              us-central1              UP
us-central1-f              us-central1              UP
us-central1-b              us-central1              UP
# 看看機器要開在哪個 zones...

### 切換到想要的 zones
$# gcloud config set compute/zone us-central1-a
Updated property [compute/zone].

### 建立一台 VM 名為 "my-vm-2"
$# gcloud compute instances create "my-vm-2" \
--machine-type "n1-standard-1" \
--image-project "debian-cloud" \
--image-family "debian-10" \
--subnet "default"

### Cloud Shell 可直接 ssh 到 VM 裡面去@@
$# ssh my-vm-1.us-central1-a
```

## Part2. Getting Started with Cloud Storage and Cloud SQL

Goals:

- 建立 Cloud Storage Bucket
- 建立 Cloud SQL instance
- 讓 GCE 的 Web Server 存取 Cloud SQL instance
- 讓 GCE 的 Web Server 存取 Cloud Storage Bucket


### Step1. 前置作業

#### 1-1. VM & Bucket

```bash
# 先建立一台 GCE && Install...
$# apt-get update
$# apt-get install apache2 php php-mysql -y
$# service apache2 restart

# 抓開源的範例圖
$# gsutil cp gs://cloud-training/gcpfci/my-excellent-blog.png my-excellent-blog.png
Copying gs://cloud-training/gcpfci/my-excellent-blog.png...
/ [1 files][  8.2 KiB/  8.2 KiB]
Operation completed over 1 objects/8.2 KiB.
```


#### 1-2. DB

> GCP Web > SQL > Create instance > Choose a database engine > MySQL

- Instance ID : blog-db
- Root password : (依喜好設定)
- Single zone : (離 GCE 近一點吧~)


### Step2. 實作需求

#### 2-1. VM & Bucket

```bash
$# export LOCATION=ASIA
# Cloud Shell 裡面的環境變數 $DEVSHELL_PROJECT_ID , 可以抓到目前專案的 PROJECT_ID
# Enter this command to make a bucket named after your project ID
$# gsutil mb -l $LOCATION gs://$DEVSHELL_PROJECT_ID
Creating gs://qwiklabs-gcp-01-275ee440aea3/...
# gsutil mb 的 mb 為 make bucket, 坐落於 $LOCATION

### 上傳圖例到 Bucket
$# gsutil cp my-excellent-blog.png gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
Copying file://my-excellent-blog.png [Content-Type=image/png]...
/ [1 files][  8.2 KiB/  8.2 KiB]
Operation completed over 1 objects/8.2 KiB.
Updated ACL on gs://qwiklabs-gcp-01-275ee440aea3/my-excellent-blog.png

### 變更 Bucket 內部資源 物件 的 ACL
$# gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
```

#### 2-2. DB 權限




## Part3. Getting Started with App Engine, GAE

如果 PROJECT 一但啟動, 然後又來啟用 App Engine 以後, 頂多只能把 App Engine `disable`

NOTE: APP Engine 預設會保留一個 default (無法被刪除, 所以不用鳥它), 總之 disable 就好了.

之後要啟用 GAE deploy 的話, 記得先來啟用它

```bash
### 若為首次使用 APP Engine, 才需要讓專案去 enable & start GAE
$# gcloud app create --project=$DEVSHELL_PROJECT_ID
# 然後必須幫她選個 region 喔

$# git clone https://github.com/GoogleCloudPlatform/python-docs-samples
$# cd python-docs-samples/appengine/standard_python3/hello_world
$# sudo apt-get update
$# sudo apt-get install virtualenv
$# virtualenv -p python3 venv
$# source venv/bin/activate
$# pip install  -r requirements.txt
$# python main.py

### 之後打算使用 GAE 來做 deploy
$# ls
app.yaml  main.py  main_test.py  requirements-test.txt  requirements.txt  venv
# ↑ GAE deploy 會遵照這個的指示. 其實裡面只有底下一行:
#runtime: python39

$# gcloud app browse
# 可透過 Web 訪問囉
```

> GCP Web > APP Engine > Settings > Disable application


## Part4. Getting Started with GKE

### Part1. 前置設定

> GCP Web > 搜尋 APIs & Services > Enable APIs and Services  若要使用 GKE, 擇要授權啟用底下 2 個 API:

- Kubernetes Engine API
- Container Registry API


### Part2. 實作 Lab

Goal: 

```bash
### Cloud Shell 開始作業...
# GCP zones 清單: https://cloud.google.com/compute/docs/regions-zones#available
$# export MY_ZONE=asia-east1

### 啟動一個 由 K8s Engine 管理的 k8s cluster. 名為 tonydemo (名字不能有「_」), 並且配置 2 個 Nodes
$# gcloud container clusters create tonydemo --zone $MY_ZONE --num-nodes 2
WARNING: Starting in January 2021, clusters will use the Regular release channel by default when `--cluster-version`, `--release-channel`, `--no-enable-autoupgrade`, and `--no-enable-autorepair` flags are not specified.
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
WARNING: Starting with version 1.18, clusters will have shielded GKE nodes by default.
WARNING: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
WARNING: Starting with version 1.19, newly created clusters and node-pools will have COS_CONTAINERD as the default node image when no image type is specified.
Creating cluster tonydemo in asia-northeast1-c...done.  # <-- 好像要跑個 2, 3 分鐘
Created [https://container.googleapis.com/v1/projects/braided-course-322809/zones/asia-northeast1-c/clusters/tonydemo].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-northeast1-c/tonydemo?project=braided-course-322809
kubeconfig entry generated for tonydemo.
NAME      LOCATION           MASTER_VERSION  MASTER_IP      MACHINE_TYPE  NODE_VERSION    NUM_NODES  STATUS
tonydemo  asia-northeast1-c  1.20.8-gke.900  34.85.118.241  e2-medium     1.20.8-gke.900  2          RUNNING
# ↑ 可看到, 目前有個 2 個 Nodes & 名為 tonydemo 的 k8s cluster 正在運行. MASTER_IP 並非 External IP 哦!!

### kubectl Version
$# kubectl version
Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.0", GitCommit:"c2b5237ccd9c0f1d600d3072634ca66cefdf272f", GitTreeState:"clean", BuildDate:"2021-08-04T18:03:20Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.8-gke.900", GitCommit:"28ab8501be88ea42e897ca8514d7cd0b436253d9", GitTreeState:"clean", BuildDate:"2021-06-30T09:23:36Z", GoVersion:"go1.15.13b5", Compiler:"gc", Platform:"linux/amd64"}
WARNING: version difference between client (1.22) and server (1.20) exceeds the supported minor version skew of +/-1

### 此時的 k8s services 如下, 只有一個(好像用來作 proxy) 的 Service
$# kubectl get services
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.11.240.1   <none>        443/TCP   4m

$# kubectl get pods
No resources found in default namespace.

### 由 Cloud Shell, 使用 kubectl 開始操作 k8s cluster, 建立一個 nginx Container
$# kubectl create deploy nginx --image=nginx:1.17.10
deployment.apps/nginx created
# In Kubernetes, all containers run in pods. This use of the kubectl create command caused Kubernetes to create a deployment consisting of a single pod containing the nginx container. A Kubernetes deployment keeps a given number of pods up and running even in the event of failures among the nodes on which they run. In this command, you launched the default number of pods, which is 1.

$# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-674c77bcbb-cbbf9   1/1     Running   0          49s
# ↑ 增加了一個 Pod, 裡面只有一個 Container. NOTE: 此時, service 一樣只有原本那個(並未增加)

### Expose the nginx container to the Internet:
$# kubectl expose deployment nginx --port 80 --type LoadBalancer
service/nginx exposed
# 建立一個 有 Public IP 的 external Load Balancer 服務. 會把流量轉發給 前一步驟建立的 Pods
# Kubernetes created a service and an external load balancer with a public IP address attached to it. The IP address remains the same for the life of the service. Any network traffic to that public IP address is routed to pods behind the service: in this case, the nginx pod.

$# kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP      10.11.240.1     <none>        443/TCP        8m36s 
nginx        LoadBalancer   10.11.254.251   <pending>     80:30717/TCP   14s  # <--  External IP 還在準備中~~
# You can use the displayed external IP address to test and contact the nginx container remotely.
# It may take a few seconds before the External-IP field is populated for your service. This is normal. Just re-run the kubectl get services command every few seconds until the field is populated.

$# kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
kubernetes   ClusterIP      10.11.240.1     <none>          443/TCP        12m
nginx        LoadBalancer   10.11.254.251   34.146.47.143   80:30717/TCP   4m32s  # <-- 可直接訪問此 IP 來訪問 Nginx

### Scale Pods
$# kubectl scale deployment nginx --replicas 3
deployment.apps/nginx scaled
# 可動態調整 Pods 的數量

$# kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
nginx-674c77bcbb-cbbf9   1/1     Running             0          82s
nginx-674c77bcbb-qv68s   0/1     ContainerCreating   0          5s
nginx-674c77bcbb-tvf6g   1/1     Running             0          4s
# scale up 以後, 可能要等一下才能 Ready

$# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-674c77bcbb-cbbf9   1/1     Running   0          91s
nginx-674c77bcbb-qv68s   1/1     Running   0          14s
nginx-674c77bcbb-tvf6g   1/1     Running   0          13s
# Ready for use, replicas = 3

$# kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
kubernetes   ClusterIP      10.11.240.1     <none>          443/TCP        15m
nginx        LoadBalancer   10.11.254.251   34.146.47.143   80:30717/TCP   6m42s
# 有 2 個 Service 了

### 如果只是練習, 記得把 cluster 銷毀以免財物損失
$# kubectl scale deployment nginx --replicas 0

$# gcloud container clusters delete tonydemo --zone $MY_ZONE
The following clusters will be deleted.
 - [tonydemo] in [asia-northeast1-c]

Do you want to continue (Y/n)?  Y

Deleting cluster tonydemo...done.
Deleted [https://container.googleapis.com/v1/projects/braided-course-322809/zones/asia-northeast1-c/clusters/tonydemo]
# ↑ 好像得跑個 2 分鐘

### ↓ 刪除完後, 就沒這東西囉~
$# kubectl get services
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

## Part5. Getting Started with App Engine

### Part1. Google Cloud Shell 簡介

- `Google Cloud Shell, (底下為了簡短, 自稱它為 GCS)` 的使用者家目錄, 預設會有 5GB 的永久儲存空間. 可用它來存取 GCP resources
    - 在 GCS 裏頭, 預設為「目前所在的 PROJECT_ID」

```bash
### 可用底下指令來切換至其它的 PROJECT_ID
$# gcloud config set project ${PROJECT_ID}
# ↓↓↓↓↓↓↓↓↓↓↓↓ 看到的結果 ↓↓↓↓↓↓↓↓↓↓↓↓
           Credentialed Accounts
ACTIVE  ACCOUNT
        student-01-ced7b983e3fc@qwiklabs.net
*       student-02-ced4b983e3fd@qwiklabs.net  # <-- 目前是這個
        student-03-bed4b983t8fd@qwiklabs.net
        student-04-pez4b783e3dd@qwiklabs.net

To set the active account, run:
    $ gcloud config set account `ACCOUNT`

# ↑↑↑↑↑↑↑↑↑↑↑↑ 看到的結果 ↑↑↑↑↑↑↑↑↑↑↑↑

### 可列出目前 PROJECT_ID 相關
$# gcloud config list project
# ↓↓↓↓↓↓↓↓↓↓↓↓ 看到的結果 ↓↓↓↓↓↓↓↓↓↓↓↓
[core]
project = qwiklabs-gcp-03-36f0c6e08a3d

Your active configuration is: [cloudshell-5615]
# ↑↑↑↑↑↑↑↑↑↑↑↑ 看到的結果 ↑↑↑↑↑↑↑↑↑↑↑↑
```

### Part2. 實作 APP Deploy

Goal:

```bash
### 目前的 PROJECT_ID
$# echo $DEVSHELL_PROJECT_ID
qwiklabs-gcp-03-36f0c6e08a3d

### 在 PROJECT_ID 建立一個 APP
$# gcloud app create --project=$DEVSHELL_PROJECT_ID
You are creating an app for project [qwiklabs-gcp-03-36f0c6e08a3d].
WARNING: Creating an App Engine application for a project is irreversible and the region
cannot be changed. More information about regions is at
<https://cloud.google.com/appengine/docs/locations>.

Please choose the region where you want your App Engine application
located:
# ↓↓↓↓↓↓↓↓↓↓↓↓ 自行選擇 APP 要搭建在哪個 ZONE 底下 ↓↓↓↓↓↓↓↓↓↓↓↓
 [1] asia-east1    (supports standard and flexible)
 [2] asia-east2    (supports standard and flexible and search_api)
 [3] asia-northeast1 (supports standard and flexible and search_api)
 ... (中間略) ...
 [17] us-central    (supports standard and flexible and search_api)
 ... (中間略) ...
 [23] us-west4      (supports standard and flexible and search_api)
 [24] cancel
Please enter your numeric choice:  17  # <-- 輸入要建立的 APP Engine 在哪個地區
Creating App Engine application in project [qwiklabs-gcp-03-36f0c6e08a3d] and region [us-central]....done.
Success! The app is now created. Please use `gcloud app deploy` to deploy your first app.
# ↑↑↑↑↑↑↑↑↑↑↑↑ 自行選擇 APP 要搭建在哪個 ZONE 底下 ↑↑↑↑↑↑↑↑↑↑↑↑

### 之後要來抓原始碼, 把服務 Deploy 起來吧~
# 抓 demo code...
$# git clone https://github.com/GoogleCloudPlatform/python-docs-samples
$# cd python-docs-samples/appengine/standard_python3/hello_world
$# sudo apt-get update
$# sudo apt-get install virtualenv
$# virtualenv -p python3 venv
$# source venv/bin/activate
$# pip install  -r requirements.txt
$# python main.py
# ↑ 都會了, 懶的說明. 服務可正常運行~
```

> GCP Web > Cloud Shell 右半部 > Web preview(齒輪旁邊, 長的很像眼睛) > Preview on port 8080  (可透過網頁訪問 Web App)

> GCP Web > 三條線 > App Engine > Dashboard

```bash
$# cd ~/python-docs-samples/appengine/standard_python3/hello_world
$# ls
app.yaml  main.py  main_test.py  requirements-test.txt  requirements.txt  venv
# ↑ 部屬依據

###
$# cat app.yaml | grep -v '^#' | grep -v '^$'
runtime: python39
# 裡面就只有一行@@...



### 使用 APP Deploy
$# gcloud app deploy
Services to deploy:

descriptor:                  [/home/student_02_ced4b983e3fd/python-docs-samples/appengine/standard_python3/hello_world/app.yaml]
source:                      [/home/student_02_ced4b983e3fd/python-docs-samples/appengine/standard_python3/hello_world]
target project:              [qwiklabs-gcp-03-36f0c6e08a3d]
target service:              [default]
target version:              [20210814t121302]
target url:                  [https://qwiklabs-gcp-03-36f0c6e08a3d.uc.r.appspot.com]
target service account:      [App Engine default service account]

Do you want to continue (Y/n)? Y  # <-- 自行輸入

Beginning deployment of service [default]...
Created .gcloudignore file. See `gcloud topic gcloudignore` for details.
╔════════════════════════════════════════════════════════════╗
╠═ Uploading 750 files to Google Cloud Storage              ═╣
╚════════════════════════════════════════════════════════════╝
File upload done.
Updating service [default]...done.
Setting traffic split for service [default]...done.
Deployed service [default] to [https://qwiklabs-gcp-03-36f0c6e08a3d.uc.r.appspot.com]

You can stream logs from the command line by running:
  $ gcloud app logs tail -s default

To view your application in the web browser run:
  $ gcloud app browse
# ~~~~~~~ ↑ 會運行一陣子~~~~~~~

### 使用 Web 來做預覽
$# gcloud app browse
Did not detect your browser. Go to this link to view your app:
https://qwiklabs-gcp-03-36f0c6e08a3d.uc.r.appspot.com  # ← 去看看吧~ 熱騰騰~~~
```

### Part3. 停止 APP Deploy

目前(2021/08), 還沒有 CLI 可以關閉 APP Deploy, 必須藉由 Web 來做操作

> GCP Web > 三條線 > App Engine > Settings > Disable application




## Part6. Getting Started with Deployment Manager and Cloud Monitoring

Goal: 建立一個專案, 然後去監控它~

```bash
### 使用 Cloud Shell button
$# gsutil cp gs://cloud-training/gcpfcoreinfra/mydeploy.yaml mydeploy.yaml
Copying gs://cloud-training/gcpfcoreinfra/mydeploy.yaml...
/ [1 files][  664.0 B/  664.0 B]
Operation completed over 1 objects/664.0 B.
# 抓取範例檔 mydeploy.yaml

$# sed -i -e "s/ZONE/$MY_ZONE/" mydeploy.yaml  # Step1. 編輯 ZONE
$# # Step2. 編輯 PROJECT_ID

### 建置
$# gcloud deployment-manager deployments create my-first-depl --config mydeploy.yaml
# mydeploy.yaml 如下
```

mydeploy.yaml 建置, 內容如下:

```yml
resources:
- name: my-vm
    type: compute.v1.instance
    properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    metadata:
        items:
        - key: startup-script
        value: "apt-get update"  # 機器運行後, 運行的指令. 
    disks:
    - deviceName: boot
        type: PERSISTENT
        boot: true
        autoDelete: true
        initializeParams:
        sourceImage: https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-9-stretch-v20180806
    networkInterfaces:
    - network: https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-dcdf854d278b50cd/global/networks/default
        accessConfigs:
        - name: External NAT
        type: ONE_TO_ONE_NAT
```

```bash
### mydeploy.yaml 若有做後續更新, 像是 key: startup-script 更改成
# apt-get update; apt-get install nginx-light -y
# 後續的 VM 更新指令為:                   ↓↓↓↓↓↓
$# gcloud deployment-manager deployments update my-first-depl --config mydeploy.yaml
The fingerprint of the deployment is b'c5qhVxXJvUwJ1dphYN0DlA=='
Waiting for update [operation-1628938927647-5c982e624aaea-0422f843-b6e078e9]...done.
Update operation operation-1628938927647-5c982e624aaea-0422f843-b6e078e9 completed successfully.
NAME   TYPE                 STATE      ERRORS  INTENT
my-vm  compute.v1.instance  COMPLETED  []
# 機器已經更新好了~

### ============================= 底下要開始做監控了 =============================
# 先幫機器安裝 Monitoring and Logging agent
$# curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
$# sudo bash install-monitoring-agent.sh
$# curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
$# sudo bash install-logging-agent.sh

### 然後去操它吧!!
$# dd if=/dev/urandom | gzip -9 >> /dev/null &
[1] 3771

### 然後就去監控頁面觀察它 
# 左上角三條線 > Monitoring > Metrics explorer
# Resource type > VM Instance
# Metric > 自己想看的監控指標
# 如此一來就可以看機器效能圖表了
```


## Part7. Getting Started with BigQuery

### 1. 簡介

BigQuery 用途, 可在 GCP Web 針對已經載入到 BigQuery 的 data 進行查詢, 並且可進行互動式的即時分析

如存在 BigQuery 的資料具備 highly durable

BigQuery 會針對原始資料進行 replicate, 查詢都是針對該 replicated data 做操作, 而且不會收取費用. 之需針對查詢支付費用.

概念名詞:

- Datasets: A dataset is a grouping mechanism that holds zero or more tables. A dataset is the lowest level unit of access control. Datasets are owned by GCP projects. Each dataset can be shared with individual users.
- Tables: A table is a row-column structure that contains actual data. Each table has a schema that describes strongly typed columns of values. Each table belongs to a dataset.
- Job: 執行查詢的工作任務(會依照查詢時間進行收費)

### 2. 實作

- 章節目標:
    - Load data from Cloud Storage into BigQuery
    - Perform a query on the data in BigQuery

> GCP Web > BigQuery > (專案編號右邊的...) > Create dataset > Dataset ID(隨便給個名字吧~) & Data location(不知道差在哪, 隨便選) > Create Dataset

> (新建的)Dataset(右邊的...) > Open > Create Table > (依照下列指示操作) > Create table

- Create table from : 自己選資料來源. Lab 裏頭, 要我們選 Google Cloud Storage 的 `gs://cloud-training/gcpfci/access_log.csv` (該 Dataset 位於 US, 因而上一步驟的 Data location 只能選 US)
- Table name : 隨便打吧
- Schema and input parameters : 勾選 (只是不知道這在幹嘛的=.=)

```bash
### 法1. BigQuery 頁面執行 bigquery (注意! 會依照查詢時間來計費)
# 點選 COMPOSE NEW QUERY
select int64_field_6 as hour, count(*) as hitcount from logdata.accesslog group by hour order by hour
# 點選 RUN
# 看到查詢結果 (略)

### 法2. Cloud Shell 執行 bigquery (注意! 會依照查詢時間來計費)
$# bq query "select string_field_10 as request, count(*) as requestcount from logdata.accesslog group by request order by requestcount desc"
Waiting on bqjob_r3dc6efdda95fb5aa_0000017b3ec19266_1 ... (0s) Current status: DONE   
# 看到查詢結果 (略)
```