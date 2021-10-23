# Install gitlab-runner by docker

- 2020/03/28
- https://docs.gitlab.com/ee/ci/quick_start/
- https://docs.gitlab.com/runner/install/docker.html


```bash
### GitLab-Runner
$# docker pull gitlab/gitlab-runner
# v12.6.0 (ac8e767a)

### 如何使用
$# docker run --rm -it gitlab/gitlab-runner --help

### ※※※※※※※※※※※※※
# 要先到 gitlab 去把 Overview > Runners > URL && token 複製出來
### ※※※※※※※※※※※※※

### Run (Macbook)
$# docker run -d \
    --name mygitlab_runner \
    --restart always \
    -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

    # -v /srv/gitlab-runner/config:/etc/gitlab-runner \  # Linux


### Token
GITLAB_URL=
GITLAB_RUNNER_TOKEN=
### Run (Centos7) - https://blog.samchu.dev/2019/05/02/%E8%A8%BB%E5%86%8A-GitLab-Runner-use-Docker/
$# docker run -d \
    --name mygitlab_runner \
    --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner:Z \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest register \
    --executor "docker" \
    --url ${GITLAB_URL} \
    --registration-token ${GITLAB_RUNNER_TOKEN}
```
