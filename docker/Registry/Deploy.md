# 搭建私有 Registry

- 2020/04/12
- [DockerHub-registry](https://hub.docker.com/_/registry?tab=description)
- [Deploy a registry server](https://docs.docker.com/registry/deploying/)


# Build

Nginx 負責 ssl, proxy, loggin, set-header

```bash
$# ls
auth  certs  docker-compose.yml conf.d
# auth:   認證資料檔放到 auth/registry.htpasswd
# certs:  把申請到的合法憑證放到 certs/fullchain.pem && certs/privkey.pem
# conf.d: 把裡頭的東西丟到 /etc/nginx/conf.d

### 增加帳密資訊
$# htpasswd -Bb auth/registry.htpasswd user01 password01
# -b, 後面接著給 <file> <user> <password>
# -B, docker 身分驗證 htpasswd 僅支援 bcrypt 格式, 故一定要給(否則預設為-m)

### 測試
HOST=https://${MyRegistryHost}
Base64_Creds=
curl -X GET ${HOST}/v2/_catalog -H "Authorization: Basic ${Base64_Creds}"
{"repositories":[]}
# 要看到上面這樣
```

## 變數

- REGISTRY_HTTP_ADDR: 預設開在 5000, 但可用此指定開在其他 port
- REGISTRY_HTTP_TLS_CERTIFICATE: 憑證位置
- REGISTRY_HTTP_TLS_KEY: 私鑰位置
- REGISTRY_AUTH: 認證方式, 使用 htpasswd 吧
- REGISTRY_AUTH_HTPASSWD_REALM: 認證頁面看到的提示訊息
- REGISTRY_AUTH_HTPASSWD_PATH: htpasswd 位置

# Usage

```bash
### Docker client
$# docker login ${MyRegistryHost}

$# docker tag alpine ${MyRegistryHost}/alpine

$# docker images
REPOSITORY                  TAG     IMAGE ID      CREATED      SIZE
${MyRegistryHost}/alpine  latest  f70734b6a266  3 weeks ago  5.61MB
alpine                    latest  f70734b6a266  3 weeks ago  5.61MB

$# docker push ${MyRegistryHost}/alpine

$# curl -X GET https://${MyRegistryHost}/v2/_catalog -H "Authorization: Basic ${MyRegistryCreds}"
{"repositories":[]}
```


# 其他備註

## Docker Registry 1 與 2

2020/04 的現在, Registry 最新為 2.7 版

Docker Distribution 專案, 實作了 Docker Registry 2.0 的規範, 與 1.0 版(當時為 Docker Registry 專案)變成了兩個獨立的專案了(應該吧). 若 CentOS7 要使用 yum 來安裝的話, 需要使用 `yum install -y docker-distribution`, 才能安裝 Registry 2.0 版


## 如果不做 https, 只是區網內部自己人使用

`vim /etc/docker/daemon.json`

```jsonc
{
    // 增加信任的 Registry
    "insecure-registries": ["YOURDOMAIN"],
}
```

後續重啟 docker: `systemctl restart docker`


## Docker Hub 與 Docker Cloud

> 預設的 docker registry 為 Docker Hub(非 Docker Cloud), 但只要在其中一個地方註冊的話, 兩邊的身份是互通的. 
> 此外, 可以把 Docker Cloud 想像成是更強大的 Docker Hub, 提供了更完善的自動化服務(至於是啥我不知道), 也可在裡頭做 Docker 的 CI/CD.


```py
import hashlib
uid='tony'
pwd='1234'
hashlib.md5((uid + ':' + pwd).encode('utf8')).hexdigest()
```
