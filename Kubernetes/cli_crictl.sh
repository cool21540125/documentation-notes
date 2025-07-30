#!/bin/bash
exit 0
#
# 相較於 直接訪問 containerd Runtime 的底層工具範例為 ctr (不建議用)
# crictl 則是適用於 CRI compatible runtime
#
# 操作 crictl 的時候, 基本上等同於 docker
# 不過要留意的是
#    crictl 的 default NS 為 k8s.io
#    docker 的 default NS 為 default
#
# -----------------------------------------------------------------

### crictl 在安裝 cri-tools 的時候就會安裝了
# 然而並沒有配置文件, 因為 Container runtime 可以自選, 路徑可能都不同 (需要自己建立)
echo 'runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false' > /etc/crictl.yaml
# 上面為 Container runtime 是 containerd 的(預設路徑)範例

### 列出來的 images 的名稱空間來自於 k8s.io NS
sudo crictl images
# 也就是說看到的會和 docker images 不一樣啦

sudo crictl ps


### (用途不明, 僅記錄)
crictl --runtime-endpoint xxx
export CONTAINER_RUNTIME_ENDPOINT=xxx
# 兩者似乎等價?
