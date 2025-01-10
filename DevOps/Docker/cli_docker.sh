#!/bin/bash
exit 0
#
#
### 如果在 ShellScript 裡頭執行 docker exec 的話, 使用 docker exec -t 即可 (帶入 -i 的話會出問題)
docker exec ...
# -i : Keep STDIN open even if not attached
# -t : Allocate a pseudo-TTY
#
# ---------------------------------------------------

### 查看所有 docker image 的 Size 總和 (MBs)
expr $(docker image inspect $(docker image ls -aq) --format {{.Size}} | awk '{totalSizeInBytes += $0} END {print totalSizeInBytes}') / 1024 / 1024
#4116  # images 佔了 4GB 左右

### 列出 <none> 的 images
docker images -f 'dangling=true' -q

###
docker images | sort -k1 -h

### 連到不同的 docker daemon
docker -H tcp://127.0.0.1:2375 info

### 清除 <none> images && 無用 container, networking, cache
docker system prune

### 增加 Container 內的 /etc/hosts
docker run --add-host host.docker.internal=host-gateway ...
# --add-host 等同於 compose 的 extra_hosts, 增加到 /etc/hosts
# host-gateway 預設指向 docker0 的 default gateway (也就是 docker host)

###############################################################################################
# run with Resource limit
###############################################################################################

### 限制 RAM 使用
docker run -m 1024m ...

### 限制 CPU 使用. 指定使用 Core 2(第一顆 Core 為 0), 只能使用 20%
### 限制 CPU 使用. 指定使用 Core 2(第一顆 Core 為 0), 只能使用 30%
docker run --cpuset-cpus="1" --cpus="0.2" ...
docker run --cpuset-cpus="1" --cpus="0.3" ...

### 動態調整(限制) Container 的資源
docker update -m 996m $ContainerName

### 限制 Disk I/O 使用. 指定對 /dev/sda 寫入限制為 100mb
docker run --device-write-bps /dev/sda:100mb ...

###############################################################################################
# inspect
###############################################################################################

### 查看 Container 的 Mounts
docker inspect -f {{.Mounts}} $CONTAINER_ID

### 查看 Container Resource Usage
docker stats --no-stream
docker top

### 這動作似乎會去做 disk scan 之類的動作(不確定), 會跑一下子
docker system df
#TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
#Images          159       26        32.35GB   30.41GB (93%)
#Containers      93        33        1.771GB   1.771GB (99%)
#Local Volumes   24        23        62.2kB    0B (0%)
#Build Cache     0         0         0B        0B

### 檢查 Docker Image 的 Digest
docker manifest inspect --verbose ${IMAGE}:${TAG} | jq '.[0].Descriptor.digest'
# 用來跟 Registry 的 Image Digest 比對

###############################################################################################
# export / import / save / load
###############################################################################################

### 由 container 製作成 tar
docker export $CONTAINER_ID >example_image.tar

### 由 tar 還原 image
docker import - $IMAGE <example_image.tar

### 由 image 製作成 tar
docker save -o example_image.tar $IMAGE

### 由 tar 還原 image
docker load <example_image.tar
