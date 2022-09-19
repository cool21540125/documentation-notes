

# Environment variables

```bash
### 可取得目前 CloudShell 所在的 project
$# echo ${DEVSHELL_PROJECT_ID}
```



# CMD

```bash
### 設定 project default region
$# REGION=asia-east1
$# gcloud config set compute/region ${REGION}
# (會花上幾分鐘...)


### 列出所有 GCP projects
$# gcloud projects list


### 列出所有 GCP regions
$# gcloud compute regions list


### 設定 gcloud default project
$# YOUR_PROJECT_ID=
$# gcloud config set project ${YOUR_PROJECT_ID}
# or
$# gcloud config get-value project
# ↑ 取得目前 gcloud shell 所在的 project



### Get a list of services that you can enable in your project:
$# gcloud services list --available
# 感覺沒啥用... API 會查詢很久, 然後回傳幾百筆的清單...


###
$# SERVICE=
$# gcloud endpoints services add-iam-policy-binding ${SERVICE} \
  --member='user:example-user@gmail.com' \
  --role='roles/servicemanagement.admin'
```