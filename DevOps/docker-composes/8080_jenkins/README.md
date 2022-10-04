# Docker 使用 Jenkins

- 2022/09/30
- [Jenkins](https://hub.docker.com/r/jenkins/jenkins/)
- [ocker-compose.jenkins-dind.yml](https://gist.github.com/adelmofilho/5a30a87eaf1cd4a03052f37b516d6714)
- [Jenkins-Docker](https://www.jenkins.io/doc/book/installing/docker/)
- [Jenkins Docker plugin(不知道將來會不會沒人維護Orz)](https://plugins.jenkins.io/docker-plugin/)


```bash
### 事先建立 volumes

docker volume create jenkins-data
docker volume create jenkins-docker-certs
docker volume create jenkins-docker-root

docker-compose up -d
```

- 為 Jenkins 安裝 Docker plugin
    > Dashboard > Manage Jenkins > Manage Plugins > Available > Docker
- 做 Docker plugin 必要配置
    > Dashboard > Manage Jenkins > Manage nodes and clouds > Configure Clouds > Add a new cloud > Docker > Docker Cloud details...
    > 
    > `Docker Host URI` 裡頭輸入 `tcp://dind:2376` (同 Jenkins(a.k.a. Docker Host 的環境變數 DOCKER_HOST))
    > 
    > 點選 `Test connection` 會看到誤導的資訊: *Status 400: Client sent an HTTP request to an HTTPS server.*
    > 
    > Add > Jenkins > Kind > X.509 Client Certificate > 裡頭有 3 個欄位
    > 
    > Client Key && Client Certificate && Server CA Certificate
    > 
    > 可由 jenkins-docker-dind 裡頭的 `/certs/client` 找到, Copy-Paste 到對應欄位, 
    > 
    > 分別是 `key.pem`, `cert.pem`, `ca.pem`
    > 
    > 再次 `Test connection`. 可看到 *Version = 20.10.18, API Version = 1.41* 表示成功~
    > 
    > 至於這證明了什麼? 完成了什麼? (老實說我現在也搞不清楚Orz)
- 配置 Docker Agent Templates (這要幹啥我開始有點不明不白了)
    > Dashboard > Manage Jenkins > Manage nodes and clouds > Configure Clouds > Docker Agent Templates > Add Docker Template
    > 
    > 