
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
### 取得目前 Project ID
$# echo ${DEVSHELL_PROJECT_ID}      # 僅限於 CloudShell
$# gcloud config get-value project


### 設定目前 Project ID
$# gcloud config set project ${PROJECT_ID}


### 設定 project default region
$# REGION=asia-east1
$# echo y | gcloud config set compute/region ${REGION}
# (會花上幾分鐘...)


### 列出目前帳戶有權訪問的所有 GCP projects
$# gcloud projects list


### (沒事別用, 沒啥意義... 列出所有 GCP regions)
$# gcloud compute regions list


### Get a list of services that you can enable in your project:
$# gcloud services list --available
# 感覺沒啥用... API 會查詢很久, 然後回傳幾百筆的清單...


### 設定 Service Account && 賦予權限
$# SERVICE=
$# gcloud endpoints services add-iam-policy-binding ${SERVICE} \
  --member='cool21540125@gmail.com' \
  --role='roles/servicemanagement.admin'


### 開通 GOOGLE_CLOUD_SERVICE GCP 服務
$# GOOGLE_CLOUD_SERVICE=
$# gcloud services enable ${GOOGLE_CLOUD_SERVICE}


### 列出該帳戶的 token
$# gcloud auth print-access-token
```
