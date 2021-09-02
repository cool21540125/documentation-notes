
# ElasticSearch

- Docker 的 Base Image 為 `centos:7`
    - User 為 `elasticsearch`(1000:1000)


```bash
### 開發模式底下使用
docker run -d \
    --name es74 \
    --net elk \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "discovery.type=single-node" \
    elasticsearch:7.14
# discovery.type : 讓此 Node 推舉自己為 master, 不會去加入其他叢集
```

### Production 環境建議配置

```bash
### 永久套用
grep vm.max_map_count /etc/sysctl.conf
vm.max_map_count=262144

### 立即套用
sysctl -w vm.max_map_count=262144
```