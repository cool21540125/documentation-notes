
# Docker CLI

```bash
### 查看 docker metrics
docker stats


### 這動作似乎會去做 disk scan 之類的動作(不確定), 會跑一下子
docker system df
#TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
#Images          159       26        32.35GB   30.41GB (93%)
#Containers      93        33        1.771GB   1.771GB (99%)
#Local Volumes   24        23        62.2kB    0B (0%)
#Build Cache     0         0         0B        0B


### 查看所有 docker image 的 Size 總和 (MBs)
expr $(docker image inspect $(docker image ls -aq) --format {{.Size}} | awk '{totalSizeInBytes += $0} END {print totalSizeInBytes}') / 1024 / 1024
#4116  # images 佔了 4GB 左右


### 列出 <none> 的 images
docker images -f 'dangling=true' -q
```