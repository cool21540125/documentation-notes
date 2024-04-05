
# Install

```bash
### Download
$# docker pull gcr.io/google.com/cloudsdktool/google-cloud-cli
# Docker Image 非常巨大... (慎用)


### Access to gcloud sh
$# VOLUME_CONTAINER=
$# docker run -ti \
  --name ${VOLUME_CONTAINER} \
  gcr.io/google.com/cloudsdktool/google-cloud-cli \
  gcloud auth login

$# docker run -it --rm \
  --volumes-from ${VOLUME_CONTAINER} \
  gcr.io/google.com/cloudsdktool/google-cloud-cli \
  sh
```


# CLI

```bash
### local CLI 使用帳密認證 (type 為 authorized_user)
# 不曉得底下差在哪邊
gcloud auth login                      # sdk 認證 (使用 Google Cloud SDK)
gcloud auth application-default login  # ADC 認證 (使用 Google Auth Library)
# Credentials 儲存到 $HOME/.config/gcloud/application_default_credentials.json


### 
gcloud init
gcloud auth list
gcloud config list


### 取得目前 Project ID
echo ${DEVSHELL_PROJECT_ID}      # 僅限於 CloudShell
gcloud config get-value project


### 設定目前 Project ID
gcloud config set project ${PROJECT_ID}


### 設定 project default region
REGION=asia-east1
echo y | gcloud config set compute/region ${REGION}
# (會花上幾分鐘...)


### 列出目前帳戶有權訪問的所有 GCP projects
gcloud projects list


### (沒事別用, 沒啥意義... 列出所有 GCP regions)
gcloud compute regions list


### Get a list of services that you can enable in your project:
gcloud services list --available
# 感覺沒啥用... API 會查詢很久, 然後回傳幾百筆的清單...


### 設定 Service Account && 賦予權限
SERVICE=
$# gcloud endpoints services add-iam-policy-binding ${SERVICE} \
  --member='cool21540125@gmail.com' \
  --role='roles/servicemanagement.admin'


### 開通 GOOGLE_CLOUD_SERVICE GCP 服務
GOOGLE_CLOUD_SERVICE=
gcloud services enable ${GOOGLE_CLOUD_SERVICE}


### 列出該帳戶的 token (用途不明)
gcloud auth print-access-token


### ------ 一次性永久配置 ------
gcloud config set disable_usage_reporting false  # 請 gcloud CLI 不要一直吵...(X)
```


# gcloud 與 Terraform 認證方式

- 有 3 種方法
  - 帳密認證 `gcloud auth login` - 適用於 local dev, Browser redirect 方式認證
  - 服務帳戶認證 
  - 使用 CloudShell (Browser 使用 GCP Console Shell)

```hcl
### Service Account 認證
provider "google" {
  credentials = file("/PATH/TO/ServiceAccount.json")
  project     = "project-id"
  region      = "asia-east1"
}
```
