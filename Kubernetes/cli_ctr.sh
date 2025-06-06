#!/bin/bash
exit 0
#
## 安裝完 containerd 以後, 會有 ctr CLI 可使用 (但是相對 low-level, 不建議直接使用)
# 因此, 看看就好
#
# 這東西是與 containerd Runtime 互動的, 並非適用於其他 CRI compatible Runtime
# 而如果萬不得已需要用 CLI 與 containerd 互動的話, 可參考 nerdctl (操作基本上等同於 docker CLI)
#
# 不過比起 docker CLI, 多了一層 Namespace 的概念, default NS 為 'default'
#
# -----------------------------------------------------------------

### (等價於 docker pull mysql:8.0)
sudo ctr images pull docker.io/library/mysql:8.0

### (等價於 docker images)
sudo ctr images ls
#REF                         TYPE                                    DIGEST                   SIZE      PLATFORMS                  LABELS
#docker.io/library/mysql:8.0 application/vnd.oci.image.index.v1+json sha256:51---略---d6728fc 219.6 MiB linux/amd64,linux/arm64/v8 -

### (等價於 docker run -e MYSQL_ROOT_PASSWORD='1qaz@WSX' --name mysql mysql:8.0)
sudo ctr run --env MYSQL_ROOT_PASSWORD='1qaz@WSX' docker.io/library/mysql:8.0 mysql

### (等價於 docker ps)
sudo ctr c list
#CONTAINER    IMAGE                          RUNTIME
#mysql        docker.io/library/mysql:8.0    io.containerd.runc.v2

### (等價於 docker rm -f mysql)
sudo ctr c mysql

### (等價於 docker rmi mysql:8.0)
sudo ctr images rm docker.io/library/mysql:8.0

###
sudo ctr -n k8s.io images ls  # 可查到 k8s NS 用到的 images
sudo ctr -n default images ls # 可查到 default NS 用到的 images
