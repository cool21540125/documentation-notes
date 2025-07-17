#!/bin/bash
exit 0
### 使用 helm 部署 n8n
#
#
# -------------------------------------------------------

### 抓取 n8n default values 
helm show values oci://8gears.container-registry.com/library/n8n --version 1.0.0 > default-values.yaml

### 修改 values.yaml
cp default-values.yaml values.yaml
vim values.yaml

### 部署
helm install n8nPoc oci://8gears.container-registry.com/library/n8n --version 1.0.0 -f values.yaml
helm install my-n8n oci://8gears.container-registry.com/library/n8n --version 1.0.0 -f values.yaml --dry-run

helm template my-n8n oci://8gears.container-registry.com/library/n8n --version 1.0.0 -f values.yaml