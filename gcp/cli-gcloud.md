
# Environment variables

```bash
### 可取得目前 CloudShell 所在的 project
$# echo ${DEVSHELL_PROJECT_ID}
# 如果自行在本機使用 gcloud 則無此 env
```


```sh
### Download
$# docker pull gcr.io/google.com/cloudsdktool/google-cloud-cli

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


# CMD

```bash
### 設定 project default region
$# REGION=asia-east1
$# echo y | gcloud config set compute/region ${REGION}
# (會花上幾分鐘...)


### 列出目前帳戶有權訪問的所有 GCP projects
$# gcloud projects list


### 列出所有 GCP regions (沒事別用, 沒啥意義...)
$# gcloud compute regions list


$# gcloud config set project ${PROJECT_ID}
$# gcloud config get-value project


### Get a list of services that you can enable in your project:
$# gcloud services list --available
# 感覺沒啥用... API 會查詢很久, 然後回傳幾百筆的清單...


###
$# SERVICE=
$# gcloud endpoints services add-iam-policy-binding ${SERVICE} \
  --member='user:example-user@gmail.com' \
  --role='roles/servicemanagement.admin'


### 
$# gcloud services enable ${GOOGLE_CLOUD_SERVICE}


### 列出該帳戶的 token
$# gcloud auth print-access-token
```
