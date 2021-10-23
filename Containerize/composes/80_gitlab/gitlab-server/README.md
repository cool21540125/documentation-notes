# Install Gitlab by docker

- 2020/04/02
- [dockerhub-gitlab-ce](https://hub.docker.com/r/gitlab/gitlab-ce)


### 使用 Docker Run
```bash
### 2020/04/02 的今天, latest 版本為 gitlab/gitlab-ce:12.9.2-ce.0
$# docker pull gitlab/gitlab-ce:12.9.2-ce.0

### Variable && Volumes
GitServer_HOST=mygitlab.com
docker volume create mygitlab-config
docker volume create mygitlab-logs
docker volume create mygitlab-data

### Run
$# docker run -d \
    --hostname ${GitServer_HOST} \
    --name mygitlab \
    --restart always \
    -p 22280:80 \
    -p 22222:22 \
    -p 22443:443 \
    -v mygitlab-config:/etc/gitlab \
    -v mygitlab-logs:/var/log/gitlab \
    -v mygitlab-data:/var/opt/gitlab \
    -e GITLAB_OMNIBUS_CONFIG="external_url 'http://${GitServer_HOST}';" \
    gitlab/gitlab-ce:latest
# 有 SELinux 問題的話, 加上「:Z」
# 設定主檔為: /etc/gitlab/gitlab.rb

### 初始化程序要等上一陣子... 追蹤 Log
$# docker logs -f gitlab
```

### 使用 docker-compose
```bash
$# vim .env


$# docker-compose up -d

$# docker-compose logs -f
```



## Notes

- 若想做成 https, 得設定 [HTTPS](https://docs.gitlab.com/omnibus/settings/nginx.html#enable-https)
- Note: The settings contained in `GITLAB_OMNIBUS_CONFIG` will not be written to the gitlab.rb configuration file, they’re evaluated on load.