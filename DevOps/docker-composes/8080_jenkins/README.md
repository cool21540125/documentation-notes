# Docker 使用 Jenkins

- 2020/03/27
- [Jenkins](https://hub.docker.com/r/jenkins/jenkins/)
- [關於 Jenkins_HOME](https://stackoverflow.com/questions/54352987/where-is-var-jenkins-home-folder-located)


```bash
### 2020/03/27 的今天, lts 為 2.222.1
# 2020/12/14, latest is 2.263.1
git pull jenkins/jenkins:lts

### 測試用
docker run -it --rm \
    -p 8080:8080 \
    -p 50000:50000 \
    jenkins/jenkins:2.263.1-lts-centos7 bash
# $JENKINS_HOME=/var/jenkins_home


### 正式 (沒有 SELinux 問題的話, 把 :Z 拿掉)
docker run -d \
    --name myjenkins \
    --restart always \
    -p 8080:8080 \
    -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home:Z \
    jenkins/jenkins:lts
# jenkins_home 位於 /var/lib/docker/volumes/jenkins-data
```

### 本地測試紀錄

id: tony
pd: 1234
