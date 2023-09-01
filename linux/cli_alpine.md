
```sh
### alpine Linux 產生使用者帳號
echo -e "用戶名\n用戶密碼" | adduser -s /bin/sh 用戶名


### Docker Image - RUN
apk add --no-cache libc6-compat
# 處理這個問題 https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine


### user & group
addgroup --system --gid 1001 demoGroup
adduser --system --uid 1001 demoUser


### 
```
