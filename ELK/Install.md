# ELK

- 2019/07/03
- [docker-elk](https://github.com/deviantony/docker-elk#host-setup)


```bash
### 載專案
git clone https://github.com/deviantony/docker-elk.git

### 解 SELinux (非 root) (不是很好的方式)
chcon -R system_u:object_r:admin_home_t:s0 docker-elk/

cd docker-elk

docker-compose up   # 要先安裝好 docker compose 「sudo yum install -y docker-compose」
```

# ElasticSearch GUI

- 2019/08/09
- [ElasticHQ](https://www.elastichq.org/index.html)
- [Docker - elastichq/elasticsearch-hq](https://hub.docker.com/r/elastichq/elasticsearch-hq/)

```bash
$# docker pull elastichq/elasticsearch-hq

$# docker run -p 9200:5000 --name es-hq elastichq/elasticsearch-hq
```

http://$DOMAIN:9200


# Kibana