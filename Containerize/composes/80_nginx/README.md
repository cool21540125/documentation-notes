# Install nginx by compose

- 2020/04/01
- [DockerHub Nginx](https://hub.docker.com/_/nginx)
- [mapping Config 參考](https://github.com/go-gitea/gitea/issues/6883)

可以把組態映射進去 Container 內來代理 Docker Host

```bash
### 2020/04/01 的今天, latest 為 1.17, 而最新的 stable 為 1.16
docker pull nginx:1.17

### docker run (目前目錄需要有 ./conf.d/)
$# docker run -d \
    --restart always \
    -v $(pwd)/conf.d:/etc/nginx/conf.d \
    nginx:1.17

### compose
$# docker-compose up
```
